/*Práctica Unidad 4: Procedimientos y Funciones*/
/*
1.	Escribir un procedimiento Alta_Job para insertar un nuevo cargo en la tabla JOB: (ver ej 4, Unidad 3)
­	el Job_Id debe generarse sumando 1 al máximo Job_Id existente
­	el nombre del cargo (Function) debe ser informado por parámetro. Recordar que en la base de datos todos los nombres de función están en mayúsculas
­	asentar en la base de datos este insert (Commit).
*/
/*
2.	Crear un procedimiento Upd_Job para actualizar los nombres de los cargos:
­	Informar el job_id y el nuevo nombre de función mediante dos parámetros. 
­	Si el job_id no existe, informar mediante un mensaje y cancelar el procedimiento.
*/
/*
3.	Crear un procedimiento Lista_Emp que recibe mediante un parámetro el código de un departamento e informe el nombre y apellido de todos los empleados que trabajan en él. 
Contemplar todos los errores posibles: el código no corresponde a un departamento, no hay empleados en el departamento o cualquier error y desplegar mensajes. 
*/
/*
4.	Crear un procedimiento Consulta_Precio que recibe un código de producto y devuelve el precio de lista (List_price) y el precio_mínimo (Min_price).
­	Si el producto no existe, atrapar la excepción correspondiente y emitir un mensaje de error.
­	Para probar el procedimiento usar el RUN de SqlDeveloper o invocarlo desde un bloque anónimo y desplegar los valores obtenidos en las variables usadas como parámetros de out.
*/
/*
5.	Escribir una función Q_Credit que recibe el id de un cliente y devuelve el límite de crédito que tiene actualmente (credit_limit). Si el cliente no existe debe devolver nulls. 
­	Probar la función desde SqlDeveloper o usando un bloque anónimo.
*/
/*
6.	Crear una función Valida_Loc que recibe un código de localidad y devuelve TRUE si el código existe en la tabla Location, en caso contrario devuelve FALSE.
*/
/*
7.	Crear un procedimiento New_Dept para insertar una fila en la tabla Department. Este procedimiento recibe como parámetros el id, (Department_id), el nombre (Name) y la localidad (Location_id). Para insertar el departamento se debe validar que el código de localidad sea válido usando la función Valida_Loc. Si la localidad es inválida cancelar el procedimiento con un mensaje se error.
*/
/*
8.	Crear una función Iva que reciba una valor y devuelva el mismo aplicándole el 21%.
­	Usar esta función para desplegar los datos de las órdenes de venta (Sales_order), mostrar todas las columnas más una columna que muestre el total de la orden aplicándole el iva.
*/