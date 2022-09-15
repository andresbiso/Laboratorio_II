/* Actividad */
/*
Crear un procedimiento para dar de alta un departamento 

Recibe por parametros el nombre y el id de localidad. 

Devuelve por parametro el id del nuevo departamento creado. 

Para generar el nuevo id, se le suma 1 al maximo existente en la tabla 

Contemplar todos los errores posibles. 

Nunca cancelar 
*/

create or replace procedure pr_nuevo_depto
    (pi_nombre in department.name%type,
    pi_loc_id in department.location_id%type,
	po_id_depto out department.department_id%type)
is
    l_max_id department.department_id%type;

    e_fk exception;
    pragma exception_init(e_fk, -02291);
    e_lv exception;
    pragma exception_init(e_lv, -01438);

    begin
        select nvl(max(department_id), 0)
        into l_max_id
        from department;

        insert into department
            (department_id, name, location_id)
        values
            (l_max_id + 1, pi_nombre, pi_loc_id);
        
        po_id_depto := l_max_id + 1;
        
        exception
        when e_fk then
            dbms_output.put_line('La localidad ingresada no existe');
        when e_lv then
            dbms_output.put_line('La localidad ingresada tiene un valor muy largo');
        when others then
            dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end;

declare
    po_id_depto department.department_id%type;
begin
    pr_nuevo_depto('Prueba SP', 123, po_id_depto);
    dbms_output.put_line('Nuevo Id Departamento: ' || po_id_depto);
end;