SET SERVEROUTPUT ON;
create table salary_raise(instructor_id varchar(5) primary key, raise_date date, raise_amt number(8, 2), foreign key(instructor_id) references instructor);
DECLARE

    CURSOR c(dname instructor.dept_name%TYPE) IS
        SELECT * FROM instructor WHERE dept_name = dname;

    str instructor.dept_name%TYPE;

BEGIN
    str := '&DeptName';

    -- Use FOR loop to automatically open, fetch, and close the cursor
    FOR inst IN c(str) LOOP
        -- Update the salary for the current instructor
        UPDATE instructor
        SET salary = salary * 1.05
        WHERE id = inst.id;

        -- Insert a record into the salary_raise table
        INSERT INTO salary_raise (instructor_id, raise_date, raise_amt)
        VALUES (inst.id, SYSDATE, inst.salary * 0.05);
    END LOOP;
END;
/

select * from salary_raise;