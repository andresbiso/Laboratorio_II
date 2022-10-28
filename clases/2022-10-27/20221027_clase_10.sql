-- # Clase 10
/*
Package para Administrar las ventas
-> Alta una orden
-> Alta sus items
-> Buscar un precio
-> Listar las ordenes
-> Actualizar precios

Package PA_ORDENES
-> procedimiento Alta (insert en la tabla sales_order)
    Recibe (parámetro de entrada): id_cliente
    Retorna (parámetro de salida): id_orden generado
Insertamos en sales_order:
- order_id := max(id) + 1
- order_date := sysdate
- ship_date := sysdate + 7
- cutomer_id := [viene por parámetro]
- total := [lo calculamos]
*/

create or replace package PA_ORDENES as
    procedure pr_alta_orden(pi_id_cliente customer.customer_id%type,
        po_id_orden out sales_order.order_id%type);
end PA_ORDENES;
create or replace package body PA_ORDENES is
    e_fk exception;
    pragma exception_init(e_fk, -02291);

    procedure pr_alta_orden(pi_id_cliente customer.customer_id%type,
        po_id_orden out sales_order.order_id%type)
    as
        l_order_date sales_order.order_date%type := sysdate;
        l_ship_date sales_order.ship_date%type := sysdate + 7;
        l_order_id  sales_order.order_id%type;
        begin
            select max(order_id)
            into l_order_id
            from sales_order;

            insert into sales_order (order_id, order_date, customer_id, ship_date, total)
            values(l_order_id + 1, l_order_date, pi_id_cliente, l_ship_date, 0);
            
            -- Asignamos el PO luego del insert para no devolver el output parameter en caso de error
            -- Esto es una buena práctica
            po_id_orden := l_order_id + 1;

            dbms_output.put_line('La orden de venta fue creada con éxito');
        exception
            when e_fk then
                dbms_output.put_line('El cliente ingresado no existe');
            when others then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
        end pr_alta_orden;
end PA_ORDENES;

declare
    po_id_orden sales_order.order_id%type;
begin
    -- PA_ORDENES.pr_alta_orden(80, po_id_orden);
    PA_ORDENES.pr_alta_orden(100, po_id_orden);
    dbms_output.put_line('Id_Orden: ' || po_id_orden);
end

-- select * from sales_order order by order_id desc
-- delete from sales_order where order_id > 621

/*
Package PA_ORDENES
-> procedimiento Alta Item (insert en la tabla item)
    Recibe (parámetro de entrada): order_id, product_id, cantidad
-> procedimiento Alta Item (sobrecarga)
    Recibe (parámetro de entrada): order_id, product_description, cantidad
-> funcion privada obtener Product Id:
    Recibe: product_description
    Retorna: product_id
*/

create or replace package PA_ORDENES as
    procedure pr_alta_orden(pi_id_cliente in customer.customer_id%type,
        po_id_orden out sales_order.order_id%type);
    procedure pr_alta_item(pi_id_order in item.order_id%type,
        pi_id_product in item.product_id%type,
        pi_cantidad in item.quantity%type);
    procedure pr_alta_item(pi_id_order in item.order_id%type,
        pi_product_desc in product.description%type,
        pi_cantidad in item.quantity%type);
end PA_ORDENES;
create or replace package body PA_ORDENES is
    e_fk exception;
    pragma exception_init(e_fk, -02291);

    function fu_obtener_producto(p_product_desc product.description%type)
        return product.product_id%type
    is
        l_id_prod product.product_id%type;
        begin
            
            select product_id
            into l_id_prod
            from product
            where lower(description) = lower(p_product_desc);

            return l_id_prod;

            exception
                when no_data_found then
                    raise_application_error(-20001, 'No existe el producto');
                 when too_many_rows then
                    raise_application_error(-20002, 'Existe más de un producto con ese nombre');
                when others then
                    raise_application_error(-20003, 'Error inesperado: ' || sqlerrm);
    end fu_obtener_producto;

    procedure pr_alta_orden(pi_id_cliente in customer.customer_id%type,
        po_id_orden out sales_order.order_id%type)
    as
        l_order_date sales_order.order_date%type := sysdate;
        l_ship_date sales_order.ship_date%type := sysdate + 7;
        l_order_id  sales_order.order_id%type;
        begin
            select max(order_id)
            into l_order_id
            from sales_order;

            insert into sales_order (order_id, order_date, customer_id, ship_date, total)
            values(l_order_id + 1, l_order_date, pi_id_cliente, l_ship_date, 0);
            
            -- Asignamos el PO luego del insert para no devolver el output parameter en caso de error
            -- Esto es una buena práctica
            po_id_orden := l_order_id + 1;

            dbms_output.put_line('La orden de venta fue creada con éxito');
        exception
            when e_fk then
                dbms_output.put_line('El cliente ingresado no existe');
            when others then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
        end pr_alta_orden;

    procedure pr_alta_item(pi_id_order in item.order_id%type,
        pi_id_product in item.product_id%type,
        pi_cantidad in item.quantity%type)
    as
        l_max_item_id item.item_id%type;
        l_actual_price price.list_price%type;
    begin
        select nvl(max(item_id), 0)
        into l_max_item_id
        from item
        where order_id = pi_id_order;

        select list_price
        into l_actual_price
        from price
        where product_id = pi_id_product and end_date is null;

        insert into item (order_id, item_id, product_id, actual_price, quantity, total)
        values(pi_id_order, l_max_item_id + 1, pi_id_product, l_actual_price, pi_cantidad, pi_cantidad * l_actual_price);

        dbms_output.put_line('El item fue creado con éxito');

        update sales_order
        set total = total + (pi_cantidad * l_actual_price)
        where order_id = order_id;

        exception
            when others then
                dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end pr_alta_item;
    

    procedure pr_alta_item(pi_id_order in item.order_id%type,
        pi_product_desc in product.description%type,
        pi_cantidad in item.quantity%type)
    as
    begin
        pr_alta_item(pi_id_order, fu_obtener_producto(pi_product_desc), pi_cantidad);
    end pr_alta_item;
end PA_ORDENES;

declare
    p_id_orden sales_order.order_id%type;
begin
    PA_ORDENES.pr_alta_orden(100, p_id_orden);
    dbms_output.put_line('Id_Orden: ' || p_id_orden);
    PA_ORDENES.pr_alta_item(p_id_orden, 'ACE TENNIS RACKET I', 2);
end

-- select * from sales_order where order_id = 625
-- select * from item order by order_id desc

-- Luego pidió el profesor que agreguemos las siguientes validaciones al último punto:
/*
- Que la cantidad sea mayor a 0
- Que el item_id no sea null -> nvl(...)
- Que exista el order_id
- Que exista el product_id
*/
-- También capturamos las exceptions generadas por la función
-- Todos estos puntos lo resolvimos en grupo