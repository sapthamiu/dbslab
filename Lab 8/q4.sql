SET SERVEROUTPUT ON;

DECLARE
    CURSOR c IS
        SELECT id, course_id
        FROM takes
        WHERE course_id = 'CS-101';
        
    cr student.tot_cred%TYPE; -- variable to store the student's total credits
    
BEGIN
    FOR i IN c LOOP
        SELECT tot_cred INTO cr 
        FROM student 
        WHERE id = i.id;
        
        IF cr < 30 THEN

            DBMS_OUTPUT.PUT_LINE('Deregistering Student ID: ' || i.id || 
                                 ', Course ID: ' || i.course_id || 
                                 ', Total Credits: ' || cr);

            DELETE FROM takes 
            WHERE id = i.id 
            AND course_id = i.course_id;
        END IF;
    END LOOP;

END;
/
