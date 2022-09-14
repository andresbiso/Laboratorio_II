/*Práctica - Unidad 1 - SQL*/
/*Primera Parte: Consultas*/
/*
1. Consultar las tablas existentes en su cuenta, ver su estructura y contenido. (Usar Ventana de Conexiones del SqlDeveloper). 
*/

-- Abrir el Object Browser del Oracle Apex.

/*
2. Mostrar las distintas funciones (jobs) que pueden cumplir los empleados. 
*/

select function
from Job

/*
3. Desplegar el nombre completo de todos los empleados (Ej: Adam, Diane) ordenados por apellido. 
*/

select first_name || ' ' || last_name
from employee
order by last_name

/*
4. Mostrar el nombre y el apellido de los empleados que ganan entre $1500 y $2850. 
*/

select first_name, last_name, salary
from employee
where salary between 1500 AND 2850

/*
5. Mostrar el nombre y la fecha de ingreso de todos los empleados que ingresaron en el año 2006. 
*/

select first_name, last_name, to_char(hire_date, 'yyyy')
from employee
where to_char(hire_date, 'yyyy') = 2006

/*
6. Mostrar el id y nombre de todos los departamentos de la localidad 122.  
*/

select department_id, name
from department
where location_id = 122

/*
7. Modificar el ejercicio anterior para que la localidad pueda ser ingresada en el momento de efectuar la consulta.  
*/

declare 
    v_dep_id   department.location_id%TYPE;
begin
    v_dep_id := :Ingrese_id_localidad;
    select department_id, name
    from department
    where location_id = v_dep_id;
exception
    when no_data_found then
        dbms_output.put_line('No existe el departamento');
end;

/*
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
*/

/*
8. Mostrar el nombre y salario de los empleados que no tienen jefe. 
*/


/*
9. Mostrar el nombre de los empleados, su comisión y un cartel que diga ¨Sin comisión¨ para aquellos empleados que tienen su comisión en nulo. 
*/
select first_name , last_name , nvl(to_char(commission),'SIN COMISION')
from employee;

/*
10. Mostrar el nombre completo de los empleados, el número de departamento y el nombre del departamento donde trabajan. 
*/


/*
11. Mostrar el nombre y apellido, la función que ejercen, el nombre del departamento y el salario de todos los empleados ordenados por su apellido. 
*/


/*
12. Para todos los empleados que cobran comisión, mostrar su nombre, el nombre del departamento donde trabajan y el nombre de la región a la que pertenece el departamento. 
*/


/*
13. Para cada empleado mostrar su id, apellido, salario y grado de salario. 
*/


/*
14. Mostrar el número y nombre de cada empleado junto con el número de empleado y nombre de su jefe. 
*/


/*
15. Modificar el ejercicio anterior para mostrar también aquellos empleados que no tienen jefe.  
*/


/*
16. Mostrar las órdenes de venta, el nombre del cliente al que se vendió y la descripción  de los productos. Ordenar la  consulta por nro. de orden. 
*/


/*
17. Mostrar la cantidad de clientes. 
*/


/*
18. Mostrar la cantidad de clientes del estado de Nueva York (NY). 
*/


/*
19. Mostrar la cantidad de empleados que son jefes. Nombrar a la columna JEFES. 
*/


/*
20. Mostrar toda la información del empleado más antiguo. 
*/


/*
21. Generar un listado con el nombre completo de los empleados, el salario, y el nombre de su departamento para todos los empleados que tengan el mismo cargo que John Smith. Ordenar la salida por salario y apellido. 
*/


/*
22. Seleccionar los nombres completos, el nombre del departamento y el salario de aquellos empleados que ganan más que el promedio de salarios. 
*/


/*
23. Mostrar los datos de las órdenes máxima y mínima. 
*/
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

/*
24. Mostrar la cantidad de órdenes agrupadas por cliente.  
*/


/*
25. Modificar el ejercicio anterior para desplegar también el nombre y teléfono del cliente.  
*/


/*
26. Mostrar aquellos empleados que tienen dos ó más personas a su cargo. 
*/
select m.last_name
from employee e , employee m
where e.manager_id = m.employee_id
group by m.last_name , m.employee_id
having count(e.employee_id) > 2;

/*
27. Desplegar el nombre del empleado más antiguo y del empleado más nuevo, (según su fecha de ingreso). 
*/


/*
28. Mostrar la cantidad de empleados que tiene los departamentos 20 y 30. 
*/


/*
29. Mostrar el promedio de salarios de los empleados de los departamentos de investigación (Research). Redondear el promedio a dos decimales. 
*/


/*
30. Por cada departamento desplegar su id, su nombre y el promedio de salarios (sin decimales) de sus empleados. El resultado ordenarlo por promedio. 
*/


/*
31. Modificar el ejercicio anterior para mostrar solamente los departamentos que tienen más de 3 empleados. 
*/


/*
32. Por cada producto (incluir todos los productos)  mostrar la cantidad de unidades que se han pedido y el precio máximo que se ha facturado.  
*/


/*
33. Para cada cliente mostrar nombre, teléfono, la cantidad de órdenes emitidas y la fecha de su última orden. Ordenar el resultado por nombre de cliente. 
*/


/*
34. Para todas las localidades mostrar sus datos, la cantidad de empleados que tiene y el total de salarios de sus empleados. Ordenar por cantidad de empleados. 
*/


/*
35. Mostrar los empleados que ganan más que su jefe. El reporte debe mostrar el nombre completo del empleado, su salario, el nombre del departamento al que pertenece y la función que ejerce. 
*/


/*Segunda Parte: Manipulación y Definición de datos */

/*
1. Insertar un par de filas en la tabla JOB. 
*/


/*
2. Hacer COMMIT. 
*/


/*
3. Eliminar las filas insertadas en la tabla JOB. 
*/


/*
4. Hacer ROLLBACK. 
*/


/*
5. Seleccionar todas las filas de la tabla JOB. 
*/


/*
6. Modificar el nombre de un cliente. 
*/


/*
7. Crear un SAVEPOINT A. 
*/


/*
8. Modificar el nombre de otro cliente. 
*/


/*
9. Crear un SAVEPOINT B. 
*/


/*
10. Hacer un ROLLBACK hasta el último SAVEPOINT creado. 
*/


/*
11. Hacer un SELECT de toda la tabla CUSTOMER. 
*/


/*
12. Si quiero que la primera modificación del nombre de un cliente que hice quede asentada definitivamente en la base, debo hacer algo?. 
*/


/*
13. Eliminar el departamento 10. Se puede? Por que? 
*/


/*
14. Insertar el departamento 50, ‘EDUCATION’ en la localidad 100.  Se puede?  
*/


/*
15. Insertar el departamento 43, ‘OPERATIONS’ sin indicar la localidad. Se puede? 
*/


/*
16. Modificar la localidad del departmento 20, para que pertenezca a la localidad 155. Se puede?  
*/


/*
17. Incrementar en un 10% el salario a todos los empleados que ganan menos que el promedio de salarios. 
*/


/*
18. A todos los clientes que han generado más de 5 órdenes, incrementar su límite de crédito en un 5%. 
*/


/*
19. Deshacer todos estos cambios. 
*/


/*
20. Crear una tabla EMP2 con 4 columnas: id number(3), nombre varchar(10), salario number( no puede ser nulo) y depto number(2). Definir id como clave primaria, nombre debe ser único y depto debe referenciar a la tabla de Department. 
*/
