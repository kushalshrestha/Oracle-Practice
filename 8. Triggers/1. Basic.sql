/* TRIGGER */


create or replace trigger first_trigger
before insert or update 
on employees_copy
begin
    dbms_output.put_line('An insert or update occurred in the employees table');
end;
/

update employees_copy set salary = salary + 100;

delete from employees_copy;

-- don't forget to rollback
/