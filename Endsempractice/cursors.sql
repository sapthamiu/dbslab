 --1.
create table sal_raise (
    i_id varchar(5) primary key,
    rdate date,
    ramt number(8, 2));

declare 
    cursor c1 (dept instructor.dept_name%type) is 
        select * from instructor where dept_name = dept;
        dept instructor.dept_name%type := :DeptNamePlease;
        ramt number;
BEGIN
    for ins in c1(dept) LOOP
        ramt := ins.salary * 0.05;
        update instructor set salary = salary * 1.05 where ins.id = instructor.id;
        insert into sal_raise values(ins.id, sysdate, ramt);
        end loop;
end;
/

select * from sal_raise;

--2. 
declare 
    cursor c1 is 
        select id, name, dept_name, tot_cred
        from student 
        order by tot_cred;
    rec c1%rowtype;
begin 
    open c1;
    loop 
        fetch c1 into rec;
        exit when c1%rowcount > 10 or c1%notfound;
        dbms_output.put_line(rec.id || '   ' || rec.name || '   ' ||  rec.dept_name || '   ' || rec.tot_cred);
    end loop;
    close c1;
end;
/

--4.
declare 
    cursor c1 is 
        select id, tot_cred
        from student join takes using (id) 
        where course_id = 'CS-101' for update;
begin 
    for i in c1 loop 
        if(i.tot_cred < 50) then 
            delete from takes where current of c1;
        end if;
    end loop;
end;
/
select * from takes;
    