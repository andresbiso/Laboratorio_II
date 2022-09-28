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

select first_name || ' ' || middle_initial || ' ' || last_name
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
    v_dep_id department.location_id%type;
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
8. Mostrar el nombre y salario de los empleados que no tienen jefe. 
*/

select first_name || ' ' || last_name, salary
from employee
where manager_id is null


/*
9. Mostrar el nombre de los empleados, su comisión y un cartel que diga ¨Sin comisión¨ para aquellos empleados que tienen su comisión en nulo. 
*/

select first_name || ' ' || last_name, decode(nvl(commission, 0), 0, 'Sin comisión', commission)
from employee

/*OR*/

select first_name , last_name , nvl(to_char(commission),'SIN COMISIÓN')
from employee;

/*
10. Mostrar el nombre completo de los empleados, el número de departamento y el nombre del departamento donde trabajan. 
*/

select e.first_name || ' ' || e.middle_initial || ' ' || e.last_name nombre_completo, d.department_id, d.name
from employee e
inner join department d
on e.department_id = d.department_id

/*
11. Mostrar el nombre y apellido, la función que ejercen, el nombre del departamento y el salario de todos los empleados ordenados por su apellido. 
*/

select e.first_name || ' ' || e.last_name nombre_completo, j.function, d.name nombre_departamento, e.salary
from employee e
inner join job j
on e.job_id = j.job_id
inner join department d
on e.department_id = d.department_id
order by e.last_name

/*
12. Para todos los empleados que cobran comisión, mostrar su nombre, el nombre del departamento donde trabajan y el nombre de la región a la que pertenece el departamento. 
*/

select e.first_name || ' ' || e.last_name nombre_completo, d.name nombre_departamento, l.regional_group region
from employee e
inner join department d
on e.department_id = d.department_id
inner join location l
on d.location_id = l.location_id
where e.commission is not null

/*
13. Para cada empleado mostrar su id, apellido, salario y grado de salario. 
*/

select e.first_name, e.last_name, salary, sg.grade_id
from employee e, salary_grade sg
where e.salary between sg.lower_bound and sg.upper_bound

/*
14. Mostrar el número y nombre de cada empleado junto con el número de empleado y nombre de su jefe. 
*/

select e.employee_id, e.first_name || ' ' || e.last_name nombre_completo, m.employee_id manager_id, m.first_name || ' ' || m.last_name nombre_completo_jefe
from employee e inner join employee m
on m.employee_id = e.manager_id

/*
15. Modificar el ejercicio anterior para mostrar también aquellos empleados que no tienen jefe.  
*/

select e.employee_id, e.first_name || ' ' || e.last_name nombre_completo, m.employee_id manager_id, m.first_name || ' ' || m.last_name nombre_completo_jefe
from employee e left join employee m
on m.employee_id = e.manager_id

/*
16. Mostrar las órdenes de venta, el nombre del cliente al que se vendió y la descripción  de los productos. Ordenar la  consulta por nro. de orden. 
*/

select so.order_id, c.name, p.description
from sales_order so
inner join customer c
on so.customer_id = c.customer_id
inner join item i
on so.order_id = i.order_id
inner join product p
on i.product_id = p.product_id
order by order_id

/*
17. Mostrar la cantidad de clientes. 
*/

select count(distinct c.customer_id)
from customer c

/*
18. Mostrar la cantidad de clientes del estado de Nueva York (NY). 
*/

select count(distinct c.customer_id)
from customer c
where c.state = 'NY'

/*
19. Mostrar la cantidad de empleados que son jefes. Nombrar a la columna JEFES. 
*/


select count(distinct m.employee_id) JEFES
from employee e
inner join employee m on e.manager_id = m.employee_id

/*
20. Mostrar toda la información del empleado más antiguo. 
*/

select * from employee
where hire_date = (select min(hire_date) from employee)

/*
21. Generar un listado con el nombre completo de los empleados, el salario, y el nombre de su departamento para todos los empleados que tengan el mismo cargo que John Smith. Ordenar la salida por salario y apellido. 
*/

select e.first_name || ' ' || e.middle_initial || ' ' || e.last_name Nombre_Completo, e.salary Salario, d.name Nombre_Departamento
from employee e
inner join department d on e.department_id = d.department_id
where e.job_id = (select job_id from employee
where upper(first_name) = upper('john') AND upper(last_name) = upper('smith'))
order by e.salary, e.last_name

/*
22. Seleccionar los nombres completos, el nombre del departamento y el salario de aquellos empleados que ganan más que el promedio de salarios. 
*/

select e.first_name || ' ' || e.middle_initial || ' ' || e.last_name Nombre_Completo, d.name Nombre_Departamento, e.salary Salario
from employee e
inner join department d on e.department_id = d.department_id
where e.salary > (select avg(salary) from employee)

/*
23. Mostrar los datos de las órdenes máxima y mínima. 
*/

select *
from sales_order
where order_id = (select max(order_id) from sales_order) or order_id = (select min(order_id) from sales_order)

/*
24. Mostrar la cantidad de órdenes agrupadas por cliente.  
*/

select count(distinct order_id), customer_id
from sales_order
group by customer_id

/*
25. Modificar el ejercicio anterior para desplegar también el nombre y teléfono del cliente.  
*/

select count(distinct so.order_id), c.customer_id, c.name, c.area_code, c.phone_number
from sales_order so
inner join customer c
on so.customer_id = c.customer_id
group by c.customer_id, c.name, c.area_code, c.phone_number

/*
26. Mostrar aquellos empleados que tienen dos ó más personas a su cargo. 
*/

select m.first_name || ' ' || m.middle_initial || ' ' || m.last_name nombre_completo, count(distinct e.employee_id) personas_a_cargo
from employee e
inner join employee m
on e.manager_id = m.employee_id
group by m.first_name, m.middle_initial, m.last_name
having count(distinct e.employee_id) > 2


/*
27. Desplegar el nombre del empleado más antiguo y del empleado más nuevo, (según su fecha de ingreso). 
*/

select first_name || ' ' || middle_initial || ' ' || last_name nombre_completo, hire_date
from employee
where hire_date = (select max(hire_date) from employee) OR hire_date = (select min(hire_date) from employee)

/*
28. Mostrar la cantidad de empleados que tiene los departamentos 20 y 30. 
*/

select count(distinct employee_id) cant_empleados, department_id
from employee
where department_id in (20, 30)
group by department_id

/*
29. Mostrar el promedio de salarios de los empleados de los departamentos de investigación (Research). Redondear el promedio a dos decimales. 
*/

select round(avg(salary), 2)
from employee
where department_id in (select department_id from department where upper(name) = upper('research'))

/*
30. Por cada departamento desplegar su id, su nombre y el promedio de salarios (sin decimales) de sus empleados. El resultado ordenarlo por promedio. 
*/

select d.department_id, d.name, trunc(avg(e.salary))
from department d
inner join employee e
on d.department_id = e.department_id
group by d.department_id, d.name
order by avg(e.salary)

/*
31. Modificar el ejercicio anterior para mostrar solamente los departamentos que tienen más de 3 empleados. 
*/

select d.department_id, d.name, trunc(avg(e.salary)), count(e.employee_id)
from department d
inner join employee e
on d.department_id = e.department_id
group by d.department_id, d.name
having count(e.employee_id) > 3
order by avg(e.salary)

/*
32. Por cada producto (incluir todos los productos)  mostrar la cantidad de unidades que se han pedido y el precio máximo que se ha facturado.  
*/

select p.product_id, sum(i.quantity) cantidad_pedida, max(list_price) precio_maximo
from product p
inner join item i
on p.product_id = i.product_id
inner join price pr
on p.product_id = pr.product_id
group by p.product_id

/*
33. Para cada cliente mostrar nombre, teléfono, la cantidad de órdenes emitidas y la fecha de su última orden. Ordenar el resultado por nombre de cliente. 
*/

select c.name, c.phone_number, count(so.order_id) cant_ordenes_emitidas, max(so.order_date) fecha_ultima_orden
from customer c
inner join sales_order so
on c.customer_id = so.customer_id
group by c.name, c.phone_number
order by c.name

/*
34. Para todas las localidades mostrar sus datos, la cantidad de empleados que tiene y el total de salarios de sus empleados. Ordenar por cantidad de empleados. 
*/

select l.location_id, l.regional_group, count(distinct e.employee_id) cantidad_empleados, sum(e.salary) total_de_salarios
from location l
inner join department d
on l.location_id = d.location_id
inner join employee e
on d.department_id = e.department_id
group by l.location_id, l.regional_group
order by count(distinct e.employee_id)

/*
35. Mostrar los empleados que ganan más que su jefe. El reporte debe mostrar el nombre completo del empleado, su salario, el nombre del departamento al que pertenece y la función que ejerce. 
*/

select e.first_name || ' ' || e.middle_initial || ' ' || e.last_name nombre_completo, e.salary, d.name nombre_departamento, j.function funcion, m.salary salario_jefe
from employee e
inner join department d
on e.department_id = d.department_id
inner join job j
on e.job_id = j.job_id
inner join employee m
on e.manager_id = m.employee_id
where e.salary > m.salary

/*Segunda Parte: Manipulación y Definición de datos */

/*
1. Insertar un par de filas en la tabla JOB. 
*/

insert into job (job_id, function)
values (20, 'a')

/*
2. Hacer COMMIT. 
*/

-- commit;

/*
3. Eliminar las filas insertadas en la tabla JOB. 
*/

delete from job
where job_id in (20)

/*
4. Hacer ROLLBACK. 
*/

-- rollback;

/*
5. Seleccionar todas las filas de la tabla JOB. 
*/

select * from job;

/*
6. Modificar el nombre de un cliente. 
*/

-- 'VOLLYRITE'
update customer
set name = 'VOLLYRITE'
where customer_id = 102

/*
7. Crear un SAVEPOINT A. 
*/

-- savepoint a;

/*
8. Modificar el nombre de otro cliente. 
*/
-- 'JUST TENNIS'
update customer
set name = 'JUST TENNIS 2'
where customer_id = 103

/*
9. Crear un SAVEPOINT B. 
*/

-- savepoint b;

/*
10. Hacer un ROLLBACK hasta el último SAVEPOINT creado. 
*/

-- rollback to b;

/*
11. Hacer un SELECT de toda la tabla CUSTOMER. 
*/

select * from customer;

/*
12. Si quiero que la primera modificación del nombre de un cliente que hice quede asentada definitivamente en la base, debo hacer algo?. 
*/

-- Debo hacer commit;

/*
13. Eliminar el departamento 10. Se puede? Por que? 
*/

-- delete from department where department_id = 10
-- No se puede dado a que es FK y se perdería la integridad referencial

/*
14. Insertar el departamento 50, ‘EDUCATION’ en la localidad 100.  Se puede?  
*/

-- insert into department (department_id, name, location_id) values (50, 'EDUCATION', 100)
-- No se puede insetar dado a que la localidad con id 100 no existe

/*
15. Insertar el departamento 43, ‘OPERATIONS’ sin indicar la localidad. Se puede? 
*/

-- insert into department (department_id, name) values (43, 'OPERATIONS')
-- no se puede ya que por constraint de unique ya existe un departamento con id 43

/*
16. Modificar la localidad del departmento 20, para que pertenezca a la localidad 155. Se puede?  
*/

-- update department set location_id = 155 where department_id = 20
-- No se puede ya que no existe la localidad 155

/*
17. Incrementar en un 10% el salario a todos los empleados que ganan menos que el promedio de salarios. 
*/

/*update employee
set salary = salary * 1.1
where salary < (select avg(salary) from employee)*/

-- select * from employee where salary < (select avg(salary) from employee)

/*
18. A todos los clientes que han generado más de 5 órdenes, incrementar su límite de crédito en un 5%. 
*/

/*
update customer
set credit_limit = credit_limit * 1.05
Where customer_id in (select c.customer_id 
from customer c
inner join sales_order so
on c.customer_id = so.customer_id
group by c.customer_id
having count(so.customer_id) > 5)
*/

/*
19. Deshacer todos estos cambios. 
*/

/*update employee
set salary = salary / 1.1
where salary < (select avg(salary) from employee)*/

/*
update customer
set credit_limit = credit_limit / 1.05
Where customer_id in (select c.customer_id 
from customer c
inner join sales_order so
on c.customer_id = so.customer_id
group by c.customer_id
having count(so.customer_id) > 5)
*/

/*
20. Crear una tabla EMP2 con 4 columnas: id number(3), nombre varchar(10), salario number( no puede ser nulo) y depto number(2). Definir id como clave primaria, nombre debe ser único y depto debe referenciar a la tabla de Department. 
*/

/*
CREATE TABLE EMP2 (
    ID number(3),
    NOMBRE varchar2(10),
    SALARIO number(6,2),
    DEPTO number(2)
);

CREATE UNIQUE INDEX I_EMP2$ID ON EMP2 (ID);

ALTER TABLE EMP2 ADD
   CHECK (ID IS NOT NULL);
ALTER TABLE EMP2 ADD
   CHECK (ID > 0);
ALTER TABLE EMP2 ADD
   CHECK (SALARIO IS NOT NULL);
ALTER TABLE EMP2 ADD
   CHECK (SALARIO > 0);
ALTER TABLE EMP2 ADD
   PRIMARY KEY (ID);
ALTER TABLE EMP2 ADD
   FOREIGN KEY (DEPTO) REFERENCES DEPARTMENT;
ALTER TABLE EMP2 ADD
   CONSTRAINT EMP2_NOMBRE_UNIQUE UNIQUE (NOMBRE);

DROP TABLE EMP2;
*/
