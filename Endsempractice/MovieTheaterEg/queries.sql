/*create table movee (
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
*/

-- Basic SQL (Create + Insert)
-- 1. Create the schema for `Movie`, `Customer`, and `Booking` tables with appropriate constraints (PK, FK).
-- 2. Insert at least 5 entries into each table with diverse data (different cities, languages, and booking dates).
-- 3. Modify a movie’s release date using `UPDATE`.


-- Selection & Filtering
-- 4. Retrieve the titles of all English movies released after 2018.
select title, RELEASEDATE 
from movee 
where language = 'English' and to_char(releasedate, 'YYYY') > 2018;
-- 5. List all customers who have made a booking in April 2025.
select custid, firstname, lastname 
from booking natural join customer 
where to_char(bookdate, 'MM-YYYY') = '04-2025';
-- 6. Display bookings where more than 3 tickets were purchased.
select * from booking 
where tickets > 3;

-- Joins + Aggregates
-- 7. Display each customer’s name and the total number of tickets they’ve booked.
select firstname, tickets 
from customer natural join booking;
-- 8. List all movies and how many unique customers have booked them.
select title, count(custid)
from movee left join booking on movee.movid = booking.movid 
group by title;
-- 9. Show customers who have booked movies in languages other than their city’s primary language (assume city-language mapping).
--invalid qn

-- Subqueries & Set Operations
-- 10. Find customers who have never made a booking.
select custid 
from customer 
where custid not in (select custid from booking);
-- 11. List movies **not** booked by any customer.
select movid 
from movee 
left join booking using (movid)
where movid is null;
-- 12. Retrieve customers who booked **every** movie available in the database (use `NOT EXISTS` + `MINUS`).
select custid 
from booking b1
where not exists (
    select movid 
    from movee
    minus 
    select movid 
    from booking b2
    where b1.custid = b2.custid
);
-- 13. Display customers who booked **only English** movies and nothing else.
select custid 
from booking b1
where not exists(
    select 1 
    from booking b2 join movee using(movid) 
    where b1.custid = b2.custid and language != 'English');
-- 14. List movies that were booked **by all customers from Pune**.
select m.movid, title 
from movee m 
where not exists(
    select custid from customer where city = 'Pune'
    MINUS
    select custid from booking b2 where m.movid = b2.movid
);

-- Date & Grouping
-- 15. Show month-wise total ticket sales.
select to_char(bookdate, 'Mon-YYYY') as month, sum(tickets)
from booking
group by to_char(bookdate, 'Mon-YYYY');
-- 16. List movies released before the average release year of all movies.
select movid, title, releasedate
from movee 
-- where to_char(releasedate, 'YYYY') < (select avg(to_char(releasedate, 'YYYY')) from movee);
where extract(year from releasedate) < (select avg(extract(year from releasedate)) from movee);
-- 17. Group bookings by customer and show average tickets per booking.
select custid, avg(tickets)
from booking 
group by custid; 

-- Basic Blocks
-- 18. Write a PL/SQL block to display all bookings made by a given customer (input: `CustomerID`).
-- 19. Accept a `MovieID` as input and count how many tickets have been booked for it.


-- Conditionals & Loops
-- 20. Write a PL/SQL block that checks if a customer has booked more than 5 tickets in total. If yes, print “Regular Customer”.
-- 21. Loop through all bookings and display those with more than 3 tickets using `FOR` loop.


-- Exception Handling
-- 22. Create a block that tries to fetch a booking by `BookingID`. If not found, raise and handle a `NO_DATA_FOUND` exception.
-- 23. Raise a custom exception if a booking has 0 or negative ticket count.


-- Cursors
-- 24. Use a cursor to fetch each movie and display the number of customers who have booked it.
-- 25. Write a cursor that goes through all bookings and calculates total revenue (assume ₹150 per ticket).


-- Functions & Procedures
-- 26. Write a function that takes `CustomerID` and returns total tickets booked.
-- 27. Write a procedure that prints booking summary for a customer: Name, number of bookings, and total tickets.


-- Bonus Practice
-- 28. Create a view called `ActiveBookings` showing only bookings made in the last 30 days.
-- 29. Write a trigger that prevents inserting a booking with more than 10 tickets.
-- 30. Create a synonym for the `Movie` table.

