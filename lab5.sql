--1. Retrieve the birth date and address of the employee(s) whose name is ‘John B. Smith’. 
--Retrieve the name and address of all employees who work for the ‘Research’ department.
select bdate, address 
from Employee
where fname='John' and minit='B' and lname='Smith';

select fname, minit, lname, address, dname
from Employee join department on employee.dno = department.dnumber
where dname = 'Research';

--2. For every project located in ‘Stanford’, list the project number, the controlling department number, 
--and the department manager’s last name, address, and birth date. 
select pnumber, dnum, lname, address, bdate
from project, department, employee
where plocation = 'Stafford' and dnum=dnumber and mgr_ssn=ssn;

--3. For each employee, retrieve the employee’s first and last name and the first and last name of his or her 
--immediate supervisor. 
select e1.fname, e1.lname, e2.fname SuperFname, e2.lname SuperLname
from Employee e1, Employee e2
where e1.super_ssn = e2.ssn;

--4. Make a list of all project numbers for projects that involve an employee whose last name is ‘Smith’, 
--either as a worker or as a manager of the department that controls the project.
select Pno, lname
from works_on, employee
where lname = 'Smith' and works_on.essn = employee.ssn
union
select Pnumber, lname
from project, department, employee
where lname = 'Smith' and dnum = dnumber and mgr_ssn = ssn;

--5. Show the resulting salaries if every employee working on the ‘ProductX’ project is given a 10 percent raise.
select Fname, Lname, salary * 1.1 as NewSalary
from works_on join project on Pnumber = Pno join employee on essn = ssn
where pname = 'ProductX';

--6. Retrieve a list of employees and the projects they are working on, ordered by department and, within each 
--department, ordered alphabetically by last name, then first name.
select ssn, Fname, Lname, Pnumber, Pname, Dname
from Employee join works_on on ssn = essn join project on pno = pnumber join department on dnumber = dnum
order by dnum, lname, fname;

--7. Retrieve the name of each employee who has a dependent with the same first name and is the same sex as
--the employee.
select fname, lname
from employee join dependent on essn = ssn
where dependent_name = fname and employee.sex = dependent.sex;

--8. Retrieve the names of employees who have no dependents. 
select fname, lname 
from employee 
where ssn not in (select essn from dependent);

--9. List the names of managers who have at least one dependent.
select fname, lname 
from employee join department on ssn = mgr_ssn 
where ssn in (select essn from dependent);

--10. Find the sum of the salaries of all employees, the maximum salary, the minimum salary, 
--and the average salary. 
select sum(salary), max(salary), min(salary), avg(salary)
from Employee;

--11. For each project, retrieve the project number, the project name, and the number of employees 
--who work on that project. 
