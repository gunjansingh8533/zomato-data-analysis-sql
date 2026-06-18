# Pune Restaurants Analysis Using SQL

## Project Overview

This project analyzes restaurant data from Pune using SQL. The objective was to clean, validate, and explore the dataset to uncover insights related to restaurant distribution, pricing patterns, cuisine trends, customer ratings, and locality-level dining preferences.

The project follows a complete SQL workflow, starting from database creation and data import, followed by data cleaning and exploratory analysis.



## Dataset Information

**Dataset:** Pune Restaurants

**Total Records:** 4,797

### Key Features

* Restaurant Name
* Category
* Pricing for 2
* Locality
* Dining Rating
* Dining Review Count
* Delivery Rating
* Delivery Rating Count
* Address
* Website
* Phone Number
* Latitude
* Longitude


## Project Structure

```text
ZOMATO DATA ANALYSIS/

│
├── dataset/
│   └── Pune Restaurants.csv
│
├── queries/
│   ├── schema.sql
│   ├── import.sql
│   ├── cleaning.sql
│   └── exploratory_analysis.sql
│
└── README.md
```


## Database Setup

### schema.sql

Contains the SQL schema used to create the restaurants table and define the appropriate data types.

### import.sql

Contains the SQL commands used to import the CSV dataset into MySQL.



## Data Cleaning

The cleaning process was performed on a staging table to preserve the raw dataset.

### Data Quality Checks Performed

* Created a staging table for safe data cleaning
* Audited missing values across all columns
* Checked for blank strings in text fields
* Identified and standardized placeholder values (`Nan`)
* Converted placeholder values to `NULL`
* Checked for duplicate restaurant records
* Validated rating ranges
* Validated geographic coordinates
* Reviewed review-count consistency
* Identified statistical pricing outliers
* Created pricing segments for analysis

### Data Cleaning Findings

* No duplicate restaurant records were found.
* All restaurant coordinates fell within Pune's expected geographic boundaries.
* 642 placeholder values were identified in `Known_for1`.
* 3,719 placeholder values were identified in `Known_for2`.
* 5 delivery ratings and 4 dining ratings were removed due to having zero associated reviews.
* 93 restaurants were flagged using the 3-sigma outlier rule but were retained after review because they represented legitimate premium and fine-dining establishments.

### Final Data Quality Summary

| Metric                   | Count |
| ------------------------ | ----: |
| Total Records            | 4,797 |
| Missing Delivery Ratings | 1,576 |
| Missing Dining Ratings   |     4 |
| Missing Known_for1       |   642 |
| Missing Known_for2       | 3,719 |



## Exploratory Data Analysis

The analysis focused on understanding:

* Restaurant distribution across Pune
* Cuisine popularity
* Pricing patterns
* Customer ratings
* Restaurant popularity
* Delivery versus dining performance



## Key Findings

### 1. Market Composition

* The dataset contains 4,797 restaurants.
* Mid-range restaurants dominate the market, accounting for approximately 66.7% of all restaurants.
* Fine Dining establishments account for only about 4% of restaurants.

### 2. Restaurant Density

* Kothrud has the highest concentration of restaurants with 194 establishments.
* Hadapsar, Wakad, Baner, and Viman Nagar also show strong restaurant presence.

### 3. Cuisine Trends

* Chinese cuisine is the most common restaurant category in the dataset.
* North Indian-Chinese combinations and Maharashtrian cuisine are also highly represented.
* Dessert and beverage-focused categories recorded some of the highest average dining ratings.

### 4. Pricing Analysis

* The average cost for two people across the dataset is approximately ₹572.
* Koregaon Park is the most expensive dining locality, with an average cost for two of approximately ₹905.
* Kalyani Nagar and Mundhwa also rank among the city's premium dining destinations.

### 5. Ratings Analysis

* Fine Dining restaurants achieved the highest average dining rating (4.02).
* Premium restaurants achieved an average dining rating of 3.84.
* Budget restaurants recorded the lowest average rating (3.53).
* Higher-priced restaurant segments generally received better customer ratings.

### 6. Restaurant Popularity

* AB's - Absolute Barbecues received the highest number of dining reviews (8,152).
* Several well-known Pune restaurants such as Cafe Goodluck, Darshan, and Vaishali ranked among the most-reviewed restaurants.

### 7. Top Rated Restaurants

Among restaurants with at least 50 dining reviews:

* Santé Spa Cuisine
* Le Plaisir
* Gong
* The French Window Patisserie
* Savya Rasa

all achieved a dining rating of 4.9.

### 8. Delivery vs Dining Performance

* Average Dining Rating: 3.63
* Average Delivery Rating: 3.84

Delivery ratings were generally higher than dining ratings.

Several restaurants also showed significant gaps between dining and delivery ratings, indicating differences in customer experience across service channels.



## Sample Outputs

### Pricing Tier Distribution

<img width="262" height="123" alt="pricing_tier_distribution" src="https://github.com/user-attachments/assets/77d74baa-2c7d-4738-ba73-86ab9548b57b" />


---

### Top Localities by Restaurant Count

<img width="328" height="257" alt="top_localities" src="https://github.com/user-attachments/assets/aa77db48-2c01-4d83-9ea1-14c9ef0ad985" />


---

### Highest Rated Restaurants

<img width="516" height="262" alt="highest_rated_restaurants" src="https://github.com/user-attachments/assets/9746b7bb-2f32-47f5-be28-2ce8404824b1" />


---

###  Most Reviewed Restaurants

<img width="392" height="255" alt="most_reviewed_restaurants" src="https://github.com/user-attachments/assets/3133f5fe-34d3-4098-9e3a-4ab975249244" />


---

## Tools Used

* MySQL
* SQL

---

## Conclusion

This project demonstrates a complete SQL-based data analysis workflow, including data cleaning, validation, feature engineering, and exploratory analysis. The findings provide insights into Pune's restaurant landscape, highlighting cuisine preferences, pricing patterns, customer ratings, and locality-level restaurant distribution.
