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
select product_id, count(product_id)
from orderitem
group by product_id 
order by count(product_id) desc 
fetch first 3 rows only;
-- 23. Identify the customer who spent the **most money** in total.
with temp as (select customer_id, sum(price * quantity) as total 
from orderitem join orders using (order_id)
join product using (product_id)
join customer using (customer_id)
group by customer_id)
select customer_id, total 
from temp 
where total = (select max(total) from temp);
-- 24. List all customers who have ordered the **same product more than once** (even in different orders).
select customer_id, product_id, count(*) as freq 
from orderitem join orders using(order_id)
group by customer_id, product_id
having count(*) > 1;
-- 25. Find all orders where the **total value exceeds ₹50,000**, and list the order ID, customer name, and total value.
select order_id, c.name, sum(price * quantity) as totval 
from customer c
join orders using (customer_id) 
join orderitem using (order_id) 
join product using(product_id) 
group by order_id, c.name
having sum(price * quantity) > 40000;

-- ### 🧠 NESTED SUBQUERIES

-- 1. **Find customers who have placed more orders than the average number of orders placed.**
-- 2. **List all products whose price is higher than the average price of their category.**
-- 3. **Show products that were never ordered, using a `NOT IN` subquery.**
-- 4. **Find customers who ordered *all* the products in the `'Clothing'` category.**
-- 5. **Display orders that include the most expensive product.**

-- ---

-- ### 🪜 CTE (WITH Clause)

-- 6. **Using a CTE, find the top 3 categories with the highest total revenue.**
-- 7. **With a CTE, list customers and their rank by total amount spent.**
-- 8. **Using a CTE, get the most recent order date per customer.**
-- 9. **With a CTE, calculate each customer's order frequency per month.**
-- 10. **Find products that appear in more than 1 order but always with the same quantity.**

-- ---

-- ### 🔭 VIEWS

-- 11. **Create a view that shows customer name, order ID, product names, and quantity.**
-- 12. **Create a view that summarizes total spend per customer.**
-- 13. **Use a view to get all orders with total value above ₹25,000.**
-- 14. **Create a view that lists products with their order count and total quantity sold.**
-- 15. **Drop and recreate a view to include shipment carrier and date.**

-- ---

-- ### 📊 AGGREGATE FUNCTIONS

-- 16. **Show each category with its total sales revenue.**
-- 17. **List customers who have ordered more than 5 distinct products.**
-- 18. **Find the average quantity per product per order.**
-- 19. **Display the highest single-order value per customer.**
-- 20. **Find categories where the average product price is above ₹10,000 and total units sold is more than 100.**

-- ---

-- ### 💡 Bonus Real-World Mix Questions

-- 21. **Using a CTE, find all customers who have spent more than the average spend across all customers.**
-- 22. **For each product, find the earliest and latest order date it appeared in.**
-- 23. **List customers who never ordered a product from a certain category (e.g., `'Electronics'`).**
-- 24. **List top 2 products in each category by total quantity ordered.**
-- 25. **Create a view that shows monthly revenue trends (month, year, total revenue).**


-- 1. Basic PL/SQL Blocks

-- 1. Write a PL/SQL block to display customer name and city for a given `CustomerID`.
declare 
    cust_id customer.CUSTOMER_ID%TYPE := :CustomerID;
    name customer.NAME%TYPE;
    city customer.CITY%TYPE;
begin 
    select name, city into name, city from customer where customer_id = cust_id;
    dbms_output.put_line(cust_id || ' ' || name || ' ' || city);
end;
/
-- 2. **Print total number of orders** placed by a customer using `CustomerID` as input.
declare 
    cust_id customer.CUSTOMER_ID%TYPE := :CustomerID;
    orders integer;
begin 
    select count(order_id) into orders 
    from orders 
    where customer_id = cust_id
    group by customer_id;
    dbms_output.put_line(cust_id || ' ' || orders);
end;
/
-- 3. Create a block that takes a `ProductID` and prints its name and price.
declare 
    prod_id product.PRODUCT_ID%TYPE := :ProductID;
    name product.name%type;
    price product.price%type;
begin 
    select name, price into name, price
    from product where product_id = prod_id;
    dbms_output.put_line(prod_id || ' ' || name || ' ' || price);
end;
/
-- 4. Accept an order ID and display **total quantity of products** ordered in that order.
declare 
    orderid orders.ORDER_ID%TYPE := :OrderID;
    quantity orderitem.QUANTITY%TYPE;
begin 
    select sum(quantity) into quantity
    from orderitem 
    where orderid = order_id
    group by order_id;
    dbms_output.put_line(orderid || ' ' || quantity);
end;
/
-- 5. Accept a product name, and display its category and price.
declare 
    pname product.NAME%TYPE := :ProductName;
    cat product.CATEGORY%TYPE;
    price product.PRICE%TYPE;
begin 
    select category, price into cat, price 
    from product 
    where pname = name;
    dbms_output.put_line(pname || ' ' || cat || ' ' || price || ' ');
end;
/
-- 2. IF-ELSE + Loops

-- 6. Check if a customer exists for a given `CustomerID`. If yes, print their name. If not, print "Customer not found".
declare 
    cust_id customer.CUSTOMER_ID%TYPE := :CustomerID;
    name customer.NAME%TYPE;
begin 
    select name into name from customer where customer_id = cust_id;
    dbms_output.put_line(name);
exception 
    when no_data_found then 
        dbms_output.put_line('Customer Not Found');
    when others then 
        dbms_output.put_line('An Unexpected Error Occurred');
end;
/
-- 7. For a given customer, loop through all their orders and print each `OrderID` and `OrderDate`.
declare 
    v_custid customer.CUSTOMER_ID%TYPE := :CustomerId;
begin 
    for i in (select * from orders where customer_id = v_custid) loop 
        dbms_output.put_line(i.order_id || ' ' || i.order_date);
    end loop;
end;
/
-- 8. Write a PL/SQL block to categorize a product price:
--    - Price < 500: ‘Low’
--    - 500 ≤ Price ≤ 5000: ‘Medium’
--    - Price > 5000: ‘High’
declare 
    v_price product.PRICE%TYPE := :Price;
begin 
    if v_price < 500 then 
        dbms_output.put_line('Low');
    elsif v_price <= 5000 then 
        dbms_output.put_line('Medium');
    elsif v_price > 5000 then 
        dbms_output.put_line('High');
    else 
        dbms_output.put_line('Price is NULL');
    end if;
end;
/
-- 3. Cursors (Static & Parameterized)

-- 9. Use a cursor to fetch all products under the `'Electronics'` category and display them.
declare 
    cursor c1 is select * from product where category = 'Electronics';
begin  
    for i in c1 loop 
        dbms_output.put_line(i.product_id || '   ' || i.name || '   ' || i.price);
    end loop;
end;
/
-- 10. Write a parameterized cursor to fetch all orders for a given city.
declare 
    cursor c1 is select * from orders join customer using(customer_id) where city = :City;
begin 
    for i in c1 loop 
        dbms_output.put_line(i.order_id || '   ' || i.customer_id || '   ' || i.order_date);
    end loop;
end;
/
-- 11. Cursor to display all **items in a given order** (order ID as input) with product names and quantities.
declare 
    cursor c1 is select orderitem_id, name, quantity from orderitem  join product p using(product_id) where order_id = :OrderID;
begin 
    for i in c1 loop 
        dbms_output.put_line(i.orderitem_id || '   ' || i.name || '   ' || i.quantity);
    end loop;
end;
/
-- 12. Use a cursor to list all **unshipped orders** and display their `OrderID` and `Customer Name`.
declare 
    cursor c1 is 
        select order_id, name from orders left join shipment using(order_id) join customer using(customer_id) where shipment.order_id is null;
begin 
    for i in c1 loop 
        dbms_output.put_line(i.order_id || '   ' || i.name);
    end loop;
end;
/
-- 4. Exceptions (Built-in + User-Defined)

-- 13. Write a block to insert a new product. If the price is negative, raise a **user-defined exception**.
declare 
    v_pid product.PRODUCT_ID%TYPE := :ProductID;
    v_name product.NAME%TYPE := :ProductName;
    v_cat product.CATEGORY%TYPE := :ProductCategory;
    v_price product.PRICE%TYPE := :ProductPrice;
    negative_price exception;
begin 
    if v_price < 0 then 
        raise negative_price;
    end if;
    insert into product values(v_pid, v_name, v_cat, v_price);
exception 
    when negative_price then 
        dbms_output.put_line('Price cannot be negative!');
    when others then 
        dbms_output.put_line('An unexpected error occurred');
end;
/
-- 14. Create a block that updates the shipment date. Handle the case where the order does not exist using `NO_DATA_FOUND`.
declare 
    v_date shipment.SHIPMENT_DATE%TYPE := :UpdatedDate;
    v_order_id shipment.ORDER_ID%TYPE := :OrderID;
    order_not_found exception;
begin 
    update shipment set shipment_date = v_date where order_id = v_order_id;
    if sql%rowcount = 0 then 
        raise order_not_found;
    end if;
exception 
    when order_not_found then 
        dbms_output.put_line('Order ID not found');
    when others then 
        dbms_output.put_line('Am unexpected error occurred');
end;
/
-- 15. Write a PL/SQL block that fetches and displays a product. 
--If product not found, handle the exception and print "Invalid Product ID".
declare 
    v_pid product.PRODUCT_ID%TYPE := :ProductID;
    -- v_cat product.CATEGORY%TYPE;
    -- v_name product.NAME%TYPE;
    -- v_price product.PRICE%TYPE;
    v_prod product%rowtype;
begin 
    select * into v_prod /*v_pid, v_name, v_cat, v_price*/ from product where product_id = v_pid;
    dbms_output.put_line(v_prod.product_id || '    ' || v_prod.name || '   ' || v_prod.category || '   ' || v_prod.price);
exception 
    when no_data_found then 
        dbms_output.put_line('Invalid Product ID');
    when others then 
        dbms_output.put_line('An unexpected error occurred');
end;
/
-- 5. Procedures & Functions

-- 16. Create a **procedure** that takes `CustomerID` and prints all their order details.
create or replace procedure order_details (v_cid in orders.customer_id%type) is 
begin 
    for i in (select * from orders where customer_id = v_cid) loop
    dbms_output.put_line(i.order_id || '   ' || i.customer_id ||'   ' || i.order_date);
    end loop;
end;
/

begin 
    order_details(:CustomerID);
end;
/
-- 17. Write a **function** that returns the **total value of an order**.
create or replace function totval (v_orderid in orders.order_id%type) 
return product.price%type as 
    v_totval product.price%type := 0;
begin 
    for i in (select * from orderitem join product using(product_id) where order_id = v_orderid) loop 
        v_totval := v_totval + i.price * i.quantity;
    end loop;
    return v_totval;
end;
/

begin 
    dbms_output.put_line('Total value: ' || totval(:OrderID));
end;
/
-- 18. Procedure that inserts a new order into the `Orders` table and returns the newly generated `OrderID`.
create or replace procedure insert_order (v_cust_id in orders.customer_id%type, v_order_dt in orders.order_date%type, v_order_id out orders.order_id%type) is 
begin 
    select nvl(max(order_id), 1000) + 1 into v_order_id from orders;

    insert into orders values(v_order_id, v_cust_id, v_order_dt);
end;
/
declare 
    v_newid orders.ORDER_ID%TYPE;
begin 
    insert_order(1, SYSDATE, v_newid);
    dbms_output.put_line('New Order ID: ' || v_newid);
end;
/
-- 19. Function that takes a city name and returns the **number of customers** in that city.
create or replace function numcustomers (v_city customer.city%type) return number as 
v_count number := 0;
begin 
    select count(*) into v_count from customer where city = v_city;
    return v_count;
end;
/

begin 
    dbms_output.put_line('Number of customers: ' || numcustomers(:City));
end;
/
-- 20. Procedure that accepts `ProductID`, `OrderID`, and `Quantity`, and inserts it into `OrderItem`.
create or replace procedure insert_orderitem (v_pid in orderitem.product_id%type, v_oid in orderitem.order_id%type, v_qty in orderitem.quantity%type, v_oiid out orderitem.orderitem_id%type) is 
begin
    select nvl(max(orderitem_id), 1000) + 1 into v_oiid from orderitem;
    insert into orderitem values (v_oiid, v_oid, v_pid, v_qty);
end;
/

declare 
    v_oiid orderitem.ORDERITEM_ID%TYPE;
begin 
    insert_orderitem(110, 210, 2, v_oiid);
    dbms_output.put_line('Order inserted with order_id: ' || v_oiid);
end;
/

-- 6. Triggers

-- 21. Write a **trigger** to prevent inserting an order with a `NULL` `CustomerID`.
create or replace trigger trg_ins_prevent 
before insert on orders 
for each row 
begin 
    if :new.customer_id is null then 
        raise_application_error (-20001, 'Invalid Customer ID');
    end if;
end;
/

insert into orders values(212,NULL, SYSDATE);
-- 22. Create a trigger to **log every new product insertion** into a separate `ProductLog` table.
create table product_log (log_id number generated by default as identity primary key, product_id number, name varchar(100), category varchar(50), price number(8, 2), log_timestamp timestamp default systimestamp);
drop table product_log;
create or replace trigger trg_log_product 
after insert on product 
for each row 
begin 
    insert into product_log (product_id, name, category, price) values (:new.product_id, :new.name, :new.category, :new.price);
end;
/

insert into product values (111, 'Washing machine', 'Appliance', 2);
select * from product_log;
-- 23. Write a trigger to **auto-update shipment date** to `SYSDATE` when a new shipment is added.
create or replace trigger trg_update_ship 
before insert on shipment 
for each row 
begin 
    if :new.shipment_date is null then 
        :new.shipment_date := sysdate;
    end if;
end;
/
insert into shipment (shipment_id, order_id, carrier) values (301, 211, 'BlueDart');
select * from shipment where shipment_id = 301;
-- 24. Trigger to ensure no order is placed with quantity ≤ 0 in `OrderItem`.
create or replace trigger qty_validate 
before insert or update on orderitem 
for each row 
begin 
    if :new.quantity <= 0 then 
        raise_application_error(-20002, 'Invalid quantity');
    end if;
end;
/

insert into orderitem values(311, 210, 101, -2);
-- 25. Create a row-level trigger that updates a `TotalOrders` field in `Customer` every time an order is placed.
alter table customer add totalorders number default 0;

create or replace trigger trg_tot_order 
after insert on orders
for each row 
begin 
    update customer set totalorders = nvl(totalorders, 0) + 1 where customer_id = :new.customer_id;
end;
/

insert into orders values (212, 1, SYSDATE);
select * from customer where customer_id = 1;
-- 7. Bonus Boss Challenges

-- 26. Write a block to print **top 3 customers by order value**.
declare 
    cursor c1 is 
        select customer_id, sum(price * quantity) as totval 
        from ORDERS join orderitem using(order_id) join product using (product_id)
        group by customer_id 
        order by totval desc
        fetch first 3 rows only;
begin
    for i in c1 loop 
        dbms_output.put_line(i.customer_id || '    ' || i.totval);
    end loop;
end;
/
-- 27. Create a procedure to generate a **monthly sales report** — total revenue grouped by category.
create or replace procedure monthsales is
begin 
    for i in (
        select to_char(order_date, 'MM-YYYY') as month_year, category, sum (price * quantity) as tot_revenue
        from orders join orderitem using(order_id) join product using(product_id)
        group by to_char(order_date, 'MM-YYYY'), category 
        order by to_date(to_char(order_date, 'MM-YYYY'), 'MM-YYYY'), category 
    ) loop 
        dbms_output.put_line(i.month_year || '   ' || i.category || '   ' || i.tot_revenue);
    end loop;
end;
/
begin 
monthsales;
end;
/
-- 28. Cursor + nested loop: For each customer, print all products they’ve ordered.
DECLARE
    -- Outer cursor: all customers
    CURSOR c_customers IS
        SELECT customer_id, name FROM customer;

    -- Inner cursor: products ordered by a specific customer
    CURSOR c_products(v_cust_id customer.customer_id%TYPE) IS
        SELECT DISTINCT p.name AS product_name
        FROM orders o
        JOIN orderitem oi ON o.order_id = oi.order_id
        JOIN product p ON oi.product_id = p.product_id
        WHERE o.customer_id = v_cust_id;
BEGIN
    FOR cust_rec IN c_customers LOOP
        DBMS_OUTPUT.PUT_LINE('📦 Customer: ' || cust_rec.name);

        -- Flag to check if any product was ordered
        DECLARE
            v_found BOOLEAN := FALSE;
        BEGIN
            FOR prod_rec IN c_products(cust_rec.customer_id) LOOP
                DBMS_OUTPUT.PUT_LINE('   🛒 ' || prod_rec.product_name);
                v_found := TRUE;
            END LOOP;

            IF NOT v_found THEN
                DBMS_OUTPUT.PUT_LINE('   ❌ No products ordered.');
            END IF;
        END;
    END LOOP;
END;
/

-- 29. Trigger to update a `LastOrderDate` column in `Customer` table after each new order.
CREATE OR REPLACE TRIGGER trg_prevent_duplicate_product
BEFORE INSERT ON product
FOR EACH ROW
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM product
    WHERE LOWER(name) = LOWER(:NEW.name)
      AND LOWER(category) = LOWER(:NEW.category);

    IF v_exists > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Duplicate product in this category not allowed.');
    END IF;
END;
/

-- 30. Build a procedure that **cancels an order** — deletes from `OrderItem`, `Shipment`, and then `Orders`.
CREATE OR REPLACE PROCEDURE cancel_order(p_order_id IN orders.order_id%TYPE) IS
BEGIN
    -- Delete child records first
    DELETE FROM orderitem
    WHERE order_id = p_order_id;

    DELETE FROM shipment
    WHERE order_id = p_order_id;

    -- Delete the parent record
    DELETE FROM orders
    WHERE order_id = p_order_id;

    DBMS_OUTPUT.PUT_LINE('✅ Order ' || p_order_id || ' cancelled successfully.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('❌ Order ID not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('💥 Error cancelling order: ' || SQLERRM);
END;
/



-- ## 🔧 **Functions**

-- 1. **Create a function** to return the total amount a customer has spent (input: customer ID).
-- 2. Write a function that takes a product ID and returns the number of times it has been ordered.
-- 3. Make a function to return the name of the product with the highest price in a given category.
-- 4. Create a function to return the shipment delay (in days) given an order ID.
-- 5. Write a function to return `TRUE` if a product has never been ordered.

-- ---

-- ## ⚙️ **Procedures**

-- 6. **Procedure to update customer email**, given customer ID and new email.
-- 7. Procedure to cancel an order (remove from orderitem, then orders).
-- 8. Write a procedure to **insert a new product**, but only if the name doesn't already exist.
-- 9. Procedure to print all orders of a customer with total value.
-- 10. Procedure to apply a **10% discount** to all products in a given category.

-- ---

-- ## 📦 **Packages**

-- 11. Create a package `CustomerUtils` with:
--    - A function to get customer total spend.
--    - A procedure to update customer city.
-- 12. Make a package `OrderAnalytics` with:
--    - A function to return total orders per month.
--    - A procedure to show the top 3 spending customers.
-- 13. Package `ProductOps`:
--    - Procedure to insert a product.
--    - Function to check if a product is in stock (assume stock table).
-- 14. Package to **track audit logs** for product updates.
-- 15. Package with **private helper procedures** and one public master procedure.

-- ---

-- ## 🔥 **Triggers**

-- 16. Create a **BEFORE INSERT** trigger on `orders` to block orders placed on weekends.
-- 17. Trigger to **log every delete** from `orderitem` into an `orderitem_audit` table.
-- 18. AFTER UPDATE trigger on `product` to log price changes.
-- 19. Trigger that auto-assigns a default shipment carrier if none is specified.
-- 20. BEFORE INSERT trigger on `customer` to **validate email format**.

-- ---

-- ## 🔁 **Cursors**

-- 21. Use a cursor to list all orders and total value of each order.
-- 22. Cursor to go through all products and print their total sales.
-- 23. Cursor FOR loop to update a new column `order_value` in `orders` table.
-- 24. Cursor with parameters to list all orders in a given month/year.
-- 25. Use an **explicit cursor with exception handling** to process each customer and print if they are a premium customer (>₹50K spent).

-- ---

-- ## 💡 BONUS – Real-world Challenges

-- 26. Create a function to determine a **loyalty tier** (Gold/Silver/Bronze) based on spending.
-- 27. Procedure to find and delete **duplicate customers** based on email.
-- 28. Trigger to **prevent deleting products** that are part of any order.
-- 29. Cursor to assign ranks to customers based on spending and update a `rank` column.
-- 30. Package to manage **reward points** (add, redeem, check balance).

