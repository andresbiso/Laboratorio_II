/* Actividad */
/*
Hacer un bloque anónimo que muestre por pantalla todos los clientes de un vendedor 

el código de vendedor se debe ingresar por variable de sustitución 

para cada cliente mostrar 

nombre , limite de crédito, leyenda(crédito) 

Leyenda crédito 

<= 4000 "BAJO" 

4001 y 8500 "MEDIO" 

>8501 "ALTO" 
*/

declare
    v_vendedor_id employee.employee_id%type;


    type tt_cust is table of customer%rowtype index by binary_integer;
    t_cust tt_cust;
    l_idx binary_integer;
begin
    v_vendedor_id := :Ingrese_codigo_vendedor;

    select *
    into t_cust
    from customer
    where salesperson_id = v_vendedor_id;

    l_idx := t_cust.first;

    while l_idx <= t_cust.last loop
        dbms_output.put_line(l_idx||' '||t_cust(l_idx).name||' '||t_cust(l_idx).credit_limit);
        l_idx := t_cust.next(l_idx);
    end loop;

    --dbms_output.put_line(v_cliente_nombre || ' ' || v_cliente_credito);
    /*
    if (v_credito < 4001) then
        v_leyenda := 'BAJO';
    elsif (v_credito < 8501) then
        v_leyenda := 'MEDIO';
    else
        v_leyenda := 'ALTO';
    end if;*/

    exception
        when no_data_found then
            dbms_output.put_line('El vendedor ingresado no existe');
        when too_many_rows then
            dbms_output.put_line('Existe más de un vendedor para ese id');
end;
