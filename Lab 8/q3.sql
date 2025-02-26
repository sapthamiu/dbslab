SET SERVEROUTPUT ON;

DECLARE
    CURSOR c IS 
        SELECT * FROM teaches; -- Cursor to loop through the teaches table
    n NUMBER; -- Variable to store the number of students enrolled
    iname instructor.name%TYPE; -- Variable to store the instructor's name
    courseRow course%ROWTYPE; -- Row variable for course details
    sectionRow section%ROWTYPE; -- Row variable for section details
BEGIN
    FOR i IN c LOOP
        BEGIN
            -- Count students enrolled in the course section
            SELECT COUNT(*) INTO n 
            FROM takes 
            WHERE course_id = i.course_id 
              AND sec_id = i.sec_id 
              AND semester = i.semester 
              AND year = i.year;

            -- In case no data found, set n to 0
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    n := 0;
        END;

        -- Fetch the instructor's name
        BEGIN
            SELECT name INTO iname 
            FROM instructor 
            WHERE id = i.id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                iname := 'Unknown Instructor';
        END;

        -- Fetch the section details
        BEGIN
            SELECT * INTO sectionRow 
            FROM section 
            WHERE course_id = i.course_id 
              AND sec_id = i.sec_id 
              AND semester = i.semester 
              AND year = i.year;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- If no section data, don't do anything
        END;

        -- Fetch the course details
        BEGIN
            SELECT * INTO courseRow 
            FROM course 
            WHERE course_id = i.course_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- If no course data, don't do anything
        END;

        -- Output the details for the course, instructor, section, and total students enrolled
        DBMS_OUTPUT.PUT_LINE('Course ID: ' || i.course_id || 
                             ' Title: ' || courseRow.title || 
                             ' Dept name: ' || courseRow.dept_name || 
                             ' Credits: ' || courseRow.credits || 
                             ' Instructor name: ' || iname || 
                             ' Building: ' || sectionRow.building || 
                             ' Room number: ' || sectionRow.room_number || 
                             ' Time slot id: ' || sectionRow.time_slot_id || 
                             ' Total students enrolled: ' || n || chr(10));
    END LOOP;
END;
/
