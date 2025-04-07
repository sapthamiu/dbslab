--EX1  A PL/SQL block to delete the student records of History 
--Department in University database. Use implicit cursor attributes 
--to check the success of delete operation.
SET SERVEROUTPUT ON;
DECLARE 
    DNAME CONSTANT STUDENT.DEPT_NAME%TYPE := 'History';
BEGIN
    DELETE FROM STUDENT WHERE DEPT_NAME = DNAME;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('DELETED STUDENTS FROM '|| DNAME || ' DEPT');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('NO STUDENTS OF ' || DNAME || ' DEPT');
    END IF;
END;
/

--EX2 A PL/SQL block to list the student names of ‘Comp. Sci.’ 
--department in University database. 
SET SERVEROUTPUT ON;
DECLARE
    DNAME CONSTANT STUDENT.DEPT_NAME%TYPE := 'Comp. Sci.';
    CURSOR C1 IS
        SELECT NAME FROM STUDENT WHERE DEPT_NAME = DNAME;
    SNAME STUDENT.NAME%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------');
    OPEN C1;
    LOOP 
        FETCH C1 INTO SNAME;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('NAME: ' || SNAME);
    END LOOP;
    CLOSE C1;
    DBMS_OUTPUT.PUT_LINE('-----------');
END;
/

--EX3 A PL/SQL block to find the department having maximum Budget in   
--University database, without using max() aggregate function. 
SET SERVEROUTPUT ON;
DECLARE 
    CURSOR C1 IS 
        SELECT * FROM Department;
    VBUDGET DEPARTMENT.BUDGET%TYPE := 0;
    VDNAME DEPARTMENT.DEPT_NAME%TYPE;
BEGIN
    FOR DEPT IN C1 LOOP
        IF DEPT.BUDGET > VBUDGET THEN
            VBUDGET := DEPT.BUDGET;
            VDNAME := DEPT.DEPT_NAME;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('MAX BUDGET: ' || VBUDGET || ' DEPT: ' || VDNAME);
    END;
    /

--EX4 A PL/SQL block to increase the Budget of different departments 
--in University database based upon current Budget.  Increase the budget 
--by 10%, 15% or 20% for the ranges ‘greater than 100000’, ‘between 
--70000 and 100000’ or ‘less than or equal to 70000’, respectively.
SET SERVEROUTPUT ON;
DECLARE 
    CURSOR C1 IS 
        SELECT * FROM DEPARTMENT FOR UPDATE;
BEGIN
    FOR DEPT IN C1 LOOP
        IF DEPT.BUDGET <= 70000 THEN
            UPDATE DEPARTMENT SET BUDGET = BUDGET * 1.2 WHERE CURRENT OF C1;
        ELSIF DEPT.BUDGET > 7000 AND DEPT.BUDGET <= 100000 THEN
            UPDATE DEPARTMENT SET BUDGET = BUDGET * 1.15 WHERE CURRENT OF C1;
        ELSE
            UPDATE DEPARTMENT SET BUDGET = BUDGET * 1.1 WHERE CURRENT OF C1;
        END IF;
    END LOOP;
END;
/

--EX5 Based on the University database schema, the following example 
--uses a parametrized cursor on the Instructor  table to display the 
--instructors of given department. 
SET SERVEROUTPUT ON;
DECLARE 
    CURSOR C1(DNAME INSTRUCTOR.DEPT_NAME%TYPE) IS
        SELECT * FROM INSTRUCTOR WHERE DEPT_NAME = DNAME;
BEGIN
    FOR TEMP IN C1('Comp. Sci.') LOOP
        DBMS_OUTPUT.PUT_LINE('EMPNO: ' || TEMP.ID);
        DBMS_OUTPUT.PUT_LINE('EMPNAME: '|| TEMP.NAME);
        DBMS_OUTPUT.PUT_LINE('EMPDEPT: '|| TEMP.DEPT_NAME);
        DBMS_OUTPUT.PUT_LINE('EMPSALARY: '||TEMP.SALARY);
        DBMS_OUTPUT.PUT_LINE('----------');
    END LOOP;
END;
/


--EX6 Consider account (account_number, balance) table, populated with 
--{(1, 200); (2, 3000); (3, 500)}. Withdraw an amount 200 and deposit 
--1000 for all the accounts. If the sum of all account balance exceeds 
--5000 then undo the deposit just made.

SET SERVEROUTPUT ON;
DECLARE 
    TOTBAL ACCO.BALANCE%TYPE;
BEGIN
    UPDATE ACCO SET BALANCE = BALANCE - 200;
    SAVEPOINT DEPOSIT;
    UPDATE ACCO SET BALANCE = BALANCE + 1000;
    SELECT SUM(BALANCE) INTO TOTBAL FROM ACCO;
    IF TOTBAL > 5000 THEN
        ROLLBACK TO SAVEPOINT DEPOSIT;
    END IF;
    COMMIT;
END;
/

--1. The HRD manager has decided to raise the salary of all the 
--Instructors in a given department number by 5%. Whenever, any such 
--raise is given to the instructor, a record for the same is maintained 
--in the salary_raise table. It includes the Instuctor Id, the date when
--the raise was given and the actual raise amount. Write a PL/SQL block 
--to update the salary of each Instructor and insert a record in the 
--salary_raise table.  
--salary_raise(Instructor_Id, Raise_date, Raise_amt)

CREATE TABLE SALRAISE  (INSID NUMBER, 
                        RAISEDATE DATE,
                        RAISEAMT NUMERIC(8, 2));
SET SERVEROUTPUT ON;
DECLARE
    CURSOR C1(DNAME INSTRUCTOR.DEPT_NAME%TYPE) IS
        SELECT * FROM INSTRUCTOR WHERE DEPT_NAME = DNAME;
    DEPT INSTRUCTOR.DEPT_NAME%TYPE;
BEGIN
    DEPT := '&DEPARTMENT';
    FOR INST IN C1(DEPT) LOOP
        UPDATE INSTRUCTOR SET SALARY = SALARY * 1.05 WHERE INST.ID = INSTRUCTOR.ID;
        INSERT INTO SALRAISE VALUES(INST.ID, SYSDATE, INST.SALARY * 0.05);
    END LOOP;
END;
/