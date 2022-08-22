-- # Insert Into
-- El profesor recomienda siempre aclarar los campos
/*
insert into
    tabla (campo1, campo2, campo3, etc)
values
    (valor1, valor2, valor3, etc)
*/

-- Sin aclarar campos
-- Por default tiene que matchear todos los values con todas las columnas de la tabla

insert into
    department
values
    (55, 'Prueba', 122)

-- Aclarando campos

insert into
    department (department_id, name, location_id)
values
    (58, 'Prueba', 122)

insert into
    department (department_id, name, location_id)
values
    (59, 'Prueba', 122)

-- Verificación de la inserción

select *
from department
where department_id = 55

select *
from department
where department_id = 58

select *
from department
where department_id = 59

select *
from department
where department_id in (55, 58, 59)

select *
from department
where name = 'Prueba'

select *
from department
where name like 'Prueba'

select *
from department
where location_id = 122

-- # Delete
-- Consejo: siempre empezar por el where del Delete

delete
from department
where department_id = 58

delete
from department
where name = 'Prueba'

-- # Update
/*
update <<tabla>>
set campo1 = valor1,
    campo2 = valor2,
    etc.
<<condiciones>>
*/

update department
set location_id = 167
where name = 'Hola'

update department
set location_id = 122
where name = 'Prueba'

-- Como la location_id 155 no existe en la tabla location
-- rompe la integridad referencial
/*
update department
set location_id = 155
where name = 'Prueba'
*/

-- # Join

select d.department_id, d.name, l.regional_group
from department d,
    location l
where d.location_id = l.location_id

-- con inner join

select d.department_id, d.name, l.regional_group
from department d
inner join location l
on d.location_id = l.location_id

-- # Commit y Rollback

/*
savepoint 1 -> guarda determinados puntos y luego puedo volver a ese punto.
commit; -> cuando se ejecuta esta sentencia entonces se aplican todas las transaciones indicadas anteoriormente.
rollback; -> mientras no se aplique un commit, uno puede realizar un rollback.
*/

/*
savepoint 1
oper 1
oper 2
savepoint 2
oper 3
*/

-- # Bloques Anónimos
-- No tiene nombre y no se almacena en la base de datos
-- Tiene tres áreas:
-- ## Área Declarativa (optativa)
/*
declare
    <<variables>> -> v_nombre o vr_nombre (variable record)
    <<constantes>> -> c_nombre
    <<tipos>> -> t_nombre
    <<cursores>>
*/
-- El profesor nos pasó buenas prácticas para los nombres de las variables
-- ## Área Ejecución (obligatoria)
/*
begin
 null
end
*/
-- (null -> no se ejecuta nada)
-- cada sentencia dentro de un bloque se debe terminar con ';'
-- ## Área Manejo de Errores(optativa)
/*
...
*/

declare
 v_nombre varchar2(15) default 'Pedro'; --> si no le pongo valor entonces pone el default
 v_edad number(2);
 v_fecha date := sysdate; --> defino la variable de tipo date y le asigno la fecha del sistema
 v_encontre boolean;
 v_precio number(6,2); --> 6 digitos y 2 son decimales
 c_iva constant number(3, 2) := 0.21;
 v_nom employee.first_name%type; --> %type nos da el mismo tipo que el campo que seleccioné
 vr_emple employee%rowtype; --> %rowtype nos da el mismo tipo que una fila de la tabla que elegí (permite almacenar 1 registro)
 -- Los vr son los tipo record
begin
 -- v_edad := :Edad; --> Abre pantalla para ingresar un valor a Edad y luego se lo asigna. (lo comenté porque estaba tirando un error, algo de configuración)
 dbms_output.put_line('Edad: ' || v_edad); --> imprime línea por consola; concateno string con variable;

 v_precio := 100;
 dbms_output.put_line('Precio: ' || v_precio || '+' || v_precio * c_iva);

 v_nombre := 'Maria';
 dbms_output.put_line('Nombre: ' || v_nombre);

 v_nombre := 'Pepe';
 dbms_output.put_line('Nombre: ' || v_nombre);
 dbms_output.put_line('Fecha: ' || v_fecha);
 
 null; --> No hace nada, pero se ejecuta.

 vr_emple.first_name := 'Jose';
 vr_emple.salary := 1500;
 vr_emple.commission := 500;

 dbms_output.put_line(vr_emple.first_name || ' ' || vr_emple.salary || ' ' || vr_emple.commission);

end


-- # Ejercicio
-- Usando un bloque anónimo, ingresar un id de departamento y un nombre utilizando variables de sustitución y luego crear el mismo.
declare
 v_department_id number(2,0);
 v_nombre varchar2(14);
begin
 v_department_id := :Id_Departamento;
 v_nombre := :Nombre;
 dbms_output.put_line('Id_Departamento: ' || v_department_id);
 dbms_output.put_line('Nombre: ' || v_nombre);

 insert into department (department_id, name, location_id)
 values (v_department_id, v_nombre, 122);
end

select *
from department
where department_id = 60

delete from department where department_id = 60

-- Resolución en grupo
declare
 v_id department.department_id%type;
 v_nom department.name%type;
begin
 v_id := :Id_Departamento;
 v_nom := :Nombre;

 -- como location_id es nullable entonces no hace falta
 insert into department (department_id, name)
 values (v_id, v_nom);

 dbms_output.put_line(v_id || ' ' || v_nom);
end
