SET SERVEROUTPUT ON;

DECLARE
    CURSOR c IS 
        SELECT t.course_id, t.sec_id, t.semester, t.year, t.id AS instructor_id,
               c.title, c.dept_name, c.credits, 
               i.name AS instructor_name, 
               s.building, s.room_number, s.time_slot_id,
               (SELECT COUNT(*) FROM takes tk
                WHERE tk.course_id = t.course_id 
                  AND tk.sec_id = t.sec_id 
                  AND tk.semester = t.semester 
                  AND tk.year = t.year) AS tot_student_no
        FROM teaches t
        LEFT JOIN course c ON t.course_id = c.course_id
        LEFT JOIN instructor i ON t.id = i.id
        LEFT JOIN section s ON t.course_id = s.course_id 
                           AND t.sec_id = s.sec_id 
                           AND t.semester = s.semester 
                           AND t.year = s.year;

    instructor_name instructor.name%TYPE;
    building section.building%TYPE;
    room_number section.room_number%TYPE;
    time_slot_id section.time_slot_id%TYPE;
    
BEGIN
    FOR rec IN c LOOP
        IF rec.instructor_name IS NULL THEN
            instructor_name := 'Unknown Instructor';
        ELSE
            instructor_name := rec.instructor_name;
        END IF;

        IF rec.building IS NULL THEN
            building := 'N/A';
        ELSE
            building := rec.building;
        END IF;

        IF rec.room_number IS NULL THEN
            room_number := 'N/A';
        ELSE
            room_number := rec.room_number;
        END IF;

        IF rec.time_slot_id IS NULL THEN
            time_slot_id := 'N/A';
        ELSE
            time_slot_id := rec.time_slot_id;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Course ID: ' || rec.course_id || 
                             ' Title: ' || rec.title || 
                             ' Dept name: ' || rec.dept_name || 
                             ' Credits: ' || rec.credits || 
                             ' Instructor name: ' || instructor_name || 
                             ' Building: ' || building || 
                             ' Room number: ' || room_number || 
                             ' Time slot id: ' || time_slot_id || 
                             ' Total students enrolled: ' || rec.tot_student_no || chr(10));
    END LOOP;
END;
/


/*
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
*/


 declare
    cursor c is 
    select c.course_id, c.title, c.dept_name, c.credits, i.name, s.building, s.room_number, s.time_slot_id, count(*) tot_student_no 
    from course c, instructor i, section s, teaches te, takes ta
    where c.course_id = s.course_id and c.course_id = te.course_id and c.course_id = ta.course_id and i.ID = te.ID and s.course_id = te.course_id and s.sec_id = te.sec_id and s.semester = te.semester and s.year = te.year and s.course_id = ta.course_id and s.sec_id = ta.sec_id and s.semester = ta.semester and s.year = ta.year and te.course_id = ta.course_id and te.sec_id = ta.sec_id and te.semester = ta.semester and te.year = ta.year
    group by c.course_id, c.title, c.dept_name, c.credits, i.name, s.building, s.room_number, s.time_slot_id;
begin
    for det in c
    loop
        dbms_output.put_line(det.course_id || det.title || det.dept_name || det.credits || det.name || det.building || det.room_number || det.time_slot_id || det.tot_student_no);
    end loop;
end;
/
