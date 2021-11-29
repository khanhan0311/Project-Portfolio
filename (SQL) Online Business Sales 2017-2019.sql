create database Online_Business_Sales;

--1. Sales of 3 years
select year, sum(total_orders) as total_order_by_year, round(sum(total_sales),2) as total_sales_by_year
from monthly_sales
group by year 
order by year

--2. Calculate products' total net sales and percentage of contribution to the portfolio's total net sales
select s.product_type, round(sum(s.total_net_sales),2) as product_total_net_sales, 
    round((sum(s.total_net_sales)/ (select sum(total_net_sales) from product_sales))*100,2) as percentage_of_contribution
from product_sales s
group by product_type
order by 2 desc, 3 desc

--3. Products' total discounts
select product_type, round(sum(discounts),2) as total_discounts, round(sum(discounts)/sum(gross_sales)*100,2) as percentage_discount
from product_sales 
group by product_type
order by 2 asc

--4. Product's return rate
select s.product_type, round(abs(sum(s.returns)/sum(s.gross_sales))*100,2) as return_rate
from product_sales s
group by s.product_type 
order by 2 desc

--5. Total orders and totales sales of each month
select month, sum(total_orders) as total_orders, round(sum(total_sales),2) as total_sales
from monthly_sales
group by month
order by 2 desc

--6. Total discounts of each month
select month, round(sum(discounts),2) as total_discounts
from monthly_sales
group by month
order by 2 desc

--7. Total returns and Return rate of each month
select month, round(sum(returns),2) as total_returns, round(abs(sum(returns)/sum(gross_sales))*100,2) as return_rate 
from monthly_sales
group by month 
order by 3 asc






