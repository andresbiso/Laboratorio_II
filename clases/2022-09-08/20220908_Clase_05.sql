-- # Cursor
/*
- Tipos: Explicitos e Implicitos
- Los cursores implícitos son los que usa el motor de forma interna.
Por ejemplo: al realizar un insert, update o delete.
- Los cursores explcítos son los que vamos a declarar nosotros.
*/

/*
cursor c_... is
    select ...
*/

/*
Pasos para tener un cursor:
1.declaro
2.abro
3.recorro
4.cierro
*/

/*
Atributos del cursor:

%found -> si estoy apuntando, mi puntero a una fila del cursor, da true y sino false.
%notfound -> si mi puntero no apunta a una fila da true y sino false.
%rowcount -> número de fila en la que estoy parado.
%isopen -> devuelve true si el cursor esta abierto y sino false.
%isclose -> devuelve true si el cursor esta cerrado y sino false.
*/

/*
El fetch lee y trae el proximo registro
*/

/*Ej-1*/

declare
    cursor c_cli is 
        select customer_id, name
        from customer
        where salesperson_id = 7789;
    
    r_cli c_cli%rowtype; --> puntero a registro lo declaro del mismo tipo que la fila del cursor
begin
    open c_cli; --> Abro el cursor
    loop
        fetch c_cli into r_cli; --> apuntar a un registro del cursor
        exit when c_cli%notfound; --> termina cuando no encuentra registro. Condición de salida.
        dbms_output.put_line(r_cli.customer_id || ' ' || r_cli.name);
    end loop;
    close c_cli; --> Cierro el cursor
end;

/*Ej-1-b*/
/*Igual al anterior pero con for (implícitamente hace todo lo anterior)*/
/*No necesitamos declarar r_cli para este caso*/
/*--> El profesor recomienda que usemos esta forma*/

/*c_cli%rowcount solo devuelve valor mientras el cursor esté abierto, dentro del for queda abierto*/

declare
    cursor c_cli is 
        select customer_id, name
        from customer
        where salesperson_id = 7789;
begin
    for r_cli in c_cli loop
        dbms_output.put_line(r_cli.customer_id || ' ' || r_cli.name || ' ' || c_cli%rowcount);
    end loop;
end;

--# Cursor Implícito
/*Ej-1*/
/*
sql%rowcount -> devuelve cantidad de filas modificadas
*/
begin
    update employee
    set commission = 20
    where department_id = 10;
    dbms_output.put_line('Se modificaron: ' || sql%rowcount || ' filas');
end;

/*Ej-1-b*/
begin
    update employee
    set commission = 20
    where department_id = 95;

    if sql%rowcount > 0 then
        dbms_output.put_line('Se modificaron: ' || sql%rowcount || ' filas');
    else
        dbms_output.put_line('No existe empleados para el departamento');
    end if;
end;

/*
Practica 3 - Ejercicio 8
Usando un cursor recorrer las tablas Sales_order e Ítem para generar un listado sobre todas las órdenes
y los productos que se ordenaron en ellas. Mostrar los siguientes datos: Order_id, order_date, product_id. 
*/

declare
    cursor c_order is 
        select so.order_id, so.order_date, i.product_id
        from sales_order so
        inner join item i on so.order_id = i.order_id;
begin
    for r_order in c_order loop
        dbms_output.put_line(r_order.order_id || ' ' || r_order.order_date || ' ' || r_order.product_id);
    end loop;
end;

/*
Practica 3 - Ejercicio 9
Escribir un bloque que reciba un código de cliente e informe el nro. de orden, la fecha de toda orden generada por él
y la descripción de los productos ordenados. (Usar las tablas Sales_order, Ítem y Product). Si no hay registros desplegar un mensaje de error.
*/
/*Lo hicimos de otra manera*/
declare
    cursor c_order is 
        select so.order_id, so.order_date, p.description
        from sales_order so
        inner join item i on so.order_id = i.order_id
        inner join product p on i.product_id = p.product_id
        where so.customer_id = 11;
begin
    
    dbms_output.put_line('entrando');
    for r_order in c_order loop
    dbms_output.put_line('dentro');
        if c_order%rowcount > 0 then
             dbms_output.put_line(r_order.order_id || ' ' || r_order.order_date || ' ' || r_order.description);
        else
            dbms_output.put_line('No hay registros');
        end if;
     
    end loop;
dbms_output.put_line('fuera');
    exception
        when no_data_found then
         dbms_output.put_line('No hay registros');
end;

--# Store Procedure

/*Es un bloque que tiene nombre y queda almacenado en la BD*/
/*Es más performante que un bloque anónimo*/
/*Acepta parámetros de entrada y de salida*/
/*Un SP tiene estados. Ej: Puede estar almacenado y estar inválido (porque se modificaron los datos,...)*/

/*create or replace --> creo si no existe y sino lo reemplaza*/
/*pi_... : parámetro entrada*/
/*po_... : parámetro salida*/

create or replace procedure suma
    (pi_num1 in number, pi_num2 in number, po_total out number)
is
    begin
        po_total := pi_num1 + pi_num2;
    end;

declare
    p_num1 number(4) := 5;
    p_num2 number(4) := 20;
    p_total number(4);
begin
    suma(p_num1,p_num2,p_total);
    dbms_output.put_line('Total Suma: ' || p_total);
end;

/*--Vimos como usar el Object browser para crear un Procedure con el wizard de Oracle Apex--*/

create or replace procedure "INSERT_PRODUCT"
(pi_id in product.product_id%type,
pi_nombre in product.description%type)
is
begin
    insert into product
    values (pi_id, pi_nombre);
    dbms_output.put_line('Producto Ingresado Correctamente');

    exception 
        when dup_val_on_index then
            dbms_output.put_line('Valores Duplicados!');
end;

/*validacion de un objeto*/
/*all_objects --> tabla del diccionario de oracle*/
select status from all_objects where object_name='SUMA';

/*
Ejercicio:
Hacer un procedimiento que cree un departamento. Pasar por parametro: nombre del departamento y opcionalmente una localidad.
Si no tengo localidad, pongo el departamento en la localidad 122 y el id del departamento lo genero como el max que tengo +1-
*/

create or replace procedure pr_alta_dep
    (pi_nombre in department.name%type,
    pi_loc_id in department.location_id%type default 122)
is
    /*declaro variables locales al procedure*/
    l_max_id department.department_id%type; --> variable local al procedimiento

    e_fk exception; --> custom exception para error no estándar
    pragma exception_init(e_fk, -2291);

    begin
        select nvl(max(department_id), 0)
        into l_max_id
        from department;

        insert into department
            (department_id, name, location_id)
        values
            (l_max_id + 1, pi_nombre, pi_loc_id);
        
            dbms_output.put_line('Se insertó correctamente');
        
        exception
        when e_fk then
            dbms_output.put_line('La localidad es incorrecta');
        when others then
            dbms_output.put_line('Error inesperado: ' || sqlerrm);

    end;

declare
    p_nombre department.name%type := 'hola';
    p_loc_id department.location_id%type;
begin
    pr_alta_dep(p_nombre);
    pr_alta_dep('Prueba 23', 123);
    pr_alta_dep('Prueba 23', 1);
end;

select * from department where name = 'hola'
select * from department where name = 'Prueba 23'
delete from department where name = 'hola'
delete from department where name = 'Prueba 23'
