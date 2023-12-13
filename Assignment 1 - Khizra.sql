SELECT * FROM food_prices_pakistan;
# Updating the type of Date column in food prices table
SET SQL_SAFE_UPDATES=0;
/*---------------------------------------------------------------------------------------------------------*/
#rename a column
ALTER TABLE food_prices_pakistan
RENAME COLUMN ï»¿date TO date_pr;
/*----------------------------------------------------------------------------------------------------------*/
UPDATE food_prices_pakistan
SET date_pr = str_to_date(date_pr, '%m/%d/%Y'); #i am not sure why my query is not working :(, i tried to change 
#it in many ways but did not succeed
/*---------------------------------------------------------------------------------------------------------*/

#1. Select dates and commodities for cities Quetta, Karachi, and Peshawar where price was less than 
#or equal 50 PKR

SELECT date_pr,cmname,price FROM food_prices_pakistan
WHERE price <= 50;
/*------------------------------------------------------------------------------------------------------------*/

#2  Query to check number of observations against each market/city in PK

SELECT city, COUNT(date_pr) AS observations
FROM food_prices_pakistan
GROUP BY city;
/*-----------------------------------------------------------------------------------------------------------*/

#3 Show number of distinct cities

SELECT COUNT(distinct(city)) FROM food_prices_pakistan;
/*-------------------------------------------------------------------------------------------------------------*/

#4 List down/show the names of cities in the table

SELECT city, COUNT(distinct(city)) AS count_cities
FROM food_prices_pakistan
GROUP BY city;
/*------------------------------------------------------------------------------------------------------------*/

#5 List down/show the names of commodities in the table

SELECT cmname, COUNT(DISTINCT cmname) AS commodities
FROM food_prices_pakistan
GROUP BY cmname;

/*-----------------------------------------------------------------------------------------------------------*/
#6.	List Average Prices for Wheat flour - Retail in EACH city separately over the entire period.

SELECT city,cmname, ROUND(AVG(price),3) AS avg_price
FROM food_prices_pakistan
GROUP BY city,cmname
HAVING cmname = 'Wheat Flour - Retail';

/*-------------------------------------------------------------------------------------------------------------*/
#7.	Calculate summary stats (avg price, max price) for each city separately for all cities except 
#Karachi and sort alphabetically the city names, commodity names where commodity is 
#Wheat (does not matter which one) with separate rows for each commodity

SELECT cmname,city, MAX(price) AS max_price, AVG(price) AS avg_price
FROM food_prices_pakistan
WHERE city <> 'Karachi' AND cmname LIKE '%Wheat%'
GROUP BY cmname,city
ORDER BY cmname,city;

/*-------------------------------------------------------------------------------------------------------------*/

#8.	Calculate Avg_prices for each city for Wheat Retail and show only those avg_prices which are less 
#than 30

SELECT cmname,city, AVG(price) AS avg_price
FROM food_prices_pakistan
WHERE cmname = 'Wheat - Retail'
GROUP BY cmname,city
HAVING avg_price<30;

/*------------------------------------------------------------------------------------------------------------*/
#9.	Prepare a table where you categorize prices based on a logic (price < 30 is LOW, price > 250 
#is HIGH, in between are FAIR)

SELECT
	price,
    cmname,
	CASE
		WHEN price < 30 THEN 'Low'
		WHEN price > 250 THEN 'High'
		ELSE 'Fair' 
	END AS price_meter
	FROM food_prices_pakistan;
    
/*----------------------------------------------------------------------------------------------------------*/
#10.	Create a query showing date, cmname, category, city, price, city_category where Logic for city category is
# Karachi and Lahore are 'Big City', Multan and Peshawar are 'Medium-sized city', Quetta is 'Small City'

SELECT * FROM food_prices_pakistan;    
SELECT COUNT(distinct city) FROM food_prices_pakistan;

ALTER TABLE food_prices_pakistan
CHANGE mktname city VARCHAR(50);

SELECT
	date_pr,
    cmname,
    category,
    city,
    price,
    CASE
		WHEN city LIKE 'Karachi' THEN 'Big City'
        WHEN city LIKE 'Lahore' THEN 'Big City'
        WHEN city LIKE 'Multan' THEN 'Medium-sized city'
        WHEN city LIKE 'Peshawar' THEN 'Medium-sized city'
        WHEN city LIKE 'Quetta' THEN 'Small city' 
	END AS city_category
FROM food_prices_pakistan;

/*-----------------------------------------------------------------------------------------------------------*/
#11.Create a query to show date, cmname, city, price. Create new column price_fairness through CASE showing price
# is fair if less than 100, unfair if more than or equal to 100, if > 300 then 'Speculative

SELECT 
	date_pr,
    cmname,
    city,
    price,
	CASE
		WHEN price < 100 THEN 'Fair'
		WHEN price >= 100 THEN 'Unfair'
		WHEN price > 300 THEN 'Speculative'
	END AS price_fairness
FROM food_prices_pakistan;

/*------------------------------------------------------------------------------------------------------------*/
#12.Join the food prices and commodities table with a left join.

ALTER TABLE commodity
RENAME COLUMN date_pr TO cmname;

SELECT * FROM commodity;

SELECT commodity.cmname, food_prices_pakistan.price  
FROM commodity 
LEFT JOIN food_prices_pakistan
ON commodity.cmname = food_prices_pakistan.cmname;
    
/*------------------------------------------------------------------------------------------------------------*/
#13.Join the food prices and commodities table with an inner join

SELECT commodity.cmname, food_prices_pakistan.price
FROM commodity
INNER JOIN food_prices_pakistan ON commodity.cmname = food_prices_pakistan.cmname;

/*=========================================================END================================================*/