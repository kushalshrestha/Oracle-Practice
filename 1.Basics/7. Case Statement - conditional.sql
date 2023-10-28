/* Control Structures */
-- IF ELSIF ELSE
DECLARE
    v_number NUMBER := 22;
    v_name   VARCHAR2(30) := 'Messi';
BEGIN
    IF v_number > 30 OR v_name = 'Kushal' THEN
        dbms_output.put_line('I am greater than 30');
    ELSIF
        v_number > 25
        AND v_name = 'Haaland'
    THEN
        dbms_output.put_line('I am greater than 25');
    ELSIF v_number > 20 THEN
        dbms_output.put_line('I am greater than 20');
    ELSE
        IF v_number IS NULL THEN
            dbms_output.put_line('The number is null...');
        ELSE
            dbms_output.put_line('No criteria matched i.e <= 20 case');
        END IF;
    END IF;
END;
/

-- CASE EXPRESSION & CASE STATEMENT
--

set serveroutput on;

DECLARE
    v_job_code        VARCHAR2(10) := 'SA_MAN';
    v_salary_increase NUMBER;
BEGIN
    v_salary_increase :=
        CASE v_job_code
            WHEN 'SA_MAN' THEN
                0.2
            WHEN 'SA_REP' THEN
                0.3
            ELSE 0
        END;

    dbms_output.put_line('Your salary increase is : ' || v_salary_increase);
END;
/

-- another way for case

set serveroutput on;

DECLARE
    v_job_code        VARCHAR2(10) := 'SA_MAN';
    v_salary_increase NUMBER;
BEGIN
    v_salary_increase :=
        CASE
            WHEN v_job_code = 'SA_MAN' THEN
                0.2
            WHEN v_job_code in ('SA_REP', 'IT_PROG') THEN
                0.3
            ELSE 0
        END;

    dbms_output.put_line('Your salary increase is : ' || v_salary_increase);
END;