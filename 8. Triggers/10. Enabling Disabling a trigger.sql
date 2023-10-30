/* Creating a disabled triggers

Trigger Status are of 4 types:
    1. Valid - no problem 
    2. Invalid - problem, prevent the DML operations on your table. So this must be validated as soon as possible
    3. Enabled
    4. Disabled - does now work, but this does not prevent the user's job because users can do the DML operations even if the triggers are disabled
        - We might need to disable it sometimes in scenarios like increasing copy table performance

*/



create or replace trigger prevent_high_salary
before insert or update of salary on employees_copy 
for each row
disable -- just add this
when (new.salary > 50000)
begin
  raise_application_error(-20006,'A salary cannot be higher than 50000!.');
end;

/


/* Enabling a trigger*/
create or replace trigger prevent_high_salary
before insert or update of salary on employees_copy 
for each row
enable -- just add this
when (new.salary > 50000)
begin
  raise_application_error(-20006,'A salary cannot be higher than 50000!.');
end;



