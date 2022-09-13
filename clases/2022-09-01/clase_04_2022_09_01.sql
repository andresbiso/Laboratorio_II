--Repaso
--EJ P2-8

declare
    type tr_emp is record (         
        nombre  employee.first_name%type,
        apellido employee.last_name%type,
        manager_id employee.manager_id%type,
        manager_name employee.first_name%type
    );

    tt_emp tr_emp;
    v_id employee.employee_id%type;

begin 

    v_id := :Ingrese_id_Empleado;
    
    select e.first_name , e.last_name , e.manager_id , m.first_name
    into tt_emp.nombre , tt_emp.apellido , tt_emp.manager_id , tt_emp.manager_name
    from employee e , employee m
    where e.employee_id = v_id 
    and e.manager_id = m.employee_id; 

    dbms_output.put_line('ID Empleado: '||v_id ||' Nombre Empleado: '||tt_emp.nombre ||' Apellido: '||tt_emp.apellido || ' Manager ID: '|| tt_emp.manager_id ||' Manager Name: ' || tt_emp.manager_name);
end;

--Excepciones Predefinidas:
no_data_found
too_many_rows
dup_val_on_index
value_error
zero_divide

--No Predefinidas:
-2291 No existe el padre
-2292 existe hijos

--Excepciones de Usuario:

declare
    v_dep_name department.name%TYPE;
    e_fk exception; 
    pragma exception_init(e_fk,-2291);

begin
    /*select name
    into v_dep_name
    from department
    where department_id = 1001;

    dbms_output.put_line(v_dep_name); */
/*
    insert
    into department
     (department_id,name,location_id)
    values
     (99,'Prueba',150);
*/

--    dbms_output.put_line(8/0);

/*    update price
    set list_price = 1
    where product_id = 100871;    */

    

exception
    when no_data_found then
     dbms_output.put_line('no existe el departmento');
    when dup_val_on_index then
     dbms_output.put_line('Dato Duplicado');
    when zero_divide then
     dbms_output.put_line('Error al dividir por 0');
    when e_fk then
     dbms_output.put_line('No Existe la localidad indicada');
    when value_error then
     raise_application_error(-20001,'error propio');
    when others then
     dbms_output.put_line('Se produjo un error inesperado '||sqlerrm);   
     dbms_output.put_line('Codigo: '||sqlcode);
end;   


declare v_nom varchar(5);
begin
    v_nom:='Martin';
    dbms_output.put_line('Nombre: '||v_nom);
exception
    when value_error then
    raise_application_error(-20015,'El nombre Ingresado es demasiado largo');
end;
