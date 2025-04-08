/* CREATE TABLE Customer (
  customer_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  email VARCHAR2(100),
  city VARCHAR2(50)
);

CREATE TABLE Product (
  product_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  category VARCHAR2(50),
  price NUMBER(8, 2)
);

CREATE TABLE Orders (
  order_id NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES Customer(customer_id),
  order_date DATE
);

CREATE TABLE OrderItem (
  orderitem_id NUMBER PRIMARY KEY,
  order_id NUMBER REFERENCES Orders(order_id),
  product_id NUMBER REFERENCES Product(product_id),
  quantity NUMBER
);

CREATE TABLE Shipment (
  shipment_id NUMBER PRIMARY KEY,
  order_id NUMBER REFERENCES Orders(order_id),
  shipment_date DATE,
  carrier VARCHAR2(50)
);
*/
-- Basic Queries:

-- 1. List all customers from a specific city (`'Mumbai'`).
select customer_id, name
from customer 
where city = 'Mumbai';

-- 2. Show all products under the category `'Electronics'` priced above ₹10,000
select product_id, name 
from product 
where category = 'Electronics' and price > 10000;
-- 3. Find the email addresses of customers who placed an order on `'2024-12-25'`.
select email 
from customer natural join orders 
--where to_char(order_date, 'YYYY-MM-DD') = '2024-03-03';
where order_date = date '2024-03-03';
-- 4. List all orders along with the name of the customer who placed them.
select orderitem_id, order_id, product_id, quantity, order_date, name 
from orderitem natural join orders natural join customer;
-- 5. Display all products in each order using `OrderID`.
select order_id, product_id, name 
from orderitem natural join product
order by order_id;

-- Intermediate (Joins, Aggregates, Grouping):

-- 6. For each order, show the total number of items purchased (sum of quantities).
select order_id, sum(quantity)
from orderitem 
group by order_id;
-- 7. List all orders with their total order value (price * quantity of each product).
select order_id, sum(quantity * price) 
from orderitem natural join product 
group by order_id;
-- 8. Find the number of orders each customer has placed.
select customer_id, count(order_id)
from orders
group by customer_id;
-- 9. Show the average product price in each category.
select category, avg(price)
from product 
group by category;
-- 10. Get the list of customers who have ordered more than 5 items in total.
select customer_id, count(quantity)
from orders natural join orderitem 
group by customer_id 
having count(orderitem_id) > 3;

-- Advanced (Subqueries, Nested Joins, Group Filters):

-- 11. List customers who have **never placed any order**.
select customer_id, name
from customer left join orders using (customer_id)
where order_id is null;
-- 12. List products that have **never been ordered**.
select product_id, name 
from product left join orderitem using (product_id) 
where orderitem_id is null;
-- 13. Show the names of customers who ordered at least **one product** from the **'Clothing'** category.
select c.name, p.name 
from customer c join orders using(customer_id) 
join orderitem using (order_id)
join product p using (product_id) 
where p.category = 'Clothing';
-- 14. Find orders that contain **more than 3 different products**.
select order_id, count(distinct product_id)
from orderitem 
group by order_id 
having count(product_id) > 1;
-- 15. For each customer, show the **total number of distinct products** they have ordered.
select customer_id, count(distinct product_id) 
from orders natural join orderitem 
group by customer_id;

-- Date-Based + Shipment Logic:

-- 16. Show all orders that were shipped **within 3 days** of ordering.
select order_id
from shipment natural join orders 
where shipment_date - order_date <= 3;
-- 17. List all carriers that have shipped **more than 10 orders**.
select carrier, count(order_id)
from shipment 
group by carrier
having count(order_id) >= 2;
-- 18. Find the earliest shipment date for each customer.
select customer_id, min(shipment_date)
from shipment natural join orders 
group by customer_id;
-- 19. List all products shipped by the carrier `'BlueDart'`.
select product_id, name, sum(quantity)
from shipment natural join orderitem natural join product 
where carrier = 'BlueDart'
group by product_id, name;
-- 20. Identify orders that haven’t been shipped yet.
select order_id 
from orders left join shipment using (order_id)
where shipment_id is null;
-- Challenge Mode (Flex your SQL muscles):

-- 21. List customers who have **only ordered products in a single category**.
select customer_id, min(category)
from orders natural join orderitem natural join product 
group by customer_id
having count(category) = 1;
-- 22. Show the **top 3 most frequently ordered products**.
select count(product_id) 
from orderitem 


-- 23. Identify the customer who spent the **most money** in total.
-- 24. List all customers who have ordered the **same product more than once** (even in different orders).
-- 25. Find all orders where the **total value exceeds ₹50,000**, and list the order ID, customer name, and total value.

-- 1. Basic PL/SQL Blocks

-- 1. **Write a PL/SQL block** to display customer name and city for a given `CustomerID`.
-- 2. **Print total number of orders** placed by a customer using `CustomerID` as input.
-- 3. Create a block that takes a `ProductID` and prints its name and price.
-- 4. Accept an order ID and display **total quantity of products** ordered in that order.
-- 5. Accept a product name, and display its **category and price**.

-- 2. IF-ELSE + Loops

-- 6. Check if a customer exists for a given `CustomerID`. If yes, print their name. If not, print "Customer not found".
-- 7. For a given customer, loop through all their orders and print each `OrderID` and `OrderDate`.
-- 8. Write a PL/SQL block to categorize a product price:
--    - Price < 500: ‘Low’
--    - 500 ≤ Price ≤ 5000: ‘Medium’
--    - Price > 5000: ‘High’

-- 3. Cursors (Static & Parameterized)

-- 9. Use a cursor to **fetch all products** under the `'Electronics'` category and display them.
-- 10. Write a parameterized cursor to fetch all orders for a **given city**.
-- 11. Cursor to display all **items in a given order** (order ID as input) with product names and quantities.
-- 12. Use a cursor to list all **unshipped orders** and display their `OrderID` and `Customer Name`.

-- 4. Exceptions (Built-in + User-Defined)

-- 13. Write a block to insert a new product. If the price is negative, raise a **user-defined exception**.
-- 14. Create a block that updates the shipment date. Handle the case where the order does not exist using `NO_DATA_FOUND`.
-- 15. Write a PL/SQL block that fetches and displays a product. If product not found, handle the exception and print "Invalid Product ID".

-- 5. Procedures & Functions

-- 16. Create a **procedure** that takes `CustomerID` and prints all their order details.
-- 17. Write a **function** that returns the **total value of an order**.
-- 18. Procedure that inserts a new order into the `Orders` table and returns the newly generated `OrderID`.
-- 19. Function that takes a city name and returns the **number of customers** in that city.
-- 20. Procedure that accepts `ProductID`, `OrderID`, and `Quantity`, and inserts it into `OrderItem`.

-- 6. Triggers

-- 21. Write a **trigger** to prevent inserting an order with a `NULL` `CustomerID`.
-- 22. Create a trigger to **log every new product insertion** into a separate `ProductLog` table.
-- 23. Write a trigger to **auto-update shipment date** to `SYSDATE` when a new shipment is added.
-- 24. Trigger to ensure no order is placed with quantity ≤ 0 in `OrderItem`.
-- 25. Create a row-level trigger that updates a `TotalOrders` field in `Customer` every time an order is placed.

-- 7. Bonus Boss Challenges

-- 26. Write a block to print **top 3 customers by order value**.
-- 27. Create a procedure to generate a **monthly sales report** — total revenue grouped by category.
-- 28. Cursor + nested loop: For each customer, print all products they’ve ordered.
-- 29. Trigger to update a `LastOrderDate` column in `Customer` table after each new order.
-- 30. Build a procedure that **cancels an order** — deletes from `OrderItem`, `Shipment`, and then `Orders`.

