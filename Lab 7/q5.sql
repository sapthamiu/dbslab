--ALTER TABLE studen
--ADD LetterGrade VARCHAR2(2);

SET SERVEROUTPUT ON;

DECLARE
    gp studen.gpa%TYPE;   
    gr studen.LetterGrade%TYPE; 
BEGIN

    FOR i IN (SELECT roll, gpa FROM studen) 
    LOOP
        gp := i.gpa;

        IF gp >= 9 THEN
            gr := 'A';
        ELSIF gp >= 7 THEN
            gr := 'B';
        ELSIF gp >= 5 THEN
            gr := 'C';
        ELSE
            gr := 'D';
        END IF;

        UPDATE studen
        SET LetterGrade = gr
        WHERE roll = i.roll;
    END LOOP;

    --COMMIT;  -- Commit the changes to the database
    DBMS_OUTPUT.PUT_LINE('Letter grades updated successfully.');
END;
/
