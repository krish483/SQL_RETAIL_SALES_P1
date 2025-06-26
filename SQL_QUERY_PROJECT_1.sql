DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(15),
	age	INT,
	Category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10

SELECT
	COUNT(*)
FROM retail_sales

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL 
	OR
	price_per_unit IS NULL 
	OR
	cogs IS NULL 
	OR 
	total_sale IS NULL

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL 
	OR
	price_per_unit IS NULL 
	OR
	cogs IS NULL 
	OR 
	total_sale IS NULl

-- Data exploration

-- Q1 How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

SELECT distinct category FROM retail_sales

--Data analysis & business key problems and answers

--Q2 How many sales were done on 5 Nov 2022?
SELECT * FROM retail_sales WHERE sale_date='2022-11-05'
--This will give information about the total sale on 5 Nov 2022

--Q3 Write a SQL Query to retrieve all coloums for sales made on '2022-11-05'?
-- First tried to get the sum of quantities for the category Clothing 
SELECT
	category,
	SUM(quantity)
FROM retail_sales
where category = 'Clothing'
Group by 1 
-- this told us about the total quantity sold till now of Clothing

-- then the final answer of question 3 is 
SELECT * FROM retail_sales where category='Clothing' AND TO_CHAR(sale_date,'yyyy-mm')='2022-11'
and quantity >=4

--Q4 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
	   SUM(total_sale) as net_sale,
	   COUNT(*) AS total_orders
	   FROM retail_sales
	   Group by 1

--Q5 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' catergory.

SELECT ROUND(AVG(age), 00) as avg_age FROM retail_sales WHERE category = 'Beauty'
--In this we used Round for for rounod-off and AVG to do the average 
--as is used to change the column name

--Q6 Write a SQL query to find all the transactions where the total_sale is greater than 1000.
SELECT transactions_id, sale_date, price_per_unit, total_sale  FROM retail_sales WHERE total_sale>=1000
-- jo jo column chahiye usey select mai daaldo jo condition hai usey where mai daal do

--Q7 Write a SQL query to find the total numbers of transactions (transactions_id) made by each gender in each category
SELECT gender AS LING, category ,COUNT(*) transactions_id FROM retail_sales GROUP BY category, gender order by 1
--if staring mai 2 cloumns hai to grouping mai bhi dono ka name likhna pdega \

--Q8 Write a SQL Query to calculate the average sale for each month find out best selling month in each year 
SELECT EXTRACT(YEAR FROM sale_date) AS YEAR,
	   EXTRACT(MONTH FROM sale_date) AS MONTH,
	   AVG(total_sale) as total_sale
	   FROM retail_sales
	   GROUP BY 1,2
	   ORDER BY 1,2 
-- each month ka average nikalne ke liye pehle year define kro then month then average kr kr unhe grp kro and then order set 


SELECT EXTRACT(YEAR FROM sale_date) AS YEAR,	  
	   EXTRACT(MONTH FROM sale_date) AS MONTH,
	   AVG(total_sale) as total_sale,
	   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	   
	   FROM retail_sales
	   GROUP BY 1,2
	   ORDER BY 1,4 

--rank set krne ke liye rank function se partition kiya by year then order set kiya then name diya rank


SELECT year,month,total_sale FROM(
SELECT EXTRACT(YEAR FROM sale_date) AS YEAR,	  
	   EXTRACT(MONTH FROM sale_date) AS MONTH,
	   AVG(total_sale) as total_sale,
	   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	   
	   FROM retail_sales
	   GROUP BY 1,2
	   ORDER BY 1,4 )
	   AS T1
	   WHERE rank=1
-- if only highest rankers chahiye to outer select use kro sbka name do year, month, total_sale then rank =1 se end kro


--Q8 Write a SQL query to find the top 5 customers based on the total_sale.

SELECT customer_id, sum(total_sale)
FROM retail_sales 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5

-- Remember by when will you select 2 columns then you have to use group by and for order use order by

--Q9 Write a SQL Query to find the number of unique customers who had purchased from each category

SELECT * FROM retail_sales
SELECT COUNT(DISTINCT customer_id), category FROM retail_sales group by category

--Q10 Write a SQL Query to create each shift number of orders (example morning <=12, afternoon btw 12 & 17 and evening >17)
WITH Hourly_Sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END AS shift 
FROM retail_sales
)
SELECT shift, COUNT(*) as total_orders
FROM Hourly_Sale
Group by shift

--end of project
		