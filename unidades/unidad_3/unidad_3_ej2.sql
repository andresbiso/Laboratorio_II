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
 v_id_depto department.department_id%type;
 v_nom_depto department.name%type;
begin
 v_id_depto := :Id_Departamento;
 v_nom_depto := :Nombre;

 insert into department (department_id, name)
 values (v_id_depto, v_nom_depto);

 dbms_output.put_line('Id_Departamento: ' || v_id_depto);
 dbms_output.put_line('Nombre: ' || v_nom_depto);
end