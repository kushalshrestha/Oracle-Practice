/* Handling & Raising User-Defined Exceptions */
/*
- When needed to handle some exceptions about our business

How to handle it?
- 1. Specify a user-defined exception  | SYNTAX: <exception_name> exception
- 2. Then raise it explicitly wherever you need | SYNTAX: RAISE <exception_name>

"You can raise Predefined, Non predefined, User defined exceptions with RAISE statement"
*/
/*************** Creating a User defined Exception *****************/
DECLARE
    too_high_salary EXCEPTION;
    v_salary_check PLS_INTEGER;
BEGIN
    SELECT
        salary
    INTO v_salary_check
    FROM
        employees
    WHERE
        employee_id = 100;

    IF v_salary_check > 20000 THEN
        RAISE too_high_salary;
    END IF;
  --we do our business if the salary is under 2000
    dbms_output.put_line('The salary is in an acceptable range');
EXCEPTION
    WHEN too_high_salary THEN
        dbms_output.put_line('This salary is too high. You need to decrease it.');
END;
/**************** Raising a Predefined Exception *******************/
DECLARE
    too_high_salary EXCEPTION;
    v_salary_check PLS_INTEGER;
BEGIN
    SELECT
        salary
    INTO v_salary_check
    FROM
        employees
    WHERE
        employee_id = 100;

    IF v_salary_check > 20000 THEN
        RAISE invalid_number;
    END IF;
  --we do our business if the salary is under 2000
    dbms_output.put_line('The salary is in an acceptable range');
EXCEPTION
    WHEN invalid_number THEN
        dbms_output.put_line('This salary is too high. You need to decrease it.');
END;
/****************** Raising Inside of the Exception ****************/
DECLARE
    too_high_salary EXCEPTION;
    v_salary_check PLS_INTEGER;
BEGIN
    SELECT
        salary
    INTO v_salary_check
    FROM
        employees
    WHERE
        employee_id = 100;

    IF v_salary_check > 20000 THEN
        RAISE invalid_number;
    END IF;
  --we do our business if the salary is under 2000
    dbms_output.put_line('The salary is in an acceptable range');
EXCEPTION
    WHEN invalid_number THEN
        dbms_output.put_line('This salary is too high. You need to decrease it.');
        RAISE;
END;