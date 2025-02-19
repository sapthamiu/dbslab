--q3
SET SERVEROUTPUT ON;

DECLARE
	
	doi date;
	dor date;
	late NUMBER;
	fine number;
	
BEGIN
	doi:= TO_DATE('&date_of_issue', 'DD-MM-YYYY');
	dor:= TO_DATE('&date_of_return', 'DD-MM-YYYY');
	late:= dor-doi;
	dbms_output.put_line('issue: ' || to_char(doi) || '  return: ' || to_char(dor) ||'  Late: ' ||late );
	IF late <= 7 THEN
		fine:=0;
	ELSIF late >= 8 and late < 16 THEN
		fine:= late*1;
	ELSIF late >= 16 and late < 30 THEN
		fine:= late*2;
	ELSE
		fine:= late*5;
	END IF;

	dbms_output.put_line('issue: ' || to_char(doi) || '  return: ' || to_char(dor) ||'  late days: ' ||late || '  Fine: ' || fine);
	
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		dbms_output.put_line('no data');
	WHEN OTHERS THEN
		dbms_output.put_line('Error occured');
	
END;
/