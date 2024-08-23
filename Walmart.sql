#Create database
create database if not exists walmartSales;

#Create Table
Create table if not exists sales(
	invoice_id varchar(30) not null Primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(30) not null,
    product_line varchar(100) not null,
    unit_price Decimal(10,2) not null,
    quantity int not null,
    tax_pct float(6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9),
    gross_income decimal(12,4),
    rating float(2,1)
);

#Data cleaning
select * from sales;

select time from sales;
-- --------------------------------------------------------------------------------------------------------------

#Add the time_of_day column
-- select time, (case 
-- 	when time between "00:00:00" and "12:00:00" then "Morning"
-- 	when time between "12:01:00" and "16:00:00" then "Afternoon"
--     else "Evening"
--     End)
-- As time_of_day
-- from sales;

select * from sales;

Alter table sales add column time_of_day varchar(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
-- --------------------------------------------------------------------------------------------------------------

-- Add day_name column
select date, dayname(DATE) from sales;

Alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

select * from sales;
-- --------------------------------------------------------------------------------------------------------------

-- Add month_name column
select date, MONTHNAME(DATE)
FROM SALES;

alter table sales add column month_name varchar(10);

update sales
set month_name = MONTHNAME(DATE);

-- --------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------Generic----------------------------------------------------------									

-- How many unique cities does the data have?
select distinct city from sales;

-- In which city is each branch?
select distinct city, branch from sales;

-- ----------------------------------------------Product---------------------------------------------------------

-- How many unique product lines does the data have?
select distinct product_line from sales;

-- What is the most selling product line
select sum(quantity) as qty, product_line
from sales
group by product_line
order by qty desc;

-- What is the total revenue by month
select month_name as month,
sum(total) as total_revenue 
from sales group by month_name
order by total_revenue desc;


-- What month had the largest COGS?
select month_name as Month, 
sum(cogs) as cogs
from sales 
group by month_name
order by cogs;

-- What product line had the largest revenue?
select product_line, 
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?
select branch, city, sum(total) as Total_revenue
from sales
group by city, branch
order by Total_revenue; 

-- What product line had the largest VAT?
select product_line, Avg(tax_pct) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad".
-- Good if its greater than average sales.

select avg(quantity) as avg_qnty
from sales;

select product_line, 
case
	when avg(quantity) > 6 then "Good"
    else "Bad"
end as remark
from sales
group by product_line;

-- Which branch sold more products than average product sold?
select branch, sum(quantity) as qnty 
from sales
group by branch
having sum(quantity)>(select avg(quantity) from sales);

-- What is the most common product line by gender
select gender, product_line,
count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- What is the average rating of each product line
select round(avg(rating),2) as avg_rating,
product_line from sales
group by product_line
order by avg_rating  desc;

-- ----------------------------------Customers-------------------------------------------------------------------

-- How many unique customer types does the data have
select distinct customer_type
from sales;

-- How many unique payment methods does the data have?
select distinct payment from sales;

-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
select customer_type, count(*)
from sales
group by customer_type;

-- What is the gender of most of the customers?
select gender, count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- What is the gender distribution per branch
select gender, count(*) as gender_cnt from sales
where branch = "C"
group by gender 
order by gender_cnt desc;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;
-- Looks like time of the day does not really affect the rating,
-- its more or less the same rating each time of the day.alter

-- which time of the day do customers give most ratings per branch?
select time_of_day, avg(rating) as avg_rating
from sales 
where branch ="A" 
group by time_of_day
order by avg_rating desc;

-- Which day of the week has the best avg rating?
Select day_name, avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;
-- Monday, Tueday, and Friday are the top best days for good rating
-- why is that the case, how many sales are, made on these days?

-- Which day of the week has the best average ratings per branch?
select day_name, count(day_name) total_sales
from sales
where branch = "C"
group by day_name
order by total_sales desc;

-- --------------------------------------------Sales-------------------------------------------------------------
-- Number of sales made in each time of the day per weekend
select time_of_day,
count(*) as Total_sales
from sales
where day_name = "Sunday"
group by time_of_day
order by total_sales desc;
-- Evening expercience most sales, the stores are filled during the evening hours

-- Which of the customer types brings most revenue?
select customer_type,
sum(total) as total_revenue
from sales 
group by customer_type
order by total_revenue;

-- Which of the customer types bring the most revenue?
select customer_type, sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue;

-- Which city has the largest taxx/vat percentage?
select city, 
round(avg(tax_pct),2) as avg_tax_pct
from sales
group by city 
order by avg_tax_pct desc;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
  



