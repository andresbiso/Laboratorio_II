/*Práctica Unidad 4: Procedimientos y Funciones*/
/*
1.	Escribir un procedimiento Alta_Job para insertar un nuevo cargo en la tabla JOB: (ver ej 4, Unidad 3)
­	el Job_Id debe generarse sumando 1 al máximo Job_Id existente
­	el nombre del cargo (Function) debe ser informado por parámetro. Recordar que en la base de datos todos los nombres de función están en mayúsculas
­	asentar en la base de datos este insert (Commit).
*/

create or replace procedure pr_alta_job
    (pi_cargo in job.function%type)
is
    v_max_id job.job_id%type;
begin
    select max(job_id)
    into v_max_id
    from job;

    insert into job(job_id, function)
    values (nvl(v_max_id, 0) + 1, upper(pi_cargo));

    -- commit;
end

begin
    pr_alta_job('estudiante');
end

delete from job where function = 'ESTUDIANTE';

/*
2.	Crear un procedimiento Upd_Job para actualizar los nombres de los cargos:
­	Informar el job_id y el nuevo nombre de función mediante dos parámetros. 
­	Si el job_id no existe, informar mediante un mensaje y cancelar el procedimiento.
*/

create or replace procedure pr_upd_job
    (pi_id_job in job.job_id%type,
        pi_cargo in job.function%type)
is
    v_i number := 0;
begin
    select count(*) into v_i from job where job_id = pi_id_job;

    if v_i = 0 then
        raise_application_error(-20001, 'El job ingresado no existe');
    end if;

    update job
    set function = upper(pi_cargo)
    where job_id = pi_id_job;

    exception
        when no_data_found then
            dbms_output.put_line('El job ingresado no existe');
end

begin
    pr_upd_job(673, 'prueba');
end

/*
3.	Crear un procedimiento Lista_Emp que recibe mediante un parámetro el código de un departamento e informe el nombre y apellido de todos los empleados que trabajan en él. 
Contemplar todos los errores posibles: el código no corresponde a un departamento, no hay empleados en el departamento o cualquier error y desplegar mensajes. 
*/
/*
4.	Crear un procedimiento Consulta_Precio que recibe un código de producto y devuelve el precio de lista (List_price) y el precio_mínimo (Min_price).
­	Si el producto no existe, atrapar la excepción correspondiente y emitir un mensaje de error.
­	Para probar el procedimiento usar el RUN de SqlDeveloper o invocarlo desde un bloque anónimo y desplegar los valores obtenidos en las variables usadas como parámetros de out.
*/

create or replace procedure pr_consulta_precio
    (pi_id_prod in product.product_id%type,
    po_list_price out price.list_price%type,
    po_min_price out price.min_price%type)
is
    v_x varchar2(1);
begin
    select '*' into v_x from product where product_id = pi_id_prod;

    select list_price, min_price
    into po_list_price, po_min_price
    from price
    where product_id = pi_id_prod and end_date is not null;

    exception
        when no_data_found then
            dbms_output.put_line('No existe el producto ingresado');
end

declare
    p_list_price price.list_price%type;
    p_min_price price.min_price%type;
begin
    pr_consulta_precio(100871, p_list_price, p_min_price);

    dbms_output.put_line('List Price: ' || to_char(p_list_price) || ' Min Price: ' || to_char(p_min_price));
end

/*
5.	Escribir una función Q_Credit que recibe el id de un cliente y devuelve el límite de crédito que tiene actualmente (credit_limit). Si el cliente no existe debe devolver nulls. 
­	Probar la función desde SqlDeveloper o usando un bloque anónimo.
*/


/*
6.	Crear una función Valida_Loc que recibe un código de localidad y devuelve TRUE si el código existe en la tabla Location, en caso contrario devuelve FALSE.
*/

create or replace function fu_valida_loc
    (pi_loc_id location.location_id%type)
    return boolean
is
    v_cantidad number := 0;
    begin
        select count(*)
        into v_cantidad
        from location
        where location_id = pi_loc_id;

        return (v_cantidad > 0);

        exception
        when others then
            dbms_output.put_line('Error inesperado: ' || sqlerrm);
    end;

declare
    v_existe boolean;
    c_loc_cod constant location.location_id%type := 122;
begin
    dbms_output.put_line('¿Existe la localidad con código ' || to_char(c_loc_cod) || ' ?');
    if fu_valida_loc(c_loc_cod) then
        dbms_output.put_line('TRUE');
    else
        dbms_output.put_line('FALSE');
    end if;
end;

/*
7.	Crear un procedimiento New_Dept para insertar una fila en la tabla Department. Este procedimiento recibe como parámetros el id, (Department_id), el nombre (Name) y la localidad (Location_id). Para insertar el departamento se debe validar que el código de localidad sea válido usando la función Valida_Loc. Si la localidad es inválida cancelar el procedimiento con un mensaje se error.
*/
/*
8.	Crear una función Iva que reciba una valor y devuelva el mismo aplicándole el 21%.
­	Usar esta función para desplegar los datos de las órdenes de venta (Sales_order), mostrar todas las columnas más una columna que muestre el total de la orden aplicándole el iva.
*/
