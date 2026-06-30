-- Databricks notebook source
USE coffee.sales;

-- COMMAND ----------

--- explore the table
SELECT * 
FROM bright_coffee_shop_sales;

--- displaying required columns
SELECT transaction_id,
      transaction_date,
      transaction_time,
      transaction_qty,
     store_location,
     product_category,
    product_type,
    product_detail,
    unit_price
FROM bright_coffee_shop_sales;

SELECT DISTINCT store_location
FROM bright_coffee_shop_sales;

--- Find all product categories
SELECT DISTINCT product_category
FROM bright_coffee_shop_sales;

--- Find all product types
SELECT DISTINCT product_type
FROM bright_coffee_shop_sales;

--- Find all product names
SELECT DISTINCT product_detail
FROM bright_coffee_shop_sales;

--- Display products sold in one store
SELECT *
FROM bright_coffee_shop_sales
WHERE store_location = 'Astoria';

--- Display only Coffee products
SELECT *
FROM bright_coffee_shop_sales
WHERE product_category = 'Coffee';


---Sort by price
SELECT *
FROM bright_coffee_shop_sales
ORDER BY unit_price;

--- Highest priced products first
SELECT *
FROM bright_coffee_shop_sales
ORDER BY unit_price DESC;

--- Sort by transaction date
SELECT *
FROM bright_coffee_shop_sales
ORDER BY transaction_date;

--- Sort by date and time
SELECT *
FROM bright_coffee_shop_sales
ORDER BY transaction_date,
transaction_time;

--- Display Coffee OR Tea
SELECT *
FROM bright_coffee_shop_sales
WHERE product_category = 'Coffee'
OR product_category = 'Tea';

--- Exclude Bakery products
SELECT *
FROM bright_coffee_shop_sales
WHERE product_category <> 'Bakery';

--- Describe table
SELECT COUNT * AS total_row
FROM bright_coffee_shop_sales

--- finding rows containing nulls
SELECT *
FROM bright_coffee_shop_sales
WHERE transaction_id IS null 

--- Finding columns containing nulls
SELECT * 
FROM bright_coffee_shop_sales
WHERE transaction_date IS null or transaction_id IS null or transaction_time is null or transaction_qty IS null or unit_price IS null;

--- Replace nulls with zero
SELECT
    COALESCE(transaction_qty, 0) AS transaction_no
      FROM bright_coffee_shop_sales;

--- Exploring the table
SELECT *
FROM bright_coffee_shop_sales;

---Data range of dataset
SELECT MIN(transaction_date) AS earliest_date,
       MAX(transaction_date) AS latest_date
FROM bright_coffee_shop_sales;

--- Remove timestamp
SELECT transaction_time,
       date_format(transaction_time, 'HH:mm:ss') AS clean_time
FROM bright_coffee_shop_sales;

--- Product levels
SELECT DISTINCT product_category
FROM bright_coffee_shop_sales;

SELECT DISTINCT product_type
FROM bright_coffee_shop_sales;

SELECT DISTINCT product_detail
FROM bright_coffee_shop_sales;


--- Finding the total number of transaction
SELECT COUNT (DISTINCT transaction_id) as total_transactions
FROM bright_coffee_shop_sales;

--- Transaction per day
SELECT transaction_date,
       COUNT(DISTINCT transaction_id) AS total_transactions
FROM bright_coffee_shop_sales
GROUP BY transaction_date
ORDER BY transaction_date;

--- Transaction per month
SELECT month(transaction_date) AS month,
       COUNT(DISTINCT transaction_id) AS total_transactions
FROM bright_coffee_shop_sales
GROUP BY month(transaction_date)
ORDER BY month(transaction_date);

--- Calculate Revenue
SELECT
    unit_price,
    transaction_qty,
    CAST(transaction_qty AS DOUBLE) *
    CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) AS Revenue
FROM bright_coffee_shop_sales;

--- Revenue by Month
SELECT
    MONTHNAME(transaction_date) AS Month,
    SUM(
        CAST(transaction_qty AS DOUBLE) *
        CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)
    ) AS Revenue
FROM bright_coffee_shop_sales
GROUP BY Month;

---Revenue Rounded
SELECT
    MONTHNAME(transaction_date) AS Month,
    ROUND(
        SUM(
            CAST(transaction_qty AS DOUBLE) *
            CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)
        ),
        2
    ) AS Revenue
FROM bright_coffee_shop_sales
GROUP BY Month;


--- Clean Time
SELECT
    transaction_time,
    DATE_FORMAT(transaction_time, 'HH:mm:ss') AS Clean_Time
FROM bright_coffee_shop_sales;

--- Time Bucket using HOUR()
SELECT
    transaction_time,
    DATE_FORMAT(transaction_time, 'HH:mm:ss') AS Clean_Time,

    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 10 AND 13 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 13 AND 18 THEN 'Late Afternoon'
        ELSE 'Evening'
    END AS Time_Bucket

FROM bright_coffee_shop_sales;

--- Morning vs Evening
SELECT
    transaction_time,
    DATE_FORMAT(transaction_time, 'HH:mm:ss') AS Clean_Time,

    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '09:59:59'
            THEN 'Morning'
        ELSE 'Evening'
    END AS Time_Bucket

FROM bright_coffee_shop_sales;


---Weekend vs Weekday (Using DAYOFWEEK)
SELECT
    CASE
        WHEN DAYOFWEEK(transaction_date) IN (1,7)
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type

FROM bright_coffee_shop_sales


--- Weekend vs Weekday (Using DAYNAME)
SELECT
    DAYNAME(transaction_date),

    CASE
        WHEN DAYNAME(transaction_date) IN ('Saturday','Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type

FROM bright_coffee_shop_sales;


---Extract Date Information
SELECT

    DAYNAME(transaction_date) AS Day_Name,

    MONTHNAME(transaction_date) AS Month_Name,

    DAY(transaction_date) AS Day_Number

FROM bright_coffee_shop_sales;


--- Main Query with New Columns
SELECT
    transaction_id,
    transaction_date,
    DATE_FORMAT(transaction_time,'HH:mm:ss') AS Clean_Time,
    transaction_qty,
    store_id,
    store_location,      
    product_id,
    unit_price,
    product_category,
    product_type,
    product_detail,
    transaction_time,
    DAYNAME(transaction_date) AS day_name,    --- day name (Monday,Tuesday...)
    MONTHNAME(transaction_date) AS month_name,  --- month name (January,February...)
    DAY(transaction_date) AS day_number,
    CASE 
        WHEN DAYNAME(transaction_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,        --- weekday vs weekend
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 11 AND 13 THEN 'Afternoon'  ---Time Bucket
        WHEN HOUR(transaction_time) BETWEEN 14 AND 18 THEN 'Late Afternoon'
        ELSE 'Evening'
    END AS Time_Bucket,
    CASE
        WHEN DAY(transaction_date) BETWEEN 1 AND 10 THEN 'Early Month'
        WHEN DAY(transaction_date) BETWEEN 11 AND 20 THEN 'Mid Month'     --- Month Period
        ELSE 'Month End'
    END AS Month_Period,
    CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) AS Clean_Unit_Price,
    ROUND(CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE), 2) AS Revenue,
    CASE
        WHEN CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) <= 50 THEN 'Cheap Spend'
        WHEN CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) > 50 AND CAST(transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) <= 300 THEN 'Medium Spend'
        ELSE 'Expensive Spend'
    END AS Spend_Bucket            ---Spend Bucket
FROM bright_coffee_shop_sales;













