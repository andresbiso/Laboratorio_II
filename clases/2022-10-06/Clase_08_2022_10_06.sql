/*
  La finalidad es agrupar una serie de elementos


  Un PKG tiene dos partes: 1 cabecera (especification) y 1 cuerpo (body)
  En la cabecera -> Procedimientos, Funciones y Estructuras que va a contener el PKG
                    Se mencionan el Nom de Proc o Func y si recibe o devuelve algun parametro
  En el Body -> La logica del Pkg

  Para Guardarlo: 1ero marco la cabecera y la ejecuto y luego hago lo mismo con el cuerpo
  Para eliminar un Pkg: 
                  Para eliminar la especificación y el cuerpo: DROP PACKAGE nombre;
		              Para eliminar sólo el cuerpo: DROP PACKAGE BODY nombre;

Ventajas:
-	Modular
- Flexibilidad
-	Seguridad
-	Performance
-	Permite "sobrecarga de funciones " (Overloading)
     	--sobrecargar: 
		  Dos formas distintas q tienen el mismo nombre de Procedimiento pero difieren en los parametros. 
	ejemplo:
		--En la Especificacion
		  procedure consulta_empleado ( p_id employee.employee_id%type);
		  procedure consulta_empleado ( p_apellido employee.last_name%type);

		--En el Body va el desarrollo de los procedimientos

		--ejecucion:
		paquete.consulta_empleado(101);
		paquete.consulta_empleado('LOPEZ');

  --------------------------------


--Sintaxis:

Creación de la Especificación:
 CREATE OR REPLACE PACKAGE  nombrePKG IS
    v_varpub number;
 		c_conspub constant varchar2(20) := 'hola';
    e_miexcepcion exception;
    pragma exception_init (e_miexcepcion , -20100);
    cursor c_emp is select * from employee;
    procedure p_procpub (p_nom varchar2);
    function f_priv(p_palabra varchar2) return varchar2;
 END [nombrePKG];


--Creación del cuerpo: 
CREATE OR REPLACE PACKAGE BODY nombre IS
		Declaraciones privadas
		Definición de subprogramas privados
		Definición de subprogramas públicos
	END [nombre];
*/

--Ejemplo:
	CREATE OR REPLACE PACKAGE DEMO IS
	  G_iva  number := .21;           -- variable global
	  PROCEDURE Actual_comision ;    -- procedimiento público
	  PROCEDURE Informe (Fecha  IN  Date default sysdate);  -- proc. público
	END DEMO;



--===================================================================================================

create or replace package PA_EMPLEADOS as

PROCEDURE pr_modif_salario (pi_nombre   employee.first_name%type,
                            pi_apellido employee.last_name%type,
                            pi_salario  employee.salary%type) ;

PROCEDURE pr_modif_salario (pi_emp_id  employee.employee_id%type,
                            pi_salario employee.salary%type) ;
end;



create or replace package body "PA_EMPLEADOS" is

e_emp_noex exception;
e_emp_dupl exception;
e_emp_otro exception;
pragma exception_init(e_emp_noex,-20001);
pragma exception_init(e_emp_dupl,-20002);
pragma exception_init(e_emp_otro,-20003);

/***************************************************/
function fu_emp_id(pi_nombre   employee.first_name%type,
                   pi_apellido employee.last_name%type)
                 return  employee.employee_id%type is
  l_emp_id employee.employee_id%type;
begin

  select employee_id
    into l_emp_id
    from employee
   where upper(first_name) = upper(pi_nombre)
     and upper(last_name) = upper(pi_apellido);

   return l_emp_id;

  exception
    when no_data_found then
      raise_application_error(-20001,'EMPLEADO NO EXISTE');
    when too_many_rows then  
      raise_application_error(-20002,'mas de un empleado con el mismo nombre');
    when others then
      raise_application_error(-20003,'error inesperado '||sqlerrm);
        
  end;                 

/***************************************************/


PROCEDURE pr_modif_salario (pi_emp_id  employee.employee_id%type,
                            pi_salario employee.salary%type) 
as
begin
   update employee
   set salary = pi_salario
   where employee_id = pi_emp_id;
 
   if sql%rowcount = 1 then  
      dbms_output.put_line('El salario se modifico exitosamente');
   else
      dbms_output.put_line('El empleado no existe');
   end if;

end PR_MODIF_SALARIO;
/**********************************************/
PROCEDURE pr_modif_salario (pi_nombre   employee.first_name%type,
                            pi_apellido employee.last_name%type,
                            pi_salario  employee.salary%type) is
  l_emp_id employee.employee_id%type;



begin

   l_emp_id := fu_emp_id (pi_nombre,pi_apellido);
   pr_modif_salario(l_emp_id,pi_salario);
exception
  when e_emp_noex then
    dbms_output.put_line('empleado no existe');
  when e_emp_dupl then
    dbms_output.put_line('mas de un empleado con el mismo nombre');
  when e_emp_otro then
    dbms_output.put_line('error inesperado el buscar el empleado '||sqlerrm);

 end;
 /****************************************************/ 





/*one time only*/
begin
  dbms_output.put_line('Primera vez');
end ;




