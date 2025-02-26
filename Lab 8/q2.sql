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

    FOR i IN 1..10 LOOP
        FETCH student_cursor INTO student_record;
        
        IF student_cursor%NOTFOUND THEN
            EXIT;
        END IF;
        
        -- Display student information
        DBMS_OUTPUT.PUT_LINE('ID: ' || student_record.ID || ', Name: ' || student_record.name || ', Department: ' || student_record.dept_name ||', Total Credits: ' || student_record.tot_cred);

    END LOOP;
    
    CLOSE student_cursor;
END;
/
