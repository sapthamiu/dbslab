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

