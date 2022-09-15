/* Actividad */
/*
Hacer un Procedimiento que muestre por pantalla todos los clientes de un vendedor 
El código de vendedor se recibe como paramentro en el procedimiento 
 

Para cada cliente mostrar: 
nombre , limite de crédito, leyenda(crédito) 

Leyenda crédito 
<= 4000 "BAJO" 
4001 y 8500 "MEDIO" 
>8501 "ALTO" 
*/

create or replace procedure pr_mostrar_clientes
	(pi_vendedor_id in employee.employee_id%type)
is
    v_leyenda varchar2(10);
	cursor c_cliente is 
        select c.name, c.credit_limit
        from customer c
        inner join employee e on c.salesperson_id = e.employee_id
        where e.employee_id = pi_vendedor_id;
begin
    for r_cliente in c_cliente
    loop
        if (r_cliente.credit_limit < 4001) then
            v_leyenda := 'BAJO';
        elsif (r_cliente.credit_limit < 8501) then
            v_leyenda := 'MEDIO';
        else
            v_leyenda := 'ALTO';
        end if;
        dbms_output.put_line('Nombre:' || r_cliente.name || ' ' || 'Límite de crédito:' || r_cliente.credit_limit || ' ' || 'Leyenda(crédito):' || v_leyenda);
    end loop;

    exception
        when others then
            dbms_output.put_line('Error inesperado: ' || sqlerrm);
end;

begin
	pr_mostrar_clientes(749);
end