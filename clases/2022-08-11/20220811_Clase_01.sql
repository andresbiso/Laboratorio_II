select * from Employee

select *
from Department

select distinct name
from Department

select first_name, last_name
from employee
where department_id = 30

select *
from employee
where department_id = 30
and salary > 1500

select *
from employee
where department_id = 30
and salary > 1500
order by first_name

select *
from employee e, department d
where e.department_id = d.department_id
order by first_name

select first_name, last_name, d.department_id, name
from employee e, department d
where e.department_id = d.department_id
order by first_name

select *
from product
where description like 'ACE%'

select *
from product
where description like '_B%'

select *
from product
where description like '%TENNIS%'

select *
from product
where product_id < 100900

select *
from employee
where department_id in (10,20)

select * from salary_grade

select *
from employee e,
    salary_grade sg
where e.salary between sg.lower_bound and sg.upper_bound

select first_name, last_name, salary, sg.grade_id
from employee e,
    salary_grade sg
where e.salary between sg.lower_bound and sg.upper_bound

-- Concatenar columnas
select first_name || ' ' || last_name nombre_completo
from employee

select *
from employee
where commission is not null

select *
from employee
where commission is null

-- Join
select *
from employee e,
    employee j
where e.manager_id = j.employee_id

select j.employee_id, j.first_name, j.last_name, e.employee_id, e.first_name, e.last_name
from employee e,
    employee j
where e.manager_id = j.employee_id

select j.employee_id, j.first_name, j.last_name, e.employee_id, e.first_name, e.last_name
from employee e,
    employee j
where e.manager_id = j.employee_id
order by j.last_name, e.last_name

select d.department_id, name, count(e.employee_id) 
from employee e,
    department d
where e.department_id = d.department_id
group by d.department_id, name

-- Outer Join
select d.department_id, name, count(e.employee_id) 
from employee e,
    department d
where e.department_id (+) = d.department_id
group by d.department_id, name

select d.department_id, name, count(e.employee_id) 
from employee e,
    department d
where e.department_id (+) = d.department_id
group by d.department_id, name
having count(e.employee_id) < 3

-- Funciones
-- Usamos tabla dummy dual

select upper('hola mundo')
from dual
	
select * from dual

select lower('hola mundo')
from dual

-- Hace uppercase la primera letra de cada palabra
select initcap('hola mundo')
from dual

-- substring
select substr('hola mundo', 3, 4)
from dual

select trim('       hola mundo     ')
from dual

-- Padding a derecha
select rpad('hola mundo', 20, '-')
from dual

-- Padding a izquierda
select lpad('hola mundo', 20, '-')
from dual

select round(125.88)
from dual
	
select round(125.888, 2)
from dual
	
select trunc(125.88, 2)
from dual

select trunc(125.88, 1)
from dual

-- Round solo parte entera
select round(125.888, -1)
from dual

-- Truncate que deja un solo dígito decimal
select trunc(125.88, 1)
from dual

-- Este trunc solo deja la parte entera
select trunc(125.88)
from dual

-- Dates a string
select to_char(sysdate)
from dual

select to_char(sysdate, 'dd-mm-yyyy hh24:mi')
from dual

select to_char(sysdate, 'yyyy')
from dual

-- Number a string
select to_char(125.25)
from dual

-- String a Number
-- tuvimos que usar la ',' ya que se tiene que poner con el formato que se muestra por pantalla para la configuración de es dispositivo.
select to_number('326,18')
from dual

select to_char(125.25)
from dual

-- Indicamos como tiene que parsear el string para pasarlo a fecha
select to_date('01/02/2003', 'dd/mm/yyyy')
from dual

select to_char(to_date('01/02/2003', 'dd/mm/yyyy'), 'dd-mm-yyyy hh24:mi')
from dual

select to_char(sysdate,'dd')
from dual

select to_char(sysdate,'month')
from dual

select to_char(sysdate,'dd')
from dual

select to_char(sysdate,'ddd')
from dual

select first_name, last_name, salary, commission
from employee

-- Suma pero perdemos el valor si hay un nulo en commission
select first_name, last_name, salary, commission, salary + comission total
from employee


-- Suma y no perdemos el valor si hay un nulo en comission
select first_name, last_name, salary, commission, salary + nvl(commission, 0) total
from employee

-- El decode es un caso de CASE
-- decode(columna, (valor, valor reemplazo) | (valor default)?)
-- Valor default es opcional
select department_id, name, decode(location_id, 122, 'Mar del Plata',
                                                124, 'Cordoba',
                                                'Otra')
from department

select department_id, name, decode(location_id, 122, 'Mar del Plata',
                                                124, 'Cordoba',
                                                location_id)
from department

-- Ejemplo con subselect
-- Obtener los empleados cuyo salario es mayor al promedio para el departamento al cual pertenecen
select first_name, last_name, salary
from employee e
where salary > (select avg(salary)
                from employee s
                where e.department_id = s.department_id)