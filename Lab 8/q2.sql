SET SERVEROUTPUT ON;

DECLARE
    CURSOR student_cursor IS
        SELECT ID, name, dept_name, tot_cred
        FROM student
        ORDER BY tot_cred ASC;

    student_record student_cursor%ROWTYPE;
BEGIN
    -- Open the cursor
    OPEN student_cursor;

    LOOP
        FETCH student_cursor INTO student_record;
        
        EXIT WHEN student_cursor%NOTFOUND OR student_cursor%ROWCOUNT > 10;
        
        -- Display student information
        DBMS_OUTPUT.PUT_LINE('ID: ' || student_record.ID || 
                             ', Name: ' || student_record.name || 
                             ', Department: ' || student_record.dept_name || 
                             ', Total Credits: ' || student_record.tot_cred);
    END LOOP;

    -- Close the cursor
    CLOSE student_cursor;
END;
/
