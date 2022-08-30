--Repaso
--EJ P1-9
--mostrar la comision y sino tiene, mostrar "SIN COMISION"

select first_name , last_name , nvl(to_char(commission),'SIN COMISION')
from employee;

--EJ P1-23
--ordenes maximo y minimo

select *
from sales_order
where order_id 
in (
    select max(order_id) from sales_order
)
or 
order_id in (
    select min(order_id) from sales_order
);

--EJ P1-26
--todos los empleados que tienen 2 o + personas a su cargo

select m.last_name
from employee e , employee m
where e.manager_id = m.employee_id
group by m.last_name , m.employee_id
having count(e.employee_id) > 2;

--EJ P2-3
--

------------------------
--Select into
------------------------
--ojo el select into devuelve una y solo una linea.
--Puede dar error por no encontrar o por mas de un dato, en cuyo caso hay que atrapar la excepcion
declare 
    v_nombre    employee.first_name%TYPE;  
    v_salario   employee.salary%TYPE;
begin
    select  first_name , salary
    into    v_nombre , v_salario
    from    employee
    where   employee_id = 7369;
    dbms_output.put_line('nombre: '||v_nombre||' Salario:'||v_salario);
end;
    
--ejemplo con NO_DATA_FOUND
declare 
    v_nombre    employee.first_name%TYPE;  
    v_salario   employee.salary%TYPE;
begin
    select  first_name , salary
    into    v_nombre , v_salario
    from    employee
    where   employee_id = 736;
    dbms_output.put_line('nombre: '||v_nombre||' Salario:'||v_salario);
exception
    when no_data_found then
        dbms_output.put_line('NO EXISTE EL EMPLEADO BUSCADO!!!!');
end;

--ejemplo con TOO_MANY_ROWS
declare 
    v_nombre    employee.first_name%TYPE;  
    v_salario   employee.salary%TYPE;
begin
    begin
        select  first_name , salary
        into    v_nombre , v_salario
        from    employee
        where   department_id = 10;
        dbms_output.put_line('nombre: '||v_nombre||' Salario:'||v_salario);
    exception
        when no_data_found then
            dbms_output.put_line('NO EXISTE EL EMPLEADO BUSCADO!!!!');
        when too_many_rows then
            dbms_output.put_line('EXISTE MAS DE UN EMPLEADO EN EL DEPTO INDICADO!!!!');
    end;
end;

-------------------
--CONDICIONALES--IF
-------------------
--1era forma
if <<condicion>> then
    xxxxxxx;
end if;

--2da
if <<condicion>> then
    xxxxxxx;
else
    yyyyyyy;
end if;

--3era
if <<condicion>> then
    xxxxxxx;
elsif <<condicion>> then
    yyyyyyy;
elsif <<condicion>> then
    zzzzzzz;
elsif <<condicion>> then
    uuuuuuu;
else
    mmmmmmm;
end if;

--ejemplo
declare
    v_edad number(2);
begin
    v_edad := 25;
    if v_edad < 18 then
        dbms_output.put_line('SECUNDARIO');
    else
        dbms_output.put_line('UNIVERSIDAD');   
    end if;
end;

/*
Ejercicio:

0-2 bebe
3-5 jardin
6-12 primaria
13-17 secundaria
18-25 universidad
>25 trabajo
*/

declare
    v_edad  number(3);
    v_fecha date;
    v_fecha_ingreso varchar2(10);

begin
    v_fecha_ingreso := :Ingrese_fecha_nacimiento;
    v_fecha := to_date(v_fecha_ingreso,'dd/mm/yyyy');
    v_edad := (sysdate - v_fecha)/365;
    dbms_output.put_line(v_edad);
    
    if (v_edad < 2) then
        dbms_output.put_line('BEBE');
    elsif v_edad < 6 then
        dbms_output.put_line('jardin');
    elsif v_edad < 13 then
        dbms_output.put_line('primaria');
    elsif v_edad < 18 then
        dbms_output.put_line('secundaria');
    elsif v_edad < 25 then
        dbms_output.put_line('universidad');
    else
        dbms_output.put_line('trabajo');
    end if;
end;

--(v_edad > 2 and v_edad <= 5)


----una resolucion
declare
    v_fechaNacimiento varchar(11);
    v_edad number(2);
begin
    v_fechaNacimiento := :FECHA;
    select round((sysdate - to_date(v_fechaNacimiento, 'dd/mm/yyyy'))/365,0)
    into v_edad from dual;

    if v_edad < 3 then
        dbms_output.put_line('bebe');
    elsif v_edad < 6 then
        dbms_output.put_line('jardin');
    elsif v_edad < 13 then
        dbms_output.put_line('primaria');
    elsif v_edad < 18 then
        dbms_output.put_line('secundaria');
    elsif v_edad < 25 then
        dbms_output.put_line('universidad');
    else
        dbms_output.put_line('trabajo');
    end if;
end;

---otra forma

Declare
    v_fecha_nac     date;
    v_edad          number(2);
Begin
    v_fecha_nac := :Fecha_de_Nacimiento;
    v_edad := to_char(sysdate,'yyyy') - to_char(v_fecha_nac,'yyyy');
    if v_edad < 3 then
        dbms_output.put_line('bebe');
    elsif v_edad < 6 then
        dbms_output.put_line('jardin');
    elsif v_edad < 13 then
        dbms_output.put_line('primaria');
    elsif v_edad < 18 then
        dbms_output.put_line('secundaria');
    elsif v_edad < 25 then
        dbms_output.put_line('universidad');
    else
        dbms_output.put_line('trabajo');
    end if;
end;


--------------------------------------
--CICLOS
--------------------------------------
--3 formas
--loop --> minimamente se va a ejecutar 1 vez
loop 
    xxxx;
    xxxx;
    xxxx;
    exit when <<condicion>>
end loop;

--while -->> min = 0 ; max = n
while <<condicion>> loop
    xxxxx
    xxxxx
    xxxxx
end loop;

--for --> min n
for i in 1..n loop
    xxxxxxx
    xxxxxxx
    xxxxxxx
end loop;

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

--ejemplo de while

declare
    v_tope  number(3);
    v_multiplo  number(3);
begin
    v_tope := :ingresar_valor_maximo;
    v_multiplo := 2;
    while v_multiplo <= v_tope loop
        dbms_output.put_line(v_multiplo);
        v_multiplo := v_multiplo + 2;
    end loop;
end;    
    
----------
variables:  -> Escalares  -> varchar2, date, number, boolean, etc
            -> Compuestas -> record y collection()

%TYPE

%ROWTYPE

declare
    type tr_emp is record (         --tipo de dato record
        emp_id  employee.employee_id%type,
        nombre  employee.first_name%type,
        apellido    employee.last_name%type,
        salario employee.salary%type
    );

type tt_emp is table of tr_emp index by binary_integer;  --tipo de dato table

t_emp tt_emp;

begin
    t_emp(1).emp_id := 8;
    t_emp(1).nombre := 'Jose';

    t_emp(2).emp_id := 15;
    t_emp(2).nombre := 'Pedro';

    t_emp(28).emp_id := 4;
    t_emp(28).nombre := 'Juan';

    for i in 1..2 loop
        dbms_output.put_line(t_emp(i).emp_id || ' '||t_emp(i).nombre);
    end loop;
end;
/

--Atributos
1
2
5
8
50
51

count   t_emp.count  >> 6
exists  t_emp.exists(5) >> true
exists  t_emp.exists(9) >> false
first   t_emp.first >> 1
last    t_emp.last  >> 51
prior   t_emp.prior(50) >> 8
next    t_emp.next(8)  >> 50
delete  t_emp.delete(8) >> borra el registro

declare
    type tr_emp is record (         --tipo de dato record
        emp_id  employee.employee_id%type,
        nombre  employee.first_name%type,
        apellido    employee.last_name%type,
        salario employee.salary%type
    );

type tt_emp is table of tr_emp index by binary_integer;  --tipo de dato table

t_emp tt_emp;
l_idx binary_integer;

begin

    t_emp(2).emp_id := 8;
    t_emp(2).nombre := 'Jose';

    t_emp(5).emp_id := 15;
    t_emp(5).nombre := 'Pedro';

    t_emp(28).emp_id := 4;
    t_emp(28).nombre := 'Juan';

    t_emp(50).emp_id := 65;
    t_emp(50).nombre := 'Luis';

    l_idx := t_emp.first;

    while l_idx <= t_emp.last loop
        dbms_output.put_line(l_idx||' '||t_emp(l_idx).emp_id ||' '||t_emp(l_idx).nombre);
        l_idx := t_emp.next(l_idx);
    end loop;
end;
/
