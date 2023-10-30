/* WHEN clause in Triggers */
/* !!! ONLY WITH ROW LEVEL TRIGGERS*/
/* Better performance and easier to understand 
* In previous cases, we used if case. Even if the cases matches, it gets called/fired
* using WHEN reduces this problem
*/


create or replace trigger prevent_high_salary
before insert or update of salary on employees_copy 
for each row
when (new.salary > 50000)
begin
  raise_application_error(-20006,'A salary cannot be higher than 50000!.');
end;
/

update employees_copy set salary = 200000;