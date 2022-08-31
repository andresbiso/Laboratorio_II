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

declare
    v_edad number(3);
    v_fecha date;
    v_fecha_nacimiento varchar2(10);
    v_escolaridad varchar2(30);
begin
    v_fecha_nacimiento := :Ingrese_fecha_nacimiento;
    v_fecha := to_date(v_fecha_nacimiento,'dd/mm/yyyy');
    v_edad := floor((sysdate - v_fecha)/365);
    dbms_output.put_line('Edad:' || v_edad);
    
    if (v_edad < 3) then
        v_escolaridad := 'bebe';
    elsif (v_edad < 6) then
        v_escolaridad := 'jardín';
    elsif (v_edad < 13) then
        v_escolaridad := 'primaria';
    elsif (v_edad < 18) then
       v_escolaridad := 'secundaria';
    elsif (v_edad < 26) then
        v_escolaridad := 'universidad';
    else
        v_escolaridad := 'trabajo';
    end if;
    dbms_output.put_line('Escolaridad:' || v_escolaridad);
end;
