--q4

SET SERVEROUTPUT ON;

DECLARE
	
	rl studen.roll%TYPE;
	g studen.gpa%TYPE;
	grade CHAR(2);
	
BEGIN
	FOR i IN (SELECT roll, gpa FROM studen) LOOP
		rl:= i.roll;
		g:= i.gpa;
		IF g >=0 AND g<4 THEN 
			grade:='F';
		ELSIF g >=4 AND g<5 THEN 
			grade:='E';
		ELSIF g >=5 AND g<6 THEN 
			grade:='D';
		ELSIF g >=6 AND g<7 THEN 
			grade:='C';
		ELSIF g >=7 AND g<8 THEN 
			grade:='B';
		ELSIF g >=8 AND g<9 THEN 
			grade:='A';
		ELSE 
			grade:='A+';
		END IF;

		dbms_output.put_line('Roll number :' || rl || '     GPA: ' || g ||'     Grade: ' || grade);
	END LOOP;
		
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('No student with roll number '|| rl);
	WHEN OTHERS THEN
		dbms_output.put_line('Error occured');
	
END;
/