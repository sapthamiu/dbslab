--1. create emp table
create table employee (
    empno number primary key,
    empname varchar(20) not null,
    gender char(1) not null check (gender in ('M', 'F')), 
    salary number(8, 2) not null,
    address varchar(20) not null, 
    dno number 
);
--2. create dept table
create table dept (
    deptno number primary key, 
    deptname varchar(20) unique, 
    location varchar(20)
);
--3. foreign key constraint
alter table employee add foreign key(dno) references dept(deptno);
--4. insert tuples
insert into dept values (1, 'HR', 'first floor');
insert into dept values (2, 'Tech', 'ground floor');
insert into employee values(1, 'Viks', 'M', 100000, 'doraemons pocket', 2);
--5. violating tuples
insert into employee values(1, 'Sami', 'F', 10000, 'anywhere door', 2); --violation
--6. violating delete
delete from dept where deptno = 2;  --violation
--7. on delete
alter table employee drop constraint SYS_C009859;

select * from user_constraints;
alter table employee modify foreign key(dno) references dept(deptno) on delete cascade;

select constraint_name from user_constraints where table_name = 'EMPLOYEE' and constraint_type = 'R';