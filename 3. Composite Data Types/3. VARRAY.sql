/* VARRAYS */

/**************** A Simple Working Example ******************/
declare
    type e_list is varray(5) of varchar2(50);
    employees e_list;
begin
    
    employees := e_list('Alex', 'Bruce', 'John', 'Bob', 'Richard');
    
    for i in 1..5 loop
        dbms_output.put_line(employees(i));
    end loop;
end;
/

declare
    type e_list is varray(5) of varchar2(50);
    employees e_list;
begin
    employees := e_list('Alex', 'Bruce', 'John', 'Bob', 'Richard');
    for i in 1..employees.count() loop
       dbms_output.put_line(employees(i));
    end loop;
end; 
/



declare
    type e_list is varray(5) of varchar2(50);
    employees e_list;
begin
    employees := e_list('Alex', 'Bruce', 'John', 'Bob', 'Richard');
    for i in employees.first()..employees.last() loop
       dbms_output.put_line(employees(i));
    end loop;
end; 
/


/* using exists() method */

declare
    type e_list is varray(5) of varchar2(50);
    employees e_list;
begin
    employees := e_list('Alex', 'Bruce', 'John', 'Bob', 'Richard');
    for i in 1..5 loop
        if employees.exists(i) then 
            dbms_output.put_line(employees(i));
        end if;    
    end loop;
end; 
/

/****** A Create-Declare at the Same Time Error Example *****/
/****************  AND A Working limit() Example *****************/
/* initialization in declare block*/
declare
    type e_list is varray(5) of varchar2(50);
    employees e_list := e_list('Alex', 'Bruce', 'John', 'Bob', 'Richard');
begin
                dbms_output.put_line(employees.limit());
end; 
/

/************** A Post Insert Varray Example ****************/
DECLARE
    TYPE e_list IS VARRAY(5) OF VARCHAR(50);
    employees e_list := e_list(); 
    idx NUMBER := 1;
    
BEGIN

    FOR i IN 100..110 LOOP
        employees.extend;
        
        SELECT first_name INTO employees(idx) 
        FROM employees 
        WHERE employee_id = i;
        
        idx := idx + 1;
    end loop;

    FOR i IN 1..employees.count() LOOP
        dbms_output.put_line(employees(i));
    END LOOP;    
END; 
/

/******* An Example for the Schema-Level Varray Types *******/
/* creating varray type in db and using it */
create or replace type e_list is varray(15) of varchar2(20) -- might need to create from administrator
/

DECLARE
    employees e_list := e_list(); 
    idx NUMBER := 1;
    
BEGIN

    FOR i IN 100..110 LOOP
        employees.extend;
        
        SELECT first_name INTO employees(idx) 
        FROM employees 
        WHERE employee_id = i;
        
        idx := idx + 1;
    end loop;

    FOR i IN 1..employees.count() LOOP
        dbms_output.put_line(employees(i));
    END LOOP;    
END; 
/



