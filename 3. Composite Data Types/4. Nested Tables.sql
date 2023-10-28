/* NESTED TABLES */
/*
- Key value pairs
- 2GB atmost
- key can be only positive numbers
- In Varray once we add our values, we cannot delete them. But in nested tables we can by using their index values
- not stored consecutively
- are unbounded
*/

declare
    --type e_list is varray(5) of varchar2(50); -- similar to varray
    type e_list is table of varchar2(50);
    emps e_list;
begin
    emps := e_list('Alex', 'Kushal', 'John');
    emps.extend; -- !! This needs to extend, before adding an element
    emps(4) := 'Bob';
    
    for i in 1..emps.count() loop
        dbms_output.put_line(emps(i));
    end loop; 
end;    
/

/************************************************************
Adding a New Value to a Nested Table After the Initialization
*************************************************************/
DECLARE
  TYPE e_list IS TABLE OF VARCHAR2(50);
  emps e_list;
BEGIN
  emps := e_list('Alex','Bruce','John');
  emps.extend;
  emps(4) := 'Bob';
  FOR i IN 1..emps.count() LOOP
    dbms_output.put_line(emps(i));
  END LOOP;
END;
 
/*************** Adding Values From a Table *****************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%type;
  emps e_list := e_list();
  idx  PLS_INTEGER:= 1;
BEGIN
  FOR x IN 100 .. 110 LOOP
    emps.extend;
    SELECT first_name INTO emps(idx) 
    FROM   employees 
    WHERE  employee_id = x;
    idx := idx + 1;
  END LOOP;
  FOR i IN 1..emps.count() LOOP
    dbms_output.put_line(emps(i));
  END LOOP;
END;
 
/********************* Delete Example ***********************/
DECLARE
  TYPE e_list IS TABLE OF employees.first_name%type;
  emps e_list := e_list();
  idx  PLS_INTEGER := 1;
BEGIN
  FOR x IN 100 .. 110 LOOP
    emps.extend;
    SELECT first_name INTO emps(idx) 
    FROM   employees 
    WHERE  employee_id = x;
    idx := idx + 1;
  END LOOP;
  emps.delete(3);
  FOR i IN 1..emps.count() LOOP
    IF emps.exists(i) THEN  -- we need to add .exists(i), else gives an error - object not found
       dbms_output.put_line(emps(i));
    END IF;
  END LOOP;
END;

