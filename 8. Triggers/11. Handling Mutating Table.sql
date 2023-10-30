/* Handling Mutating table errors */
/*
Sometimes you may want to make some checks using the same table in the trigger. Eg:
you may want to restrict too high salaries based on their deparment_id averages. We did by Compound Triggers.

But assume we did that with a BEFORE or AFTER each row trigger?
- we will try to get the average salary of the specified rows' department with a SELECT query in the trigger and make a comparison with the 
new salary. The problem is HERE!!!!
    - Oracle does not let us query from the same table within same triggers while we are making some modifications on that table.
    i.e you get the mutating table errors if you want to query 
        - the same table within the row level triggers 
        - or statement level triggers only if they are fired as a result of "ON DELETE CASCADE"
    So, you get this error within the row level triggers, but you get this error with the statement level triggers too.
    i.e the base table of the trigger is bounded to another one with the DELETE CASCADE constraint.
    i.e when a row in another table is deleted, then related row in our table will also be deleted with the DELETE CASCADE constraint.
    If so, our statement triggers will also have mutating table errors.

- !!! But the key thing in mutating table errors is in its trigger, -> you must make a change on that table with an insert, update or delete
                                                                        or query from the base table with that trigger. If not, there's no problem.
        - But you cannot write an update command about the base table into that trigger
        - or you cannot delete, or you cannot query from that trigger

- !!! Views being modified by the instead of triggers are not considered as mutating.

-- SOLUTION to Mutating Table Errors:
    1. Store related data in another table
    2. Store related data in a Package (not good)
    3. Compound trigger (Preferred way)
*/        
                                                                        
    

-- A mutating table error example: ----------------------------------
create or replace trigger trg_mutating_emps
before insert or update on employees_copy 
for each row
    declare
    v_interval number := 15;
    v_avg_salary number;
    begin
    select avg(salary) into v_avg_salary from employees_copy where department_id = :new.department_id;
      if :new.salary > v_avg_salary*v_interval/100 then
        RAISE_APPLICATION_ERROR(-20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
      end if;
end;

update employees_copy set salary = salary + 1000 where employee_id = 154; -- will give an error


/********************************************************************/
-- Getting mutating table error within a compound trigger: -----------
create or replace trigger trg_comp_emps
for insert or update or delete 
on employees_copy 
compound trigger
  type t_avg_dept_salaries is table of employees_copy.salary%type index by pls_integer;
  avg_dept_salaries t_avg_dept_salaries;
  before statement is
   begin
    for avg_sal in (select avg(salary) salary,nvl(department_id,999) department_id from employees_copy group by department_id) loop
      avg_dept_salaries(avg_sal.department_id) := avg_sal.salary;
    end loop;
  end before statement; 
 
  after each row is
    v_interval number := 15;
    begin
    update employees_copy set commission_pct = commission_pct;
      if :new.salary > avg_dept_salaries(:new.department_id)*v_interval/100 then
        RAISE_APPLICATION_ERROR(-20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
      end if;
  end after each row;
  after statement is
    begin
      dbms_output.put_line('All the updates are done successfully!.');
  end after statement;
end;


update employees_copy set salary = salary + 1000 where employee_id = 154; -- will give an error
-- WHY?? b/c even though we used compound trigger, we cannot modify the same table within the row level sections.
-- so the solution is: you need to do at BEFORE/AFTER STATEMENT section




/********************************************************************/
-- An example of getting maximum level of recursive SQL levels: ------
create or replace trigger trg_comp_emps
for insert or update or delete on employees_copy 
compound trigger
  type t_avg_dept_salaries is table of employees_copy.salary%type index by pls_integer;
  avg_dept_salaries t_avg_dept_salaries;
  before statement is
   begin
    update employees_copy set commission_pct = commission_pct where employee_id = 100;
    for avg_sal in (select avg(salary) salary,nvl(department_id,999) department_id from employees_copy group by department_id) loop
      avg_dept_salaries(avg_sal.department_id) := avg_sal.salary;
    end loop;
  end before statement; 
 
  after each row is
    v_interval number := 15;
    begin
      if :new.salary > avg_dept_salaries(:new.department_id)*v_interval/100 then
        RAISE_APPLICATION_ERROR(-20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
      end if;
  end after each row;
  after statement is
    begin
      update employees_copy set commission_pct = commission_pct where employee_id = 100;
      dbms_output.put_line('All the updates are done successfully!.');
  end after statement;
end;


update employees_copy set salary = salary + 1000 where employee_id = 154; -- again gives error although we placed it in STATEMENT Level.
-- b/c it's nested. The trigger is called again inside of another trigger causing infinite looping.
/

------------------


-- 
create or replace trigger trg_comp_emps
for insert or update on employees_copy 
compound trigger
  type t_avg_dept_salaries is table of employees_copy.salary%type index by pls_integer;
  avg_dept_salaries t_avg_dept_salaries;
  
  before statement is
   begin
   delete from employees_copy where employee_id=100;
   -- Initialize the collection with department average salaries
    for avg_sal in (select avg(salary) salary,nvl(department_id,999) department_id from employees_copy group by department_id) loop
      avg_dept_salaries(avg_sal.department_id) := avg_sal.salary;
    end loop;
  end before statement; 
 
  after each row is
    v_interval number := 15;
    begin
      if :new.salary > avg_dept_salaries(:new.department_id)* v_interval/100 then
        RAISE_APPLICATION_ERROR(-20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
      end if;
  end after each row;
  
  after statement is
    begin
     delete from employees_copy where employee_id = 100;
      dbms_output.put_line('All the updates are done successfully!.');
  end after statement;
end;


update employees_copy set salary = salary + 1000 where employee_id = 154; -- again gives error although we placed it in STATEMENT Level.
-- b/c it's nested. The trigger is called again inside of another trigger causing infinite looping.
/

--CONCLUSION:
/* Using DML commands inside of the BEFORE and AFTER statements are valid. We can use it. But if our DML fires the same trigger again, 
we fall into an infinite loop trigger fires. so we cannot do that. But we can run any DML commands that will not fire the same triggers.
*/