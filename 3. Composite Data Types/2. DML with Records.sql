/* DML Operations with Records */

create table retired_employees as 
select * from employees where 1=2;

select * from retired_employees;

/

/* Let's try INSERT */

declare
    r_emp employees%rowtype;
begin
    select * 
    into r_emp 
    from employees
    where employee_id=104;
    
    insert into retired_employees
    values r_emp;
    
    -- Select data from the retired_employees table
    -- you cannot use select * from retired_employees
    FOR retired_employee IN (SELECT * FROM retired_employees) LOOP
        -- You can print the selected data here, or perform any other operations
        DBMS_OUTPUT.PUT_LINE('Retired Employee: ' || retired_employee.employee_id || ' ' || retired_employee.first_name || ' ' || retired_employee.last_name);
    END LOOP;

end;   

/

/* Let's try UPDATE */
declare
    r_emp employees%rowtype;
begin
    select * 
    into r_emp 
    from employees
    where employee_id=104;
    
    r_emp.salary := 0;
    r_emp.commission_pct := 0;
    
    update retired_employees
    set row = r_emp 
    where employee_id=104;
    
    
    -- Select data from the retired_employees table
    FOR retired_employee IN (SELECT * FROM retired_employees) LOOP
        -- You can print the selected data here, or perform any other operations
        DBMS_OUTPUT.PUT_LINE('Retired Employee: ' || retired_employee.employee_id || ' ' || retired_employee.first_name || ' ' || retired_employee.last_name || ', Salary ' ||
        retired_employee.salary || ', and Commission pct: ' || retired_employee.commission_pct);
    END LOOP;

end;   

/


/* 
Q. Can we do DELETE Operation?
- No, actually we can, but not directly like insert or update. 
We need to use a where clause and say that a column is equal to our record
*/

