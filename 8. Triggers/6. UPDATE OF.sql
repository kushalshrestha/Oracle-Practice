/* Using UPDATE OF event in Triggers */
/*
Sometimes you may not care about all the updates but only specific columns(one or more). we can do like creating if condition in normal triggers,
but it makes the performance decrease since the triggers are called every time even though the condition is not satisfied. 
So, we come up with UPDATE OF trigger
*/

create or replace trigger prevent_updates_of_constant_columns
before update of hire_date,salary 
on employees_copy 
for each row
begin
  raise_application_error(-20005,'You cannot modify the hire_date and salary columns');
end;
/


update employees_copy set hire_date = sysdate;

update employees_copy set salary = 2000;