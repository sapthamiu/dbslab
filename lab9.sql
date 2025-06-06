--PROCEDURE 
--EX1. Create a procedure to print Hello world and execute the procedure. 
create or replace procedure print_hello is 
begin 
    dbms_output.put_line('Hello World');
end;
/
set serveroutput on; 
begin 
    print_hello;
end;
/

--FUNCTIONS
--EX1.  Create a function to return the sum of two numbers
create or replace function sum_num(a number, b number)
return number as 
    tot number;
begin 
    tot := a + b;
    return tot;
end;
/
set serveroutput on;
begin 
    dbms_output.put_line(sum_num(5,4));
end;
/
--EX2. : A function that, given the name of a department, returns the 
--count of the number of instructors in that department. 
create or replace function dept_count(dept_name varchar)
return integer as 
    d_count integer;
begin 
    select count(*) into d_count 
    from instructor where instructor.dept_name = dept_count.dept_name;
    return d_count;
end;
/ 

select dept_name, budget from department where dept_count(dept_name)>2;

--PROCEDURES
--EX1. A procedure that, given the name of a department, returns the 
--count of the number of instructors in that department.
create or replace procedure dept_count_proc(dept_name in varchar, d_count out integer) is
begin 
    select count(*) into d_count from instructor where instructor.dept_name = dept_count_proc.dept_name;
end;
/
set serveroutput on;
declare d_count integer;
begin 
    dept_count_proc('Physics', d_count);
    dbms_output.put_line(d_count);
end;
/

--EX2. The procedure p has two IN parameters, one OUT parameter, and 
--one IN OUT parameter. The OUT and IN OUT parameters are passed by 
--value (the default). The anonymous block invokes p twice, with 
--different actual parameters. Before each invocation, the anonymous 
--block prints the values of the actual parameters. The procedure p 
--prints the initial values of its formal parameters. After each 
--invocation, the anonymous block prints the values of the actual 
--parameters again.
create or replace procedure p(a PLS_INTEGER, b in pls_integer, c out pls_integer, d in out binary_float) IS
begin 
    dbms_output.put_line('Inside procedure p: ');
    dbms_output.put_line('In a = ');
    dbms_output.put_line(NVL(to_char(a), 'null'));
    dbms_output.put_line('In b = ');
    dbms_output.put_line(NVL(to_char(b), 'null'));
    dbms_output.put_line('Out c = ');
    dbms_output.put_line(NVL(to_char(c), 'null'));
    dbms_output.put_line('In out d = ' || to_char(d));
    c := a+10;
    d := 10/b;
end;
/
declare 
    aa constant pls_integer := 1;
    bb pls_integer := 2;
    cc pls_integer := 3;
    dd binary_float := 4;
    ee pls_integer;
    ff binary_float := 5;
begin
    dbms_output.put_line('Before invoking p: ');
    dbms_output.put('aa = ');
    dbms_output.put_line(NVL(to_char(aa), 'null'));
    dbms_output.put('bb = ');
    dbms_output.put_line(NVL(to_char(bb), 'null'));
    dbms_output.put('cc = ');
    dbms_output.put_line(NVL(to_char(cc), 'null'));
    dbms_output.put_line('dd = ' || to_char(dd));
    dbms_output.put('ee = ');
    dbms_output.put_line(NVL(to_char(ee), 'null'));
    dbms_output.put_line('ff = ' || to_char(ff));

    p(aa, bb, cc, dd);

    dbms_output.put_line('After invoking procedure: ');
    dbms_output.put('aa = ');
    dbms_output.put_line(NVL(to_char(aa), 'null'));
    dbms_output.put('bb = ');
    dbms_output.put_line(NVL(to_char(bb), 'null'));
    dbms_output.put('cc = ');
    dbms_output.put_line(NVL(to_char(cc), 'null'));
    dbms_output.put_line('dd = ' || to_char(dd));

    p(1, (bb+3)*4, ee, ff);

    dbms_output.put('ee = ');
    dbms_output.put_line(NVL(to_char(ee), 'null'));
    dbms_output.put_line('ff = '|| to_char(ff));
end;
/

--EXERCISE
--1. Write a procedure to display a message “Good Day to You”.
create or replace procedure message is 
begin 
    dbms_output.put_line('Good Day to You');
end;
/
begin 
    message;
end;
/

--2. Based on the University Database Schema in Lab 2, write a procedure 
--which takes the dept_name as input parameter and lists all the 
--instructors associated with the department as well as list all the 
--courses offered by the department. Also, write an anonymous block 
--with the procedure call.
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE Get_Dept_Details(p_dept_name IN VARCHAR2)IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Instructors in Department: ' || p_dept_name);
    FOR rec IN (SELECT ID, name, salary FROM Instructor WHERE dept_name = p_dept_name) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.ID || ', Name: ' || rec.name || ', Salary: ' || rec.salary);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Courses offered by Department: ' || p_dept_name);
    FOR rec IN (SELECT course_id, title, credits FROM Course WHERE dept_name = p_dept_name) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Course ID: ' || rec.course_id || ', Title: ' || rec.title || ', Credits: ' || rec.credits);
    END LOOP;
END;
/

DECLARE
    v_dept_name VARCHAR2(50) := 'Comp. Sci.'; 
BEGIN
    Get_Dept_Details(v_dept_name);
END;
/

--3. Based on the University Database Schema in Lab 2, write a Pl/Sql block of code that lists the most popular course 
--(highest number of students take it) for each of the departments. It should make use of a procedure course_popular which  
--finds the most popular course in the given department. 

SET SERVEROUTPUT ON;

CREATE VIEW Enrols AS
SELECT t.course_id, c.title, c.dept_name, COUNT(t.ID) AS student_count
FROM Takes t
JOIN Course c on t.course_id = c.course_id
GROUP BY t.course_id, c.title, c.dept_name;

CREATE OR REPLACE PROCEDURE course_popular (p_dept_name IN VARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Department: ' || p_dept_name);
    FOR rec IN (
        SELECT course_id, title, student_count
        FROM Enrols
        WHERE dept_name = p_dept_name
        AND student_count = (
            SELECT MAX(student_count) 
            FROM Enrols 
            WHERE dept_name = p_dept_name
        )
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Most Popular Course: ' || rec.course_id || ' - ' || rec.title);
        DBMS_OUTPUT.PUT_LINE('Total Students Enrolled: ' || rec.student_count);
    END LOOP;
END;
/
BEGIN
    FOR rec IN (SELECT dept_name FROM Department) 
    LOOP
        course_popular(rec.dept_name);
    END LOOP;
END;
/

--4. Based on the University Database Schema in Lab 2, write a procedure which takes 
--the  dept-name  as  input  parameter  and  lists  all  the  students  associated  with  the 
--department as well as list all the courses offered by the department. Also, write an 
--anonymous block with the procedure call
set serveroutput on;
create or replace procedure stud_course(p_dept_name IN varchar2) is 
begin 
    dbms_output.put_line('Department: '|| p_dept_name);
    dbms_output.put_line('Students in '|| p_dept_name || ': ');
    for stud in (select id, name from student where dept_name = p_dept_name) loop 
        dbms_output.put_line(stud.id || ' - ' || stud.name || ' ');
    end loop;
    dbms_output.put_line('Courses offered by '||p_dept_name||': ');
    for cour in (select course_id, title from course where dept_name = p_dept_name) loop 
        dbms_output.put_line(cour.course_id || ' - ' || cour.title || ' ');
    end loop;
    if sql%notfound then dbms_output.put_line('No students or courses found for this dept.');
    end if;
end;
/

declare dept varchar2(50) := 'Comp. Sci.';
begin 
        stud_course(dept);
end;
/

--5. Write a function to return the Square of a given number and call it from an anonymous block.
create or replace function Square(pnum number)
return number as 
BEGIN 
    return pnum * pnum;
end;
/

declare 
    num number := 5;
    res number;
begin 
    res := Square(num);
    dbms_output.put_line('Square of ' || num || ' is: ' || res);
end;
/

--6. Based on the University Database Schema in Lab 2, write a Pl/Sql block of code 
--that lists the highest paid Instructor in each of the Department. It should make use 
--of a function department_highest which returns the highest paid Instructor for the 
--given branch
create or replace function dep_high (p_dept_name varchar2)
return varchar2 as 
    vname instructor.name%type;
    vsal instructor.salary%type;
begin 
    select name, salary into vname, vsal 
    from instructor 
    where dept_name = p_dept_name and salary = (select max(salary)
                                                from instructor 
                                                where dept_name = p_dept_name);
    return vname || ' - ' || vsal;
end;
/

declare vhighest varchar2(100);
begin 
    for dept in (select dept_name from department) loop 
        vhighest := dep_high(dept.dept_name);
        dbms_output.put_line('Department: ' || dept.dept_name);
        dbms_output.put_line('Highest paid instructor: ' || vhighest);
    end loop;
end;
/

--7. Based on the University Database Schema in Lab 2, create a package to include the following: 
--    a) A named procedure to list the instructor_names of given department 
--    b) A function which returns the max salary for the given department 
--    c) Write a PL/SQL block to demonstrate the usage of above package components 
create or replace package dept_pack as 
    procedure list_inst (p_dept_name varchar2);
    function max_sal (p_dept_name varchar2) return number;
end dept_pack;
/

create or replace package body dept_pack as 
    procedure list_inst (p_dept_name varchar2) is 
    begin 
        dbms_output.put_line('Instructors in dept.: ' || p_dept_name);
        for rec in (select name from instructor where dept_name = p_dept_name) loop
            dbms_output.put_line(' ' || rec.name);
        end loop;
        if sql%notfound then 
            dbms_output.put_line(' No instructors found');
        end if;
    end;

    function max_sal (p_dept_name varchar2) 
    return number as 
        v_maxsal number := 0;
    begin 
        select max(salary) into v_maxsal from instructor where dept_name = p_dept_name;
        if v_maxsal is null then return 0;
        else return v_maxsal;
        end if;
    end;
end dept_pack;
/

declare 
    v_dept_name Department.dept_name%type := 'Comp. Sci.';
    v_maxsal number;
begin 
    dept_pack.list_inst(v_dept_name);
    v_maxsal := dept_pack.max_sal(v_dept_name);
    dbms_output.put_line('Max salary in ' || v_dept_name || ': ' || v_maxsal);
end;
/

--8. Write  a  PL/SQL  procedure  to  return  simple  and  compound  interest  (OUT 
--parameters) along with the Total Sum (IN OUT) i.e. Sum of Principle and Interest 
--taking as input the principle, rate of interest and number of years (IN parameters). 
--Call this procedure from an anonymous block

CREATE OR REPLACE PROCEDURE calc_interest (
    p IN NUMBER,
    r IN NUMBER,
    t IN NUMBER,
    s OUT NUMBER,
    c OUT NUMBER,
    total IN OUT NUMBER
) IS
BEGIN
    -- Calculate Simple Interest
    s := (p * r * t) / 100;
    
    -- Calculate Compound Interest (compounded annually)
    c := p * POWER((1 + r / 100), t) - p;

    -- Update Total Sum (Principal + Interest)
    total := p + c;
END;
/
DECLARE
    v_p NUMBER := 10000;  -- Example Principal Amount
    v_r NUMBER := 5;           -- Example Interest Rate (5%)
    v_t NUMBER := 3;          -- Example Time Period in Years
    v_s NUMBER;              -- Variable to hold Simple Interest
    v_c NUMBER;            -- Variable to hold Compound Interest
    v_total NUMBER;               -- Variable to hold Total Sum
BEGIN
    -- Initialize total with principal amount
    v_total := v_p;

    -- Call the procedure
    calc_interest(v_p, v_r, v_t, v_s, v_c, v_total);

    -- Display the results
    DBMS_OUTPUT.PUT_LINE('Simple Interest: ' || v_s);
    DBMS_OUTPUT.PUT_LINE('Compound Interest: ' || v_c);
    DBMS_OUTPUT.PUT_LINE('Total Sum (Principal + Compound Interest): ' || v_total);
END;
/
