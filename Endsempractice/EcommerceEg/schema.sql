CREATE TABLE Customer (
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
--customers
INSERT INTO Customer VALUES (1, 'Aditi Sharma', 'aditi@example.com', 'Delhi');
INSERT INTO Customer VALUES (2, 'Rahul Verma', 'rahul@example.com', 'Mumbai');
INSERT INTO Customer VALUES (3, 'Sneha Das', 'sneha@example.com', 'Kolkata');
INSERT INTO Customer VALUES (4, 'Karan Mehta', 'karan@example.com', 'Chennai');
INSERT INTO Customer VALUES (5, 'Neha Singh', 'neha@example.com', 'Bangalore');
INSERT INTO Customer VALUES (6, 'Aman Joshi', 'aman@example.com', 'Hyderabad');
INSERT INTO Customer VALUES (7, 'Divya Rao', 'divya@example.com', 'Pune');
INSERT INTO Customer VALUES (8, 'Ravi Kumar', 'ravi@example.com', 'Ahmedabad');
INSERT INTO Customer VALUES (9, 'Isha Roy', 'isha@example.com', 'Delhi');
INSERT INTO Customer VALUES (10, 'Tushar Patil', 'tushar@example.com', 'Mumbai');

--Product
INSERT INTO Product VALUES (101, 'Smartphone', 'Electronics', 19999.99);
INSERT INTO Product VALUES (102, 'Laptop', 'Electronics', 49999.00);
INSERT INTO Product VALUES (103, 'Washing Machine', 'Appliances', 22999.00);
INSERT INTO Product VALUES (104, 'Microwave', 'Appliances', 7999.50);
INSERT INTO Product VALUES (105, 'Shoes', 'Footwear', 2499.00);
INSERT INTO Product VALUES (106, 'T-Shirt', 'Clothing', 599.00);
INSERT INTO Product VALUES (107, 'Backpack', 'Accessories', 1599.00);
INSERT INTO Product VALUES (108, 'Headphones', 'Electronics', 2999.00);
INSERT INTO Product VALUES (109, 'Book', 'Stationery', 499.00);
INSERT INTO Product VALUES (110, 'Office Chair', 'Furniture', 8499.00);

--Orders
INSERT INTO Orders VALUES (201, 1, TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (202, 1, TO_DATE('2024-03-05', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (203, 2, TO_DATE('2024-03-02', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (204, 3, TO_DATE('2024-03-03', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (205, 4, TO_DATE('2024-03-07', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (206, 5, TO_DATE('2024-03-08', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (207, 5, TO_DATE('2024-03-10', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (208, 6, TO_DATE('2024-03-11', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (209, 7, TO_DATE('2024-03-12', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (210, 1, TO_DATE('2024-03-13', 'YYYY-MM-DD'));

--OrderItem
INSERT INTO OrderItem VALUES (301, 201, 101, 1);  -- Aditi
INSERT INTO OrderItem VALUES (302, 201, 105, 2);  
INSERT INTO OrderItem VALUES (303, 202, 106, 3);  -- Aditi again
INSERT INTO OrderItem VALUES (304, 203, 102, 1);  -- Rahul
INSERT INTO OrderItem VALUES (305, 204, 103, 1);  -- Sneha
INSERT INTO OrderItem VALUES (306, 205, 104, 1);  -- Karan
INSERT INTO OrderItem VALUES (307, 206, 107, 2);  -- Neha
INSERT INTO OrderItem VALUES (308, 207, 108, 1);  -- Neha again
INSERT INTO OrderItem VALUES (309, 208, 109, 4);  -- Aman
INSERT INTO OrderItem VALUES (310, 210, 110, 1);  -- Aditi again

--Shipment
INSERT INTO Shipment VALUES (401, 201, TO_DATE('2024-03-02', 'YYYY-MM-DD'), 'BlueDart');
INSERT INTO Shipment VALUES (402, 202, TO_DATE('2024-03-06', 'YYYY-MM-DD'), 'Delhivery');
INSERT INTO Shipment VALUES (403, 203, TO_DATE('2024-03-04', 'YYYY-MM-DD'), 'EcomExpress');
INSERT INTO Shipment VALUES (404, 204, TO_DATE('2024-03-05', 'YYYY-MM-DD'), 'FedEx');
INSERT INTO Shipment VALUES (405, 205, TO_DATE('2024-03-08', 'YYYY-MM-DD'), 'DTDC');
INSERT INTO Shipment VALUES (406, 206, TO_DATE('2024-03-09', 'YYYY-MM-DD'), 'BlueDart');
INSERT INTO Shipment VALUES (407, 207, TO_DATE('2024-03-11', 'YYYY-MM-DD'), 'IndiaPost');
INSERT INTO Shipment VALUES (408, 208, TO_DATE('2024-03-12', 'YYYY-MM-DD'), 'FedEx');
INSERT INTO Shipment VALUES (409, 209, TO_DATE('2024-03-13', 'YYYY-MM-DD'), 'Delhivery');
INSERT INTO Shipment VALUES (410, 210, TO_DATE('2024-03-14', 'YYYY-MM-DD'), 'BlueDart');


commit;