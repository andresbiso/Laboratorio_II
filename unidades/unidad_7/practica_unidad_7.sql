/* Práctica Unidad 5: Paquetes */

/*
1. Crear un paquete EMP_PACK que contenga subprogramas públicos y privados:

­ Una función privada Valida_Job (job_id) para validar si un cargo existe o no.

­ Una función privada Valida_Jefe (id) para validar si el id corresponde a un jefe existente.
(Verificar que existe en la columna manager_id de la tabla Employee).

­ Un procedimiento público: Alta_Emp que recibe como parámetros el código de empleado, nombre y apellido, cargo (job_id),
y código de su jefe (manager_id).

a. Este procedimiento debe usar las funciones Valida_Job y Valida_Jefe.

b. Las columnas Middle_initial y Commission por ahora dejarlas en nulls

c. En la columna Hire_date poner la fecha del día si no viene la fecha de ingreso por parámetro (Usar la opción Default en el parámetro)

d. El departamento en el que inicialmente se incorpora un empleado es el mismo en el que está su jefe

e. El salario del empleado inicialmente debe ser igual al salario mínimo de ese cargo y departamento.
*/

/*
2. Hacer las siguientes modificaciones al ejercicio anterior: (sobrecarga)

­ El procedimiento Alta_Emp puede recibir el nombre del cargo o el id del cargo.

Agregar una función Valida_job que recibe el nombre del cargo y devuelve su Id,
si no existe debe provocar una excepción que debe ser atrapada por el procedimiento que invoca a la función.
*/

/*
3. Crear un paquete ABM_JOB para actualizar cargos:

­ Incorporar al cuerpo los procedimientos Alta_Job y Mod_Job (ej.1 y 2 práctica 4).

­ Permitir que se puedan insertar varios cargos en una sesión. Para esto en una variable global G_id se debe guardar el máximo Job_id existente,
que debe ser inicializada en un bloque One_Time_Only.

­ Si la variable G_id es pública puede usarse externamente al paquete, por ejemplo desde un bloque anónimo:

ABM_JOB.G_id := 25;

­ Que modificación habría que hacer para que la variable G_id sea global pero no pública?

­ Agregar el procedimiento Del_Job por ahora solamente en la especificación del paquete.
Se puede? Como se puede solucionar para no modificar la especificación?
*/

/*
4. Crear un paquete CLIENTES con las siguientes consignas:

­ Una tabla Pl/Sql t_cli: con el nombre, id, teléfono y cantidad de órdenes de todos los clientes ordenados alfabéticamente.
Esta tabla debe ser cargada usando Bulk Collect en un bloque One_Time_Only.

­ Procedimiento público Lista: muestra todos los clientes existentes en la tabla.

­ Procedimiento público Lista que recibe el nombre o id de un cliente y muestra sus datos (nombre o id, teléfono y cantidad de órdenes).

­ Procedimiento público Ordenes que recibe un número y muestra todos los clientes que han generado más de esa cantidad de órdenes.

­ Función privada Valida_cli que recibe el nombre o id de un cliente y devuelve el índice de la fila en la que se encuentran sus datos en la tabla.
Si el cliente no existe provocar una excepción.
*/

/*
5. Crear un paquete SHOW_DATOS con dos procedimientos públicos:
Show_Emp y Show_Dept para desplegar los datos de los empleados y de los departamentos.

­ En una tabla Pl/Sql: cargar los nombres de las localidades.
Para esto definir una tabla LOC en memoria que sea global y pública.
Esta tabla debe ser llenada al invocar el paquete por primera vez.
Usar el código de localidad como índice de la tabla y en una columna de tipo Location.regional_group%Type poner los nombres de las localidades.

­ El procedimiento Show_Dept debe mostrar por pantalla un listado de los departamentos con el siguiente formato:

Nombre del departamento Region

ACCOUNTING New York

RESEARCH Dallas

...............................

No hacer un join entre las tablas Department y Location , sino usar la tabla Loc.

­ El procedimiento SHOW_EMP debe mostrar el siguiente listado:

Region Apellido y Nombre

NEW YORK Doyle, Jean

NEW YORK Baker , Leslie

......

DALLAS Smith , John

........

Recorrer toda la tabla LOC y por cada fila consultar sus empleados con un cursor:

select last_name || ’,’ || first_name nombre

from employee

where department_id in (select department_id from department

where location_id =LOC(i));
*/