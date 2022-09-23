-- # Clase 7 - Repaso pre-parcial
-- Hicimos ejercicios de la tres prácticas
-- Repasamos los temas del parcial

-- Consejos Pre-Parcial
-- Si el ejercicio dice:
-- No cancelar / No Cancele
--> Capturar los errores y que no tire errores por terminal (error amarillo estándar)

/*
Si el ejercicio dice
Localidad - XXX
Department: 1 - xxxx
Empl XXXX
9999 XXXX

Department: 2 - xxxx
Empl XXXX
9999 XXXX

tengo que suponer cursor anidado
Ej: una localidad, un cursor para departamento y otro para los empleados dentro del depto
*/

/*
Si dice: Evitar accesos inecesarios a la base.

Ej: Mover un select a una función y así evito que el select se repita más de una vez
*/

/*
Ejercicio:
Crear un procedimiento: Lista Productos
Por cada producto mostrar:
prod_id, descripción y fecha de última venta
historial de precios (fecha desde, fecha hasta, p_min, p_lista)
ordernar por vigencia
en caso de que nunca se haya vendido, informarlo, en lugar de poner la fecha
*/

create or replace procedure pr_lista_productos
is
    cursor c_prod is
        select p.product_id, p.description, max(order_date) order_date
        from product p
        inner join item i
        on i.product_id = p.product_id
        inner join sales_order so
        on so.order_id = i.order_id
        group by p.product_id, p.description;
    
    cursor c_prod_history (p_prod_id product.product_id%type)
    is
        select p.start_date, p.end_date, p.min_price, p.list_price
        from price p
        where p.product_id = p_prod_id;

    begin
        for r_prod in c_prod loop
            dbms_output.put_line('Product_Id: ' || r_prod.product_id || ' Descripción: ' || r_prod.description || ' Fecha última venta: ' || r_prod.order_date);
            for r_prod_history in c_prod_history (r_prod.product_id) loop
                dbms_output.put_line('Fecha desde: ' || r_prod_history.start_date || ' Fecha hasta: '|| r_prod_history.end_date || ' Precio Mínimo: ' || r_prod_history.min_price || ' Precio Lista: ' || r_prod_history.list_price);
            end loop;
        end loop;

        exception
            when others then
                dbms_output.put_line('Error Inesperado: ' || sqlerrm);               
    end;

begin
    pr_lista_productos();
end

/*
Ejercicio:
Crear un procedimiento que recibe por parámetro:
id_cliente
id_de_vendedor

Actualiza el vendedor del cliente
NO Cancelar

Indicar si:
Se actualizó correctamente
Cliente no existe
Vendedor no existe
Cualquier otro error
*/

create or replace procedure pr_up_customer_salesman
    (pi_customer_id in customer.customer_id%type,
    pi_salesperson_id in customer.salesperson_id%type)
is

    v_x number;

    begin

        select count(*) into v_x from customer where customer_id = pi_customer_id;

        if v_x = 0 then
            raise_application_error(-20001, 'Error: el cliente no existe');
        end if;

        select count(*) into v_x from employee where employee_id = pi_salesperson_id;

        if v_x = 0 then
            raise_application_error(-20002, 'Error: el vendedor no existe');
        end if;

        update customer
        set salesperson_id = pi_salesperson_id
        where customer_id = pi_customer_id;

        dbms_output.put_line('El cliente se actualizó correctamente');

        exception
            when no_data_found then
                dbms_output.put_line('Error: No existe el cliente o vendedor');
            when others then
                dbms_output.put_line('Error Inesperado: ' || sqlerrm);               
    end;

declare
    e_no_customer exception;
    e_no_salesperson exception;

    pragma exception_init(e_no_customer, -20001);
    pragma exception_init(e_no_salesperson, -20002);

begin
    pr_up_customer_salesman(10, 7844);
    --pr_up_customer_salesman(100, 7844);
    --pr_up_customer_salesman(100, 7521);
    exception
        when e_no_customer then
           dbms_output.put_line('Error: el cliente no existe');
        when e_no_salesperson then
            dbms_output.put_line('Error: el vendedor no existe');
end