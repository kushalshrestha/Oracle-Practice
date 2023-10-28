/* Variables:
PL/SQL Variable Types:
 - Oracle categorizes variable into 4 types
 1. Scalar (can be called as simple data types) - holds single value with one type
 2. Reference - holds value which point to a storage location
 3. Large Objects (LOBs) - are also pointers to other data items that are stored outside of the table such as images, files, etc
 4. Composite - generally called as collections or records - can hold more than one value
 
 SCALAR DATA TYPES:
 1. CHAR(max_length) - 32767 bytes
 2. VARCHAR2(max_length) - extended version of CHAR. If you allocate 32 bits, it will allocate anyhow 32 bits.
 3. NUMBER[precision, scale] - Fixed-length number data type with precision and scale
    * If you write NUMBER keyword only, that means you allocate the maximum value of number type.
    * The precision can be between 1 and 38
    * The scale can be between -84 to 127
    * Eg: NUMBER[3,2] - 2 digits at total and 2 of them are the decimal parts
4. BINARY_INTEGERS 
5. BINARY_FLOAT
6. BINARY_DOUBLE
7. BOOLEAN
8. DATE
9. TIMESTAMP
10. TIMESTAMP WITH TIMEZONE
11. TIMESTAMP WITH LOCAL TIME ZONE
11. INTERVAL YEAR TO MONTH
12. INTERVAL DAY TO SECOND
*/

-- to get current date
select SYSDATE, CURRENT_DATE FROM DUAL;

-- DECLARING AND INITIALIZING & USING VARIABLES
-- SYNTAX: NAME [CONSTANT] datatype [NOT NULL] [:= DEFAULT value|expression]

SET SERVEROUTPUT ON;
DECLARE
    V_TEXT varchar2(50) ;
    V_TEXT1 varchar2(50) NOT NULL := 'Hello';
    V_TEXT2 varchar2(50) NOT NULL DEFAULT 'Hello';
    v_number number not null := 50.32;
    v_number2 number(12) not null := 50.32; -- only 50 will be printed
    v_number3 number(12,3) not null := 50.32; -- only 50 will be printed --precision can be equal or higher
    v_number4 number(12,1) not null := 50.3233; -- only 50 will be printed -- works but only one digit will be shown
    v_number5 pls_integer := 100;
    v_number6 binary_integer := 100;
    v_number7 binary_float := 50.42f;
    
    v_date date NOT NULL := SYSDATE;
    v_date1 date NOT NULL := '20 NOV 2021';
    v_dateTime timestamp NOT NULL := SYSDATE;
    v_dateTime1 timestamp with time zone NOT NULL := SYSDATE;
    v_dateTime2 timestamp with local time zone NOT NULL := SYSDATE;
    
    v_dateInterval interval Day(4) to SECOND(2) := '24 02:05:21.012';
    v_dateInterval1 interval year to month := '12-3';
    
    v_bool boolean := true;
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_TEXT);
    V_TEXT1 := 'Hello1';
    DBMS_OUTPUT.PUT_LINE(V_TEXT1);
    V_TEXT2 := 'World!';
    DBMS_OUTPUT.PUT_LINE(V_TEXT2);
    DBMS_OUTPUT.PUT_LINE(V_TEXT1 || ' ' || V_TEXT2);
    dbms_output.put_line(v_number || ' ' || ' times Messi scored');
    dbms_output.put_line(v_number2 || ' ' || ' times Messi scored');
    dbms_output.put_line(v_number3 || ' ' || ' times Messi scored');
    dbms_output.put_line(v_number4 || ' ' || ' times Messi scored');

    dbms_output.put_line(v_number5 || ' ' || ' times Messi scored');
    dbms_output.put_line(v_number6 || ' ' || ' times Messi scored');

    dbms_output.put_line(v_number7 || ' ' || ' times Messi scored');  -- see the number is not accurate, but are faster (use only if accuracy is not important 
    dbms_output.put_line(v_date ||' --> '|| 'today''s date and time,
    if time not shown change from preferences');
    dbms_output.put_line(v_date1 ||' --> '|| 'today''s date and time,
    if time not shown change from preferences');
    
    dbms_output.put_line(v_dateTime ||' --> '|| 'using Timestamp');
    dbms_output.put_line(v_dateTime1 ||' --> '|| 'using Timestamp with time zone');
    dbms_output.put_line(v_dateTime2 ||' --> '|| 'using Timestamp with local time zone');
    
    dbms_output.put_line(v_dateInterval ||' --> '|| 'using interval day to second');
    dbms_output.put_line(v_dateInterval1 ||' --> '|| 'using interval year to month'); 
    
    -- dbms_output.put_line(v_bool ||' --> '|| 'using boolean');  -- can't print boolean, these are for conditional statement
    dbms_output.put_line(sys.diutil.bool_to_int(v_bool)); -- boolean to int, this can be done

END;    


