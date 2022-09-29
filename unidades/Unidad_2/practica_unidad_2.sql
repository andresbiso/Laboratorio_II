/*Práctica Unidad 2 - PL/SQL – Bloques Anónimos */

/*
1. Determinar si estas declaraciones son correctas. (se puede crear bloques anónimos con la parte ejecutable con null;) 

V_var			number(8,3); 
V_a, V-b		number; 
V_fec_ingreso	Date := sysdate +2; 
V_nombre		varchar2(30) not null; 
V_logico		boolean default ‘TRUE’; 
*/

declare
V_var			number(8,3); -- OK
begin
null;
end;

declare
V_a, V-b		number; -- solo se puede definir una variable por sentencia;
begin
null;
end;

declare
V_fec_ingreso	Date := sysdate +2; -- OK
begin
null;
end;

declare
V_nombre		varchar2(30) not null; -- debería estar inicializada ya que no puede ser null;
begin
null;
end;

declare
V_logico		boolean default 'TRUE'; -- debería ser true no 'TRUE'
begin
null;
end;

/*
2. Crear un bloque anónimo para desplegar los siguientes mensajes: 

‘Hola , soy ‘ username  

‘Hoy es: ‘  dd – Mon – yyyy’.  (mostrar la fecha del día) 
*/

declare
    v_fecha date := sysdate;
    v_user varchar2(20) := user;
begin
    dbms_output.put_line('Hola, soy ' || user);
    dbms_output.put_line('Hoy es: ' || to_char(sysdate, 'dd-month-yyyy'));
end
 
/*
3. Crear un bloque Pl/Sql para consultar el salario de un empleado dado: 

Ingresar el id del empleado usando una variable de sustitución 

Desplegar por pantalla el siguiente texto: 

First_name, Last_name  tiene un salario de Salary pesos.
*/

declare
    v_id_emp employee.employee_id%type;
    v_first_name employee.first_name%type;
    v_last_name employee.last_name%type;
    v_salary employee.salary%type;
begin
    v_id_emp := :Ingresar_Id_Empleado;

    select first_name, last_name, salary
    into v_first_name, v_last_name, v_salary
    from employee
    where employee_id = v_id_emp;

    dbms_output.put_line(v_first_name || ',' || v_last_name ||  ' tiene un salario de ' || v_salary || ' pesos.');
end


/*
4. Escribir un bloque para desplegar todos los datos de una orden dada.  

Ingresar el nro de orden usando una variable de sustitución 

En una variable de tipo record recuperar toda la información y desplegarla usando Dbms_output. 

Que pasa si la orden no existe? 
*/

declare
    v_nro_orden sales_order.order_id%type;
    v_orden sales_order%rowtype;
begin
    v_nro_orden := :Ingresar_Id_orden;

    select *
    into v_orden
    from sales_order
    where order_id = v_nro_orden;

    dbms_output.put_line(v_orden.order_id || ' ' || v_orden.order_date || ' '|| v_orden.customer_id || ' ' || v_orden.ship_date || ' ' || v_orden.total);
    /*Que pasa si la orden no existe? -> tira un error de no_data_found ya que no encontró la orden*/
end
 
/*
5. Escribir un bloque para mostrar la cantidad de órdenes que emitió un cliente dado siguiendo las siguientes consignas: 

Ingresar el id del cliente una variable de sustitución 

Si el cliente emitió menos de 3 órdenes desplegar: 

“El cliente nombre  ES REGULAR”. 

Si emitió entre 4 y 6 

“El cliente  nombre ES BUENO”. 

Si emitió más: 

“El cliente nombre ES MUY BUENO”. 
*/

declare
    v_id_customer customer.customer_id%type;
    v_customer_name customer.name%type;
    v_cant_ordenes number;
begin
    v_id_customer := :Ingrese_Id_Customer;

    select count(distinct so.order_id)
    into v_cant_ordenes
    from sales_order so
    inner join customer c
    on so.customer_id = c.customer_id
    where c.customer_id = v_id_customer;

    select name
    into v_customer_name
    from customer
    where customer_id = v_id_customer;

    if v_cant_ordenes < 3 then
        dbms_output.put_line('El cliente ' || v_customer_name || ' ES REGULAR');
    elsif v_cant_ordenes < 7 then
        dbms_output.put_line('El cliente ' || v_customer_name || ' ES BUENO');
    else
        dbms_output.put_line('El cliente ' || v_customer_name || ' ES MUY BUENO');
    end if;

end
 
/*
6. Ingresar un número de departamento n y mostrar el nombre del departamento y la cantidad de empleados que trabajan en él. 

Si no tiene empleados sacar un mensaje “Sin empleados” 

Si tiene entre 1 y 10 empleados desplegar “Normal” 

Si tiene más de 10 empleados, desplegar “Muchos”. 
*/

declare
    v_id_depto department.department_id%type;
    v_nombre_depto department.name%type;
    v_cant_emple number;
begin
    v_id_depto := :Ingrese_Id_Depto;

    select name
    into v_nombre_depto
    from department
    where department_id = v_id_depto;

    select count(distinct employee_id)
    into v_cant_emple
    from employee
    where department_id = v_id_depto;

    dbms_output.put_line('Departamento: ' || v_nombre_depto || ' Cantidad Empleados: ' || v_cant_emple );
    if v_cant_emple = 0 then
        dbms_output.put_line('Sin empleados');
    elsif v_cant_emple < 11 then
        dbms_output.put_line('Normal');
    else
        dbms_output.put_line('Muchos');
    end if;
end

/*
7. Ingresar un código de producto y mostrar su nombre y la cantidad de veces que se vendió. 
*/

declare
    v_id_prod product.product_id%type;
    v_nombre_prod product.description%type;
    v_cant_ventas number;
begin
    v_id_prod := :Ingrese_Id_Producto;

    select p.description, count(i.item_id)
    into v_nombre_prod, v_cant_ventas
    from product p
    inner join item i
    on p.product_id = i.product_id
    where p.product_id = v_id_prod
    group by p.description;

    dbms_output.put_line('Producto: ' || v_nombre_prod || ' Cantidad Veces Vendido: ' || v_cant_ventas);
end

/*
8. Definir un registro que contenga los siguientes campos: nro .de empleado, nombre del Empleado, nro de jefe, nombre del jefe. Ingresar un nro.  de empleado, completar los campos del registro y mostrarlos. 
*/

declare
    type tr_emp is record (
        id_empleado employee.employee_id%type,
        nombre_empleado employee.first_name%type,
        id_jefe employee.employee_id%type,
        nombre_jefe employee.first_name%type
    );

    r_emp tr_emp;
    v_id_emple employee.employee_id%type;
begin
    v_id_emple := :Ingrese_id_Empleado;

    select e.employee_id, e.first_name, e.manager_id, m.first_name
    into r_emp.id_empleado, r_emp.nombre_empleado, r_emp.id_jefe, r_emp.nombre_jefe
    from employee e
    inner join employee m
    on e.manager_id = m.employee_id
    where e.employee_id = v_id_emple;
    

    dbms_output.put_line('Id_Empleado: ' || r_emp.id_empleado || ' Nombre_Empleado: ' || r_emp.nombre_empleado || ' Id_Jefe: ' || r_emp.id_jefe || ' Nombre_Jefe: ' || r_emp.nombre_jefe);
end;

/*
9. Crear un bloque que pida un número de empleado y muestre su apellido y nombre y tantos ‘*’ como resulte de dividir su salario por 100. 

Ej: empleado 7900 gana 950, entonces muestro ********* 
*/

declare
    v_id_emple employee.employee_id%type;
    v_nombre_emple employee.first_name%type;
    v_apellido_emple employee.last_name%type;
    v_salario_emple employee.salary%type;
    v_i number := 0;
    v_cant_loops number := 0;
    v_asteriscos varchar2(1000);
begin
    v_id_emple := :Ingrese_Id_Empleado;

    select first_name, last_name, salary
    into v_nombre_emple, v_apellido_emple, v_salario_emple
    from employee
    where employee_id = v_id_emple;

    dbms_output.put_line('El empleado ' || v_nombre_emple || ' ' || v_apellido_emple || ' con id ' || v_id_emple || ' gana ' || v_salario_emple);

    v_cant_loops := floor(v_salario_emple / 100);
    while v_i < v_cant_loops loop
        v_asteriscos := v_asteriscos || '*';
        v_i := v_i + 1;
    end loop;

    dbms_output.put_line(v_asteriscos || '(' || v_i || ')');
    
end

/*
10. Crear un bloque anónimo para desplegar los primeros n números múltiplos de 3. El valor de n debe ingresarse por pantalla usando una variable de sustitución del SqlDeveloper. Si n >10  desplegar un mensaje de advertencia y terminar el bloque.  
*/

declare
    v_cant_multiplos number(3);
    v_multiplo number(10) := 3;
    v_i number(3) := 1;
begin
    v_cant_multiplos := :Ingresar_Cantidad_Multiplos;

    if v_cant_multiplos > 10 then
        raise_application_error(-20001, 'Ha ingresado un valor máximo muy grande. Ingrese un valor menor o igual a 10.');
    end if;

    while v_i <= v_cant_multiplos loop
        dbms_output.put_line(v_multiplo);
        v_multiplo := v_multiplo + 3;
        v_i := v_i + 1;
    end loop;
end;
