/* Actividad */
/*
Desarrollar un bloque anónimo que reciba por variable de sustitución una fecha de nacimiento en el formato dd/mm/yyyy 

calcular la edad y mostrar por pantalla el nivel de escolaridad 

0-2 bebe 

3-5 jardín 

6-12 primaria 

13-17 secundaria 

18-25 universidad 

>25 trabajo 
*/
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