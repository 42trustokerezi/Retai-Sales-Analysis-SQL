CREATE DATABASE sql_project_p1;

-- create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15), 	
		quantiy	INT,
		price_per_unit FLOAT,	
		cogs FLOAT,
		total_sale FLOAT
);

select * from retail_sales;

-- count all records
select count(*) from retail_sales;

-- finding null records
select * from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or 
	category is null
	or
	quantiy is null
	or 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

-- delete null records
delete from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or 
	category is null
	or
	quantiy is null
	or 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

-- Data exploration --
-- 1. how many sales do we have?
select count(*) as total_transactions
from retail_sales;

-- 2. how many customers do we have?
select * from retail_sales;
select count(distinct customer_id) as total_customers 
from retail_sales;

-- 3. what categories are present in our dataset?
select distinct category from retail_sales;

-- DATA ANALYSIS --
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
where sale_date = '2022-11-05';
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select category,
 sum(quantiy) as quantity
from retail_sales
where
	category = 'Clothing'
	and 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	and 
	quantiy >= 4
group by category;
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as total_sale from retail_sales
group by category;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- select * from retail_sales;
select 
round(avg(age)) as avg_age from retail_sales
where category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select transactions_id from retail_sales
where total_sale > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(*) as total_transactions from retail_sales
group by
category,
gender;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
	year,
	month,
	avg_sale
from
(
select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date)order by avg(total_sale) desc) as rank
from retail_sales
group by 1, 2
) as t1;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
	category,
	count(distinct customer_id) as unique_cs
from retail_sales
group by category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'morning'
		when extract(hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;