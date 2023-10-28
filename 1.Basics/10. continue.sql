/* CONTINUE STATEMENT */

declare
v_inner number:=1;
begin
    for v_outer in 1..10 loop
        dbms_output.put_line('My outer value is : ' || v_outer);
        v_inner := 1;
        
        while v_inner <=15 loop
            v_inner := v_inner + 1;
            continue when mod(v_inner * v_outer, 3) = 0;
            dbms_output.put_line('      My inner value is : ' || v_inner);
        end loop;
    end loop;
end;    