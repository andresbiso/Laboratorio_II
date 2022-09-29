/*Práctica Unidad 3: Interacción con Oracle*/

/*Primera Parte: Sentencias de manipulación de datos*/

/*
1. Crear un bloque Pl/Sql que solicite el número de empleado usando una variable de sustitución y dependiendo del monto de su sueldo incrementar su comisión según el siguiente criterio: 

Si el sueldo es menor a 1300 el incremento es de 10% 

Si el sueldo está entre 1300 y 1500 el incremento es de 15% 

Si el sueldo es mayor a 1500 el incremento es de 20% 

Tener en cuenta que puede haber comisiones en NULL 

Si el empleado no existe mandar un mensaje de error. 
*/

declare
    v_id_emple employee.employee_id%type;
    v_salario_emple employee.salary%type;
    v_incremento number(4,2) := 1.0;
begin
    v_id_emple := :Ingresar_Id_Empleado;

    select salary
    into v_salario_emple
    from employee
    where employee_id = v_id_emple;

    if (v_salario_emple < 1300) then
        v_incremento := 1.1;
    elsif (v_salario_emple < 1501) then
        v_incremento := 1.15;
    else
        v_incremento := 1.2;
    end if;

    update employee
    set commission = nvl(commission, 0) * v_incremento
    where employee_id = v_id_emple;

    exception
        when no_data_found then
            dbms_output.put_line('No existe el empleado ingresado');
end

/*
2. Modificar el ejercicio anterior para actualizar la comisión de todos los empleados de acuerdo a su sueldo usando los mismos criterios. Desplegar mensajes indicando cuantos registros fueron actualizados según cada criterio.  
*/

declare
    v_incremento number(4,2) := 1.0;
    v_cant_diez number(3) := 0;
    v_cant_quince number(3) := 0;
    v_cant_veinte number(3) := 0;

    cursor c_employee
    is
        select * 
        from employee;
begin
    for r_employee in c_employee loop
        if (r_employee.salary < 1300) then
            v_incremento := 1.1;
            v_cant_diez := v_cant_diez + 1;
        elsif (r_employee.salary < 1501) then
            v_incremento := 1.15;
            v_cant_quince := v_cant_quince + 1;
        else
            v_incremento := 1.2;
            v_cant_veinte := v_cant_veinte + 1;
        end if;

        update employee
        set commission = nvl(commission, 0) * v_incremento
        where employee_id = r_employee.employee_id;
    end loop;

    dbms_output.put_line('Cantidad Actualizó 10%: ' || v_cant_diez);
    dbms_output.put_line('Cantidad Actualizó 15%: ' || v_cant_quince);
    dbms_output.put_line('Cantidad Actualizó 20%: ' || v_cant_veinte);

    exception
        when others then
            dbms_output.put_line('Error inesperado: ' || sqlerrm);
end

/*OR*/

declare
    v_cant_diez number(3) := 0;
    v_cant_quince number(3) := 0;
    v_cant_veinte number(3) := 0;
begin

    select count(distinct employee_id)
    into v_cant_diez
    from employee
    where salary < 1300;

    update employee
    set commission = nvl(commission, 0) * 1.1
    where salary < 1300;

    select count(distinct employee_id)
    into v_cant_quince
    from employee
    where salary >= 1300 AND salary <= 1500;

    update employee
    set commission = nvl(commission, 0) * 1.15
    where salary >= 1300 AND salary <= 1500;

    select count(distinct employee_id)
    into v_cant_veinte
    from employee
    where salary > 1500;

    update employee
    set commission = nvl(commission, 0) * 1.2
    where salary > 1500;

    dbms_output.put_line('Cantidad Actualizó 10%: ' || v_cant_diez);
    dbms_output.put_line('Cantidad Actualizó 15%: ' || v_cant_quince);
    dbms_output.put_line('Cantidad Actualizó 20%: ' || v_cant_veinte);

    exception
        when others then
            dbms_output.put_line('Error inesperado: ' || sqlerrm);
end

/*
3. Crear un bloque Pl/Sql que permita dar de baja cargos que ya no se usan (usar la tabla JOB): 

Eliminar de la tabla JOB aquella fila cuyo Job_Id es ingresado con una variable de sustitución del SqlDeveloper. 

Capturar  e informar mediante excepciones o atributos del cursor , las siguientes eventualidades: no existe el código de cargo ingresado (Sql%Notfound  o Sql%Rowcount) no puede eliminar un cargo que está asignado a empleados (Asociar una excepción con el error correspondiente) . 
*/

/*
insert into job
values (6, 'test');
*/

declare
    v_id_cargo job.job_id%type;
    e_cr exception;
    pragma exception_init(e_cr, -02292);

    v_ex varchar2(1);
begin
    v_id_cargo := :Ingrese_Id_Cargo;

    select '*' into v_ex from job where job_id = v_id_cargo;

    delete from job
    where job_id = v_id_cargo;

    exception
        when no_data_found then
            dbms_output.put_line('No existe el cargo ingresado');
        when e_cr then
            dbms_output.put_line('El cargo ingresado se encuentra en uso');
        when others then
            dbms_output.put_line('Error inesperado: ' || sqlerrm);
end

/*
4. Escribir un bloque PL/Sql para insertar un nuevo cargo en la tabla JOB: 

El Job_Id debe generarse sumando 1 al máximo Job_Id existente. Para esto primero encontrar el Max(Job_Id) y guardarlo en una variable. 

El nombre del cargo (Function) debe ser informado desde una variable de sustitución del SqlDeveloper (usar Becario o Estudiante). En la tabla JOB los nombres de función deben estar en mayúsculas.    

Asentar en la base de datos este insert (Commit). 

Una vez que se ejecutó el bloque Pl/Sql  consultar desde SqlDeveloper todo el contenido de la tabla JOB. 
*/

declare
    v_max_id job.job_id%type;
    v_cargo job.function%type;
begin
    select max(job_id)
    into v_max_id
    from job;

    v_cargo := :Ingrese_Cargo;

    insert into job(job_id, function)
    values (nvl(v_max_id, 0) + 1, upper(v_cargo));
end

select * from job;

-- delete from job where function = 'ESTUDIANTE';

/*
5. Escribir un bloque PL/SQL que actualice el precio de lista de un producto de acuerdo al número de veces que el producto se vendió: 

Use una variable de sustitución para ingresar el producto. 

Calcule las veces que el producto se vendió (Tabla ITEM). Si el producto se vendió 2 veces o menos decremente su precio en un 10%. Si se vendió más de 2 veces decremente su precio en un 20% y no se vendió nunca en un 50%. 

Tenga en cuenta que el precio de lista vigente de un producto es aquel que tiene la columna END_DATE en null. 
*/

declare
    v_prod_id product.product_id%type;
    v_cant_vendida number(4);
    v_porcentaje number(4, 2);
begin
    v_prod_id := :Ingrese_Prod_id;

    select count(item_id)
    into v_cant_vendida
    from item
    where product_id = v_prod_id;

    if v_cant_vendida in (1, 2) then
        v_porcentaje := 0.9; 
    elsif v_cant_vendida > 2 then
        v_porcentaje := 0.8;
    else
        v_porcentaje := 0.5;
    end if;

    update price
    set min_price = round(min_price * v_porcentaje),
    list_price = round(list_price * v_porcentaje)
    where product_id = v_prod_id and end_date is null;

    exception
        when no_data_found then
            dbms_output.put_line('El producto ingresado no existe');
        when others then
            dbms_output.put_line('Error inesperado: ' || sqlerrm);
end

/*
6. Modificar el ejercicio 5 de la práctica 2 para mostrar un mensaje en caso de no existir la orden. 
*/

/*Creo que se refiere al ejercicio 4 de la práctica 2*/

declare
    v_nro_orden sales_order.order_id%type;
    v_orden sales_order%rowtype;
begin
    v_nro_orden := :Ingresar_Id_orden;

    select *
    into v_orden
    from sales_order
    where order_id = v_nro_orden;

    dbms_output.put_line(v_orden.order_id || ' ' || v_orden.order_date || ' '|| v_orden.customer_id || ' ' || v_orden.ship_date || ' ' || v_orden.total);
    
    exception
        when no_data_found then
            dbms_output.put_line('No existe la orden ingresada');
end

/*
7. Modificar el ejercicio 8 de la práctica 2 para ingresar el apellido del empleado y mostrar su id, nombre, salario y asteriscos de acuerdo al salario. 
Mostrar mensajes si no existe empleado con dicho apellido, o si hay más de un empleado con ese apellido.
*/

/*Creo que se refiere al ejercicio 9 de la práctica 2*/

declare
    v_id_emple employee.employee_id%type;
    v_nombre_emple employee.first_name%type;
    v_apellido_emple employee.last_name%type;
    v_salario_emple employee.salary%type;
    v_i number := 0;
    v_cant_loops number := 0;
    v_asteriscos varchar2(1000);
begin
    v_apellido_emple := :Ingrese_Apellido_Empleado;

    select employee_id, first_name, salary
    into v_id_emple, v_nombre_emple, v_salario_emple
    from employee
    where upper(last_name) = upper(v_apellido_emple);

    dbms_output.put_line('El empleado ' || v_nombre_emple || ' ' || upper(v_apellido_emple) || ' con id ' || v_id_emple || ' gana ' || v_salario_emple);

    v_cant_loops := floor(v_salario_emple / 100);
    while v_i < v_cant_loops loop
        v_asteriscos := v_asteriscos || '*';
        v_i := v_i + 1;
    end loop;

    dbms_output.put_line(v_asteriscos || '(' || v_i || ')');

    exception
        when no_data_found then
            dbms_output.put_line('El empleado ingresado no existe');
        when too_many_rows then
            dbms_output.put_line('Existe más de un empleado con ese apellido');
end

/* Segunda Parte: Cursores explícitos */

/*
8. Usando un cursor recorrer las tablas Sales_order e Ítem para generar un listado sobre todas las órdenes y los productos que se ordenaron en ellas. Mostrar los siguientes datos: Order_id, order_date, product_id. 
*/

declare
    cursor c_order_product is 
        select so.order_id, so.order_date, i.product_id
        from sales_order so
        inner join item i
        on so.order_id = i.order_id;
begin
    for r_oder_product in c_order_product loop
        dbms_output.put_line('Order_id: ' || r_oder_product.order_id || ' Order_date: ' || r_oder_product.order_date || ' Product_id: ' || r_oder_product.product_id );
    end loop;
end

/*
9. Escribir un bloque que reciba un código de cliente e informe el nro. de orden, la fecha de toda orden generada por él y la descripción de los productos ordenados. (Usar las tablas Sales_order, Ítem y Product). Si no hay registros desplegar un mensaje de error.  
*/

declare
    v_id_cust customer.customer_id%type;

    cursor c_orden (p_id_cust customer.customer_id%type)
    is
      select so.order_id, so.order_date, p.description
      from sales_order so
      inner join item i
      on so.order_id = i.order_id
      inner join product p
      on i.product_id = p.product_id
      where so.customer_id = p_id_cust
      order by p.description;

    v_i number := 0;
begin
    v_id_cust := :Ingrese_Id_Cliente;

    for r_orden in c_orden (v_id_cust) loop
        dbms_output.put_line('Oder_Id: ' || r_orden.order_id || ' Order_Date: ' || r_orden.order_date || ' Product_Description: ' || r_orden.description );
        v_i := c_orden%rowcount;
    end loop;

    if v_i = 0 then
        raise_application_error(-20001, 'El cliente no tiene órdenes');
    end if;
end

/*
10. Necesitamos tener una lista de los empleados que son candidatos a un aumento de salario en los distintos departamentos: 

Indicar el id de departamento a través de una variable de sustitución  

Recuperar apellido, nombre, y salario de los empleados que trabajan en el departamento dado y cuyo cargo sea ‘CLERK’. 

Si el salario es menor que 1000 desplegar el mensaje: 

   Last_Name, First_name candidato a un aumento 

Si el salario supera los 1000 ( o es igual) desplegar : 

   Last_Name, First_name no es candidato a un aumento 

El listado debe estar ordenado por apellido. 

Si en el departamento no existe la función ‘CLERK’ desplegar el mensaje: 

   El departamento Department_Id no tiene candidatos a aumento de salario.  

Probar el bloque con distintos departamentos. 

*/ 

declare
    v_id_depto department.department_id%type;

    cursor c_empl (p_id_depto department.department_id%type)
    is
        select e.last_name, e.first_name, e.salary
        from employee e
        inner join job j
        on e.job_id = j.job_id
        where department_id = p_id_depto and upper(j.function) = upper('clerk')
        order by last_name;
    v_x varchar2(1);
    v_i number := 0;
begin
    v_id_depto := :Ingrese_Id_Depto;
    select '*' into v_x from department where department_id = v_id_depto;

    for r_empl in c_empl (v_id_depto) loop
        if r_empl.salary < 1000 then
            dbms_output.put_line(r_empl.first_name || ',' || r_empl.last_name || ' candidato a un aumento');
        else
            dbms_output.put_line(r_empl.first_name || ',' || r_empl.last_name || ' no es candidato a un aumento');
        end if;
        v_i := c_empl%rowcount;
    end loop;

    if v_i = 0 then
        dbms_output.put_line('El departamento ' || v_id_depto || ' no tiene candidatos a aumento de salario');
    end if;

    exception
        when no_data_found then
            dbms_output.put_line('No existe el departamento');
end

/*
11. Escribir un bloque PL/Sql que muestre los 5 productos más caros. 
*/

declare
    cursor c_prod
    is
        select p.product_id, p.description, pr.list_price
        from product p
        inner join price pr
        on p.product_id = pr.product_id
        where end_date is null
        order by pr.list_price desc;
begin
    for r_prod in c_prod loop
        if c_prod%rowcount <= 5 then
            dbms_output.put_line('Product_id: ' || r_prod.product_id || ' Description: ' || r_prod.description || ' List_Price: ' || r_prod.list_price);
        end if;
    end loop;
end

/*
12. Usando dos cursores, recorrer las tablas Department y Employee para generar un listado mostrando los datos de todos los departamentos y por cada uno el nombre completo y fecha de ingreso de sus empleados. Ordenar los datos por id de departamento y nombre de empleado.  

El listado deberá mostrarse así: 

10  -  ACCOUNTING  -  NEW YORK 

  CLARK,CAROL	  09-Jun-1985  

  KING,FRANCIS 	  17-Nov-1985 

 

12  -  RESEARCH  -  NEW YORK 

  ALBERTS,CHRIS 	  06-Apr-1985  
*/

declare
    cursor c_dept
    is
        select d.department_id, d.name, l.regional_group
        from department d
        inner join location l
        on d.location_id = l.location_id
        order by department_id;

    cursor c_emp_dept (p_dept_id department.department_id%type)
    is
        select first_name, last_name, hire_date
        from employee
        where department_id = p_dept_id
        order by first_name;
begin
    for r_dept in c_dept loop
        dbms_output.put_line(r_dept.department_id || ' - ' || r_dept.name || ' - ' || r_dept.regional_group);
        for r_emp_dept in c_emp_dept(r_dept.department_id) loop
            dbms_output.put_line(r_emp_dept.last_name || ',' || r_emp_dept.first_name || ' ' || to_char(r_emp_dept.hire_date, 'DD-MON-YYYY'));
        end loop;
    end loop;
end
