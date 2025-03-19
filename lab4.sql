--1.
select course_id, count(id) from takes group by course_id;

--2.
select dept_name from student group by dept_name having count(id) > 3;

--3.
select dept_name, count(course_id) from course group by dept_name;

--4.
select dept_name, avg(salary) from instructor group by dept_name having avg(salary) > 42000;

--5.
select course_id, sec_id, count(id) from takes where semester = 'Spring' and year = 2009 group by sec_id, course_id;

--6.
select course_id, prereq_id from prereq order by course_id;

--7.
select * from instructor order by salary desc;

--8.
with dept_sal as (select dept_name, sum(salary) as tot_sal from instructor group by dept_name)
select dept_name, tot_sal 
from dept_sal
where tot_sal = (select max(tot_sal) from dept_sal);

--9.
--select dept_name, avg(salary) from instructor group by dept_name having avg(salary) > 42000;

with dept_avg_sal as (select dept_name, avg(salary) as avg_sal 
		      from instructor 
		      group by dept_name)
select dept_name, avg_sal 
from dept_avg_sal 
where avg_sal > 42000;

--10. 
with sec_enroll as (select course_id, sec_id, count(id) as students 
		    from takes 
		    where semester = 'Spring' and year = 2010 
		    group by sec_id, course_id)
select course_id, sec_id, students 
from sec_enroll 
where students = (select max(students) 
		  from sec_enroll);

--11.
select name
from instructor I
where not exists(
    select id
    from student
    where dept_name='Comp. Sci.'
    minus
    select T.id
    from takes T,teaches E
    where T.course_id=E.course_id and T.sec_id=E.sec_id 
        and T.semester=E.semester and T.year=E.year 
        and E.id=I.id
);

--12. Find the average salary  of those departments where the average salary is  greater than 50000 and total number of instructors in the department are more than 5.
select dept_name, avg(salary) as avg_sal
from instructor
group by dept_name 
having avg(salary)>50000 and count(id) > 2;

--13. Find all departments with the maximum budget.
with dept_budget as(
    select dept_name, budget 
    from DEPARTMENT 
)
select dept_name, budget 
from dept_budget 
where budget = (select max(budget) from dept_budget);

--14. Find all departments where the total salary is greater than the average of the total salary at all departments. 
with dept_sal as(
    select dept_name, sum(salary) as total 
    from INSTRUCTOR
    group by dept_name
)
select dept_name, total
from dept_sal
where total > (select avg(total) from dept_sal);

--15.  Transfer all the students from CSE department to IT department.
set AUTOCOMMIT off;
savepoint s;
update student set dept_name = 'Biology' where dept_name = 'Comp. Sci.';
rollback;
commit;
--16. Increase salaries of instructors whose salary is over $100,000 by 3%, and all others receive a 5% raise 
savepoint s;
update instructor set salary = salary * 1.03 where salary > 50000;
update instructor set salary = salary * 1.05 where salary <= 50000;

rollback to s;
commit;
