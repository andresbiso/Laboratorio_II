-- # Repaso de clase 3
/*
La tabla tiene campos y registros
    c1  c2  c3  c4
reg|__|__|__|__|
reg|__|__|__|__|
reg|__|__|__|__|
reg|__|__|__|__|
reg|__|__|__|__|
c1: id
c2: nombre
...
La idea de las variables tipo record es poder almacenar todo un registro.
La idea de las variables tipo table es poder traer una tabla a memoria.
*/
/*
t_emp.exists(posición): existe registro en posición
*/

-- # Ej8 - Práctica 2
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

-- # Excepciones
/*
    Predefinidas y No Predefinidas son del motor
*/
-- ## Excepciones Predefinidas
/*
no_data_found
too_many_rows
dup_val_on_index
value_error
zero_divide
*/
/*
En el examen el profesor evalúa que pensemos las posibles exceptions que pueden surgir en, por ejemplo, un insert.
No debemos poner más exceptions que los que pueden surgir de esas sentencias.
*/

-- ## Excepciones No Predefinidas
/*
No tienen un nombre asociado. Se referencian por código.
*/
/*
-2291 No existe el padre
-2292 Existen hijos -> FK a otra tabla
*/

-- ## Excepciones de Usuario
-- Ej1
declare
    v_dep_name department.name%type;

begin
    select name
    into v_dep_name
    from department
    where department_id = 10;

    dbms_output.put_line(v_dep_name);

    exception
        when no_data_found then
         dbms_output.put_line('No existe el departamento');
end;

-- Ej2
declare
    v_dep_name department.name%type;

begin
    insert into department
    (department_id, name, location_id)
    values (10,'Prueba',122);

    exception
        when dup_val_on_index then
         dbms_output.put_line('Ya existe el departamento');
end;

-- Ej3
begin

    dbms_output.put_line(8/0);

    exception
        when zero_divide then
         dbms_output.put_line('Error al dividir por 0');
end;

--ej4
begin

    update price
    set list_price = 1
    where product_id = 100871;

    exception
        when others then
         dbms_output.put_line('Se produjo un error inesperado: ' || sqlerrm);
         dbms_output.put_line('Código: ' || sqlcode);
end;

-- El 'when others then' captura todos los exceptions no definidos en la parte de excepciones
-- sqlerrm: devuelve el error completo
-- sqlcode: devuelve solo el código del error

-- ej5

/*
e_fk exception; -> declaro variable de tipo exception
pragma exception_init(e_fk, -2291); -> asocio la variable a un código de excepción
*/

declare
    e_fk exception;
    pragma exception_init(e_fk, -2291);
begin

    insert
    into department
    (department_id, name, location_id)
    values
    (99, 'Prueba', 150);

    exception
        when e_fk then
         dbms_output.put_line('No existe la Localidad indicada');  
        when others then
         dbms_output.put_line('Se produjo un error inesperado: ' || sqlerrm);
         dbms_output.put_line('Código: ' || sqlcode);
end;

-- ej6

/*
    raise_application_error(-20001, 'error custom');
    -- Uno puede lanzar un error custom definido dentro de un rango de valores
*/
declare
    v_nom varchar(5);
begin
    v_nom := 'Martin';

    dbms_output.put_line('Nombre: ' || v_nom);

    exception
        when value_error then
         raise_application_error(-20015, 'El nombre ingresado es demasiado largo');
end;
