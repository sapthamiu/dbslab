--EX1 A PL/SQL block to display the grade for given letter grade
SET SERVEROUTPUT ON
DECLARE
    grade CHAR(1);
BEGIN
    grade := '&g';
IF grade = 'A' THEN 
    DBMS_OUTPUT.PUT_LINE('EXCELLENT');
ELSIF grade = 'B' THEN
    DBMS_OUTPUT.PUT_LINE('VERY GOOD');
ELSIF grade = 'C' THEN
    DBMS_OUTPUT.PUT_LINE('GOOD');
ELSIF grade = 'D' THEN
    DBMS_OUTPUT.PUT_LINE('FAIR');
ELSIF grade = 'F' THEN
    DBMS_OUTPUT.PUT_LINE('POOR');
ELSE DBMS_OUTPUT.PUT_LINE('NO SUCH GRADE');
END IF;
END;
/

--EX2 The following PL/SQL block traces the control flow in a simple LOOP construct.
SET SERVEROUTPUT ON
DECLARE 
    x NUMBER := 0;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('INSIDE LOOP: X = '|| TO_CHAR(x));
        x := x + 1;
        IF X > 3 THEN 
            EXIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('AFTER LOOP: X = '|| TO_CHAR(X));
END;
/

--EX3 The following PL/SQL block traces the control flow in a while LOOP.
SET SERVEROUTPUT ON
DECLARE X NUMBER := 0;
BEGIN
    WHILE X < 4 LOOP
            DBMS_OUTPUT.PUT_LINE('INSIDE LOOP: X = '|| TO_CHAR(X));
            X := X + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('AFTER LOOP: X = '|| TO_CHAR(X));
END;
/

--EX3 The following PL/SQL block traces the control flow in a FOR LOOP
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('LOWER BOUND < UPPER BOUND');
    FOR I IN 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('LOWER BOUND = UPPER BOUND');
    FOR I IN 2..2 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('LOWER BOUND > UPPER BOUND');
    FOR I IN 3..1 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('UPPER BOUND TO LOWER BOUND');
    FOR I IN REVERSE 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

--EX4 A PL/SQL block to check whether a given number is prime number
SET SERVEROUTPUT ON
DECLARE 
    P VARCHAR2(30);
    N PLS_INTEGER := 36; --37
BEGIN
    FOR J IN 2..ROUND(SQRT(N)) LOOP
        IF N MOD J = 0 THEN
            P := ' IS NOT A PRIME NUMBER';
            GOTO PRINT_NOW;
        END IF;
    END LOOP;
    P := ' IS A PRIME NUMBER';
<<PRINT_NOW>>
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(N) || P);
END;
/

/*EX5 Update all accounts with balance less than 0 to 0 in account(account_number,
balance) table, populated with {(1, 100); (2, 3000); (3, 500)} */

CREATE TABLE ACCO(ACCNO NUMBER PRIMARY KEY, BALANCE NUMERIC(8, 2));
INSERT INTO ACCO VALUES(001, 100);
INSERT INTO ACCO VALUES(002, 3000);
INSERT INTO ACCO VALUES(003, 500);

SET SERVEROUTPUT ON
DECLARE 
    B NUMBER;
BEGIN 
    SELECT COUNT(BALANCE) INTO B FROM ACCO WHERE BALANCE < 0;
    IF B = 0 THEN RAISE NO_DATA_FOUND;
    END IF;
    UPDATE ACCO SET BALANCE = 0 WHERE BALANCE < 0;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO ROWS FOUND');
END;
/

/*EX6 Validate the resultant balance before supporting withdrawal of money from
the account table such that a min. of 500 is maintained.*/
DECLARE 
    INSUF_BAL EXCEPTION;
    AMT ACCO.BALANCE%TYPE;
    BAL ACCO.BALANCE%TYPE;
    ANO ACCO.ACCNO%TYPE;
BEGIN
    ANO := &NUMBER;
    AMT := &AMOUNT;
    SELECT BALANCE INTO BAL FROM ACCO WHERE ACCNO = ANO;
    BAL := BAL - AMT;
    IF BAL >= 500 THEN
        UPDATE ACCO SET BALANCE = BAL WHERE ACCNO = ANO;
        ELSE RAISE INSUF_BAL;
    END IF;
EXCEPTION
    WHEN INSUF_BAL THEN DBMS_OUTPUT.PUT_LINE('INSUFFICIENT BALANCE');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('ERROR');
END;
/

------------------------------------------------------------------EXERCISES-------------------------------------------------------------------------
CREATE TABLE STUD (RNO NUMBER PRIMARY KEY, GPA NUMERIC(2, 1));
INSERT INTO STUD VALUES(1, 5.8);
INSERT INTO STUD VALUES(2, 6.5);
INSERT INTO STUD VALUES(3, 3.4);
INSERT INTO STUD VALUES(4, 7.8);
INSERT INTO STUD VALUES(5, 9.5);

select * from stud;
--1. Write a PL/SQL block to display the GPA of given student.
SET SERVEROUTPUT ON;
DECLARE 
    ROLL STUD.RNO%TYPE;
    GPA STUD.GPA%TYPE;
BEGIN
    ROLL := :ROLLNO;
    SELECT GPA INTO GPA FROM STUD WHERE ROLL = RNO;
    DBMS_OUTPUT.PUT_LINE('GPA OF '|| TO_CHAR(ROLL) || ' IS '|| TO_CHAR(GPA));
END;
/

--2. Write a PL/SQL block to display the letter grade(0-4: F; 4-5: E; 5-6: D; 6-7: C; 7-8: B; 8-9: A; 9-10: A+) of given student. 
SET SERVEROUTPUT ON;
DECLARE 
    ROLL STUD.RNO%TYPE;
    GPA STUD.GPA%TYPE;
    GRADE CHAR(2);
BEGIN
    ROLL := :ROLLNO;
    SELECT GPA INTO GPA FROM STUD WHERE ROLL = RNO;
    IF GPA >= 0 AND GPA < 4 THEN
        GRADE := 'F';
    ELSIF GPA >= 4 AND GPA < 5 THEN
        GRADE := 'E';
    ELSIF GPA >= 5 AND GPA < 6 THEN 
        GRADE := 'D';
    ELSIF GPA >= 6 AND GPA < 7 THEN
        GRADE := 'C';
    ELSIF GPA >= 7 AND GPA < 8 THEN
        GRADE := 'B';
    ELSIF GPA >= 8 AND GPA < 9 THEN
        GRADE := 'A';
    ELSE GRADE := 'A+';
END IF;
DBMS_OUTPUT.PUT_LINE('Roll number: ' || ROLL || ' Grade: ' || GRADE);
END;
/

SELECT SYSDATE FROM DUAL;
--3. Input the date of issue and date of return for a book. Calculate and display the fine with the appropriate message 
--using a PL/SQL block. The fine is charged as (7 days: NIL; 8 - 15 days: Rs. 1/day; 16-30 days: Rs. 2/day; After 30 days: Rs. 5) 
SET SERVEROUTPUT ON;
DECLARE 
    DOI DATE;
    DOR DATE;
    LATE NUMBER;
    FINE NUMBER;
BEGIN
    DOI := :DATEOFISSUE;
    DOR := :DATEOFRETURN;
    LATE := DOR-DOI;
    --DBMS_OUTPUT.PUT_LINE('ISSUE: '||TO_CHAR(DOI) || ' RETURN: ' || TO_CHAR(DOR) || ' LATE: ' || LATE);

    IF LATE <= 7 THEN
        FINE := 0;
    ELSIF LATE >= 8 AND LATE < 16 THEN
        FINE := LATE * 1;
    ELSIF LATE >= 16 AND LATE < 30 THEN
        FINE := LATE * 2;
    ELSE FINE := 5;
    END IF;

    dbms_output.put_line('ISSUE: ' || TO_CHAR(DOI) || ' RETURN: ' || TO_CHAR(DOR) || ' LATE DAYS: ' || LATE || ' FINE: ' || FINE);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO DATA');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR OCCURRED');
END;
/

--4. Write a PL/SQL block to print the letter grade of all the students(RollNo: 1 - 5)
SET SERVEROUTPUT ON;
DECLARE
    ROLL STUD.RNO%TYPE;
    GPA STUD.GPA%TYPE;
    GRADE CHAR(2);
BEGIN
    ROLL := 1;
    LOOP
        SELECT GPA INTO GPA FROM STUD WHERE RNO = ROLL;
        
        IF GPA >= 0 AND GPA < 4 THEN
            GRADE := 'F';
        ELSIF GPA >= 4 AND GPA < 5 THEN
            GRADE := 'E';
        ELSIF GPA >= 5 AND GPA < 6 THEN 
            GRADE := 'D';
        ELSIF GPA >= 6 AND GPA < 7 THEN
            GRADE := 'C';
        ELSIF GPA >= 7 AND GPA < 8 THEN
            GRADE := 'B';
        ELSIF GPA >= 8 AND GPA < 9 THEN
            GRADE := 'A';
        ELSE 
            GRADE := 'A+';
        END IF;

        DBMS_OUTPUT.PUT_LINE('ROLL NO.: '||ROLL || ' GPA: ' || GPA || ' GRADE: ' || GRADE);
        ROLL := ROLL + 1;
        IF ROLL > 5 THEN 
            EXIT;
        END IF;
    END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO STUDENT WITH ROLL NUMBER ' || ROLL);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR OCCURRED');
END;
/

--5. Alter StudentTable by appending an additional column LetterGrade Varchar2(2). 
-- Then write a PL/SQL block  to update the table with letter grade of each student.

ALTER TABLE STUD ADD LETTERGRADE VARCHAR(2);

SET SERVEROUTPUT ON;
DECLARE 
    ROLL STUD.RNO%TYPE;
    GPA STUD.GPA%TYPE;
    GRADE STUD.LETTERGRADE%TYPE;
BEGIN
    ROLL := 1;
    WHILE ROLL <= 5 LOOP
        SELECT GPA INTO GPA FROM STUD WHERE RNO = ROLL;

        IF GPA >= 9 THEN
            GRADE := 'A';
        ELSIF GPA >= 7 THEN
            GRADE := 'B';
        ELSIF GPA >= 5 THEN
            GRADE := 'C';
        ELSE GRADE := 'D';
        END IF;
        UPDATE STUD SET LETTERGRADE = GRADE WHERE RNO = ROLL;
        ROLL := ROLL + 1;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('LETTER GRADES UPDATED SUCCESSFULLY');
END;
/
