-- Preguntarle al profesor si puede subir la practica de packages
-- # Clase 8
/*
# Repaso clase anterior

Invocar procedimiento de package: package.[nomProc]

borrar todo el paquete: drop package [nom_package]
borrar solo el body del paquete: drop package body [nom_package]

## Sobrecarga
Mantengo Nombre de procedimiento y cambio el tipo, cantidad u orden

Ej: dbms_output.put_line(...)

## Bloque One Time Only
- Bloque que solo lleva begin.
- Se pone en el final del package.
- Se ejecuta una sola vez cuando arranco el package.
- Se utiliza para cargar datos en memoria.
*/

/*
Fuera de un package solo puedo tener un procedimiento con un nombre.
Dentro de un package si se puede por sobrecarga o en distintos packages el disintos procedimientos con el mismo nombre.
*/

/*
Ej: Generar una tabla en memoria que tenga id_depto, nombre_depto,
cantidad de empleados de ese departamento y el promedio de salarios de ese departamento
*/

create or replace package PA_EMPLEADOS as
procedure pr_modif_salario (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type,
                               pi_salario employee.salary%type);

procedure pr_modif_salario (pi_emp_id employee.employee_id%type,
pi_salario employee.salary%type);
procedure pr_mostrar_depto_emp;
end;

create or replace package body PA_EMPLEADOS is
    e_emp_noex exception;
    e_emp_dupl exception;
    e_emp_otro exception;
    pragma exception_init(e_emp_noex, -20001);
    pragma exception_init(e_emp_dupl, -20002);
    pragma exception_init(e_emp_otro, -20003);

   type tr_dept_emp is record (
        dept_id department.department_id%type,
        dept_name department.name%type,
        dept_emp_count number,
        dept_salary_avg employee.salary%type
    );

    type tt_dept_emp is table of tr_dept_emp index by binary_integer;

    t_dept_emp tt_dept_emp;

    cursor c_dept_emp is
        select d.department_id, d.name, count(distinct e.employee_id) cantidad, avg(e.salary) promedio
        from department d
        inner join employee e
        on d.department_id = e.department_id
        group by d.department_id, d.name;

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

    procedure pr_mostrar_depto_emp
    as
        l_idx binary_integer;
    begin
        l_idx := t_dept_emp.first;
        
        while l_idx <= t_dept_emp.last loop
            dbms_output.put_line(l_idx || ' Id Depto: ' || t_dept_emp(l_idx).dept_id
            || ' Nombre Depto: ' || t_dept_emp(l_idx).dept_name
            || ' Cantidad Empelados: ' || t_dept_emp(l_idx).dept_emp_count
            || ' Promedio Salarios: ' || t_dept_emp(l_idx).dept_salary_avg);
            l_idx := t_dept_emp.next(l_idx);
        end loop;
    end;

    /*one time only*/
    begin
        for r_dept_emp in c_dept_emp loop
            t_dept_emp(r_dept_emp.department_id).dept_id := r_dept_emp.department_id;
            t_dept_emp(r_dept_emp.department_id).dept_name := r_dept_emp.name;
            t_dept_emp(r_dept_emp.department_id).dept_emp_count := r_dept_emp.cantidad;
            t_dept_emp(r_dept_emp.department_id).dept_salary_avg := r_dept_emp.promedio;
        end loop;

end PA_EMPLEADOS;

begin
    PA_EMPLEADOS.pr_mostrar_depto_emp();
end

/*Ej: pr_listar que listar los valores de la tabla y los apellidos de los empleados que trabajan en ese departamento*/
create or replace package PA_EMPLEADOS as
procedure pr_modif_salario (pi_nombre employee.first_name%type,
                               pi_apellido employee.last_name%type,
                               pi_salario employee.salary%type);

procedure pr_modif_salario (pi_emp_id employee.employee_id%type,
pi_salario employee.salary%type);
procedure pr_mostrar_depto_emp;
procedure pr_listar;
end;

create or replace package body PA_EMPLEADOS is
    e_emp_noex exception;
    e_emp_dupl exception;
    e_emp_otro exception;
    pragma exception_init(e_emp_noex, -20001);
    pragma exception_init(e_emp_dupl, -20002);
    pragma exception_init(e_emp_otro, -20003);

   type tr_dept_emp is record (
        dept_id department.department_id%type,
        dept_name department.name%type,
        dept_emp_count number,
        dept_salary_avg employee.salary%type
    );

    type tt_dept_emp is table of tr_dept_emp index by binary_integer;

    t_dept_emp tt_dept_emp;

    cursor c_dept_emp is
        select d.department_id, d.name, count(distinct e.employee_id) cantidad, avg(e.salary) promedio
        from department d
        inner join employee e
        on d.department_id = e.department_id
        group by d.department_id, d.name;
    
    cursor c_empleados_depto (p_depto_id department.department_id%type)
    is
        select e.employee_id, e.first_name, e.last_name
        from employee e
        inner join department d
        on e.department_id = d.department_id
        where e.department_id = p_depto_id;

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

    procedure pr_mostrar_depto_emp
    as
        l_idx binary_integer;
    begin
        l_idx := t_dept_emp.first;
        
        while l_idx <= t_dept_emp.last loop
            dbms_output.put_line(l_idx || ' Id Depto: ' || t_dept_emp(l_idx).dept_id
            || ' Nombre Depto: ' || t_dept_emp(l_idx).dept_name
            || ' Cantidad Empelados: ' || t_dept_emp(l_idx).dept_emp_count
            || ' Promedio Salarios: ' || t_dept_emp(l_idx).dept_salary_avg);
            l_idx := t_dept_emp.next(l_idx);
        end loop;
    end;

    procedure pr_listar
    as
        l_idx binary_integer;
    begin
        l_idx := t_dept_emp.first;
        
        while l_idx <= t_dept_emp.last loop
            dbms_output.put_line(l_idx || ' Id Depto: ' || t_dept_emp(l_idx).dept_id
            || ' Nombre Depto: ' || t_dept_emp(l_idx).dept_name
            || ' Cantidad Empelados: ' || t_dept_emp(l_idx).dept_emp_count
            || ' Promedio Salarios: ' || t_dept_emp(l_idx).dept_salary_avg);
            for r_empleados_depto in c_empleados_depto (t_dept_emp(l_idx).dept_id) loop
                dbms_output.put_line( r_empleados_depto.employee_id || ' Empleado: ' || r_empleados_depto.last_name || ',' || r_empleados_depto.first_name);
            end loop;
            l_idx := t_dept_emp.next(l_idx);
        end loop;
    end;

    /*one time only*/
    begin
        for r_dept_emp in c_dept_emp loop
            t_dept_emp(r_dept_emp.department_id).dept_id := r_dept_emp.department_id;
            t_dept_emp(r_dept_emp.department_id).dept_name := r_dept_emp.name;
            t_dept_emp(r_dept_emp.department_id).dept_emp_count := r_dept_emp.cantidad;
            t_dept_emp(r_dept_emp.department_id).dept_salary_avg := r_dept_emp.promedio;
        end loop;

end PA_EMPLEADOS;

begin
    PA_EMPLEADOS.pr_listar();
end
