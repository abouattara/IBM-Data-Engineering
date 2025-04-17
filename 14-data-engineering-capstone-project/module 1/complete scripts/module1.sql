--------------------------------------------------------
-- Here sql code used for capstone module 1
-- Author : Abdoulaye OUATTARA
--------------------------------------------------------
--- 1. Create database sales_data
CREATE DATABASE sales;
use sales;

--- 2. Create table sales_data
CREATE TABLE sales_data(
    product_id int,
    customer_id int,
    price int,
    quantity int,
    timestamp date
);

--- 4. List tables in sales
SHOW TABLES;

--- 5. Query to find the count of records in sales_data
SELECT count(*) FROM sales_data;

--- 6 & 7. Create index and view it
CREATE INDEX sales_data_index 
ON sales_data(product_id, custumer_id);

SHOW INDEX FROM sales_data;

--- 8. Export sales_data rows to sales.sql
-- The command bellow are used in bash
-- mysqldump -u root -pxjjbdjadbhbaahnjzjshsbhs sales > sales_data.sql