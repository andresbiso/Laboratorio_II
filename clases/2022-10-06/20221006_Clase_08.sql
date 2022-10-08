-- # Clase 8
-- # Packages
-- Agrupa procedimientos y funciones sobre un tema
-- La persona que lo utiliza solo ve la firma del procedimiento y de la función y no como está implementado
-- Un procedimiento y una función son objetos únicos.
-- Los paquetes por un lado tienen el spec, header (encabezado) o especificación y por otro lado el body (cuerpo).
-- En el encabezado puedo incluir variables, constantes o types, quedan accesibles para quienes usen el paquete (públicas).
-- Si defino variables, constantes o types en el body, son privadas al paquete (no son accesibles desde fuera).
-- No puedo tener firma de procedimientos y funciones (en el spec) sin tener un body.
-- En el body puedo tener procedimiento y funciones privados en el body del paquete sin ponerlos en el spec.
-- El nombre que ponemos en el spec y en el body tiene que ser el mismo para que lo tome correctamente.
-- Puedo tener las siguiente combinaciones:
-- -> spec con body
-- -> spec sin body (solo tengo un spec con constantes, tipos y variables)

-- No puedo tener body sin spec.

-- Ej1) Creamos con el sistema de creación de objetos en la BD de Apex un package
-- Primero generamos el spec
-- Segundo seleccionamos el spec durante la creación del body

create or replace package PA_EMPLEADOS as
    procedure pr_modif_salario (pi_emp_id employee.employee_id%type,
                               pi_salario employee.salary%type);
end;

create or replace package body PA_EMPLEADOS is
    procedure pr_modif_salario(pi_emp_id employee.employee_id%type,
                               pi_salario employee.salary%type)
    as
    begin
        update employee
        set salary = pi_salario
        where employee_id = pi_emp_id;

        -- Verifico que se haya actualizado el salario de un empleado.
        if sql%rowcount = 1 then
            dbms_output.put_line('Se modificó el salario exitosamente');
        else
            dbms_output.put_line('El empleado no existe');
        end if;
    end pr_modif_salario;
end PA_EMPLEADOS;

-- Llamamos al procedimiento del paquete
--[paquete].[objeto_del_paquete]
begin
    pa_empleados.pr_modif_salario(7369, 810);
end

begin
    -- pa_empleados.pr_modif_salario(7369, 810);
    -- Empleado que no existe
    pa_empleados.pr_modif_salario(736, 810);
end

select employee_id, salary
from employee
where employee_id = 7369;

/*
Dentro de un paquete debo declarar en orden de uso.
Ej: si tengo PR1 que usa PR2 => primero agrego en el spec a PR2 y luego agrego PR1 (sino tira error)
*/

/*
Si llamo a un paquete, este queda cargado en memoria para su uso.
Hace que posteriormente a la primera llamada se realice una ejecución más rápida
*/

-- # ONE_TIME_ONLY
/*
ONE_TIME_ONLY es un bloque anónimo que se ejecuta la primera vez que llamo al paquete y se carga en memoria
Se ubica al final de mi body
Permite, por ejemplo, inicializar variables globales.
Ejemplo 1: Estas podrían almacenar una fecha particular y toda operación hace uso de esa variable y no tiene que realizar consultas a las tablas.
Ejemplo 2: creo y cargo una tabla en memoria que tenga código y descripciones que se acceden constantemente para evitar realizar tantas consultas a las tablas.
*/
create or replace package body PA_EMPLEADOS is
    procedure pr_modif_salario(pi_emp_id employee.employee_id%type,
                               pi_salario employee.salary%type)
    as
    begin
        update employee
        set salary = pi_salario
        where employee_id = pi_emp_id;

        if sql%rowcount = 1 then
            dbms_output.put_line('Se modificó el salario exitosamente');
        else
            dbms_output.put_line('El empleado no existe');
        end if;
    end pr_modif_salario;


    /*one time only*/
    begin
        dbms_output.put_line('Primera vez');
    /*No lleva end, usa el del package*/
end PA_EMPLEADOS;

begin
    -- probamos el "on time only"
    pa_empleados.pr_modif_salario(7369, 1000);
    pa_empleados.pr_modif_salario(736, 1000);
    pa_empleados.pr_modif_salario(7369, 800);
end

select employee_id, salary
from employee
where employee_id = 7369;

/*
Podemos observar que, por como esta herramienta funciona, se muestra el mensaje cada vez que se abre sesión a la base.
*/

-- # Overloading
/*
    Dentro de un paquete si puedo tener dos procedimiento o funciones con el mismo nombre y distinta cantidad y/o tipo (varchar, number,...) de parámetros.
    Esto se denomina sobrecarga.
*/
/*Ejemplo: el dbms_output.put_line() está sobrecargado para aceptar casi todo tipo de parámetro*/

-- is o as funcionan generalmente de la misma manera

-- Ej (para este caso tratamos de reutilizar en la sobrecarga lo ya implementado en el otro procedimiento)

create or replace package PA_EMPLEADOS as
procedure pr_modif_salario (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type,
                               pi_salario employee.salary%type);

procedure pr_modif_salario (pi_emp_id employee.employee_id%type,
pi_salario employee.salary%type);
end;

create or replace package body PA_EMPLEADOS is
    procedure pr_modif_salario(pi_emp_id employee.employee_id%type,
                               pi_salario employee.salary%type)
    as
    begin
        update employee
        set salary = pi_salario
        where employee_id = pi_emp_id;

        if sql%rowcount = 1 then
            dbms_output.put_line('Se modificó el salario exitosamente');
        else
            dbms_output.put_line('El empleado no existe');
        end if;
    end pr_modif_salario;

     procedure pr_modif_salario (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type,
                               pi_salario employee.salary%type)
    as
        l_emp_id employee.employee_id%type; 
        begin
            select employee_id
            into l_emp_id
            from employee
            where upper(first_name) = upper(pi_nombre)
            and upper(last_name) = upper(pi_apellido);

            /*llamamos al procedimiento base*/
            pr_modif_salario(l_emp_id, pi_salario);
        end;

    /*one time only*/
    begin
        dbms_output.put_line('Primera vez');
end PA_EMPLEADOS;

begin
    pa_empleados.pr_modif_salario('john', 'smith', 800);
end

-- Ej2

/*Agregamos una función privada al body*/

create or replace package body PA_EMPLEADOS is

    function fu_emp_id (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type)
    return employee.employee_id%type
    is
      l_emp_id employee.employee_id%type;
    begin
            select employee_id
            into l_emp_id
            from employee
            where upper(first_name) = upper(pi_nombre)
            and upper(last_name) = upper(pi_apellido);

            return l_emp_id;
    end;

    procedure pr_modif_salario(pi_emp_id employee.employee_id%type,
                               pi_salario employee.salary%type)
    as
    begin
        update employee
        set salary = pi_salario
        where employee_id = pi_emp_id;

        if sql%rowcount = 1 then
            dbms_output.put_line('Se modificó el salario exitosamente');
        else
            dbms_output.put_line('El empleado no existe');
        end if;
    end pr_modif_salario;

     procedure pr_modif_salario (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type,
                               pi_salario employee.salary%type)
    as
        l_emp_id employee.employee_id%type; 
        begin
            l_emp_id := fu_emp_id (pi_nombre, pi_apellido);
            pr_modif_salario(l_emp_id, pi_salario);
        end;

    /*one time only*/
    begin
        dbms_output.put_line('Primera vez');
end PA_EMPLEADOS;

begin
    pa_empleados.pr_modif_salario('john', 'smith', 800);
end

-- Ej3 - Agregamos excepciones y con exception variables privadas globales a todo el body
create or replace package body PA_EMPLEADOS is
    e_emp_noex exception;
    e_emp_dupl exception;
    e_emp_otro exception;
    pragma exception_init(e_emp_noex, -20001);
    pragma exception_init(e_emp_dupl, -20002);
    pragma exception_init(e_emp_otro, -20003);

    function fu_emp_id (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type)
    return employee.employee_id%type
    is
      l_emp_id employee.employee_id%type;
    begin
            select employee_id
            into l_emp_id
            from employee
            where upper(first_name) = upper(pi_nombre)
            and upper(last_name) = upper(pi_apellido);

            return l_emp_id;

            exception
                when no_data_found then
                    raise_application_error(-20001, 'Empleado no existe');
                when too_many_rows then
                    raise_application_error(-20002, 'Existe más de un empleado con el mismo nombre');
                when others then
                    raise_application_error(-20003, 'Error inesperado: ' || sqlerrm);
    end;

    procedure pr_modif_salario(pi_emp_id employee.employee_id%type,
                               pi_salario employee.salary%type)
    as
    begin
        update employee
        set salary = pi_salario
        where employee_id = pi_emp_id;

        if sql%rowcount = 1 then
            dbms_output.put_line('Se modificó el salario exitosamente');
        else
            dbms_output.put_line('El empleado no existe');
        end if;
    end pr_modif_salario;

     procedure pr_modif_salario (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type,
                               pi_salario employee.salary%type)
    as
        l_emp_id employee.employee_id%type; 
        begin
            l_emp_id := fu_emp_id (pi_nombre, pi_apellido);
            pr_modif_salario(l_emp_id, pi_salario);

            exception
                when e_emp_noex then
                    dbms_output.put_line('Empleado no existe');
                when e_emp_dupl then
                    dbms_output.put_line('Existe más de un empleado con el mismo nombre');
                when e_emp_otro then
                    dbms_output.put_line('Error inesperado: ' || sqlerrm);
        end;

    /*one time only*/
    begin
        dbms_output.put_line('Primera vez');

end PA_EMPLEADOS;

begin
    pa_empleados.pr_modif_salario('john', 'smith', 800);
    pa_empleados.pr_modif_salario('john', 'smiths', 800);
end

-- Ej: agregar procedimiento que recibe id de empleado y devuelve el nombre y el apellido del jefe en un parámetro de salida todo junto
create or replace package PA_EMPLEADOS as
    procedure pr_modif_salario (pi_nombre employee.first_name%type,
                                pi_apellido employee.last_name%type,
                                pi_salario employee.salary%type);

    procedure pr_modif_salario (pi_emp_id employee.employee_id%type,
    pi_salario employee.salary%type);
    procedure pr_obtener_jefe (pi_emp_id in employee.employee_id%type,
                        po_nombre_jefe out varchar2);
end;

create or replace package body PA_EMPLEADOS is
    e_emp_noex exception;
    e_emp_dupl exception;
    e_emp_otro exception;
    pragma exception_init(e_emp_noex, -20001);
    pragma exception_init(e_emp_dupl, -20002);
    pragma exception_init(e_emp_otro, -20003);

    function fu_emp_id (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type)
    return employee.employee_id%type
    is
      l_emp_id employee.employee_id%type;
    begin
            select employee_id
            into l_emp_id
            from employee
            where upper(first_name) = upper(pi_nombre)
            and upper(last_name) = upper(pi_apellido);

            return l_emp_id;

            exception
                when no_data_found then
                    raise_application_error(-20001, 'Empleado no existe');
                when too_many_rows then
                    raise_application_error(-20002, 'Existe más de un empleado con el mismo nombre');
                when others then
                    raise_application_error(-20003, 'Error inesperado: ' || sqlerrm);
    end;

    procedure pr_modif_salario(pi_emp_id employee.employee_id%type,
                               pi_salario employee.salary%type)
    as
    begin
        update employee
        set salary = pi_salario
        where employee_id = pi_emp_id;

        if sql%rowcount = 1 then
            dbms_output.put_line('Se modificó el salario exitosamente');
        else
            dbms_output.put_line('El empleado no existe');
        end if;
    end pr_modif_salario;

     procedure pr_modif_salario (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type,
                               pi_salario employee.salary%type)
    as
        l_emp_id employee.employee_id%type; 
        begin
            l_emp_id := fu_emp_id (pi_nombre, pi_apellido);
            pr_modif_salario(l_emp_id, pi_salario);

            exception
                when e_emp_noex then
                    dbms_output.put_line('Empleado no existe');
                when e_emp_dupl then
                    dbms_output.put_line('Existe más de un empleado con el mismo nombre');
                when e_emp_otro then
                    dbms_output.put_line('Error inesperado: ' || sqlerrm);
        end;

    procedure pr_obtener_jefe(pi_emp_id in employee.employee_id%type,
                        po_nombre_jefe out varchar2)
    as
    begin
        select m.first_name || ' ' || m.last_name
        into po_nombre_jefe
        from employee e
        inner join employee m
        on e.manager_id = m.employee_id
        where e.employee_id = pi_emp_id;
         
        exception
            when no_data_found then
                dbms_output.put_line('El empleado no existe');
            when others then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end;

    /*one time only*/
    begin
        dbms_output.put_line('Primera vez');
end PA_EMPLEADOS;

declare
    v_nombre_jefe varchar2(100);
begin
    pa_empleados.pr_obtener_jefe(7369, v_nombre_jefe);
    dbms_output.put_line(v_nombre_jefe);
end