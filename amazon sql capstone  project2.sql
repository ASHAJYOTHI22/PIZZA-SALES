use amazon_database;

SELECT  * FROM amazon; 

-- 1. What is the count of distinct cities in the dataset?
select distinct(city) from amazon;  

SELECT 
    COUNT(DISTINCT (city)) 
FROM
    amazon; 

-- 2. For each branch, what is the corresponding city?
SELECT DISTINCT
    (branch), city
FROM
    amazon; 

-- 3. What is the count of distinct product lines in the dataset?
select distinct(Productline) from amazon; 

SELECT 
    COUNT(DISTINCT (Productline)) AS count_prod
FROM
    amazon; 

-- 4. Which payment method occurs most frequently?
SELECT DISTINCT
    (payment), COUNT(*)
FROM
    amazon
GROUP BY payment
ORDER BY COUNT(*) DESC
LIMIT 1; 

-- 5. Which product line has the highest sales?
select distinct(Productline), sum(Quantity) as no_of_sales from amazon group by productline;

SELECT DISTINCT
    (Productline), SUM(Quantity) AS no_of_sales
FROM
    amazon
GROUP BY productline
ORDER BY no_of_sales DESC
LIMIT 1;

/*
set sql_safe_updates = 0;
alter table amazon
add column time_of_the_day varchar(50); 

UPDATE amazon
SET time_of_the_day = 
    CASE
        WHEN HOUR(Time) BETWEEN 0 AND 12 THEN 'morning'
        WHEN HOUR(Time) BETWEEN 13 AND 18 THEN 'afternoon'
        ELSE 'night'
    END; 
    
alter table amazon 
add column month_name varchar(50); 
    
UPDATE amazon
SET month_name = MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y')); 

    */ 

-- 6. How much revenue is generated each month?
SELECT 
    month_name, SUM(total) AS revenue
FROM
    amazon
GROUP BY 1; 

-- 7.In which month did the cost of goods sold reach its peak? 
select month_name, sum(cogs) as cost_of_goods
from amazon group by month_name; 

SELECT 
    month_name, SUM(cogs) AS cost_of_goods
FROM
    amazon
GROUP BY month_name
ORDER BY cost_of_goods DESC
LIMIT 1; 

-- 8.Which product line generated the highest revenue?
select Productline, sum(Total) as revenue 
from amazon 
group by 1;

SELECT 
    Productline, SUM(Total) AS revenue
FROM
    amazon
GROUP BY 1
ORDER BY revenue DESC
LIMIT 1;

-- 9.In which city was the highest revenue recorded?
SELECT 
    City, SUM(Total) AS revenue
FROM
    amazon
GROUP BY 1
ORDER BY revenue DESC
LIMIT 1;

/*ALTER TABLE amazon CHANGE COLUMN `Tax5%` Tax DECIMAL(12,4);*/

-- 10.Which product line incurred the highest Value Added Tax?
SELECT 
    Productline, SUM(Tax) AS tax
FROM
    amazon
GROUP BY 1
ORDER BY tax DESC
LIMIT 1;

-- 11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT 
    Productline,
    CASE
        WHEN SUM(Total) > AVG(Total) THEN 'GOOD'
        ELSE 'BAD'
    END AS sales_category
FROM
    amazon
GROUP BY 1;

-- 12.Identify the branch that exceeded the average number of products sold.
SELECT 
    Branch, SUM(Quantity) AS no_of_products_sold
FROM
    amazon
GROUP BY 1
HAVING SUM(Quantity) > (SELECT 
        AVG(Quantity)
    FROM
        amazon);  
        

-- 13.Which product line is most frequently associated with each gender?
SELECT
    DISTINCT(Gender),
    Productline,
    count(*) AS total_quantity
FROM
    amazon
GROUP BY
    Gender,
    Productline
ORDER BY
    Gender,
    total_quantity DESC
LIMIT 1; 

-- 14.Calculate the average rating for each product line.
SELECT 
    Productline, AVG(Rating) AS avg_rating
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC; 

ALTER TABLE amazon
ADD COLUMN dayname VARCHAR(20);
/*
UPDATE amazon
SET dayname = DAYNAME(STR_TO_DATE(Date, '%m/%d/%Y')); 
*/

-- 15.Count the sales occurrences for each time of day on every weekday. 
SELECT 
    dayname, time_of_the_day, COUNT(*) AS salescount
FROM
    amazon
WHERE
    dayname NOT IN ('Saturday' , 'Sunday')
GROUP BY 1 , 2
ORDER BY 2 ASC , 3 DESC;

-- 16.Identify the customer type contributing the highest revenue
SELECT 
    Customertype, SUM(Total) AS revenue
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1; 

-- 17.Determine the city with the highest VAT percentage.
SELECT 
    City, ROUND(SUM(Tax) / 100, 2) AS total_vat
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 18.Identify the customer type with the highest VAT payments.
SELECT 
    Customertype, SUM(Tax) AS total_vat
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1; 

-- 19.What is the count of distinct customer types in the dataset? 
SELECT 
    COUNT(DISTINCT (Customertype)) AS count
FROM
    amazon;

-- 20.What is the count of distinct payment methods in the dataset?
SELECT 
    COUNT(DISTINCT (Payment)) AS Payment_method_count
FROM
    amazon;

-- 21.Which customer type occurs most frequently?
SELECT 
    Customertype, COUNT(*) AS count
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;  

-- 22.Identify the customer type with the highest purchase frequency.
SELECT 
    Customertype, COUNT(*) AS count
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;  

-- 23.Determine the predominant gender among customers.
SELECT 
    Gender, COUNT(*) AS count
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;  

-- 24.Examine the distribution of genders within each branch.
SELECT 
    Branch, Gender, COUNT(*) AS count
FROM
    amazon
GROUP BY 1 , 2
ORDER BY 1 ASC , 3 DESC;  

-- 25.Identify the time of day when customers provide the most ratings.
SELECT 
    time_of_the_day, COUNT(Rating) AS count
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;  

-- 26.Determine the time of day with the highest customer ratings for each branch.
SELECT 
    time_of_the_day, 
    Branch, 
    COUNT(*) AS count, 
    RANK() OVER (PARTITION BY Branch ORDER BY COUNT(*) DESC) AS ranks
FROM 
    amazon 
GROUP BY 
    time_of_the_day, 
    Branch
ORDER BY 
    COUNT(*) DESC;

-- 27.Identify the day of the week with the highest average ratings.
SELECT 
    dayname, AVG(Rating) AS avg_rating
FROM
    amazon
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;  

-- 28.Determine the day of the week with the highest average ratings for each branch.
SELECT DISTINCT
    (dayname), Branch, AVG(Rating) AS avg_rating
FROM
    amazon
GROUP BY 1 , 2
ORDER BY 3 DESC
;  

