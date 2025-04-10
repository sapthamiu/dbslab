/*
CREATE TABLE Customer1 (
  customer_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  email VARCHAR2(100),
  city VARCHAR2(50)
);

CREATE TABLE Product1 (
  product_id NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  category VARCHAR2(50),
  price NUMBER(8, 2)
);

CREATE TABLE Orders1 (
  order_id NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES Customer1(customer_id),
  order_date DATE
);

CREATE TABLE OrderItem1 (
  orderitem_id NUMBER PRIMARY KEY,
  order_id NUMBER REFERENCES Orders1(order_id),
  product_id NUMBER REFERENCES Product1(product_id),
  quantity NUMBER
);

CREATE TABLE Shipment1 (
  shipment_id NUMBER PRIMARY KEY,
  order_id NUMBER REFERENCES Orders1(order_id),
  shipment_date DATE,
  carrier VARCHAR2(50)
);

--customers
INSERT INTO Customer1 VALUES (1, 'Aditi Sharma', 'aditi@example.com', 'Delhi');
INSERT INTO Customer1 VALUES (2, 'Rahul Verma', 'rahul@example.com', 'Mumbai');
INSERT INTO Customer1 VALUES (3, 'Sneha Das', 'sneha@example.com', 'Kolkata');
INSERT INTO Customer1 VALUES (4, 'Karan Mehta', 'karan@example.com', 'Chennai');
INSERT INTO Customer1 VALUES (5, 'Neha Singh', 'neha@example.com', 'Bangalore');
INSERT INTO Customer1 VALUES (6, 'Aman Joshi', 'aman@example.com', 'Hyderabad');
INSERT INTO Customer1 VALUES (7, 'Divya Rao', 'divya@example.com', 'Pune');
INSERT INTO Customer1 VALUES (8, 'Ravi Kumar', 'ravi@example.com', 'Ahmedabad');
INSERT INTO Customer1 VALUES (9, 'Isha Roy', 'isha@example.com', 'Delhi');
INSERT INTO Customer1 VALUES (10, 'Tushar Patil', 'tushar@example.com', 'Mumbai');

--Product
INSERT INTO Product1 VALUES (101, 'Smartphone', 'Electronics', 19999.99);
INSERT INTO Product1 VALUES (102, 'Laptop', 'Electronics', 49999.00);
INSERT INTO Product1 VALUES (103, 'Washing Machine', 'Appliances', 22999.00);
INSERT INTO Product1 VALUES (104, 'Microwave', 'Appliances', 7999.50);
INSERT INTO Product1 VALUES (105, 'Shoes', 'Footwear', 2499.00);
INSERT INTO Product1 VALUES (106, 'T-Shirt', 'Clothing', 599.00);
INSERT INTO Product1 VALUES (107, 'Backpack', 'Accessories', 1599.00);
INSERT INTO Product1 VALUES (108, 'Headphones', 'Electronics', 2999.00);
INSERT INTO Product1 VALUES (109, 'Book', 'Stationery', 499.00);
INSERT INTO Product1 VALUES (110, 'Office Chair', 'Furniture', 8499.00);

--Orders
INSERT INTO Orders1 VALUES (201, 1, TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (202, 1, TO_DATE('2024-03-05', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (203, 2, TO_DATE('2024-03-02', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (204, 3, TO_DATE('2024-03-03', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (205, 4, TO_DATE('2024-03-07', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (206, 5, TO_DATE('2024-03-08', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (207, 5, TO_DATE('2024-03-10', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (208, 6, TO_DATE('2024-03-11', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (209, 7, TO_DATE('2024-03-12', 'YYYY-MM-DD'));
INSERT INTO Orders1 VALUES (210, 1, TO_DATE('2024-03-13', 'YYYY-MM-DD'));

--OrderItem
INSERT INTO OrderItem1 VALUES (301, 201, 101, 1); 
INSERT INTO OrderItem1 VALUES (302, 201, 105, 2);  
INSERT INTO OrderItem1 VALUES (303, 202, 106, 3);  -- Aditi again
INSERT INTO OrderItem1 VALUES (304, 203, 102, 1);  -- Rahul
INSERT INTO OrderItem1 VALUES (305, 204, 103, 1);  -- Sneha
INSERT INTO OrderItem1 VALUES (306, 205, 104, 1);  -- Karan
INSERT INTO OrderItem1 VALUES (307, 206, 107, 2);  -- Neha
INSERT INTO OrderItem1 VALUES (308, 207, 108, 1);  -- Neha again
INSERT INTO OrderItem1 VALUES (309, 208, 109, 4);  -- Aman
INSERT INTO OrderItem1 VALUES (310, 210, 110, 1);  -- Aditi again

--Shipment
INSERT INTO Shipment1 VALUES (401, 201, TO_DATE('2024-03-02', 'YYYY-MM-DD'), 'BlueDart');
INSERT INTO Shipment1 VALUES (402, 202, TO_DATE('2024-03-06', 'YYYY-MM-DD'), 'Delhivery');
INSERT INTO Shipment1 VALUES (403, 203, TO_DATE('2024-03-04', 'YYYY-MM-DD'), 'EcomExpress');
INSERT INTO Shipment1 VALUES (404, 204, TO_DATE('2024-03-05', 'YYYY-MM-DD'), 'FedEx');
INSERT INTO Shipment1 VALUES (405, 205, TO_DATE('2024-03-08', 'YYYY-MM-DD'), 'DTDC');
INSERT INTO Shipment1 VALUES (406, 206, TO_DATE('2024-03-09', 'YYYY-MM-DD'), 'BlueDart');
INSERT INTO Shipment1 VALUES (407, 207, TO_DATE('2024-03-11', 'YYYY-MM-DD'), 'IndiaPost');
INSERT INTO Shipment1 VALUES (408, 208, TO_DATE('2024-03-12', 'YYYY-MM-DD'), 'FedEx');
INSERT INTO Shipment1 VALUES (409, 209, TO_DATE('2024-03-13', 'YYYY-MM-DD'), 'Delhivery');
INSERT INTO Shipment1 VALUES (410, 210, TO_DATE('2024-03-14', 'YYYY-MM-DD'), 'BlueDart');
*/

-- 1. List all customers from a specific city (`'Mumbai'`).
SELECT * from CUSTOMER1 where city='Mumbai';

-- 2. Show all products under the category `'Electronics'` priced above â‚¹10,000
SELECT name FROM product1 where category='Electronics' and price > 10000;

-- 3. Find the email addresses of customers who placed an order on `'2024-03-25'`.
SELECT customer1.email
FROM customer1 
JOIN orders1 using(customer_id)
WHERE to_char(order_date,'YYYY-MM-DD')='2024-03-03';

-- 4. List all orders along with the name of the customer who placed them.
SELECT c.name AS customer_name, o.order_id, p.name AS product_name
FROM customer1 c
JOIN orders1 o ON o.customer_id = c.customer_id
JOIN orderitem1 oi ON oi.order_id = o.order_id
JOIN product1 p ON p.product_id = oi.product_id;

-- 5. Display all products in each order using `OrderID`.
SELECT *
FROM orders1 o JOIN orderitem1 oi ON oi.order_id=o.order_id
order by o.order_id;

-- 6. For each order, show the total number of items purchased (sum of quantities).
SELECT order_id, sum(quantity) FROM orderitem1 oi group by order_id;

--7 list all orders with their total value order
SELECT order_id, sum(quantity * price) 
FROM orderitem1 oi JOIN product1 p ON p.product_id=oi.product_id 
group by order_id;

--8 Find the number of orders each customer has placed.
SELECT count(order_id),customer_id
FROM orders1 o
group by customer_id;

--9 find customers who have placed more orders than the average number of orders placed
WITH ord_cnt AS(
	SELECT count(order_id) as cnt, customer_id as id
	FROM orders1 o
	group by customer_id
)
SELECT id
FROM ord_cnt
WHERE cnt > (select avg(cnt) from ord_cnt);

--10 List all products whose price is higher than the average price of their category.
WITH avg_price AS(
	select count(price) as cn,category as c
	from product1 
	group by category
)
select c,cn
from avg_price
where cn > (select avg(cn) from avg_price);

--11 **Show products that were never ordered, using a `NOT IN` subquery.**
select p.name
from product1 p
where p.product_id NOT IN(
	select product_id 
	from orderitem1 );

--12 **Use a view to get all orders with total value above â‚¹25,000.**
CREATE VIEW ord_above_25k AS
select sum(quantity * price) as sval, order_id
from orderitem1 o JOIN product1 p using(product_id)
group by order_id
having sum(quantity * price) > 25000;

select * from ord_above_25k;

--13 Show each category with its total sales revenue.
SELECT p.category, sum(quantity* price)
FROM orderitem1 oi 
JOIN product1 p ON p.product_id=oi.product_id
group by category;

--14  Display the highest single-order value per customer
WITH ord_cust AS(
	select oi.order_id as o_id,sum(oi.quantity* price)as total,c.name as name
	from orderitem1 oi join product1 p using(product_id)
	join orders1 o on o.order_id=oi.order_id
	join customer1 c on c.customer_id=o.customer_id
	group by oi.order_id,c.name
)
SELECT name, MAX(total)
FROM ord_cust
GROUP BY name;


--15 Write a PL/SQL block to display customer name and city for a given `CustomerID`
DECLARE
	cid customer1.customer_id%TYPE := '&customer_id';
	nam customer1.name%TYPE;
	cit customer1.city%TYPE;
BEGIN
	select name,city into nam,cit FROM customer1 WHERE customer_id=cid;
	dbms_output.put_line('Name: '||nam||', City: '||cit);
END;
/

--16  Check if a customer exists for a given `CustomerID`. If yes, print their name. If not, print "Customer not found".
DECLARE
	cid customer1.customer_id%TYPE :=&customerID;
	cname customer1.name%TYPE;
	ccity customer1.city%TYPE;
BEGIN
	select name, city into cname,ccity FROM customer1 WHERE customer_id=cid;
	dbms_output.put_line('Name: '||cname||',  City: '||ccity); 
EXCEPTION
	WHEN no_data_found THEN
		dbms_output.put_line(cid|| ' not found');
	WHEN others THEN
		dbms_output.put_line('Error occurred');
END;
/

--17 create a block that updates the shipment date. Handle the case where the order does not exist using `NO_DATA_FOUND
DECLARE
	sid shipment1.order_id%TYPE :=&ship;
	sdate shipment1.shipment_date%TYPE;
	order_not_found EXCEPTION;
BEGIN
	UPDATE shipment1 SET shipment_date=sysdate WHERE order_id=sid;
	IF sql%rowcount=0 THEN
		raise order_not_found;
	END IF;	

EXCEPTION
	WHEN order_not_found THEN
		dbms_output.put_line('Order id' || sid|| ' not found');

END;
/

--18  Use a cursor to list all orders and total value of each order.
DECLARE
	CURSOR c1 IS
		select oi.order_id, SUM(quantity*price) as tot, c.name as name
		from orderitem1 oi JOIN product1 p ON oi.product_id=p.product_id JOIN orders1 o ON o.order_id=oi.order_id
		JOIN customer1 c ON o.customer_id=c.customer_id
		group by oi.order_id,c.name,o.customer_id;

	i c1%ROWTYPE;
BEGIN
	open c1;
	LOOP
		FETCH c1 into i;
		EXIT when c1%NOTFOUND;
		dbms_output.put_line('order id: '||i.order_id||', Name: '||i.name||', total value: '||i.tot);
	END LOOP;
	close c1;
END;
/

-- 19. Cursor to go through all products and print their total sales.
DECLARE
	CURSOR c1 IS
		select SUM(quantity * price) as sales,p.name as name,p.category
		from orderitem1 oi JOIN product1 p using(product_id)
		group by p.category, p.name;	
BEGIN
	FOR i in c1 LOOP
		dbms_output.put_line('Product: '||i.name||', Category'||', Sales: '||i.sales);
	END LOOP;
END;
/
-- 20. Cursor with parameters to list all orders in a given month/year.
DECLARE
	CURSOR c1(month date) IS
		select o.order_id,c.name from orders1 o join orderitem1 oi ON oi.order_id=o.order_id
		JOIN customer1 c ON c.customer_id=o.customer_id
		where to_char(order_date,'MM')=to_char(month,'MM') Group by o.order_id,c.name,c.customer_id;
	i c1%ROWTYPE;
	dt DATE :=to_date('&date','YYYY-MM-DD');
BEGIN
	open c1(dt);
	LOOP
		fetch c1 into i;
		EXIT when c1%NOTFOUND;
		dbms_output.put_line('Order ID: '||i.order_id||', Customer name: '||i.name);
	END LOOP;
END;
/

-- 21. **Create a function** to return the total amount a customer has spent (input: customer ID).
CREATE OR REPLACE FUNCTION customer_spend(cid in customer1.customer_id%TYPE)
return number AS
res number :=0;
BEGIN
	select NVL(sum(quantity*price),0) into res 
	from orders1 o JOIN customer1 using(customer_id)
	JOIN orderitem1 oi ON oi.order_id=o.order_id
	JOIN product1 p ON p.product_id=oi.product_id
	where c.customer_id=cid;

	RETURN res;
END;
/
DECLARE
	cid customer1.customer_id%TYPE :=&customer_id;
BEGIN
	dbms_output.put_line('Customer id '||cid||' has spent'||customer_spend(cid));	
END;
/

-- 22. Write a function that takes a product ID and returns the number of times it has been ordered.
CREATE OR REPLACE FUNCTION repeat_prod(pid IN product1.product_id%TYPE) 
return number AS
cnt number :=0;
BEGIN
	select count(*) into cnt
	FROM orderitem1 where product_id=pid;	
	return cnt;
END;
/

DECLARE
	pid product1.product_id%TYPE :=&product_id;
	pname product1.name%TYPE;
BEGIN
	SELECT name into pname FROM product1 WHERE product_id=pid;
	dbms_output.put_line(pname||' is ordered '||repeat_prod(pid)||' times');
END;
/

-- 23. Make a function to return the name of the product with the highest price in a given category.
CREATE OR REPLACE FUNCTION highest_price(cate IN product1.category%TYPE)
return varchar AS
hp number :=0;
pname product1.name%TYPE;
BEGIN
	for i in (select name,price FROM product1 where category=cate) LOOP
		IF i.price > hp THEN
			hp :=i.price;
			pname :=i.name;
		END IF;
	END LOOP;
	return pname||' with price: '||hp;
END;
/

DECLARE
	cate product1.category%TYPE :='&category';
BEGIN 
	dbms_output.put_line('Highest priced item under '||cate||' category is '||highest_price(cate));
END;
/

--24.  Write a **trigger** to prevent inserting an order with a `NULL` `CustomerID`.
CREATE OR REPLACE TRIGGER trig_null_prevention
BEFORE insert ON orders1
for each row
BEGIN 
	if :NEW.customer_id is NULL THEN
		raise_application_error(-20002,'Invalid id');
	END IF;
END;
/
insert into orders1 values(212,NULL, SYSDATE);

--26. BEFORE INSERT trigger on `customer` to **validate email format**.
CREATE OR REPLACE