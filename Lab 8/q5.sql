CREATE TABLE studentable (
    rollno NUMBER PRIMARY KEY,
    gpa NUMBER(3,1),
    LetterGrade VARCHAR2(2) -- LetterGrade column already exists
);
drop table studentable;
INSERT INTO studentable VALUES (1, 5.8, NULL);
INSERT INTO studentable VALUES (2, 6.5, NULL);
INSERT INTO studentable VALUES (3, 3.4, NULL);
INSERT INTO studentable VALUES (4, 7.8, NULL);
INSERT INTO studentable VALUES (5, 5.8, NULL);

COMMIT;

-- Reset all LetterGrade values to 'F'
ALTER TABLE studentable MODIFY LetterGrade VARCHAR2(2) DEFAULT 'F';
UPDATE studentable SET LetterGrade = 'F';
COMMIT;

SET SERVEROUTPUT ON;

DECLARE
    -- Cursor with FOR UPDATE to allow modification
    CURSOR c IS 
        SELECT rollno, gpa, LetterGrade 
        FROM studentable 
        FOR UPDATE;  

    v_grade studentable.LetterGrade%TYPE; -- Variable to store calculated letter grade

BEGIN
    FOR i IN c LOOP
        -- Determine the letter grade based on GPA
        IF i.gpa >= 9.0 THEN
            v_grade := 'A+';
        ELSIF i.gpa >= 8.0 THEN
            v_grade := 'A';
        ELSIF i.gpa >= 7.0 THEN
            v_grade := 'B';
        ELSIF i.gpa >= 6.0 THEN
            v_grade := 'C';
        ELSIF i.gpa >= 5.0 THEN
            v_grade := 'D';
        ELSE
            v_grade := 'F';
        END IF;

        -- Update LetterGrade using WHERE CURRENT OF
        UPDATE studentable 
        SET LetterGrade = v_grade 
        WHERE CURRENT OF c;

        -- Print updated information
        DBMS_OUTPUT.PUT_LINE('Roll No: ' || i.rollno || 
                             ', GPA: ' || i.gpa || 
                             ', Updated Letter Grade: ' || v_grade);
    END LOOP;

    COMMIT; -- Save changes

END;
/
