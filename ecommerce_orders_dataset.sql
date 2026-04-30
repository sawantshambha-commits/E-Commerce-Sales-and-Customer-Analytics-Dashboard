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



