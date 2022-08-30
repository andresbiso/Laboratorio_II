/* Actividad */
/*
crear un bloque anónimo en que ingresen por variable de sustitución un id de departamento y un nombre
y de de alta un departamento.
Solo por este ejercicio no contemplar excepciones (Errores).
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