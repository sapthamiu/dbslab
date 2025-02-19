SET SERVEROUTPUT ON;

DECLARE
    gpa studen.gpa%TYPE;
    grd CHAR(2);
    rno studen.roll%TYPE := 1;
BEGIN
    -- Start of loop
    START_LOOP:
    IF rno > 5 THEN
        GOTO END_LOOP;  -- Exit loop after RollNo 5
    END IF;

    -- Fetch GPA for the studen with the current RollNo
    BEGIN
        SELECT gpa INTO gpa FROM studen WHERE roll = rno;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No studen found for RollNo ' || rno);
            rno := rno + 1;
            GOTO START_LOOP;
    END;

    -- Go to letter grade assignment
    GOTO GRADE_ASSIGN;

    -- Assign letter grade
    GRADE_ASSIGN:
    IF gpa >= 9 THEN
        grd := 'A+';
    ELSIF gpa >= 8 THEN
        grd := 'A';
    ELSIF gpa >= 7 THEN
        grd := 'B';
    ELSIF gpa >= 6 THEN
        grd := 'C';
    ELSIF gpa >= 5 THEN
        grd := 'D';
    ELSIF gpa >= 4 THEN
        grd := 'E';
    ELSE
        grd := 'F';
    END IF;

    -- Print the result
    DBMS_OUTPUT.PUT_LINE('RollNo: ' || rno || ' - GPA: ' || gpa || ' - Grade: ' || grd);

    -- Increment RollNo
    rno := rno + 1;

    -- Go back to the loop label
    GOTO START_LOOP;

    -- Label to exit the loop
    END_LOOP:
    DBMS_OUTPUT.PUT_LINE('End of grade printing.');
END;
/
