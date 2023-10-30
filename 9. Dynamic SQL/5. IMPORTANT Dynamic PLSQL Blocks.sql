/* Dynamic PL/SQL block
-- but avoid using this approach. Use other methods
*/

BEGIN
    FOR r_emp in (SELECT * FROM employees) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
    END LOOP;
END;
/
DECLARE
    v_dynamic_text varchar2(1000);
BEGIN
    v_dynamic_text := q'[BEGIN
    FOR r_emp in (SELECT * FROM employees) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
    END LOOP;
    END;]';
    EXECUTE IMMEDIATE v_dynamic_text;
END;
/

-- you cannot access the variable in this case
DECLARE
    v_dynamic_text VARCHAR2(1000);
    v_department_id PLS_INTEGER := 30;
BEGIN
    v_dynamic_text := q'[BEGIN
    FOR r_emp in (SELECT * FROM employees WHERE department_id = v_department_id) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
    END LOOP;
    END;]';
    EXECUTE IMMEDIATE v_dynamic_text;
END;
/
-- but if you declare it inside it can execute
DECLARE
    v_dynamic_text VARCHAR2(1000);
    --v_department_id pls_integer := 30;
BEGIN
    v_dynamic_text := q'[DECLARE
    v_department_id pls_integer := 30;
    BEGIN
    FOR r_emp in (SELECT * FROM employees WHERE department_id = v_department_id) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
    END LOOP;
    END;]';
    EXECUTE IMMEDIATE v_dynamic_text;
END;
/

-- now let's declare the variable in a package (global)

CREATE OR REPLACE PACKAGE pkg_temp AS
v_department_id_pkg PLS_INTEGER := 50;
END;
/

-- now it gets executed
DECLARE
    v_dynamic_text VARCHAR2(1000);
    --v_department_id pls_integer := 30;
BEGIN
    v_dynamic_text := q'[BEGIN
    FOR r_emp in (SELECT * FROM employees WHERE department_id = pkg_temp.v_department_id_pkg) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
    END LOOP;
    END;]';
    EXECUTE IMMEDIATE v_dynamic_text;
END;
/
-- now how do we get the local variable accessible?

-- by 'USING' clause
DECLARE
    v_dynamic_text VARCHAR2(1000);
    v_department_id PLS_INTEGER := 30;
BEGIN
    v_dynamic_text := q'[BEGIN
    FOR r_emp in (SELECT * FROM employees WHERE department_id = :1) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
    END LOOP;
    END;]';
    EXECUTE IMMEDIATE v_dynamic_text USING v_department_id;
END;
/


-- we got both sent and got back values using the bind arguments into our EXECUTE
DECLARE
    v_dynamic_text VARCHAR2(1000);
    v_department_id PLS_INTEGER := 30;
    v_max_salary PLS_INTEGER := 0;
BEGIN
    v_dynamic_text := q'[BEGIN
    FOR r_emp in (SELECT * FROM employees WHERE department_id = :1) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
        if r_emp.salary > :2 then
            :2 := r_emp.salary;
        end if;
    END LOOP;
    END;]';
    EXECUTE IMMEDIATE v_dynamic_text USING v_department_id, IN OUT v_max_salary;
    dbms_output.put_line('The maximum salary of this department is : '||v_max_salary);
END;
/

--!!!! Handling exception in Dynamic block
DECLARE
    v_dynamic_text VARCHAR2(1000);
    v_department_id PLS_INTEGER := 30;
    v_max_salary PLS_INTEGER := 0;
BEGIN
    v_dynamic_text := q'[BEGIN
    FOR r_emp in (SELECT * FROM employeese WHERE department_id = :1) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
        if r_emp.salary > :sal then
            :sal := r_emp.salary;
        end if;
    END LOOP;
    END;]';
    EXECUTE IMMEDIATE v_dynamic_text USING v_department_id, IN OUT v_max_salary;
    dbms_output.put_line('The maximum salary of this department is : '||v_max_salary);
EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line('The error is : '||sqlerrm);
END;
/
DECLARE
    v_dynamic_text VARCHAR2(1000);
    v_department_id PLS_INTEGER := 30;
    v_max_salary PLS_INTEGER := 0;
BEGIN
    v_dynamic_text := q'[BEGIN
    FOR r_emp in (SELECT * FROM employeeseasdvasda WHERE department_id = :1) LOOP
        dbms_output.put_line(r_emp.first_name||' '||r_emp.last_name);
        if r_emp.salary > :sal then
            :sal := r_emp.salary;
        end if;
    END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    dbms_output.put_line('The error is : '||SQLERRM);
    END;]';
    EXECUTE IMMEDIATE v_dynamic_text USING v_department_id, IN OUT v_max_salary;
    dbms_output.put_line('The maximum salary of this department is : '||v_max_salary);
END;
/
DROP PACKAGE pkg_temp;