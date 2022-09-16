-- # Cursores Explícitos con Parámetros
/*
    cursor cursor_name (param_list)
    is
    cursor_query
*/

/* Ej: Armar un procedimiento que reciba p parámetro un id de departamento
y armar el cursor que recorra la tabla department y devuelva los empleados de
ese department_id
clave: empleados por departamento
*/

create or replace procedure lista_empleados
    (pi_depto in department.department_id%type)
    -- (p_depto department.department_id%type) -> si no ponemos nada lo toma como "in"
is
    cursor c_emp is
        select first_name || ',' || last_name nombre
        from employee
        where department_id = pi_depto;

    v_x varchar2(1);
    begin
        -- Forzamos exception
        select '*' into v_x from department where department_id = pi_depto;
        for r_emp in c_emp loop
            dbms_output.put_line(r_emp.nombre);
        end loop;

        exception
            when no_data_found then
                dbms_output.put_line('Error: No existe el departamento');
            when others then --> tratamos de agregar siempre por si surge otro error
                dbms_output.put_line('Error Inesperado: ' || sqlerrm);               
    end;

begin
    lista_empleados(10);
end

/*Recomendó el profesor revisar que si insertamos en una tabla
un max(value) + 1 no nos vayamos fuera de rango de valores que acepta esa columna*/

/*Ej2: Listar todos los clientes de un vendedor dado por parámetro*/

create or replace procedure lista_empleados_vendedor
    (pi_vendedor in customer.salesperson_id%type)
is
    cursor c_cust is
        select name
        from customer
        where salesperson_id = pi_vendedor;

    v_x varchar2(1);
    begin
        select distinct '*' into v_x from customer where salesperson_id = pi_vendedor;

        for r_cust in c_cust loop
            dbms_output.put_line(r_cust.name);
        end loop;

        exception
            when no_data_found then
                dbms_output.put_line('Error: No existe el vendedor');
            when others then
                dbms_output.put_line('Error Inesperado: ' || sqlerrm);               
    end;

begin
    lista_empleados_vendedor(7654);
end

/*Ej2 (otra forma): Listar todos los clientes de un vendedor dado por parámetro*/

create or replace procedure lista_empleados_vendedor_b
    (pi_vendedor in customer.salesperson_id%type)
is
    cursor c_cust is
        select name
        from customer
        where salesperson_id = pi_vendedor;

    v_x varchar2(1);
    v_i number := 0;
    begin
        select distinct '*' into v_x from customer where salesperson_id = pi_vendedor;

        for r_cust in c_cust loop
            dbms_output.put_line(r_cust.name);
            v_i := v_i + 1;
        end loop;

        if v_i = 0 then
            dbms_output.put_line('El vendedor no tiene Clientes');
        end if;

        exception
            when no_data_found then
                dbms_output.put_line('Error: No existe el vendedor');
            when others then
                dbms_output.put_line('Error Inesperado: ' || sqlerrm);               
    end;

begin
    lista_empleados_vendedor_b(7654);
end

/*Si un ejercicio indica "No cancelar" significa que tenemos que capturar los errores y que no tire error por pantalla no capturado*/
/*Los ejercicios de unidades 4 y 5 semanales me indicó que los hice bien*/
/*Una de las formas de capturar errores es ver con el others cuales va tirando e ir generando las exception de las no conocidas*/

-- # Cursores Anidados - Encadenados

/*Ej: Listar todos los departamentos y por cada uno todos sus empleados*/

create or replace procedure list_emple_p_depto
is
    cursor c_dep
    is
      select department_id id, name
      from department
      order by department_id;

    cursor c_emp (p_id_dep number)
    is
      select employee_id id, first_name nombre, last_name apellido
      from employee
      where department_id = p_id_dep;

    v_i number := 0;
begin
    for r_dep in c_dep loop
        dbms_output.put_line('-----');
        dbms_output.put_line('*****' || r_dep.id || ' ' || r_dep.name || '*****');
        for r_emp in c_emp (r_dep.id) loop
            dbms_output.put_line('Id: ' || r_emp.id || ' ' || r_emp.nombre || ' ' || r_emp.apellido);
            v_i := v_i + 1;
        end loop;
        if v_i = 0 then
            dbms_output.put_line('El departamento no tiene empleados');
        end if;
        v_i := 0;
    end loop;

    exception
        when others then
            dbms_output.put_line('Error inesperado:' || sqlerrm);
end;

begin
    list_emple_p_depto();
end;

/*Ej (otra forma): Listar todos los departamentos y por cada uno todos sus empleados*/

create or replace procedure list_emple_p_depto_b
is
    cursor c_dep
    is
      select department_id id, name
      from department
      order by department_id;

    cursor c_emp (p_id_dep number)
    is
      select employee_id id, first_name nombre, last_name apellido
      from employee
      where department_id = p_id_dep;

    total_rows number := 0;
begin
    for r_dep in c_dep loop
        dbms_output.put_line('-----');
        dbms_output.put_line('*****' || r_dep.id || ' ' || r_dep.name || '*****');
        for r_emp in c_emp (r_dep.id) loop
            dbms_output.put_line('Id: ' || r_emp.id || ' ' || r_emp.nombre || ' ' || r_emp.apellido);
            total_rows := c_emp%rowcount; --> indica número de registro actual
        end loop;
        
        dbms_output.put_line('El departamento tiene: ' || total_rows || ' empleados');
        total_rows := 0;
        
    end loop;

    exception
        when others then
            dbms_output.put_line('Error inesperado:' || sqlerrm);
end;

begin
    list_emple_p_depto_b();
end;

/*Ej2: Armar un procedure que muestro para cada producto los precios históricos*/

create or replace procedure precio_historico_productos
is
    cursor c_prod
    is
        select * 
        from product;
    
    cursor c_precio (p_id number)
    is
        select list_price, start_date, end_date
        from price
        where product_id = p_id;
begin
      
      for r_prod in c_prod loop
      dbms_output.put_line('-----');
        dbms_output.put_line('Producto: ' || r_prod.description);
        for r_precio in c_precio (r_prod.product_id) loop
            dbms_output.put_line('Precio: $' || r_precio.list_price || ' Fecha Inicio: ' || r_precio.start_date || ' Fecha Fin: ' || r_precio.end_date);
        end loop;
      end loop;

      exception
        when others then
            dbms_output.put_line('Error inesperado:' || sqlerrm);
end;

begin
    precio_historico_productos();
end;

-- # Function

/*Las funciones no puedo llamarlas por si solas como los stored procedures*/

create or replace function fu_prom_sal
    (pi_dep_id number)
return number
is
    v_prom number(8,2);
    begin
        select avg(salary)
        into v_prom
        from employee
        where department_id = pi_dep_id;

        return v_prom;
    end;

begin
    dbms_output.put_line(fu_prom_sal(10));
end;

/*Otra forma de invocación de la función*/

select fu_prom_sal(10)
from dual;

select department_id, name, fu_prom_sal(department_id) promedio
from department;

/*
Ej: una función que recibe nombre y apellido de un empleado y devuelve el id
*/

/*
El profesor decidió para este caso levantar excepciones custom para que si usan la función
entonces puedan tener un mejor entendimiento de los errores
*/
create or replace function fu_emp_id
    (pi_nombre employee.first_name%type,
    pi_apellido employee.last_name%type)
return number
is
    v_emp_id number;
    begin
        select employee_id
        into v_emp_id
        from employee
        where upper(first_name) = upper(pi_nombre)
        and upper(last_name) = upper(pi_apellido);

        return v_emp_id;

        exception
            when no_data_found then
                -- errores custom van del -20001 para abajo
                raise_application_error(-20001, 'Empleado no existe');
            when too_many_rows then
                raise_application_error(-20002, 'Existe más de un empleado');
            when others then
                raise_application_error(-20003, 'Error inesperado al validar empleado ' || sqlerrm);
    end;

begin
    dbms_output.put_line(fu_emp_id('JOHN', 'SMITH'));
end;