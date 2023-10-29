/* Non-predefined Exceptions */
/*
- they do not have any specific names in the Oracle Server
- There are 10,000 of error codes that is non predefined in the database server. How do we handle this? Using 'When Others then', is too generic. We 
can do it -> we declare exceptions with the error codes
        exception_name EXCEPTION;    // 1. Declare our exception variable and exception keyword
        PRAGMA EXCEPTION_INIT(exception_name, error_code) //2. Assign an error code for our exception
        
        there are 4 more directices like EXCEPTION_INIT for the Pragma directive

* WHAT IS PRAGMA?
- a compiler directive or hint and is used to provide an instruction to the compiler. It will tell, 'Hi compiler, do the things that I will tell you.'

* What exception_init do?
- It says to the compiler that "Hi Compiler, when you face with this error code know that it has this name and viceversa.

- But know that, when your code finished, this declaration of exception will be gone.
*/


begin
  UPDATE employees_copy set email = null where employee_id = 100;
end;
/
-----------------HANDLING a nonpredefined exception
declare
  cannot_update_to_null exception;
  pragma exception_init(cannot_update_to_null,-01407);
begin
  UPDATE employees_copy set email = null where employee_id = 100;
exception
  when cannot_update_to_null then
    dbms_output.put_line('You cannot update with a null value!');
end;
/
        
        
