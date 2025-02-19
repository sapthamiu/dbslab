DECLARE
  -- Declare variables to hold the instructor details
  v_id        instructor.id%TYPE;
  v_name      instructor.name%TYPE;
  v_dept_name instructor.dept_name%TYPE;
  v_salary    instructor.salary%TYPE;
  v_count     NUMBER;  -- Variable to store the count of instructors with the same name
  
  -- Exception declarations
  e_multiple_instructors EXCEPTION;
  e_no_instructor EXCEPTION;

BEGIN

  SELECT name, id, dept_name, salary
  INTO v_name, v_id, v_dept_name, v_salary
  FROM instructor
  WHERE name = '&instructor_name';  -- Prompt for instructor name

  -- Check for multiple instructors with the same name
  SELECT COUNT(*) INTO v_count
  FROM instructor
  WHERE name = v_name;

  IF v_count > 1 THEN
    RAISE e_multiple_instructors;
  END IF;

  -- Display the details of the instructor
  DBMS_OUTPUT.PUT_LINE('Instructor ID: ' || v_id);
  DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
  DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name);
  DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
  
EXCEPTION
  -- Handle the case where no instructor with the given name is found
  WHEN NO_DATA_FOUND THEN
    RAISE e_no_instructor;
    
  -- Handle the case of multiple instructors with the same name
  WHEN e_multiple_instructors THEN
    DBMS_OUTPUT.PUT_LINE('Error: Multiple instructors found with the name ' || v_name);

  -- Handle the case where no instructor with the name is found
  WHEN e_no_instructor THEN
    DBMS_OUTPUT.PUT_LINE('Error: No instructor found with the name ' || '&instructor_name');

  -- Handle any other unexpected errors
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
