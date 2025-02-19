CREATE TABLE studen (
    roll INT PRIMARY KEY,
    gpa DECIMAL(15, 2) NOT NULL
);

INSERT INTO studen (roll, gpa) VALUES(1,5.8);
INSERT INTO studen (roll, gpa) VALUES(2,6.5);
INSERT INTO studen (roll, gpa) VALUES(3,3.4);
INSERT INTO studen (roll, gpa) VALUES(4,7.8);
INSERT INTO studen (roll, gpa) VALUES(5,9.5);


SET SERVEROUTPUT ON;

DECLARE
	
	rl studen.roll%TYPE;
	g studen.gpa%TYPE;
	
BEGIN
	rl:= &roll_number;
	SELECT gpa into g FROM studen WHERE roll=rl;
	dbms_output.put_line('GPA of ' || rl || ' is : '|| g);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('No student with roll number '|| rl);
	WHEN OTHERS THEN
		dbms_output.put_line('Error occured');
	
END;
/