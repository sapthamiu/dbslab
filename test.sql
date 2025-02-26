select table_name from user_tables;
select * from tab;

--1. List all Students with names and their department names
select name, dept_name 
from student;

-- 2. List all instructors in CSE department
select name 
from instructor 
where dept_name = 'Comp. Sci.';

--3. Find the names of courses in CSE department which have 3 credits
select title 
from course where credits = 3;

--4. For the student with ID 12345 (or any other value), 
--show all course-id and title of all courses registered for by the student. 
select course_id, title 
from course natural join takes 
where id = 12345;

--5.  List all the instructors whose salary is in between 40000 and 90000. 
select id, name 
from instructor 
where salary between 40000 and 90000;

--6. Display the IDs of all instructors who have never taught a course
select instructor.id 
from instructor 
where instructor.id not in (select teaches.id from teaches);

--7. Find the student names, course names, and the year, for all students 
--those who have attended classes in room-number 303.
select name, title, year 
from student natural join takes natural join section natural join course 
where room_number = 101; 

--8. For all students who have opted courses in 2015, find their names and 
--course id’s with the attribute course title replaced by c-name
-- select name, course_id, title as "c-name"
-- from  student natural join takes natural join COURSE
-- where year = 2010;
--DO NOT USE NATURAL JOIN WHEN THERE ARE MORE THAN ONE COMMON ATTRIBUTE

select name, takes.course_id, title 
from student join takes on takes.id = student.ID
join course on course.course_id = takes.COURSE_ID
where year = 2010;

--9. Find the names of all instructors whose salary is greater than the 
--salary of at least one instructor of CSE department and salary 
--replaced by inst-salary.
select distinct i1.name, i1.salary as "inst-salary"
from instructor i1, instructor i2
where i1.salary > i2.salary and i2.dept_name = 'Comp. Sci.';

--10. Find the names of all instructors whose department name includes the 
--substring ‘ch’. 
select name, dept_name
from instructor 
where dept_name like '%om%';

--11. List the student names along with the length of the student names.
select name, length(name)
from student;

--12. List the department names and 3 characters from 3rd position 
--of each department name
select dept_name, substr(dept_name, 3, 3)
from department;

--13. List the instructor names in upper case.
select upper(name) from instructor;

--14. Replace NULL with value1(say 0) for a column in any of the table 
select id, nvl(grade, 0) grade from takes;

--15. Display the salary and salary/3 rounded to nearest hundred from Instructor.
select salary, round(salary/3, -2) from instructor;

--16. Add date of birth column (DOB). Display the birth date of all the employees in the following format:
--‘DD-MON-YYYY’
--‘DD-MON-YY’
--‘DD-MM-YY’
select sysdate from dual;
alter table student add (DOB date);
update student set DOB='29-DEC-2005';
select to_char(DOB, 'DD-MON-YYYY') from student;
select to_char(DOB, 'DD-MON-YY') from student;
select to_char(DOB, 'DD-MM-YY') from student;

--17. List the employee names and the year (fully spelled out) in which they are born
--‘YEAR’
--‘Year’
--‘year’
select name, to_char(DOB, 'YEAR') from student;
select name, to_char(DOB, 'Year') from student;
select name, to_char(DOB, 'year') from student;

--18. Modify the employee table to check the salary of every employee 
--to be greater than 5000.
alter table instructor add check(salary > 5000);

select salary from instructor;
insert into instructor values(2275, 'Viks', 'Psychology', 2000);

--19. Find the quarter of year from the given date.
select to_char(DOB,'Q') from student;
select to_char(to_date('06-07-25'), 'Q') from dual;

--20. For all instructors who have taught some course, find their names 
--and the course ID of the courses they taught.
select name, course_id
from teaches natural join INSTRUCTOR;

--21. Find the names of all departments with instructor, and remove duplicates
select  distinct dept_name
from instructor;

--22. List all the students with student name, department name, advisor name 
--and the number of courses registered
select student.name, student.dept_name, instructor.name as AdvisorName,
(select count(takes.id) from takes where student.id = takes.id) numCourse
from student join advisor on s_id = student.id join instructor on i_id = instructor.ID;

--23. Find courses that ran in Fall 2009 or in Spring 2010
select course_id 
from teaches 
where semester = 'Fall' and year = 2009
union 
select COURSE_ID
from teaches 
where semester = 'Spring' and year = 2010;

select COURSE_ID
from TEACHES
where (semester,year) in (('Fall',2009),('Spring', 2010));

--24. Find courses that ran in Fall 2009 and in spring 2010
select course_id 
from teaches 
where semester = 'Fall' and year = 2009
intersect
select COURSE_ID
from teaches 
where semester = 'Spring' and year = 2010;

select course_id 
from teaches 
where semester = 'Fall' and year = 2009 and 
course_id in (select course_id from teaches where semester = 'Spring' and year = 2010);

--25. Find courses that ran in Fall 2009 but not in Spring 2010
select course_id 
from teaches 
where semester = 'Fall' and year = 2009
MINUS 
select COURSE_ID
from teaches 
where semester = 'Spring' and year = 2010;

select COURSE_ID
from TEACHES
where semester = 'Fall' and year = 2009
and course_id not in (select course_id from teaches where semester = 'Spring' and year = 2010);


--26. Find the name of the course for which none of the students registered
select distinct title 
from course, TAKES
where course.course_id not in (select course_id from takes);

select title from course 
minus 
select title from course natural join takes;

--27. Find the total number of students who have taken course taught by 
--the instructor with ID 10101
select count(takes.id)
from takes join teaches 
using (course_id, semester, year, sec_id)
where teaches.id = 10101;

--28. Find the names of all students whose name is same as the instructor’s name.
select name
from student join instructor using (NAME);

--29. Find names of instructors with salary greater than that of some (at least one) instructor
--in the Biology department.
select name, salary
from instructor
where salary > some(select salary from instructor where dept_name = 'Biology');

--30. Find the names of all instructors whose salary is greater than the 
--salary of all instructors in the Biology department.
select name, salary
from instructor
where salary > all(select salary from instructor where dept_name = 'Biology');

--31. Find the departments that have the highest average salary.
select max(avgsal) 
from(select avg(salary) as avgsal
    from instructor
    group by dept_name);

select dept_name, avg(salary)
from INSTRUCTOR
group by DEPT_NAME
having avg(salary) >= all(select avg(salary) from instructor group by dept_name);

--32. 
--33.
--34.
--35.

--36. Find all the students who have opted at least two courses offered by 
--CSE department.
select id
from takes natural join COURSE
where dept_name = 'Comp. Sci.'
group by id 
having count(course_id) >= 2;

--37. Find the average instructors salary of those departments where the average 
--salary is greater than 42000

select dept_name, avg(salary)
from instructor 
group by dept_name 
having avg(salary) > 42000;

--38. Create a view all_courses consisting of course sections offered by Physics
--department in the Fall 2009, with the building and room number of each section.
create view all_courses as 
select sec_id, building, room_number
from section join course using (course_id) 
where dept_name = 'Physics' and semester = 'Fall' and year = 2009;

--39. Select all the courses from all_courses view
select * from all_courses;

--40. Create a view department_total_salary consisting of department name and 
--total salary of that department
create view dept_sal as 
select dept_name, sum(salary) as tot_sal 
from instructor 
group by dept_name;

--41. Find the names of all departments with instructor and remove duplicates
select distinct name, dept_name
from instructor;

--42. For all instructors who have taught some course, find their names and 
--the course ID of the courses they taught.
select distinct name, course_id 
from instructor join teaches using (id);

--43. Find all the instructors with the courses they taught
select distinct name, title 
from instructor join teaches using (id) join course using (course_id);

--44. List all the students with student name, department name, advisor name 
--and the number of courses registered
with temp as (select id, count(course_id) numcourse from takes group by id)
select s.name, s.dept_name, i.name, numcourse 
from student s join advisor on s.id = s_id join instructor i on i.id = i_id, temp
where s.id = temp.id;

select s.name, s.dept_name, i.name, 
(select count(course_id) from takes where takes.id = s.id group by id)numcourse 
from student s join advisor on s.id = s_id join instructor i on i.id = i_id;

--45. Find the number of students in each course.
select course_id, count(id) 
from takes 
group by course_id;

--46. Find those departments where the number of students are greater than 10
select dept_name, count(id)
from student 
group by dept_name 
having count(id) > 3;

--47. Find the total number of courses in each department.
select dept_name, count(course_id)
from course 
group by DEPT_NAME;

--48. Find the enrolment of each section that was offered 
--in Spring 2009
select course_id, sec_id, count(id)
from takes 
where semester = 'Spring' and year = 2009
group by sec_id, course_id;

--49. List all the courses with prerequisite courses, then display 
--course id in increasing order.
select course_id, prereq_id
from prereq 
order by course_id;

/*--50. Display the details of instructors sorting the salary in 
--decreasing order*/
select * 
from instructor
order by salary desc;

--51. Find the maximum total salary across the departments.
with totsal as (select dept_name, sum(salary) sal from instructor group by dept_name)
select dept_name, sal 
from totsal
where sal >= all(select sal from totsal);
