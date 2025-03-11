SET SERVEROUTPUT ON;

DECLARE
    -- Cursor to fetch students registered for courses taught by their advisor
    CURSOR c IS
        SELECT distinct s.ID AS student_id, s.name AS student_name
        FROM student s
        JOIN takes t ON s.ID = t.ID
        JOIN teaches tc ON t.course_id = tc.course_id
                      AND t.sec_id = tc.sec_id
                      AND t.semester = tc.semester
                      AND t.year = tc.year
        JOIN advisor a ON s.ID = a.s_id
        WHERE a.i_id = tc.ID;  -- Ensures the advisor is teaching the course

BEGIN
    -- Loop through the cursor and print student details
    FOR i IN c LOOP
        DBMS_OUTPUT.PUT_LINE('Student ID: ' || i.student_id || 
                             ', Name: ' || i.student_name);
    END LOOP;
    
END;
/
