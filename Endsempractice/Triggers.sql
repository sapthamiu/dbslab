--1.
create table log_change_takes(
    toc timestamp,
    ID varchar(5),
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6),
    year numeric(4,0),
    grade varchar(2),
    primary key (ID, course_id, sec_id, semester, year)
    );
create or replace trigger log_changes 
after insert or update on takes 
for each row 
begin 
    insert into log_change_takes values(sysdate, :new.ID, :new.course_id, :new.sec_id, :new.semester, :new.year, :new.grade);
end;
/

--test:
insert into takes values ('00128', 'CS-315', '1', 'Spring', '2010', 'A');
select * from LOG_CHANGE_TAKES;

--2. 
create table old_data_inst (
    id varchar(5) primary key,
    name varchar(20), 
    dept_name varchar(20), 
    salary numeric (8,2));
create or replace trigger updatesal
after update of salary 
on instructor 
for each row 
begin 
    insert into old_data_inst values (:old.id, :old.name, :old.dept_name, :old.salary);
end;
/

--test: 
update instructor set salary = salary * 1.1 where id = 10101;
select * from instructor where id = 10101;
select * from old_data_inst where id = 10101;

--3. 
create or replace trigger validation 
before insert or update 
on instructor 
for each row 
declare 
    v_budg department.BUDGET%TYPE;
begin 
    if not regexp_like(:new.name, '^[A-Za-z]+$') then 
        raise_application_error(-20000, 'Invalid name');
    end if;
    if :new.salary <= 0 THEN
        raise_application_error(-20001, 'Invalid salary');
    end if;
    select budget into v_budg from department where dept_name = :new.dept_name;
    if :new.salary > v_budg then 
        raise_application_error(-20002, 'Invalid salary');
    end if;
end;
/

--test: 
insert into instructor values(2, 'Mark1', 'Physics', 80000);

--5. 
create or replace view Adv_Stud as 
select i.id as instructor_id, s.id as student_id 
from advisor join student s on s_id = s.id 
join instructor i on i_id = i.id;
create or replace trigger stud_adv_trg 
instead of delete on Adv_Stud 
for each row 
begin 
    delete from advisor where s_id = :old.student_id and i_id = :old.instructor_id;
end;
/

drop trigger validation;
--test:
INSERT INTO Student VALUES (1, 'John Doe', 'Comp. Sci.', 30);
INSERT INTO Instructor VALUES (101, 'Dr. Smith', 'Comp. Sci.', 70000);
INSERT INTO Advisor VALUES (1, 101);
SELECT * FROM Advisor;
SELECT * FROM Adv_Stud;
DELETE FROM Adv_Stud WHERE student_id = 1 AND instructor_id = 101;
SELECT * FROM Advisor;

