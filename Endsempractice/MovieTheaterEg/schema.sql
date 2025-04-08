drop table booking;
drop table customer;
drop table movee;
create table movee (
    movid number primary key,
    title varchar2(100),
    language varchar2(30), 
    releasedate date
);

create table customer (
    custid number primary key,
    firstname varchar2(50),
    lastname varchar2(50),
    city varchar2(50)
);

create table booking (
    bookid number primary key,
    movid number,
    custid number,
    bookdate date,
    tickets number,
    foreign key (movid) references movee(movid),
    foreign key (custid) references customer(custid)
);

-- Movies
INSERT INTO movee VALUES (1, 'Inception', 'English', TO_DATE('2010-07-16', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (2, 'Interstellar', 'English', TO_DATE('2014-11-07', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (3, 'Dangal', 'Hindi', TO_DATE('2016-12-23', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (4, '3 Idiots', 'Hindi', TO_DATE('2009-12-25', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (5, 'Parasite', 'Korean', TO_DATE('2019-05-30', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (6, 'Avengers: Endgame', 'English', TO_DATE('2019-04-26', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (7, 'Kantara', 'Kannada', TO_DATE('2022-09-30', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (8, 'RRR', 'Telugu', TO_DATE('2022-03-25', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (9, 'Jawan', 'Hindi', TO_DATE('2023-09-07', 'YYYY-MM-DD'));
INSERT INTO movee VALUES (10, 'The Batman', 'English', TO_DATE('2022-03-04', 'YYYY-MM-DD'));


-- Customers
INSERT INTO Customer VALUES (101, 'Aditi', 'Sharma', 'Delhi');
INSERT INTO Customer VALUES (102, 'Rohan', 'Mehra', 'Mumbai');
INSERT INTO Customer VALUES (103, 'Neha', 'Verma', 'Bangalore');
INSERT INTO Customer VALUES (104, 'Kabir', 'Khan', 'Delhi');
INSERT INTO Customer VALUES (105, 'Isha', 'Patel', 'Ahmedabad');
INSERT INTO Customer VALUES (106, 'Arjun', 'Singh', 'Lucknow');
INSERT INTO Customer VALUES (107, 'Sara', 'Ali', 'Mumbai');
INSERT INTO Customer VALUES (108, 'Vikram', 'Rao', 'Hyderabad');
INSERT INTO Customer VALUES (109, 'Sneha', 'Das', 'Kolkata');
INSERT INTO Customer VALUES (110, 'Manav', 'Bajaj', 'Chennai');


-- Bookings
INSERT INTO Booking VALUES (201, 1, 101, TO_DATE('2024-03-01', 'YYYY-MM-DD'), 2);
INSERT INTO Booking VALUES (202, 4, 101, TO_DATE('2024-03-05', 'YYYY-MM-DD'), 1);
INSERT INTO Booking VALUES (203, 9, 101, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 3);
INSERT INTO Booking VALUES (204, 2, 102, TO_DATE('2024-03-02', 'YYYY-MM-DD'), 1);
INSERT INTO Booking VALUES (205, 5, 102, TO_DATE('2024-03-07', 'YYYY-MM-DD'), 2);
INSERT INTO Booking VALUES (206, 3, 103, TO_DATE('2024-03-03', 'YYYY-MM-DD'), 2);
INSERT INTO Booking VALUES (207, 6, 103, TO_DATE('2024-03-09', 'YYYY-MM-DD'), 1);
INSERT INTO Booking VALUES (208, 7, 104, TO_DATE('2024-03-04', 'YYYY-MM-DD'), 1);
INSERT INTO Booking VALUES (209, 8, 105, TO_DATE('2024-03-06', 'YYYY-MM-DD'), 2);
INSERT INTO Booking VALUES (210, 10, 106, TO_DATE('2024-03-08', 'YYYY-MM-DD'), 1);
