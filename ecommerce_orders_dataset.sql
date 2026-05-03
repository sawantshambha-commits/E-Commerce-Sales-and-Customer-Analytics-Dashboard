create database e_commerce_sales;
select * from ecommerce_orders_dataset
limit 10;

-- Check Null Values
select * from ecommerce_orders_dataset
where OrderID is null or CustomerID is null;

-- Check and Remove Duplicate Records
select CustomerID, count(OrderID) as Duplicate_value
from ecommerce_orders_dataset
group by CustomerID
having Duplicate_value > 1; 

-- Fix Date Format
alter table ecommerce_orders_dataset
modify Date date;

-- Detect Outliers
select * from ecommerce_orders_dataset
where Quantity < 0 or UnitPrice < 0 or ItemsInCart < 0 or TotalPrice < 0;

-- Rename Columns Properly
alter table ecommerce_orders_dataset
rename column Date to Order_date;

-- Business Analysis SQL Queries
-- 1 Total Sales
select round(sum(TotalPrice), 02) as Total_Sales
from ecommerce_orders_dataset;

-- 2 Top 10 Customers
select CustomerID, sum(TotalPrice) Total_amount 
from ecommerce_orders_dataset
group by CustomerID
order by Total_amount desc
limit 5;

-- 3 Monthly Sales/ Monthly Sales Trend
select month(Order_date) as Month, Year(Order_date) as Year, 
round(sum(TotalPrice), 02) as Total_sales
from ecommerce_orders_dataset
group by month(Order_date), Year(Order_date)
order by year(Order_date), month(Order_date);

-- 4 Top Product
select product, sum(Quantity) as Total_quantity, round(sum(TotalPrice), 02) as Total_amount
from ecommerce_orders_dataset
group by product
order by Total_amount desc
limit 1;

-- 5 Region Wise Profit
select ShippingAddress as City, round(sum(TotalPrice), 2) as Total_amount
from ecommerce_orders_dataset group by City;

-- 6. Running Total Sales
select Order_date, Product, Quantity, sum(TotalPrice) over (partition by date_format(Order_date, '%m-%y') order by Order_date) as Running_Sales
from ecommerce_orders_dataset;

-- Running Total Sales by Month-Year
SELECT 
    Order_date,
    Product,
    Quantity,
    SUM(TotalPrice) OVER (
        PARTITION BY Product, date_format(Order_date, '%m-%y')
        ORDER BY Order_date
    ) AS Running_Sales
FROM ecommerce_orders_dataset;

-- Month-wise Sales Summary with Running Total
SELECT 
    DATE_FORMAT(Order_date, '%Y-%m') AS Month_Year,
    ROUND(SUM(TotalPrice), 2) AS Monthly_Sales,
    SUM(ROUND(SUM(TotalPrice), 2)) OVER (
        ORDER BY DATE_FORMAT(Order_date, '%Y-%m')
    ) AS Running_Total
FROM ecommerce_orders_dataset
GROUP BY DATE_FORMAT(Order_date, '%Y-%m')
ORDER BY DATE_FORMAT(Order_date, '%Y-%m');

-- Month Moving Average
select date_format(order_date, '%y-%m'), avg(TotalPrice) over(order by date_format(order_date, '%y-%m')) as month_avg
from ecommerce_orders_dataset
group by date_format(order_date, '%y-%m')
order by date_format(order_date, '%y-%m');

-- Top 10 Customers by Revenue
select CustomerId, sum(TotalPrice) as Total_Revenue
from ecommerce_orders_dataset
group by CustomerID
order by Total_Revenue desc
limit 10;

-- Loss Making Customers
select CustomerID, sum(TotalPrice) as Total_Revenue
from ecommerce_orders_dataset
group by CustomerID
having Total_Revenue < 0;

-- Prduct Wise Sales Contribution %
select Product, round(sum(TotalPrice), 02) as Total_Sales, 
round(sum(TotalPrice)*100 / (select sum(TotalPrice) from ecommerce_orders_dataset), 02) as Sales_Percetage
from ecommerce_orders_dataset
group by Product
order by Sales_Percetage;

select Product  from ecommerce_orders_dataset limit 1;



