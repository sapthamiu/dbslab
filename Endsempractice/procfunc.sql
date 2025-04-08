--1. 
create or replace procedure displaymsg IS
begin 
    dbms_output.put_line('Good Day to You');
end;
/

begin 
displaymsg;
end;
/

--2.
create or replace procedure dept_details (dept in varchar) IS
begin 
    for ins in (select * from instructor where dept_name = dept) loop 
        dbms_output.put_line(ins.name);
    end loop;
    for crs in (select * from course where dept_name = dept) loop 
        dbms_output.PUT_LINE(crs.title);
    end loop;
end;
/

declare 
    v_dept department.DEPT_NAME%TYPE := :DeptName;
begin 
    dept_details(v_dept);
end;
/

--3. 
create or replace view enrolment as 
select course_id, title, dept_name, count(id) as cnt
from takes join course using (course_id)
group by course_id, title, dept_name;

create or replace procedure crs_pop (dept in varchar) IS
begin 
    dbms_output.put_line(dept || '   ');
    for rec in (select course_id, title, dept_name, cnt 
                from enrolment 
                where dept_name = dept and cnt = (select max(cnt) 
                                                from enrolment 
                                                where dept_name = dept)) LOOP
        dbms_output.put_line(rec.course_id || '   ' || rec.title || '   ' || rec.dept_name || '   ' || rec.cnt);
    end loop;   
end;
/


begin 
    for i in (select dept_name from department) loop 
        crs_pop(i.dept_name);
    end loop;
end;
/

--5. 
create or replace function square (numi in number) 
return number as 
begin 
    return numi * numi;
end;
/

declare 
    numi int := :NumberPlease;
begin 
    dbms_output.put_line(square(numi));
end;
/

--6. 
create or replace function highpay (dept in varchar) 
return varchar as 
    v_name instructor.name%type;
begin 
    select name into v_name 
    from instructor 
    where dept_name = dept and salary = (
                            select max(salary) 
                            from instructor 
                            where dept_name = dept);
    return v_name;
end;
/

begin 
    for i in (select dept_name from department) loop 
        dbms_output.put_line(i.dept_name || '   ' || highpay(i.dept_name));
    end loop;
end;
/

--7. 
create or replace package dpack as 
    procedure insnames (dept varchar);
    function maxsal (dept varchar) return number;
end dpack;
/
create or replace package body dpack as 
    procedure insnames (dept varchar) is 
    begin 
        for rec in (select name from instructor where dept_name = dept) loop 
            dbms_output.put_line(rec.name);
        end loop;
    end;
    function maxsal (dept varchar) return number as 
    mx number;
    begin 
        select max(salary) into mx from instructor where dept_name = dept;
        return mx;
    end;
end dpack;
/

declare 
    v_dept department.DEPT_NAME%TYPE := 'Comp. Sci.';
begin 
    dpack.insnames(v_dept);
    dbms_output.put_line(dpack.maxsal(v_dept));
end;
/

    
