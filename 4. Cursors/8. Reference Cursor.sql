/* REFERENCE CURSORS (REF CURSORS) */

/* 
- stores the memory location of the cursors. So we can pass the reference to the other platform too.
- It is not tied to any specific cursor or select query. Since it is a pointer to the memory address of a cursor, 
we can easily open that cursor with another query and continue working. So it will increase the flexibility.


Why we need it?
- Sometimes we need to create a cursor that can work on employees table or employees_history table or send the cursor to a function,
or even to the different platform like Java Program. This is where we need to create a generic cursor that works for all.
So, reference cursors are used in such case. "Reference cursors are the pointers to the actual cursor"

What we cannot do?
- we cannot assign null values to our cursor variables.
- we cannot use ref cursors in our CREATE TABLE or CREATE VIEW statements
- We cannot store ref cursors in a collection
- We cannot compare the cursor variables.
*/


declare
    type t_emps is ref cursor return employees%rowtype; -- for strong ref cursor
    rc_emps t_emps; -- cursor variable
    r_emps employees%rowtype; -- record of return type same as cursor type
begin
    open rc_emps for select * from employees;
    loop
        fetch rc_emps into r_emps;
        exit when rc_emps%notfound;
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name);
    end loop;
    close rc_emps;
end;
/

/* Now let's change the table to retired_employees */

declare
    type t_emps is ref cursor return employees%rowtype; -- for strong ref cursor
    rc_emps t_emps; -- cursor variable
    r_emps employees%rowtype; -- record of return type same as cursor type
begin
    open rc_emps for select * from retired_employees;
    loop
        fetch rc_emps into r_emps;
        exit when rc_emps%notfound;
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name);
    end loop;
    close rc_emps;
end;
/

/* What if we replace by department table -> gives error - expression is of wrong type */
declare
    type t_emps is ref cursor return employees%rowtype; -- for strong ref cursor
    rc_emps t_emps; -- cursor variable
    r_emps employees%rowtype; -- record of return type same as cursor type
begin
    open rc_emps for select * from departments;
    loop
        fetch rc_emps into r_emps;
        exit when rc_emps%notfound;
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name);
    end loop;
    close rc_emps;
end;
/

/* Creating a ref cursor based upon another cursor type */
declare
    type t_emps is ref cursor return employees%rowtype; -- for strong ref cursor
    rc_emps t_emps; -- cursor variable
    type t_emps2 is ref cursor return rc_emps%rowtype; -- another cursor 
    r_emps employees%rowtype; -- record of return type same as cursor type
begin
    open rc_emps for select * from employees;
    loop
        fetch rc_emps into r_emps;
        exit when rc_emps%notfound;
        dbms_output.put_line(r_emps.first_name || ' ' || r_emps.last_name);
    end loop;
    close rc_emps;
end;
/

declare
 type t_emps is ref cursor return employees%rowtype;
 rc_emps t_emps;
 r_emps employees%rowtype;
begin
  open rc_emps for select * from employees;
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
    end loop;
  close rc_emps;
end;
--------------- in two different queries
declare
 type t_emps is ref cursor return employees%rowtype;
 rc_emps t_emps;
 r_emps employees%rowtype;
begin
  open rc_emps for select * from retired_employees;
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
    end loop;
  close rc_emps;
  
  dbms_output.put_line('--------------');
  
  open rc_emps for select * from employees where job_id = 'IT_PROG';
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
    end loop;
  close rc_emps;
end;
---------------Example of using with %type when declaring records first
declare
  r_emps employees%rowtype;
 type t_emps is ref cursor return r_emps%type;
 rc_emps t_emps;
 --type t_emps2 is ref cursor return rc_emps%rowtype;
begin
  open rc_emps for select * from retired_employees;
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
    end loop;
  close rc_emps;
  
  dbms_output.put_line('--------------');
  
  open rc_emps for select * from employees where job_id = 'IT_PROG';
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name);
    end loop;
  close rc_emps;
end;
---------------manually declared record type with cursors example
declare
  type ty_emps is record (e_id number, 
                         first_name employees.first_name%type, 
                         last_name employees.last_name%type,
                         department_name departments.department_name%type);
 r_emps ty_emps;
 type t_emps is ref cursor return ty_emps;
 rc_emps t_emps;
begin
  open rc_emps for select employee_id,first_name,last_name,department_name 
                      from employees join departments using (department_id);
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
            ' is at the department of : '|| r_emps.department_name );
    end loop;
  close rc_emps;
end;
---------------first example of weak ref cursors - we won't have return type defined in weak ref cursor
declare
  type ty_emps is record (e_id number, 
                         first_name employees.first_name%type, 
                         last_name employees.last_name%type,
                         department_name departments.department_name%type);
 r_emps ty_emps;
 type t_emps is ref cursor;
 rc_emps t_emps;
 q varchar2(200);
begin
  q := 'select employee_id,first_name,last_name,department_name 
                      from employees join departments using (department_id)';
  open rc_emps for q;
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
            ' is at the department of : '|| r_emps.department_name );
    end loop;
  close rc_emps;
end;
--------------- WEAK CURSOR - bind variables with cursors example
declare
  type ty_emps is record (e_id number, 
                         first_name employees.first_name%type, 
                         last_name employees.last_name%type,
                         department_name departments.department_name%type);
 r_emps ty_emps;
 type t_emps is ref cursor;
 rc_emps t_emps;
 r_depts departments%rowtype;
 --r t_emps%rowtype;
 q varchar2(200);
begin
  q := 'select employee_id,first_name,last_name,department_name 
                      from employees join departments using (department_id)
                      where department_id = :t';
  open rc_emps for q using '50';
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
            ' is at the department of : '|| r_emps.department_name );
    end loop;
  close rc_emps;
  
  open rc_emps for select * from departments;
    loop
      fetch rc_emps into r_depts;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_depts.department_id|| ' ' || r_depts.department_name);
    end loop;
  close rc_emps;
end;
---------------sys_refcursor example
declare
  type ty_emps is record (e_id number, 
                         first_name employees.first_name%type, 
                         last_name employees.last_name%type,
                         department_name departments.department_name%type);
 r_emps ty_emps;
-- type t_emps is ref cursor;
 rc_emps sys_refcursor;
 r_depts departments%rowtype;
 --r t_emps%rowtype;
 q varchar2(200);
begin
  q := 'select employee_id,first_name,last_name,department_name 
                      from employees join departments using (department_id)
                      where department_id = :t';
  open rc_emps for q using '50';
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
            ' is at the department of : '|| r_emps.department_name );
    end loop;
  close rc_emps;
  
  open rc_emps for select * from departments;
    loop
      fetch rc_emps into r_depts;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_depts.department_id|| ' ' || r_depts.department_name);
    end loop;
  close rc_emps;
end;