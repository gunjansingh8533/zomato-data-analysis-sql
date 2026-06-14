DROP TABLE IF EXISTS pune_restaurants;
CREATE TABLE pune_restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Restaurant_Name VARCHAR(150),
    Category VARCHAR(255),
    Pricing_for_2 SMALLINT UNSIGNED,
    Locality VARCHAR(100),
    Dining_Rating DECIMAL(3,1),
    Dining_Review_Count INT UNSIGNED,
    Delivery_Rating DECIMAL(3,1),
    Delivery_Rating_Count INT UNSIGNED,
    Website VARCHAR(255),
    Address VARCHAR(255),
    Phone_No VARCHAR(28),
    Latitude DECIMAL(11,8),
    Longitude DECIMAL(11,8),
    Known_for1 VARCHAR(500),
    Known_for2 VARCHAR(500)
);