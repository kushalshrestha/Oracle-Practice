/* COMPOUND TRIGGERS */
/*

Previously, we learned BEFORE/AFTER TRIGGERS on both Row level(FOR EACH ROW) and Statement level.

COMPOUND TRIGGERS:
- a single trigger that allows us to specify actions for each DML trigger types
- So they can share the variables, types etc among each other
- We will have 
    1. Declaration Section (1 common)
    2. Optional Body Section (4 section but optional)
        Before Statement
        After Statement
        Before each row
        After each row
- Take actions for various timing points by sharing the common data (variables declared on declaration section)
- Making inserts to some other tables faster with bulk inserts
- !!!!Avoiding mutating table errors - only compound triggers can handle this

!!! We have compound triggers with views too.
    1. Initial Section
    2. Instead of Section (but not frequently used type b/c we have 'INSTEAD OF')
    
- RESTRICTIONS OF COMPOUND TRIGGER:
    - Must be a DML trigger defined on a table or view - so you cannot create compound trigger as DDL trigger or something
    - A compound trigger body cannot have an initialization block. But can have exception section. Each section can have its own exception section.
    - You cannot have common exception section
    - !!!OLD and NEW qualifiers cannot be used in the declaration or BEFORE/AFTER Statements b/c they are only for BEFORE ROW AND AFTER ROW
    - !!! The firing order of compound triggers is not guaranteed if you don't use the FOLLOWS clause.
*/



------------------ The first simple compound trigger ----------------
create or replace trigger trg_comp_emps
for insert or update or delete on employees_copy 
compound trigger
v_dml_type varchar2(10);

  before statement is
   begin
    if inserting then
      v_dml_type := 'INSERT';
    elsif updating then
      v_dml_type := 'UPDATE';
    elsif deleting then
      v_dml_type := 'DELETE';
    end if;
    dbms_output.put_line('Before statement section is executed with the '||v_dml_type ||' event!.');
  end before statement; 
  
  before each row is
  t number;
    begin
      dbms_output.put_line('Before row section is executed with the '||v_dml_type ||' event!.');
  end before each row;
  
  after each row is
    begin
      dbms_output.put_line('After row section is executed with the '||v_dml_type ||' event!.');
  end after each row;
  
  after statement is
    begin
      dbms_output.put_line('After statement section is executed with the '||v_dml_type ||' event!.');
  end after statement;
end;
/

delete from employees_copy where department_id = 30;

/*******************************************************************/

/* Better Example: a trigger that will check the salaries after the updates or inserts. If salary > 15% of avg salary of its department,
our trigger will prevent that update */


CREATE OR REPLACE TRIGGER TRG_COMP_EMPS
  FOR INSERT OR UPDATE OR DELETE ON EMPLOYEES_COPY
  COMPOUND TRIGGER
    TYPE T_AVG_DEPT_SALARIES IS TABLE OF EMPLOYEES_COPY.SALARY%TYPE INDEX BY PLS_INTEGER;
    AVG_DEPT_SALARIES T_AVG_DEPT_SALARIES;
  
  BEFORE STATEMENT IS
    BEGIN
      FOR AVG_SAL IN (SELECT AVG(SALARY) SALARY , NVL(DEPARTMENT_ID,999) DEPARTMENT_ID
                        FROM EMPLOYEES_COPY GROUP BY DEPARTMENT_ID) LOOP
        AVG_DEPT_SALARIES(AVG_SAL.DEPARTMENT_ID) := AVG_SAL.SALARY;
      END LOOP;
  END BEFORE STATEMENT;
  
  AFTER EACH ROW IS
    V_INTERVAL NUMBER := 15;
    BEGIN
       IF :NEW.SALARY > AVG_DEPT_SALARIES(:NEW.DEPARTMENT_ID) + AVG_DEPT_SALARIES(:NEW.DEPARTMENT_ID)*V_INTERVAL/100 THEN
        RAISE_APPLICATION_ERROR(-20005,'A raise cannot be '|| V_INTERVAL|| ' percent higher than
                                  its department''s average!');
       END IF;
  END AFTER EACH ROW;
  
  AFTER STATEMENT IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('All the changes are done successfully!');
  END AFTER STATEMENT;
 
END;
/

update employees_copy set salary = salary + 50000
where employee_id = 154;