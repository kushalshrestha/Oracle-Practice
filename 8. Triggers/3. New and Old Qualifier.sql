/* New and Old Qualifiers */
/*
!!! Used only with row level triggers
!!! Q. Can the qualifiers new and old work on both before and after triggers?
- Yes, on both. Oracle makes the calculation before rollout. So even before will have old and new values.

!!! NEW and OLD is not available in Statement level. Gives compilation error.
*/

-- First let's disable all trigger 
alter table employees_copy disable all triggers;
/

create or replace trigger before_row_emp_cpy
before insert or update
on employees_copy
for each row
begin
    dbms_output.put_line('Before row trigger is fired!');
    dbms_output.put_line('The Salary of Employee id: ' || :old.employee_id || ' was : ' || :old.salary || ' and now: ' || :new.salary);
end;
/

update employees_copy
set salary = salary + 100
where department_id = 20;



/* Adding trigger for delete */
create or replace trigger before_row_emp_cpy
before insert or update or delete
on employees_copy
for each row
begin
    dbms_output.put_line('Before row trigger is fired!');
    dbms_output.put_line('The Salary of Employee id: ' || :old.employee_id || ' was : ' || :old.salary || ' and now: ' || :new.salary);
end;
/


delete from employees_copy;
/

/* If you want to use referencing 
referencing should be done before for each row
*/
create or replace trigger before_row_emp_cpy 
before insert or update or delete on employees_copy 
referencing old as O new as N 
for each row
begin
  dbms_output.put_line('Before Row Trigger is Fired!.');
  dbms_output.put_line('The Salary of Employee '||:o.employee_id
    ||' -> Before:'|| :o.salary||' After:'||:n.salary);
end;