/* PACKAGES */

/*
* Packages groups subprograms, types, variables etc in one container 
* 2nd most important: Increases the performance b/c the packages when accessed first time, it will be loaded to SGA (Shared/System Global Area) in memory,
reducing I/O operation.

Package consists of two parts:
1. Package Specification - is for globalization. anyone who has the privilege will be able to use all the objects declared in the package specification.
    - !!IMPORTANT - here, we only declare our objects like functions, procedures, variables, cursors etc
    - we cannot type the BEGIN-END block of our subprograms, but we can assign some values to the variables.
    - what you declared in the package specification are all considered as public.
    - 2 main reason to create package specification:
        - to declare I will have these subprograms in the package body
        - to provide some public variables for the others
2. Package Body - has the implementations of the subprograms declared in the package spec
    - can have its own variables, subprograms, cursors, etc
    - If a variable or subprogram or any other object is not declared in the package spec, it is not visible to the others. So, these
        objects are considered as private objects.
    - A package body can also use the objects declared in the package spec
- "Package Body and Package Spec are related with each other. So, they must have the same name."
- "If there is not any subprograms declared in the package spec, there is no need to create a package body for that package"


*/


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------CREATING & USING PACKAGES-----------------------------------------------
--------------------------------------------------------------------------------------------------------------------
----------------- Creating first package specification
CREATE OR REPLACE 
PACKAGE EMP AS 
  v_salary_increase_rate number := 0.057; 
  cursor cur_emps is select * from employees;
  
  procedure increase_salaries;
  function get_avg_sal(p_dept_id int) return number;
END EMP;
/
----------------- Creating the package body
CREATE OR REPLACE
PACKAGE BODY EMP AS
  procedure increase_salaries AS
  BEGIN
    for r1 in cur_emps loop
      update employees_copy set salary = salary + salary * v_salary_increase_rate;
    end loop;
  END increase_salaries;
  function get_avg_sal(p_dept_id int) return number AS
  v_avg_sal number := 0;
  BEGIN
    select avg(salary) into v_avg_sal from employees_copy where
          department_id = p_dept_id;
    RETURN v_avg_sal;
  END get_avg_sal;
END EMP;
/
----------------- using the subprograms in packages
exec EMP_PKG.increase_salaries;
----------------- using the variables in packages
begin
  dbms_output.put_line(emp_pkg.get_avg_sal(50));
  dbms_output.put_line(emp_pkg.v_salary_increase_rate);
