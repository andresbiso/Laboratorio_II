--cursores

declaro
abro
Leerlo
cerrarlo


tipos: Explicitos e Implicitos

Atributos:

%FOUND -> si estoy apuntando, mi puntero a una fila del cursor, me dara true, sino false
%NOTFOUND -> pregunto p la negativa
%ROWCOUNT -> num de fila en la q estoy parado -> numero
%ISOPEN -> cursor abierto? -> true/false
%ISCLOSE -> cursor cerrado? -> true/false

--usando el loop

Declare
    cursor c_cli is
        select customer_id , name
        from customer
        where salesperson_id = 7789;

    r_cli c_cli%rowtype;    -- declaro el puntero registro de tipo cursor

    begin
     open c_cli; --abrir cursor
      loop
        fetch c_cli into r_cli; --apuntar a un registro del cursor
        exit when c_cli%notfound;
        dbms_output.put_line(r_cli.customer_id || ' ' || r_cli.name);
      end loop;
     close c_cli;
    end;

--otra forma: usando el for

Declare
    cursor c_cli is
        select customer_id , name
        from customer
        where salesperson_id = 7789;

    begin
        for r_cli in c_cli loop
            dbms_output.put_line(r_cli.customer_id || ' ' || r_cli.name || ' ' ||c_cli%rowcount);
        end loop;
    end;


--cursores implicitos
begin 
    update employee
    set commission = 20
    where department_id = 10;

    dbms_output.put_line('Se modificaron : ' || sql%rowcount || 'filas'     );
end;


begin 
    update employee
    set commission = 20
    where department_id = 95;

    dbms_output.put_line('Se modificaron : ' || sql%rowcount || 'filas'     );
end;


--variante 

begin 
    update employee
    set commission = 20
    where department_id = 95;

    if sql%rowcount > 0 then
        dbms_output.put_line('Se modificaron : ' || sql%rowcount || 'filas'     );
    else
        dbms_output.put_line('No existen empleados para el depto. ');
    end if;
end;

--Ejercicio 8 (Practica 3)

declare
    cursor c_sales is select s.order_id, s.order_date, i.product_id
                                                 from sales_order s inner join item i on (s.order_id = i.order_id);
begin
    for r_sales in c_sales loop
        dbms_output.put_line(r_sales.order_id || ' ' || r_sales.order_date || ' '  ||r_sales.product_id);
    end loop;
end;


--Procedure
create or replace procedure suma 
    (pi_num1 IN number , pi_num2 IN number , po_total OUT number)
IS
    begin
        po_total := pi_num1 + pi_num2;
    end;


declare
    p_num1 number(4) := 5;
    p_num2 number(4) := 20;
    p_total number(4);

    begin
        suma (p_num1,p_num2,p_total);
        dbms_output.put_line('Total Suma: '||p_total);
    end;


create or replace procedure "INSERT_PRODUCT1"
(pi_id IN product.product_id%type,
pi_nombre IN product.description%type)
is
begin
 insert into product 
 values (pi_id , pi_nombre);
 dbms_output.put_line('Producto Ingresado Correctamente');
 exception
    when dup_val_on_index then
        dbms_output.put_line('Valores Duplicados!!!');

end;

declare
    p_num1 number(4) :=5;
begin

-- validacion de un objecto

select status from all_objects where object_name ='SUMA';


--Ejercicio:
/* Hacer un procedimiento que cree un departamento: Pasar por param... 
un nombre , y opcionalmente una localidad
si no tengo localidad, pongo el depto en la localidad 122
y el id de depto, lo genero internamente como el max que tengo +1
*/
create or replace procedure pr_alta_dep
    (pi_nombre IN department.name%type,
     pi_loc_id IN department.location_id%type default 122) 
is

    l_max_id department.department_id%type;

    e_fk    exception;
    pragma exception_init(e_fk,-2291);

    begin
        select nvl(max(department_id),0)
        into l_max_id
        from department;

        insert
        into department
            (department_id , name , location_id)
        values
            (l_max_id+1 , pi_nombre , pi_loc_id);

            dbms_output.put_line('Se insertó correctamente');

    exception
        when e_fk then
            dbms_output.put_line('La Localidad es Incorrecta');
        when others then
            dbms_output.put_line('Error Inesperado: '|| sqlerrm);

end;

begin
    --pr_alta_dep('Prueba 33',123);
    --pr_alta_dep('Prueba 34');
    pr_alta_dep('Prueba 35',1);
end;

select * from department order by department_id desc;