/* Statement & Row Level Triggers */

/* we can define the trigger to execute on :
1. each row
2. on statement only (by default)
*/

create or replace trigger before_statement_emp_cpy
before insert or update
on employees_copy
begin
    dbms_output.put_line('Before Statement Trigger is Fired!.');
end;
/

create or replace trigger after_statement_emp_cpy
after insert or update
on employees_copy
begin
    dbms_output.put_line('After Statement Trigger is Fired!.');
end;
/


create or replace trigger before_row_emp_cpy
before insert or update
on employees_copy
for each row
begin
    dbms_output.put_line('Before row trigger is fired!');
end;
/

create or replace trigger after_row_emp_cpy
after insert or update
on employees_copy
for each row
begin
    dbms_output.put_line('After row trigger is fired!');
end;
/


/* DEMO */
update employees_copy set salary=salary + 100
where employee_id = 100;
/

update employees_copy set salary=salary + 100
where employee_id = 99; 


update employees_copy set salary=salary + 100
where department_id = 30; 



