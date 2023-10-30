/* RAISE APPLICATION ERROR () in triggers */
/*
    EG: RAISE_APPLICATION_ERROR(-20012, 'error message goes here');
*/


create or replace trigger before_row_emp_cpy 
before insert or update or delete on employees_copy 
referencing old as O new as N
for each row
begin
  
  if inserting then
    begin
        if :n.hire_date > sysdate then
            raise_application_error(-20000, 'You cannot enter a future hire');
        end if;
    end;
    dbms_output.put_line('An INSERT occurred on employees_copy table');
  elsif deleting then
    raise_application_error(-20001,'You cannot delete from the employees_copy table...');
    dbms_output.put_line('A DELETE occurred on employees_copy table');
  
  elsif updating then
    begin
        if updating('salary') then
            if :n.salary>50000 then
                raise_application_error(-20002, 'A salary cannot be higher than 50000.');
            else    
                dbms_output.put_line('An UPDATE occurred on the salary column');
            end if;    
        elsif updating('commission_pct') then
            dbms_output.put_line('An UPDATE occurred on the updating column');
        else
            dbms_output.put_line('An UPDATE occurred on the other columns');
        end if;
    end;
  end if;
end;
/


delete from employees_copy;

update employees_copy set salary = 60000;