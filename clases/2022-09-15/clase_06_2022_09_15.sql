--cursores con parametros

sintaxis
  cursor cursor_name (param_list)
  is
  cursor_query

  --Armar un procedimiento, que reciba p parametro un id de depto,
  --y armar el cursor, q recorra la tabla department y devuelva
  --los empleados de ese department_id
  --clave: empleados p/departamento

create or replace procedure lista_empleados
    (pi_depto in department.department_id%type)
is
  cursor c_emp is
    select first_name || ',' || last_name nombre
    from employee
    where department_id = pi_depto;

  v_x varchar2(1);

  begin
    select '*' into v_x from department 
    where department_id = pi_depto;

    for r_emp in c_emp loop
      dbms_output.put_line (r_emp.nombre);

    end loop;
    exception
      when no_data_found then
        dbms_output.put_line ('Error no Existe el departamento');
      when others then
        dbms_output.put_line ('Error Inesperado' || sqlerrm);
  end;

declare
  v_num1 number(2) :=99;
  begin
    lista_empleados(v_num1);
  end;


  --listar todos los clientes de un vendedor dado por parametro


create or replace procedure lista_empleados
    (pi_vendedor customer.salesperson_id%type)
is
    cursor c_cust is
        select customer_id || ',' || name cli
        from customer
        where salesperson_id = pi_vendedor;

    v_xflag varchar2(1);  
    v_i number := 0;

    begin 
        select distinct '*' into v_xflag from customer 
        where salesperson_id = pi_vendedor;         

        for r_cust in c_cust loop
            dbms_output.put_line(r_cust.cli);
            v_i := v_i +1;
        end loop;

        if v_i = 0 then
          dbms_output.put_line('El Vendedor no tiene Clientes');
        end if;

    exception
    when NO_DATA_FOUND then
        dbms_output.put_line('EL ID DE VENDEDOR NO EXISTE');
    when OTHERS then
        dbms_output.put_line('SE PRODUJO OTRO ERROR'||sqlerrm);
    end;


-------------------------------------------------------------------------
declare 
    v_vendedor customer.salesperson_id%TYPE;
begin
    v_vendedor:=:INGRESE_UN_SALESPERSON;
    lista_empleados(v_vendedor);
end;


-- cursores anidados / encadenados

  -- Listar Todos los departamentos y por c/u -> todos sus empleados

create or replace procedure list_emple_p_depto
is
  cursor c_dep is 
    select department_id id , name 
    from department 
    order by department_id;
  cursor c_emp (p_id_dep number) is 
    select employee_id id , first_name nombre , last_name apellido 
    from employee 
    where department_id = p_id_dep;

    --v_x number := 0;
    total_rows number := 0;

  begin
    for r_dep in c_dep loop
      dbms_output.put_line('-------------------------------');
      dbms_output.put_line('************ ' || r_dep.id || ' ' || r_dep.name || '*******');
      for r_emp in c_emp (r_dep.id) loop
        dbms_output.put_line('ID: '|| r_emp.id || ' ' || r_emp.nombre ||'' || r_emp.apellido);
        --v_x := v_x + 1 ;
        total_rows := c_emp%rowcount;
      end loop;

      --if v_x = 0 then
        dbms_output.put_line('El Departamento Tiene: ' || total_rows || ' Empleados ');
        total_rows := 0;
      --end if;
      --v_x := 0;
    end loop;

    exception
      when others then
        dbms_output.put_line('SE PRODUJO OTRO ERROR'||sqlerrm);
end;

begin
  list_emple_p_depto;
end;


--Armar un procedure que muestre p/producto muestre los precios historicos

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


--Funciones

create or replace function "FU_PROM_SAL"
  (pi_dep_id number)
return NUMBER
is

v_prom number (8,2);

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

--otra forma de invocarla

select fu_prom_sal(10)
from dual;

select department_id , name , fu_prom_sal(department_id) Promedio
from department;

select * from employee where department_id = 40;

--Una funcion que reciba nombre y apellido de un empleado y devuelva el id

create or replace function fu_emp_id
    (pi_nombre in employee.first_name%type, pi_apellido in employee.last_name%type)
    return number is
 v_emp_id employee.employee_id%type;
 begin
    select employee_id 
    into v_emp_id 
    from employee 
    where upper(first_name) = upper(pi_nombre) 
    and upper(last_name) = upper(pi_apellido);
    return v_emp_id;
 exception
    when no_data_found then 
        raise_application_error (-20001,'Empleado no existe'); --errores propios van del -20000 para abajo, p/ejemplo el -20001
    when too_many_rows then
        raise_application_error (-20002,'Existe más de un Empleado con el mismo nombre y apellido');
    when others then
        raise_application_error (-20003,'Error Inesperado al validar empleado '|| sqlerrm);
 end fu_emp_id;

begin
  dbms_output.put_line(fu_emp_id('jose','SMITH'));
end;


