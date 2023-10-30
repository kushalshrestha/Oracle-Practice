/* OPEN-FOR, FETCH Statements 
- to run dynamic SQL Queries for multiple row queries

Oracle enhanced this feature to run dynamic SQL queries, especially for multiple row queries.

Because using the DBMS_SQL package needs lots of effort to implement multi-row queries like parsing,

binding and defining each column individually and executing, fetching and extracting each column individually,

etc..
*/

DECLARE
  TYPE emp_cur_type  IS REF CURSOR;
  emp_cursor      emp_cur_type; -- variable of ref cursor
  emp_record      employees%rowtype;
BEGIN
  OPEN emp_cursor FOR 'SELECT * FROM employees WHERE job_id = ''IT_PROG''';
    FETCH emp_cursor INTO emp_record;
    dbms_output.put_line(emp_record.first_name||emp_record.last_name);
  CLOSE emp_cursor;
END;
/

-- now bind variables in OPEN-FOR FETCH CLOSE
DECLARE
  TYPE emp_cur_type  IS REF CURSOR;
  emp_cursor      emp_cur_type;
  emp_record      employees%rowtype;
BEGIN
  OPEN emp_cursor FOR 'SELECT * FROM employees WHERE job_id = :job' USING 'IT_PROG';
    FETCH emp_cursor INTO emp_record;
    dbms_output.put_line(emp_record.first_name||emp_record.last_name);
  CLOSE emp_cursor;
END;
/

-- !!!IMPORTANT now looping and fetching all
DECLARE
  TYPE emp_cur_type  IS REF CURSOR;
  emp_cursor      emp_cur_type;
  emp_record      employees%rowtype;
BEGIN
  OPEN emp_cursor FOR 'SELECT * FROM employees WHERE job_id = :job' USING 'IT_PROG';
  LOOP
    FETCH emp_cursor INTO emp_record;
    EXIT WHEN emp_cursor%notfound;
    dbms_output.put_line(emp_record.first_name||emp_record.last_name);
  END LOOP;
  CLOSE emp_cursor;
END;
/



/* !!! IMPORTANT - DYNAMIC + Any table */
DECLARE
  TYPE emp_cur_type  IS REF CURSOR;
  emp_cursor      emp_cur_type;
  emp_record      employees%rowtype;
  v_table_name    VARCHAR(20);
BEGIN
  v_table_name := 'employees';
  OPEN emp_cursor FOR 'SELECT * FROM '||v_table_name||' WHERE job_id = :job' USING 'IT_PROG';
  LOOP
    FETCH emp_cursor INTO emp_record;
    EXIT WHEN emp_cursor%notfound;
    dbms_output.put_line(emp_record.first_name||emp_record.last_name);
  END LOOP;
  CLOSE emp_cursor;
END;
