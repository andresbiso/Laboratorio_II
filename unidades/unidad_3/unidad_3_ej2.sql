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
    v_leyenda varchar2(10);
begin
    v_vendedor_id := :Ingrese_codigo_vendedor;

    for c in (select *
    from customer
    where salesperson_id = v_vendedor_id)
    loop
        if (c.credit_limit < 4001) then
            v_leyenda := 'BAJO';
        elsif (c.credit_limit < 8501) then
            v_leyenda := 'MEDIO';
        else
            v_leyenda := 'ALTO';
        end if;
        dbms_output.put_line('Nombre:' || c.name || ' ' || 'Límite de crédito:' || c.credit_limit || ' ' || 'Leyenda(crédito):' || v_leyenda);
    end loop;

    exception
        when no_data_found then
            dbms_output.put_line('El vendedor ingresado no existe');
        when too_many_rows then
            dbms_output.put_line('Existe más de un vendedor para ese id');
end;
