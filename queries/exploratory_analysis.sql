-- Phase 1: Dataset Overview

-- 1. Total Restaurants

SELECT COUNT(*) AS total_restaurants
FROM restaurants_staging;

-- Result:
-- The dataset contains 4,797 restaurants

-- 2. Restaurants by Pricing Tier

SELECT Pricing_Tier,
       COUNT(*) AS restaurant_count
FROM restaurants_staging
GROUP BY Pricing_Tier
ORDER BY restaurant_count DESC;

-- Findings:
-- Mid-range   : 3,200 restaurants
-- Budget      : 826 restaurants
-- Premium     : 581 restaurants
-- Fine Dining : 190 restaurants

WITH pricing_distribution AS
(
    SELECT Pricing_Tier,
           COUNT(*) AS restaurant_count
    FROM restaurants_staging
    GROUP BY Pricing_Tier
)
SELECT
    Pricing_Tier,
    restaurant_count,
    ROUND(
        restaurant_count * 100.0 /
        (SELECT SUM(restaurant_count)
         FROM pricing_distribution),
         2
    ) AS percentage
FROM pricing_distribution
ORDER BY restaurant_count DESC;

-- Business Insight:
-- Nearly two-thirds (66.7%) of restaurants fall into the
-- Mid-range segment, making it the dominant pricing category.

-- Fine Dining establishments account for less than 4% of
-- all restaurants, indicating that Pune's restaurant market
-- is largely focused on affordable and mid-priced dining.

-- Phase 2: Location Analysis

-- 3. Top Localities by Restaurant Count

SELECT Locality,
       COUNT(*) AS restaurant_count
FROM restaurants_staging
GROUP BY Locality
ORDER BY restaurant_count DESC
LIMIT 10;

-- 4. Best Rated Localities

SELECT Locality,
       ROUND(AVG(Dining_Rating),2) AS avg_rating,
       COUNT(*) AS restaurants
FROM restaurants_staging
GROUP BY Locality
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC
LIMIT 10;

-- Phase 3: Cuisine Analysis

-- 5. Most Common Restaurant Categories

SELECT Category,
       COUNT(*) AS restaurant_count
FROM restaurants_staging
GROUP BY Category
ORDER BY restaurant_count DESC
LIMIT 15;

-- 6. Highest Rated Categories

SELECT Category,
       ROUND(AVG(Dining_Rating),2) AS avg_rating,
       COUNT(*) AS restaurants
FROM restaurants_staging
GROUP BY Category
HAVING COUNT(*) >= 10
ORDER BY avg_rating DESC
LIMIT 15;

-- Phase 4: Pricing Analysis

-- 7. Average Price by Locality

SELECT Locality,
       ROUND(AVG(Pricing_for_2),0) AS avg_price
FROM restaurants_staging
GROUP BY Locality
HAVING COUNT(*) >= 25
ORDER BY avg_price DESC
LIMIT 10;

-- 8. Average Rating by Pricing Tier

SELECT Pricing_Tier,
       ROUND(AVG(Dining_Rating),2) AS avg_rating,
       COUNT(*) AS restaurants
FROM restaurants_staging
GROUP BY Pricing_Tier
ORDER BY avg_rating DESC;

-- 9. Price vs Rating Correlation

SELECT
    ROUND(AVG(Pricing_for_2),0) AS avg_price,
    ROUND(AVG(Dining_Rating),2) AS avg_rating
FROM restaurants_staging;

-- Phase 5: Popularity Analysis

-- 10. Most Reviewed Restaurants

SELECT Restaurant_Name,
       Dining_Review_Count
FROM restaurants_staging
ORDER BY Dining_Review_Count DESC
LIMIT 10;

-- 11. Highest Rated Restaurants

SELECT Restaurant_Name,
       Dining_Rating,
       Dining_Review_Count
FROM restaurants_staging
WHERE Dining_Review_Count >= 50
ORDER BY Dining_Rating DESC
LIMIT 10;

-- Phase 6: Delivery Analysis

-- 12. Dining vs Delivery Ratings

SELECT
    ROUND(AVG(Dining_Rating),2) AS avg_dining,
    ROUND(AVG(Delivery_Rating),2) AS avg_delivery
FROM restaurants_staging;

-- 13. Restaurants with Largest Rating Gap

-- Identify restaurants with the largest difference
-- between dining and delivery ratings.

SELECT Restaurant_Name,
       Dining_Rating,
       Delivery_Rating,
       ROUND(ABS(Dining_Rating - Delivery_Rating),2) AS gap
FROM restaurants_staging
WHERE Dining_Rating IS NOT NULL
  AND Delivery_Rating IS NOT NULL
ORDER BY gap DESC
LIMIT 10;