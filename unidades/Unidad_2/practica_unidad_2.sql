/*Práctica Unidad 2 - PL/SQL – Bloques Anónimos */

/*
1. Determinar si estas declaraciones son correctas. (se puede crear bloques anónimos con la parte ejecutable con null;) 

V_var			number(8,3); 
V_a, V-b		number; 
V_fec_ingreso	Date := sysdate +2; 
V_nombre		varchar2(30) not null; 
V_logico		boolean default ‘TRUE’; 
*/

/*
2. Crear un bloque anónimo para desplegar los siguientes mensajes: 

‘Hola , soy ‘ username  

‘Hoy es: ‘  dd – Mon – yyyy’.  (mostrar la fecha del día) 
*/
 
/*
3. Crear un bloque Pl/Sql para consultar el salario de un empleado dado: 

Ingresar el id del empleado usando una variable de sustitución 

Desplegar por pantalla el siguiente texto: 

First_name, Last_name  tiene un salario de Salary pesos.
*/

/*
4. Escribir un bloque para desplegar todos los datos de una orden dada.  

Ingresar el nro de orden  usando una variable de sustitución 

En una variable de tipo record recuperar toda la información y desplegarla usando Dbms_output. 

Que pasa si la orden no existe? 
*/
 
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
 
/*
6. Ingresar un número de departamento n y mostrar el nombre del departamento y la cantidad de empleados que trabajan en él. 

Si no tiene empleados sacar un mensaje “Sin empleados” 

Si tiene entre 1 y 10 empleados desplegar “Normal” 

Si tiene más de 10 empleados, desplegar “Muchos”. 
*/

/*
7. Ingresar un código de producto y mostrar su nombre y la cantidad de veces que se vendió. 
*/

/*
8. Definir un registro que contenga los siguientes campos: nro .de empleado, nombre del Empleado, nro de jefe, nombre del jefe. Ingresar un nro.  de empleado, completar los campos del registro y mostrarlos. 
*/

declare
    type tr_emp is record (
        nombre  employee.first_name%type,
        apellido    employee.last_name%type,
        manager_id  employee.employee_id%type,
        manager_name  employee.first_name%type
    );

    tt_emp tr_emp;
    v_id employee.employee_id%type;
begin
    v_id := :Ingrese_id_Empleado;

    select e.first_name, e.last_name, e.manager_id, m.first_name
    into tt_emp.nombre, tt_emp.apellido, tt_emp.manager_id, tt_emp.manager_name
    from employee e, employee m
    where e.employee_id = v_id
    and e.manager_id = m.employee_id;

    dbms_output.put_line('Id Empleado: ' || v_id || ' Nombre Empleado: ' || tt_emp.nombre || ' Apellido Empleado: ' || tt_emp.apellido || ' Id Jefe: ' || tt_emp.manager_id || ' Nombre Jefe: ' || tt_emp.manager_name);
end;

/*
9. Crear un bloque que pida un número de empleado y muestre su apellido y nombre y tantos ‘*’ como resulte de dividir su salario por 100. 

Ej: empleado 7900 gana 950, entonces muestro ********* 
*/

/*
10. Crear un bloque anónimo para desplegar los primeros n números múltiplos de 3. El valor de n debe ingresarse por pantalla usando una variable de sustitución del SqlDeveloper. Si n >10  desplegar un mensaje de advertencia y terminar el bloque.  
*/



 



 