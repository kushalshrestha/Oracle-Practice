/* RAISE_APPLICATION_ERROR() Procedure */
/*
we use RAISE_APPLICATION_ERROR() to raise an error to other application calling the block (i.e raises the error to the caller)

SYNTAX:
    raise_application_error(error_number, error_message[, TRUE | FALSE]);  -- By default false
     - !!!! Error number must be between -20000 and -20999
     
     - ERROR STACK:
        TRUE - error gets added to the error stack. In this way, you'll see all the error that occur.
        FALSE - previous errors are deleted from this day and only this error is stored in it.

* When you raise the application error, it will cause your program to stop the execution. So we need to handle that in our application 
with and then others have an exception handler.

!!!! Error number must be between -20000 and -20999
*/




declare
too_high_salary exception;
v_salary_check pls_integer;
begin
  select salary into v_salary_check from employees where employee_id = 100;
  if v_salary_check > 20000 then
    --raise too_high_salary;
 raise_application_error(-20243,'The salary of the selected employee is too high!');
  end if;
  --we do our business if the salary is under 2000
  dbms_output.put_line('The salary is in an acceptable range');
exception
  when too_high_salary then
  dbms_output.put_line('This salary is too high. You need to decrease it.');
end;
----------------- raise inside of the exception section
declare
too_high_salary exception;
v_salary_check pls_integer;
begin
  select salary into v_salary_check from employees where employee_id = 100;
  if v_salary_check > 20000 then
    raise too_high_salary;
  end if;
  --we do our business if the salary is under 2000
  dbms_output.put_line('The salary is in an acceptable range');
exception
  when too_high_salary then
  dbms_output.put_line('This salary is too high. You need to decrease it.');
  raise_application_error(-20123,'The salary of the selected employee is too high!',true);
end;