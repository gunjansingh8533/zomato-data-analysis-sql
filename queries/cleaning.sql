

-- STEP 1: Create Staging Table

-- Before making any changes, I created a staging table
-- so the original dataset remains untouched. All cleaning
-- and validation steps are performed on this copy.

SELECT *
FROM pune_restaurants;

CREATE TABLE restaurants_staging
LIKE pune_restaurants;

INSERT INTO restaurants_staging
SELECT *
FROM pune_restaurants;

SELECT *
FROM restaurants_staging;

-- STEP 2: Initial Data Audit

-- Check the total number of records in the dataset.

SELECT COUNT(*) AS Total_rows
FROM restaurants_staging;

-- Result:
-- Dataset contains 4,797 restaurant records.

-- Check for NULL values across all columns 

SELECT
  SUM(Restaurant_Name IS NULL)       AS null_name,
  SUM(Category IS NULL)              AS null_category,
  SUM(Pricing_for_2 IS NULL)         AS null_pricing,
  SUM(Locality IS NULL)              AS null_locality,
  SUM(Dining_Rating IS NULL)         AS null_dining_rating,
  SUM(Dining_Review_Count IS NULL)   AS null_dining_reviews,
  SUM(Delivery_Rating IS NULL)       AS null_delivery_rating,
  SUM(Delivery_Rating_Count IS NULL) AS null_delivery_count,
  SUM(Website IS NULL)               AS null_website,
  SUM(Address IS NULL)               AS null_address,
  SUM(Phone_No IS NULL)              AS null_phone,
  SUM(Latitude IS NULL)              AS null_lat,
  SUM(Longitude IS NULL)             AS null_lon,
  SUM(Known_for1 IS NULL)            AS null_kf1,
  SUM(Known_for2 IS NULL)            AS null_kf2
FROM restaurants_staging;

-- Findings:
-- Most columns were complete.
-- Delivery_Rating contained 1,571 NULL values.
-- Missing delivery ratings were retained, as they likely
-- represent restaurants without delivery activity rather
-- than data entry issues.

-- Check for blank strings in important text columns.

SELECT
  SUM(Restaurant_Name = '')       AS blank_name,
  SUM(Category = '')              AS blank_category,
  SUM(Locality = '')              AS blank_locality,
  SUM(Address = '')               AS blank_address,
  SUM(Known_for1 = '')            AS blank_kf1,
  SUM(Known_for2 = '')            AS blank_kf2
FROM restaurants_staging;

-- Result:
-- No blank values found in any of the checked columns.

-- Check for 'Nan' values stored as text instead of proper NULLs.

SELECT
  SUM(Restaurant_Name = 'Nan')       AS empty_name,
  SUM(Category = 'Nan')              AS empty_category,
  SUM(Locality = 'Nan')              AS empty_locality,
  SUM(Address = 'Nan')               AS empty_address,
  SUM(Known_for1 = 'Nan')            AS empty_kf1,
  SUM(Known_for2 = 'Nan')            AS empty_kf2
FROM restaurants_staging;

-- Findings:
-- Known_for1 contained 642 'Nan' values.
-- Known_for2 contained 3,719 'Nan' values.
-- These values were later converted to NULL
-- for consistency.

-- STEP 3: Review Category Distribution

-- Check all distinct categories

SELECT DISTINCT Category
FROM restaurants_staging
ORDER BY Category;

-- Category variants

SELECT category, COUNT(*) AS cnt
FROM restaurants_staging
GROUP BY category
ORDER BY cnt DESC
LIMIT 50;

-- Most common categories:
-- - Chinese (130 restaurants)
-- - North Indian, Chinese (126 restaurants)
-- - Maharashtrian (122 restaurants)
-- - North Indian (110 restaurants)
-- - Street Food (92 restaurants)

-- STEP 4: Validate Numeric Fields

-- Pricing range

SELECT 
	MIN(Pricing_for_2),
    MAX(Pricing_for_2),
    AVG(Pricing_for_2)
FROM restaurants_staging;

-- Findings:
--  Lowest cost for two: ₹100
--  Highest cost for two: ₹4,300
--  Average cost for two: ₹572

-- Rating range 

SELECT MIN(Dining_Rating), MAX(Dining_Rating),
       MIN(Delivery_Rating), MAX(Delivery_Rating)
FROM restaurants_staging;

-- Findings:
-- Dining Rating:
--  Minimum: 3.0
--  Maximum: 4.9
--
-- Delivery Rating:
--  Minimum: 2.4
--  Maximum: 4.5

-- STEP 5: Check for Duplicate Restaurants

-- Identify Duplicates Using Cleaned Keys

SELECT 
	TRIM(LOWER(Restaurant_name)) AS clean_name,
    TRIM(LOWER(Locality))        AS clean_locality,
    COUNT(*)                     AS dup_count,
    GROUP_CONCAT(id ORDER BY id) AS all_ids
FROM restaurants_staging
GROUP BY clean_name, clean_locality
HAVING COUNT(*) > 1
ORDER BY dup_count DESC;

SELECT 
	TRIM(LOWER(Restaurant_name)) AS clean_name,
    TRIM(LOWER(Address))        AS clean_address,
    COUNT(*)                     AS dup_count,
    GROUP_CONCAT(id ORDER BY id) AS all_ids
FROM restaurants_staging
GROUP BY clean_name, clean_address
HAVING COUNT(*) > 1
ORDER BY dup_count DESC;

-- Result:
-- No duplicate records were found 

-- STEP 6: Replace Placeholder Values

SELECT known_for1, known_for2
FROM restaurants_staging
WHERE known_for1 = 'Nan' OR known_for2 = 'Nan';

-- Convert placeholder values to NULL.

UPDATE restaurants_staging
SET known_for1 = NULL 
WHERE known_for1 = 'Nan';

UPDATE restaurants_staging
SET known_for2 = NULL 
WHERE known_for2 = 'Nan';

-- Trim whitespace and Normalize casing

SELECT Restaurant_Name, TRIM(Restaurant_Name)
FROM restaurants_staging;

UPDATE restaurants_staging SET
  Restaurant_Name = TRIM(Restaurant_Name),
  Locality        = TRIM(Locality),
  Address         = TRIM(Address),
  Category        = TRIM(Category),
  Website         = TRIM(LOWER(Website)),
  Phone_No        = TRIM(Phone_No),
  Known_for1      = TRIM(Known_for1),
  Known_for2      = TRIM(Known_for2);


-- Rating Range Validation (0.0 to 5.0)

SELECT *
FROM restaurants_staging
WHERE Dining_Rating   NOT BETWEEN 0.0 AND 5.0
   OR Delivery_Rating NOT BETWEEN 0.0 AND 5.0;
 
 -- Result: No invalid ratings found.
 
 -- Flag suspiciously high review counts
SELECT id, Restaurant_Name,
       Dining_Review_Count, Delivery_Rating_Count
FROM restaurants_staging
WHERE Dining_Review_Count   > 100000
   OR Delivery_Rating_Count > 100000;
   
 -- Result: No suspicious review counts detected.

-- STEP 7: Validate Location Coordinates
-- Pune approximate bounding box

SELECT id, Restaurant_Name, Latitude, Longitude
FROM restaurants_staging
WHERE (Latitude = 0 AND Longitude = 0)
   OR Latitude  NOT BETWEEN 18 AND 19
   OR Longitude NOT BETWEEN 73 AND 75;
   
-- Result:
-- No records were returned.

-- All restaurant coordinates fall within the expected
-- Pune region and no invalid latitude/longitude values
-- were detected.

-- STEP 8: Check Rating and Review Count Consistency

-- Identify restaurants with a delivery rating but
-- no recorded delivery reviews.

SELECT id, Restaurant_Name,
       Delivery_Rating, Delivery_Rating_Count
FROM restaurants_staging
WHERE Delivery_Rating IS NOT NULL
  AND (Delivery_Rating_Count IS NULL
       OR Delivery_Rating_Count = 0);

-- Findings:
-- 5 restaurants had delivery ratings despite having
-- zero delivery reviews.

UPDATE restaurants_staging
SET Delivery_Rating = NULL
WHERE Delivery_Rating IS NOT NULL
  AND (Delivery_Rating_Count IS NULL
       OR Delivery_Rating_Count = 0);

-- Identify restaurants with dining ratings but
-- no recorded dining reviews.

SELECT id, Restaurant_Name,
       Dining_Rating, Dining_Review_Count
FROM restaurants_staging
WHERE Dining_Rating IS NOT NULL
  AND (Dining_Review_Count IS NULL
       OR Dining_Review_Count = 0);

-- Findings:
-- 4 restaurants had dining ratings despite having
-- zero dining reviews.

UPDATE restaurants_staging
SET Dining_Rating = NULL
WHERE Dining_Rating IS NOT NULL
  AND (Dining_Review_Count IS NULL
       OR Dining_Review_Count = 0);

-- STEP 9: Compare Dining and Delivery Ratings

-- Check for unusually large differences between
-- dining and delivery ratings.

SELECT id, Restaurant_Name,
       Dining_Rating, Delivery_Rating,
       ABS(Dining_Rating - Delivery_Rating) AS gap
FROM restaurants_staging
WHERE Dining_Rating IS NOT NULL
  AND Delivery_Rating IS NOT NULL
  AND ABS(Dining_Rating - Delivery_Rating) > 2.0
ORDER BY gap DESC;

-- Result:
-- No restaurants showed a rating difference greater than 2 points.
-- Dining and delivery ratings appear reasonably consistent.
-- Pricing Outliers

-- STEP 10: Review Pricing Distribution

-- Statistical summary
SELECT
  MIN(Pricing_for_2)    AS min_price,
  MAX(Pricing_for_2)    AS max_price,
  AVG(Pricing_for_2)    AS avg_price,
  STDDEV(Pricing_for_2) AS stddev_price
FROM restaurants_staging WHERE Pricing_for_2 IS NOT NULL;

-- Findings:
-- - Minimum price: ₹100
-- - Maximum price: ₹4,300
-- - Average price: ₹572
-- - Standard deviation: ₹425

-- Identify restaurants with unusually high prices
-- using the 3-sigma rule.

SELECT id, Restaurant_Name, Pricing_for_2
FROM restaurants_staging
WHERE Pricing_for_2 > (
  SELECT AVG(Pricing_for_2) + 3 * STDDEV(Pricing_for_2)
  FROM restaurants_staging WHERE Pricing_for_2 IS NOT NULL);

-- Findings:
-- 93 restaurants were flagged by the 3-sigma rule.

-- After reviewing the records, the values appeared to
-- represent legitimate premium and fine-dining restaurants
-- rather than data entry errors.

-- No pricing values were modified or removed.

-- STEP 11: Create Pricing Segments

ALTER TABLE restaurants_staging
  ADD COLUMN Pricing_Tier VARCHAR(20);

UPDATE restaurants_staging
SET Pricing_Tier = CASE
  WHEN Pricing_for_2 IS NULL              THEN NULL
  WHEN Pricing_for_2 < 300                THEN 'Budget'
  WHEN Pricing_for_2 BETWEEN 300  AND 800 THEN 'Mid-range'
  WHEN Pricing_for_2 BETWEEN 801 AND 1500 THEN 'Premium'
  ELSE 'Fine Dining'
END;

-- STEP 12: Review Pricing Tier Distribution

SELECT Pricing_Tier
FROM restaurants_staging;

SELECT pricing_tier, COUNT(*) 
FROM restaurants_staging
GROUP BY pricing_Tier;

-- Findings:
-- Budget      : 826 restaurants
-- Mid-range   : 3,200 restaurants
-- Premium     : 581 restaurants
-- Fine Dining : 190 restaurants

-- FINAL DATA QUALITY CHECK

-- Post-Cleaning Row Count
SELECT COUNT(*) AS final_rows FROM restaurants_staging;

-- Result:
-- Final row count: 4,797
-- No records were removed during cleaning.

-- Null counts after cleaning

SELECT
    COUNT(*) AS total_rows,
    SUM(Delivery_Rating IS NULL) AS missing_delivery,
    SUM(Dining_Rating IS NULL) AS missing_dining,
    SUM(Known_for1 IS NULL) AS missing_kf1,
    SUM(Known_for2 IS NULL) AS missing_kf2
FROM restaurants_staging;

-- Final Findings:
-- Total Records      : 4,797
-- Missing Delivery Ratings : 1,576
-- Missing Dining Ratings   : 4
-- Missing Known_for1       : 642
-- Missing Known_for2       : 3,719
--
-- Known_for1 and Known_for2 contain descriptive information
-- and were retained as NULL where values were unavailable.

