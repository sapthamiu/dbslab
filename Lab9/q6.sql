SET SERVEROUTPUT ON;

DECLARE
    -- Declare the parameterized cursor that takes course_id as input
    CURSOR c(cid teaches.course_id%TYPE) IS
        SELECT DISTINCT id 
        FROM teaches 
        WHERE course_id = cid;
        
    -- Declare variables to hold instructor name and course_id
    iname instructor.name%TYPE;
    cid teaches.course_id%TYPE;
BEGIN
    -- Get the course_id from user input
    cid := '&CourseID';

    -- Loop through the cursor to fetch instructors for the course
    FOR i IN c(cid) LOOP
        -- Fetch the instructor's name based on the ID
        SELECT name INTO iname 
        FROM instructor 
        WHERE id = i.id;
        
        -- Output the instructor's ID and name
        DBMS_OUTPUT.PUT_LINE('Instructor ID: ' || i.id || ' Name: ' || iname);
    END LOOP;
END;
/
