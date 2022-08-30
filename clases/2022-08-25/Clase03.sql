--Clase 03

--manejo de exceptions too many rows & no data found que pueden incidir en el select into

--------------------------

--SELECT INTO

-------------------------

declare 
    v_nombre employee.first_name%TYPE;
    v_salario employee.salary%TYPE;
begin
    select first_name, salary
    into v_nombre, v_salario
    from employee
    where employee_id = 736;

    dbms_output.put_line('Nombre: '||v_nombre||'Salario: '||v_salario);

exception
    when no_data_found then
        dbms_output.put_line('EMPLEADO NO EXISTE');
    when too_many_rows then
        dbms_output.put_line('EMPLEADO REPETIDO');
end;

---------------------------------------------------

--Condicionales

---------------------------------------------------
/*
------sintaxis--------

if <<condicion>> then
    xxxxxxxx;
end if;

----------------------------------

if <<condicion>> then
    xxxxxxxx;
else 
    yyyyyyyy;

----------------------------------

if <<condicion>> then
    xxxxxxxx;
elsif <<condicion>> then
    yyyyyyyy;
elsif <<condicion>> then
    zzzzzzzzz;
elsif <<condicion>> then
    wwwwwwww;
else
    mmmmmmm;

*/

----ejemplo


declare 
    v_edad number(2);
begin
    v_edad := 15;
    if v_edad < 18 then
        dbms_output.put_line('secundario');
    else
        dbms_output.put_line('universitario');
    end if;
end;

---------------------------------------------
/*
desarrollar un bloque anonimo que reciba por vsus una fecha de nacimiento, dd/mm/yyyy, calcular la edad y mostrar por pantalla el nivel escolar

*/


declare 
    v_fechahoy date:= sysdate;
    v_fecha date;
    v_edad number(2);
begin
    v_fecha := :fecha;
    v_edad := (v_fechahoy - v_fecha)/365;

    if v_edad < 3 then
        dbms_output.put_line('bebe'); 

    elsif (v_edad >= 3) and (v_edad <= 5)  then
        dbms_output.put_line('jardin');

    elsif v_edad >= 6 and v_edad <= 12  then
        dbms_output.put_line('primaria');

    elsif v_edad >= 13 and v_edad <= 17  then
        dbms_output.put_line('secundaria');

    elsif v_edad >= 18 and v_edad <= 25  then
        dbms_output.put_line('universidad');

    else 
        dbms_output.put_line('trabajo');
    
    end if;    
end;
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


/*----------------------
CICLOS
---------------------*/

/*

--loop se ejecuta min 1 vez.

loop 
    xxxx
    xxxx
    xxxx
    exit when <<condicion>>
end loop;

--- while se ejecuta min 0 veces

while <<condicion>> loop
    xxxx
    xxxx
    xxxx
    xxxx
end loop;

--for se ejecuta minimo n veces

for i in 1..n loop 
    xxxx
    xxxx
    xxxx
end loop;

*/


begin 
    for i in 1..5 loop
        dbms_output.put_line('posicion: '||i);
    end loop;
end;


begin 
    for i in reverse 1..5 loop
        dbms_output.put_line('posicion: '||i);
    end loop;
end;


--por varsus un numero mostrar multiplos de 2 a al num ingresado

declare 
    v_tope number(3);
    v_multiplo number(3);
begin
    v_tope := :ingresar_valor_maximo;
    v_multiplo := 2;
    while v_multiplo <= v_tope loop
        dbms_output.put_line(v_multiplo);
        v_multiplo := v_multiplo + 2;
    end loop;
end;


----------------------------
/*

variables --> escalares: varchar2, date,number,boolean

              compuestas: record y collection

%type

%rowtype 

*/

declare

    type tr_emp is record(
        emp_id employee.employee_id%type,
        nombre employee.first_name%type,
        apellido employee.last_name%type,
        salario employee.salary%type
    );

type tt_emp is table of tr_emp index by binary_integer;

t_emp tt_emp;
begin
    t_emp(1).emp_id := 8;
    t_emp(1).nombre := 'Jose';

    t_emp(2).emp_id := 15;
    t_emp(2).nombre := 'Pedro';

    t_emp(28).emp_id := 4;
    t_emp(28).nombre := 'Juan';

    for i in 1..2 loop 
        dbms_output.put_line(t_emp(i).emp_id || ' ' ||t_emp(i).nombre);
    end loop;
end;
 /*
--atributos
count t_emp.count   >> 6  
exists t_emp.exists(5) >> true/false
first t_emp.first >> 1
last t_emp.last >> ultimo
prior t_emp.prior    >> 
next t_emp.next(8) >> 
delete t_emp.delete(8) >> borrar registro

*/
