/*
Q1. SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)
 a.	Fetch the employee number, first name and last name of those employees who are 
working as Sales Rep reporting to employee with employeenumber 1102 (Refer employee table)
*/

use `classicmodels`;
show tables;
select * from employees;
select employeeNumber,firstName,lastName from employees where jobTitle ="Sales Rep" and reportsTo=1102;

# b.	Show the unique productline values containing the word cars at the end from the products table
select * from products;

select DISTINCT(productline) from products where productline like "%cars";

/*
Q2. CASE STATEMENTS for Segmentation

. a. Using a CASE statement, segment customers into three categories based on their country:(Refer Customers table)
                        "North America" for customers from USA or Canada
                        "Europe" for customers from UK, France, or Germany
                        "Other" for all remaining countries
     Select the customerNumber, customerName, and the assigned region as "CustomerSegment".

*/

select customerNumber,customerName,case 
when country in ("USA","Canada") then "North America"
when country in ("UK","France","Germany") then "Europ"
else "other"  end as customerSegment from customers;

# Q3. Group By with Aggregation functions and Having clause, Date and Time functions
#a.	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders.

select * from orderdetails ;
select productcode, sum(quantityordered) as total_quantity from orderdetails group by productcode order by total_quantity  desc limit 10;

/* b.	Company wants to analyse payment frequency by month. Extract the month name from the payment date to count the total number
 of payments for each month and include only those months with a payment count exceeding 20. Sort the results by total number of payments 
 in descending order.  (Refer Payments table). */
 
 select * from payments;
 select MONTHNAME(paymentdate) as months,count(customernumber) as payment_count from payments group by months having payment_count>20 order by payment_count desc ;

/*
Q4. CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default

Create a new database named and Customers_Orders and add the following tables as per the description

a.	Create a table named Customers to store customer information. Include the following columns:

customer_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
first_name: This should be a VARCHAR(50) to store the customer's first name.
last_name: This should be a VARCHAR(50) to store the customer's last name.
email: This should be a VARCHAR(255) set as UNIQUE to ensure no duplicate email addresses exist.
phone_number: This can be a VARCHAR(20) to allow for different phone number formats.

Add a NOT NULL constraint to the first_name and last_name columns to ensure they always have a value.
*/
create database Customers_Orders;
use customers_orders;

create table Customers(
customer_id int auto_increment primary key,
first_name varchar(50) not null ,
last_name varchar(50) not null,
email varchar(255) 	unique,
phone_number varchar(20)

);

/* b.	Create a table named Orders to store information about customer orders. Include the following columns:

    	order_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
customer_id: This should be an integer referencing the customer_id in the Customers table  (FOREIGN KEY).
order_date: This should be a DATE data type to store the order date.
total_amount: This should be a DECIMAL(10,2) to store the total order amount.
     	
Constraints:
a)	Set a FOREIGN KEY constraint on customer_id to reference the Customers table.
b)	Add a CHECK constraint to ensure the total_amount is always a positive value.
 */
create table Orders(
Order_id int auto_increment primary key,
customer_id int,
order_date date,
total_amount decimal(10,2) check (total_amount>0),
foreign key(customer_id) references customers(customer_id)
);


#  Q5. JOINS
# a. List the top 5 countries (by order count) that Classic Models ships to. (Use the Customers and Orders tables)
use `classicmodels`;
show tables;

select * from customers;
select * from orders;
select c.country as country, count(o.orderNumber) as order_count from customers as c join orders as o on c.customernumber=o.customernumber group by country order by order_count desc limit 5;

/*
Q6

a. Create a table project with below fields.


●	EmployeeID : integer set as the PRIMARY KEY and AUTO_INCREMENT.
●	FullName: varchar(50) with no null values
●	Gender : Values should be only ‘Male’  or ‘Female’
●	ManagerID: integer 


*/
create table project(
EmployeeID int primary key auto_increment not null,
FullName varchar(111) not null,
gender enum("Male","female"),
managerID int 

);
INSERT INTO project (EmployeeID,FullName, gender, managerID) 
VALUES
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);
select * from project;

select m.fullname as manager,e.fullname as employee from project as e join project as m on e.managerid=m.employeeid order by manager;



/*

Q7. DDL Commands: Create, Alter, Rename
a. Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.

*/
create table facility(
facility_id int ,
Name_ varchar(100),
state varchar(100),
country varchar(100)

);

desc facility;
alter table facility modify facility_id int auto_increment primary key;
alter table facility add column city varchar(100) not null after name_;



/*
Q8. Views in SQL
a. Create a view named product_category_sales that provides insights into sales performance by product category. This view should include the following information:


*/

DROP VIEW IF EXISTS product_category_sales;
create view product_category_sales as 
select pl.productline as productline, 
sum(od.quantityOrdered*od.priceEach) as total_sales,
count(distinct(o.orderNumber)) as number_of_orders 
FROM orderdetails AS od
JOIN products AS p 
    ON od.productCode = p.productCode
JOIN productlines AS pl 
    ON p.productLine = pl.productLine
JOIN orders AS o 
    ON od.orderNumber = o.orderNumber
GROUP BY pl.productLine;

select* from product_category_sales;





select * from product_category_sales;
/*
Q12. ERROR HANDLING in SQL
      Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress

*/

create table Emp_EH(
 emp_id int unsigned primary key,
 Emp_name varchar(111),
 EmailAddress varchar(111)
);

/*
Q10. Window functions - Rank, dense_rank, lead and lag

a) Using customers and orders tables, rank the customers based on their order frequency

*/
select * from customers;
desc customers;
desc orders;
select c.customername,count(o.orderNumber) as order_count ,rank() over(order by count(o.orderNumber) desc) as rnk
 from customers as c join orders as o on c.customernumber=o.customernumber group by c.customername;


/*

b) Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
*/

 with x as(SELECT years,months,counts,LAG(counts,1,"not avaliable") OVER (PARTITION BY years ORDER BY months) AS prev_month_count FROM (SELECT YEAR(orderDate) AS years,MONTH(orderDate) AS months,COUNT(orderNumber) AS counts FROM orders GROUP BY YEAR(orderDate),MONTH(orderDate)) AS t ORDER BY years,months)
 select years,months,counts,concat(round(((counts-prev_month_count)/prev_month_count)*100,0),"%") from x;

/*

Q11.Subqueries and their applications

a. Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.


*/
select productline,count(*) as total from products where buyPrice>(select avg(buyprice) from products) group by productline order by  total desc;



/*
Q13. TRIGGERS
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

*/
create table Emp_BIT(
Name varchar(111),
occupation varchar(111),
working_date date,
woriking_hours time

);
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
