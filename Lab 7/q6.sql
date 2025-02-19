SET SERVEROUTPUT ON;

DECLARE
    mx studen.gpa%TYPE := 0;  
    rl studen.roll%TYPE;      
    gp studen.gpa%TYPE;       
BEGIN
    FOR i IN (SELECT roll, gpa FROM studen) LOOP
        gp := i.gpa;
        IF gp > mx THEN
            mx := gp;
            rl := i.roll;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Student with RollNo ' || rl || ' has the maximum GPA of ' || mx);
END;
/
