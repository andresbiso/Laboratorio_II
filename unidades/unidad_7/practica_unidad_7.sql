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
create or replace package PA_EMP_PACK as
    procedure pr_alta_emp(pi_employee_id employee.employee_id%type,
        pi_first_name employee.first_name%type,
        pi_last_name employee.last_name%type,
        pi_job_id job.job_id%type,
        pi_manager_id employee.manager_id%type,
        pi_hire_date employee.hire_date%type default sysdate);
end;
create or replace package body PA_EMP_PACK is
    function fu_valida_job (pi_job_id job.job_id%type)
        return boolean
    is
        l_job_id job.job_id%type;

        begin
            select job_id
            into l_job_id
            from job
            where job_id = pi_job_id;

            return true;

            exception
                when no_data_found then
                    return false;
                when others then
                    return false;
        end;

    function fu_valida_jefe (pi_manager_id employee.manager_id%type)
        return boolean
    is
        l_manager_id number := 0;

        begin
            select count(employee_id)
            into l_manager_id
            from employee
            where manager_id = pi_manager_id;

            return l_manager_id > 0;

            exception
                when no_data_found then
                    return false;
                when others then
                    return false;
        end;

    procedure pr_alta_emp(pi_employee_id employee.employee_id%type,
        pi_first_name employee.first_name%type,
        pi_last_name employee.last_name%type,
        pi_job_id job.job_id%type,
        pi_manager_id employee.manager_id%type,
        pi_hire_date employee.hire_date%type default sysdate)
    as
        emplo_dept employee.department_id%type;
        emplo_salary employee.salary%type;

        e_job_noex exception;
        e_manager_noex exception;
        pragma exception_init(e_job_noex, -20001);
        pragma exception_init(e_manager_noex, -20002);
    begin
        if not fu_valida_job(pi_job_id) then
            raise_application_error(-20001, 'El job ingresado no existe');
        end if;
        if not fu_valida_jefe(pi_manager_id) then
             raise_application_error(-20002, 'El jefe ingresado no existe');
        end if;

        select department_id
        into emplo_dept
        from employee
        where employee_id = pi_manager_id;

        select min(salary)
        into emplo_salary
        from employee
        where job_id = pi_job_id and department_id = emplo_dept;

        insert into employee (employee_id, last_name, first_name, middle_initial, job_id, manager_id, hire_date, salary, commission, department_id)
        values (pi_employee_id, pi_last_name, pi_first_name, null, pi_job_id, pi_manager_id, pi_hire_date, emplo_salary, null, emplo_dept);
        
         dbms_output.put_line('El empleado fue creado con éxito');

        exception
            when e_job_noex then
                dbms_output.put_line('El job ingresado no existe');
            when e_manager_noex then
                dbms_output.put_line('El jefe ingresado no existe');
            when dup_val_on_index then
                dbms_output.put_line('El empleado ya existe');
            when others then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end pr_alta_emp;
end PA_EMP_PACK;

begin
    PA_EMP_PACK.pr_alta_emp(56,'john','diaz',668,7902);
end

-- select * from employee where employee_id = 56
-- delete from employee where employee_id = 56

/*
2. Hacer las siguientes modificaciones al ejercicio anterior: (sobrecarga)

­ El procedimiento Alta_Emp puede recibir el nombre del cargo o el id del cargo.

Agregar una función Valida_job que recibe el nombre del cargo y devuelve su Id,
si no existe debe provocar una excepción que debe ser atrapada por el procedimiento que invoca a la función.
*/

create or replace package PA_EMP_PACK as
    procedure pr_alta_emp(pi_employee_id employee.employee_id%type,
        pi_first_name employee.first_name%type,
        pi_last_name employee.last_name%type,
        pi_job_id job.job_id%type,
        pi_manager_id employee.manager_id%type,
        pi_hire_date employee.hire_date%type default sysdate);

     procedure pr_alta_emp(pi_employee_id employee.employee_id%type,
        pi_first_name employee.first_name%type,
        pi_last_name employee.last_name%type,
        pi_job_func job.function%type,
        pi_manager_id employee.manager_id%type,
        pi_hire_date employee.hire_date%type default sysdate);
end;
create or replace package body PA_EMP_PACK is
    function fu_valida_job (pi_job_id job.job_id%type)
        return boolean
    is
        l_job_id job.job_id%type;

        begin
            select job_id
            into l_job_id
            from job
            where job_id = pi_job_id;

            return true;

            exception
                when no_data_found then
                    return false;
                when others then
                    return false;
        end;

    function fu_valida_job (pi_job_func job.function%type)
        return job.job_id%type
    is
        l_job_id job.job_id%type;

        begin
            select job_id
            into l_job_id
            from job
            where upper(function) = upper(pi_job_func);

            return l_job_id;

            exception
                when no_data_found then
                    raise_application_error(-20001, 'No existe el cargo');
                when too_many_rows then
                    raise_application_error(-20002, 'Existe más de un cargo con ese nombre');
                when others then
                    raise_application_error(-20003, 'Error inesperado: ' || sqlerrm);
        end;

    function fu_valida_jefe (pi_manager_id employee.manager_id%type)
        return boolean
    is
        l_manager_id number := 0;

        begin
            select count(employee_id)
            into l_manager_id
            from employee
            where manager_id = pi_manager_id;

            return l_manager_id > 0;

            exception
                when no_data_found then
                    return false;
                when others then
                    return false;
        end;

    procedure pr_alta_emp(pi_employee_id employee.employee_id%type,
        pi_first_name employee.first_name%type,
        pi_last_name employee.last_name%type,
        pi_job_id job.job_id%type,
        pi_manager_id employee.manager_id%type,
        pi_hire_date employee.hire_date%type default sysdate)
    as
        emplo_dept employee.department_id%type;
        emplo_salary employee.salary%type;

        e_job_noex exception;
        e_manager_noex exception;
        pragma exception_init(e_job_noex, -20001);
        pragma exception_init(e_manager_noex, -20002);
    begin
        if not fu_valida_job(pi_job_id) then
            raise_application_error(-20001, 'El job ingresado no existe');
        end if;
        if not fu_valida_jefe(pi_manager_id) then
             raise_application_error(-20002, 'El jefe ingresado no existe');
        end if;

        select department_id
        into emplo_dept
        from employee
        where employee_id = pi_manager_id;

        select min(salary)
        into emplo_salary
        from employee
        where job_id = pi_job_id and department_id = emplo_dept;

        insert into employee (employee_id, last_name, first_name, middle_initial, job_id, manager_id, hire_date, salary, commission, department_id)
        values (pi_employee_id, pi_last_name, pi_first_name, null, pi_job_id, pi_manager_id, pi_hire_date, emplo_salary, null, emplo_dept);
        
         dbms_output.put_line('El empleado fue creado con éxito');

        exception
            when e_job_noex then
                dbms_output.put_line('El job ingresado no existe');
            when e_manager_noex then
                dbms_output.put_line('El jefe ingresado no existe');
            when dup_val_on_index then
                dbms_output.put_line('El empleado ya existe');
            when others then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end pr_alta_emp;

    procedure pr_alta_emp(pi_employee_id employee.employee_id%type,
        pi_first_name employee.first_name%type,
        pi_last_name employee.last_name%type,
        pi_job_func job.function%type,
        pi_manager_id employee.manager_id%type,
        pi_hire_date employee.hire_date%type default sysdate)
    as
        emplo_dept employee.department_id%type;
        emplo_salary employee.salary%type;
        job_id job.job_id%type;

        e_no_data exception;
        e_too_many exception;
        e_other exception;
        pragma exception_init(e_no_data, -020001);
        pragma exception_init(e_too_many, -020002);
        pragma exception_init(e_other, -020003);
    begin
        job_id := fu_valida_job(pi_job_func);

        pr_alta_emp(pi_employee_id, pi_first_name, pi_last_name, job_id, pi_manager_id, pi_hire_date);

        exception
            when e_no_data then
                dbms_output.put_line('No existe el cargo');
            when e_too_many then
                dbms_output.put_line('Existe más de un cargo con ese nombre');
            when e_other then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end pr_alta_emp;
end PA_EMP_PACK;

begin
    PA_EMP_PACK.pr_alta_emp(56,'john','diaz','staff',7902);
end

-- select * from employee where employee_id = 56
-- delete from employee where employee_id = 56

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
Que modificación habría que hacer para que la variable G_id sea global pero no pública?
Se agrega la variable al obdy pero no a la especificación del paquete
*/

/*
­Agregar el procedimiento Del_Job por ahora solamente en la especificación del paquete.
Se puede?
No, si agrego un procedure a la especificación debo agregarlo al body.
Como se puede solucionar para no modificar la especificación?
Se puede agregar al body una implementación con null en el cuerpo del procedure o que devuelva un mensaje indicando que no está implementado
*/

create or replace package PA_ABM_JOB as
    procedure pr_alta_job (pi_cargo in job.function%type);
    procedure pr_mod_job (pi_id_job in job.job_id%type, pi_cargo in job.function%type);
    procedure pr_del_job (pi_id_job in job.job_id%type);
end PA_ABM_JOB
create or replace package body PA_ABM_JOB as
    g_id job.job_id%type;

    procedure pr_alta_job
        (pi_cargo in job.function%type)
    is
    begin
        insert into job(job_id, function)
        values (g_id + 1, upper(pi_cargo));

        g_id := g_id + 1;

        dbms_output.put_line('El cargo ' || pi_cargo || ' fue insertado con éxito');

        exception
            when others then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end pr_alta_job;

    procedure pr_mod_job
        (pi_id_job in job.job_id%type,
            pi_cargo in job.function%type)
    is
        v_i number := 0;
    begin
        select count(*) into v_i from job where job_id = pi_id_job;

        if v_i = 0 then
            raise_application_error(-20001, 'El job ingresado no existe');
        end if;

        update job
        set function = upper(pi_cargo)
        where job_id = pi_id_job;

        if (sql%rowcount > 0) then
            dbms_output.put_line('El cargo fue actualizado con éxito a ' || pi_cargo);
        end if;

        exception
            when no_data_found then
                dbms_output.put_line('El job ingresado no existe');
            when others then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end pr_mod_job;

    procedure pr_del_job (pi_id_job in job.job_id%type)
    is
    begin
        delete from job
        where job_id = pi_id_job;

        if (sql%rowcount > 0) then
            dbms_output.put_line('El cargo fue eliminado con éxito');
        end if;

        exception
                when no_data_found then
                    dbms_output.put_line('El job ingresado no existe');
                when others then
                    dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end pr_del_job;

    begin
        select nvl(max(job_id), 0)
        into g_id
        from job;
end PA_ABM_JOB;

begin
    PA_ABM_JOB.pr_alta_job('estudiante');
    PA_ABM_JOB.pr_alta_job('estudiante2');
    PA_ABM_JOB.pr_alta_job('estudiante3');
    PA_ABM_JOB.pr_mod_job(673, 'prueba');
end

begin
    PA_ABM_JOB.pr_del_job(674);
    PA_ABM_JOB.pr_del_job(675);
    PA_ABM_JOB.pr_del_job(676);
end

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

create or replace package PA_CLIENTES as
    procedure pr_lista;
    procedure pr_lista(pi_cli_nombre in customer.name%type);
    procedure pr_lista(pi_cli_id in customer.customer_id%type);
    procedure pr_ordenes(pi_num in number);
end PA_CLIENTES;
create or replace package body PA_CLIENTES as
    type tr_clientes is record (
        cli_name customer.name%type,
        cli_id customer.customer_id%type,
        cli_phone customer.phone_number%type,
        cli_orders number
    );

    type tt_clientes is table of tr_clientes index by binary_integer;

    t_cli tt_clientes;

    function fu_valida_cli(p_id customer.customer_id%type)
        return binary_integer
    as
        l_idx binary_integer;
    begin

        l_idx := t_cli.first;

        while l_idx <= t_cli.last loop
            if t_cli(l_idx).cli_id = p_id then
                return l_idx;
            end if;
            l_idx := t_cli.next(l_idx);
        end loop;
        
        raise_application_error(-20001, 'El cliente ingresado no existe');
        
    end fu_valida_cli;

    function fu_valida_cli(p_nombre customer.name%type)
        return binary_integer
    as
        l_idx binary_integer;
    begin

        l_idx := t_cli.first;

        while l_idx <= t_cli.last loop
            if upper(t_cli(l_idx).cli_name) = upper(p_nombre) then
                return l_idx;
            end if;
            l_idx := t_cli.next(l_idx);
        end loop;
        
        raise_application_error(-20001, 'El cliente ingresado no existe');
        
    end fu_valida_cli;

    procedure pr_lista
    as

    l_idx binary_integer;

    begin
        l_idx := t_cli.first;

        while l_idx <= t_cli.last loop
            dbms_output.put_line(l_idx
            || ' Id: ' || t_cli(l_idx).cli_id
            || ' Nombre: ' || t_cli(l_idx).cli_name
            || ' Teléfono: ' || t_cli(l_idx).cli_phone
            || ' Cantidad de órdenes: ' || t_cli(l_idx).cli_orders);
        l_idx := t_cli.next(l_idx);
        end loop;

    end pr_lista;

    procedure pr_lista(pi_cli_nombre in customer.name%type)
    as
        e_cli_noex exception;
        pragma exception_init(e_cli_noex, -20001);

        l_idx binary_integer;
    begin
        l_idx := fu_valida_cli(pi_cli_nombre);

        dbms_output.put_line(l_idx
        || ' Id: ' || t_cli(l_idx).cli_id
        || ' Nombre: ' || t_cli(l_idx).cli_name
        || ' Teléfono: ' || t_cli(l_idx).cli_phone
        || ' Cantidad de órdenes: ' || t_cli(l_idx).cli_orders);

        exception
            when e_cli_noex then
                dbms_output.put_line('El cliente ingresado no existe');
    end pr_lista;

    procedure pr_lista(pi_cli_id in customer.customer_id%type)
    as
        e_cli_noex exception;
        pragma exception_init(e_cli_noex, -20001);

        l_idx binary_integer;
    begin
        l_idx := fu_valida_cli(pi_cli_id);

        dbms_output.put_line(l_idx
        || ' Id: ' || t_cli(l_idx).cli_id
        || ' Nombre: ' || t_cli(l_idx).cli_name
        || ' Teléfono: ' || t_cli(l_idx).cli_phone
        || ' Cantidad de órdenes: ' || t_cli(l_idx).cli_orders);

        exception
            when e_cli_noex then
                dbms_output.put_line('El cliente ingresado no existe');
    end pr_lista;

    procedure pr_ordenes(pi_num in number)
    as
        l_idx binary_integer;
    begin
    l_idx := t_cli.first;

        while l_idx <= t_cli.last loop
            if t_cli(l_idx).cli_orders > pi_num then
                dbms_output.put_line(l_idx
                || ' Id: ' || t_cli(l_idx).cli_id
                || ' Nombre: ' || t_cli(l_idx).cli_name
                || ' Teléfono: ' || t_cli(l_idx).cli_phone
                || ' Cantidad de órdenes: ' || t_cli(l_idx).cli_orders);
            end if;
            l_idx := t_cli.next(l_idx);
        end loop;
    end pr_ordenes;

    begin
        select c.name, c.customer_id, c.phone_number, count(distinct so.order_id)
        bulk collect into t_cli
        from customer c
        inner join sales_order so
        on c.customer_id = so.customer_id
        group by c.name, c.customer_id, c.phone_number
        order by name asc;

end PA_CLIENTES;

begin
   PA_CLIENTES.pr_lista();
   --PA_CLIENTES.pr_lista(208);
   --PA_CLIENTES.pr_lista('CENTURY SHOP');
   --PA_CLIENTES.pr_ordenes(1);
end
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
