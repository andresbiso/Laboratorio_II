/*
# Ejercicio Nro 6 (Funcion)

Realizar una función que recibe un salario
y devuelve el valor del id de la escala de salarios
hacer un bloque anónimo que liste todos los empleados que pertenecen a esa escala de salarios.
*/

create or replace function fu_salary_grade
    (pi_salary employee.salary%type)
return salary_grade.grade_id%type
is
    v_salary_grade salary_grade.grade_id%type;
    begin
        select grade_id
        into v_salary_grade
        from salary_grade
        where pi_salary between lower_bound and upper_bound;

        return v_salary_grade;

        exception
            when no_data_found then
                dbms_output.put_line('Error, el valor ingresado no pertenece a una escala válida');
                return -1;
            when others then
                dbms_output.put_line('Error inesperado al validar empleado ' || sqlerrm);
    end;

declare
    v_salary employee.salary%type;
    v_grade_id salary_grade.grade_id%type;
    v_lower_bound salary_grade.lower_bound%type;
    v_upper_bound salary_grade.upper_bound%type;

    cursor c_emp_escala (p_grade_id number)
    is
        select e.*
        from employee e, salary_grade sg
        where sg.grade_id = p_grade_id and e.salary between sg.lower_bound and sg.upper_bound;
begin
    v_salary := :Ingresa_Salario;
    /*
    select fu_salary_grade(v_salary)
    into v_grade_id
    from dual;
    */
    for r_emp_escala in c_emp_escala (fu_salary_grade(v_salary)) loop
            dbms_output.put_line('Employee_Id: ' || r_emp_escala.employee_id || ' Full Name: ' || r_emp_escala.first_name || ' ' || r_emp_escala.middle_initial || ' ' || r_emp_escala.last_name || ' Salary: ' || r_emp_escala.salary);
    end loop;
end;
