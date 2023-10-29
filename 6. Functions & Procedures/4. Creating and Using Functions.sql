/* FUNCTIONS */
/*
Difference with Stored Procedures : Function must return a value.
- Function does not need to have OUT parameter since they return some value "but it can also have OUT"
    i.e we can still use IN, OUT modes. but not recommended to use OUT mode b/c only one value should return from function for better approach
    - if you need multiple values -> use record or PL/SQL table

FUNCTIONS can be used in:
 - SELECT clause
 - GROUP BY clause
 - HAVING clause
 - ORDER BY clause
 - VALUES clause - in insert 
 - CONNECT BY clause
 - START WITH clause
 - SET clause - in update
 
RESTRICTIONS OF USING FUNCTIONS IN SQL EXPRESSIONS
* Must be compiled and stored in the database.
* Your functions should not have an OUT parameter
* Must return a valid type of the SQL Data Types
* !!! You cannot call a function that contains a DML Statement within an SQL query 
    i.e if your function is updating or deleting something, you cannot use it within an SQL query
* Cannot include COMMIT, ROLLBACK or DDL Statements.
* !!!! If the function has DML operation of the specified table. 
    i.e SELECT, UPDATE, DELETE statements, you cannot use that function within an UPDATE or DELETE statements of that table
    Eg: if you function has a DELETE or UPDATE statement of the table X, or a SELECT query of the table X, you cannot call that function 
    within a query that has an UPDATE or DELETE command of the table X
*/

CREATE OR REPLACE FUNCTION get_avg_sal (
    p_dept_id departments.department_id%TYPE
) RETURN NUMBER AS
    v_avg_sal NUMBER;
BEGIN
    SELECT
        AVG(salary)
    INTO v_avg_sal
    FROM
        employees
    WHERE
        department_id = p_dept_id;

    RETURN v_avg_sal;
END get_avg_sal;
----------------- using a function in begin-end block
DECLARE
    v_avg_salary NUMBER;
BEGIN
    v_avg_salary := get_avg_sal(50);
    dbms_output.put_line(v_avg_salary);
END;
----------------- using functions in a select clause
SELECT
    employee_id,
    first_name,
    salary,
    department_id,
    get_avg_sal(department_id) avg_sal
FROM
    employees;
----------------- using functions in group by, order by, where clauses 
SELECT
    get_avg_sal(department_id)
FROM
    employees
WHERE
    salary > get_avg_sal(department_id)
GROUP BY
    get_avg_sal(department_id)
ORDER BY
    get_avg_sal(department_id);
----------------- dropping a function
DROP FUNCTION get_avg_sal;