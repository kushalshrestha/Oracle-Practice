/* WHERE CURRENT OF <cursor_name> - CLAUSE*/
/*
* works with update and delete
* Not the function only FOR UPDATE clause
* WHERE CURRENT OF -> used for update and delete to make much faster HOW??
    Updating using primary index column is fast. But there is much faster way. 
    - By using rowid. Instead of finding the index first and locating the row, we use rowid to point directly to the record(row).
    - WHERE CURRENT OF -  it uses the cursor itself to keep track of the current row being processed. 
        When you declare a cursor and use "WHERE CURRENT OF," 
        Oracle knows which row you are referring to based on the cursor's internal position.

!!!!IMPORTANT
In a cursor that involves joins, the "WHERE CURRENT OF" clause may not work as expected if the cursor is based on multiple tables and the result 
set is not directly updatable. In this scenario, you might encounter issues with "WHERE CURRENT OF" not reflecting changes as intended.

The "WHERE CURRENT OF" clause is typically used for updating or deleting rows in a cursor that is based on a single table and is updatable. 
When you have a cursor based on a join, especially if it involves multiple tables or complex subqueries, the cursor may become non-updatable, 
which can result in issues when using "WHERE CURRENT OF."
*/

declare
  cursor c_emps is select * from employees 
                    where department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where current of c_emps;
  end loop;  
end;

select * from employees;
/
---------------Wrong example of using where current of clause -> When joins are used in cursor, where current of doesn't reflect change
declare
  cursor c_emps is select e.* from employees e, departments d
                    where 
                    e.department_id = d.department_id
                    and e.department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where current of c_emps;
  end loop;  
end;
---------------Solution to above problem: An example of using rowid like where current of clause
declare
  cursor c_emps is select e.rowid,e.salary from employees e, departments d
                    where 
                    e.department_id = d.department_id
                    and e.department_id = 30 for update;
begin
  for r_emps in c_emps loop
    update employees set salary = salary + 60
          where rowid = r_emps.rowid;
  end loop;  
end;