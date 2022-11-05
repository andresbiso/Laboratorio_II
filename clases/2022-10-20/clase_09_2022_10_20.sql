/*
  La finalidad es agrupar una serie de elementos


  Un PKG tiene dos partes: 1 cabecera (especification) y 1 cuerpo (body)
  En la cabecera -> Procedimientos, Funciones y Estructuras que va a contener el PKG
                    Se mencionan el Nom de Proc o Func y si recibe o devuelve algun parametro
  En el Body -> La logica del Pkg

  Para Guardarlo: 1ero marco la cabecera y la ejecuto y luego hago lo mismo con el cuerpo
  Para eliminar un Pkg: 
                  Para eliminar la especificaciÃ³n y el cuerpo: DROP PACKAGE nombre;
		              Para eliminar sÃ³lo el cuerpo: DROP PACKAGE BODY nombre;

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

CreaciÃ³n de la EspecificaciÃ³n:
 CREATE OR REPLACE PACKAGE  nombrePKG IS
    v_varpub number;
 		c_conspub constant varchar2(20) := 'hola';
    e_miexcepcion exception;
    pragma exception_init (e_miexcepcion , -20100);
    cursor c_emp is select * from employee;
    procedure p_procpub (p_nom varchar2);
    function f_priv(p_palabra varchar2) return varchar2;
 END [nombrePKG];


--CreaciÃ³n del cuerpo: 
CREATE OR REPLACE PACKAGE BODY nombre IS
		Declaraciones privadas
		DefiniciÃ³n de subprogramas privados
		DefiniciÃ³n de subprogramas pÃºblicos
	END [nombre];
*/

--Ejemplo:
	CREATE OR REPLACE PACKAGE DEMO IS
	  G_iva  number := .21;           -- variable global
	  PROCEDURE Actual_comision ;    -- procedimiento pÃºblico
	  PROCEDURE Informe (Fecha  IN  Date default sysdate);  -- proc. pÃºblico
	END DEMO;



--===================================================================================================

create or replace package PA_EMPLEADOS as

PROCEDURE pr_modif_salario (pi_nombre   employee.first_name%type,
                            pi_apellido employee.last_name%type,
                            pi_salario  employee.salary%type) ;

PROCEDURE pr_modif_salario (pi_emp_id  employee.employee_id%type,
                            pi_salario employee.salary%type) ;

procedure pr_lista_dep;

end;



create or replace package body "PA_EMPLEADOS" is

e_emp_noex exception;
e_emp_dupl exception;
e_emp_otro exception;
pragma exception_init(e_emp_noex,-20001);
pragma exception_init(e_emp_dupl,-20002);
pragma exception_init(e_emp_otro,-20003);

type tr_dep is record (
        id department.department_id%type,
        name department.name%type,
        c_emp number,
        prom number
);

type tt_dep is table of tr_dep index by binary_integer; 
t_dep tt_dep;

cursor c_dep is 
select d.department_id id, d.name, avg(e.salary) prom, count(e.employee_id) cant
from department d inner join employee e on (d.department_id = e.department_id)
group by d.department_id, d.name;

v_x number := 1;

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

 /*****************Listado*********************/ 
procedure pr_lista_dep
as
    cursor c_emp (pi_dep_id department.department_id%type) is
    select first_name f, last_name l
    from employee
    where department_id = pi_dep_id;
begin
    for i in 1..t_dep.count loop
        dbms_output.put_line('Id: '|| t_dep(i).id ||', Nombre: '|| t_dep(i).name || ', Promedio salario: ' || trunc(t_dep(i).prom, 2) || ', Cant empleados: ' ||t_dep(i).c_emp );
        for r_emp in c_emp(t_dep(i).id) loop
            dbms_output.put_line('Nombre: ' || r_emp.f || ' Apellido: '|| r_emp.l);
        end loop;
    end loop;
end;
 /****************************************************/ 

/*one time only*/
begin
  dbms_output.put_line('Primera vez');

  for r_dep in c_dep loop
    t_dep(v_x).id := r_dep.id;
    t_dep(v_x).name := r_dep.name;
    t_dep(v_x).prom := r_dep.prom;
    t_dep(v_x).c_emp := r_dep.cant;
    v_x := v_x + 1;
  end loop;

end ;


begin
  pa_empleados.PR_MODIF_SALARIO('KEVIN','ALLEN',2000);
end;

begin
  pa_empleados.PR_MODIF_SALARIO(7560,6000);
end;

begin
  pa_empleados.pr_lista_dep;
end;

SELECT employee_id , last_name , first_name , salary from employee order by 1;


--Variante con Bulk collect
/*
/*one time only*/
begin

  select d.department_id , d.name , count(e.employee_id) , avg(e.salary)
    bulk collect into t_dep
    from department d, employee e
    where d.department_id = e.department_id
    group by d.department_id , d.name
    order by d.department_id;
*/

