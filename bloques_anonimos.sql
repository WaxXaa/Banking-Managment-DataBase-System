-- configuracion para imprimir
SET SERVEROUTPUT ON;
SET LINESIZE 2000;
--tipo celular
DECLARE
    v_tipo_telefono Tipo_Telefono.tipo_telefono%TYPE;
    v_tipo_telefono_id Tipo_Telefono.tipo_telefono_id%TYPE;
BEGIN
    v_tipo_telefono := 'celular';
    v_tipo_telefono_id := 1;
    InsertarTipoTelefono(v_tipo_telefono_id, v_tipo_telefono);

    v_tipo_telefono:= 'residencia';
    v_tipo_telefono_id := 2;
    InsertarTipoTelefono(v_tipo_telefono_id, v_tipo_telefono);

    v_tipo_telefono := 'familiar mas cercano';
    v_tipo_telefono_id := 3;
    InsertarTipoTelefono(v_tipo_telefono_id, v_tipo_telefono);

    v_tipo_telefono := 'conyugue';
    v_tipo_telefono_id := 4;
    InsertarTipoTelefono(v_tipo_telefono_id, v_tipo_telefono);

    DBMS_OUTPUT.PUT_LINE('tipos de telefonos insertados correctamente');

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');
    COMMIT;
END;
/

--tipo correo
DECLARE
    v_tipo_email Tipo_Email.tipo_emaiL%TYPE;
    v_tipo_email_id Tipo_Email.tipo_email_id%TYPE;
BEGIN
    v_tipo_email := 'academico';
    v_tipo_email_id := 1;
    InsertarTipoCorreo(v_tipo_email_id, v_tipo_email);

    v_tipo_email := 'laboral';
    v_tipo_email_id := 2;
    InsertarTipoCorreo(v_tipo_email_id, v_tipo_email);

    v_tipo_email := 'personal';
    v_tipo_email_id := 3;
    InsertarTipoCorreo(v_tipo_email_id, v_tipo_email);

    DBMS_OUTPUT.PUT_LINE('tipos de email insertados correctamente');
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');
COMMIT;
END;
/

--tipo prestamo
DECLARE
v_tipo_prestamo Tipo_Prestamo.tipo_prestamo%TYPE;
v_tipo_prestamo_id Tipo_Prestamo.tipo_prestamo_id%TYPE;
BEGIN
    v_tipo_prestamo := 'personal';
    v_tipo_prestamo_id := 1;
    InsertarTipoPrestamo(v_tipo_prestamo_id, v_tipo_prestamo);

    v_tipo_prestamo := 'hipoteca';
    v_tipo_prestamo_id := 2;
    InsertarTipoPrestamo(v_tipo_prestamo_id, v_tipo_prestamo);

    v_tipo_prestamo := 'auto';
    v_tipo_prestamo_id := 3;
    InsertarTipoPrestamo(v_tipo_prestamo_id, v_tipo_prestamo);

    v_tipo_prestamo := 'garantizado con ahorros';
    v_tipo_prestamo_id := 4;
    InsertarTipoPrestamo(v_tipo_prestamo_id, v_tipo_prestamo);

    DBMS_OUTPUT.PUT_LINE('tipos de prestamos insertados correctamente');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');
COMMIT;
END;
/

--sucursales
DECLARE
    v_cod_sucursal Sucursal.cod_sucursal%TYPE;
    v_nombre_sucursal Sucursal.nombre_sucursal%TYPE;
BEGIN
    v_cod_sucursal := 1;
    v_nombre_sucursal := 'calle 50';
    InsertarSucursal(
        p_cod_sucursal => v_cod_sucursal,
        p_nombre_sucursal => v_nombre_sucursal
    );

    v_cod_sucursal := 2;
    v_nombre_sucursal := 'via españa';
    InsertarSucursal(
        p_cod_sucursal => v_cod_sucursal,
        p_nombre_sucursal => v_nombre_sucursal
    );
    
    v_cod_sucursal := 3;
    v_nombre_sucursal := 'el dorado';
    InsertarSucursal(
        p_cod_sucursal => v_cod_sucursal,
        p_nombre_sucursal => v_nombre_sucursal
    );

    v_cod_sucursal := 4;
    v_nombre_sucursal := 'avenida balboa';
    InsertarSucursal(
        p_cod_sucursal => v_cod_sucursal,
        p_nombre_sucursal => v_nombre_sucursal
    );

    DBMS_OUTPUT.PUT_LINE('Sucursales insertadas correctamente');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');
    COMMIT;
END;
/


-- cliente

DECLARE
    v_cedula Cliente.cedula%TYPE;
    v_nombre Cliente.nombre%TYPE;
    v_apellido Cliente.apellido%TYPE;
    v_sexo Cliente.sexo%TYPE;
    v_fecha_nacimiento Cliente.fecha_nacimiento%TYPE;
    v_email Email.email%TYPE;
    v_tipo_correo Tipo_Email.tipo_email%TYPE;
    v_telefono Telefono.telefono%TYPE;
    v_tipo_telefono Tipo_Telefono.tipo_telefono%TYPE;
    v_profesion Profesion.profesion%TYPE;
    v_sucursal_nombre Sucursal.nombre_sucursal%TYPE;
BEGIN
    v_cedula := '8-888';
    v_nombre := 'pedro';
    v_apellido := 'gonzalez';
    v_sexo := 'M';
    v_fecha_nacimiento := TO_DATE('09-09-2000');
    v_email := 'g.pedro@gmail.com';
    v_tipo_correo := 'personal';
    v_telefono := '6455';
    v_tipo_telefono := 'celular';
    v_profesion := 'abogado';
    v_sucursal_nombre := 'calle 50';

    InsertarCliente(
        p_cedula => v_cedula,
        p_nombre => v_nombre,
        p_apellido => v_apellido,
        p_sexo => v_sexo,
        p_fecha_nacimiento => v_fecha_nacimiento,
        p_email => v_email,
        p_tipo_correo => v_tipo_correo,
        p_telefono => v_telefono,
        p_tipo_telefono => v_tipo_telefono,
        p_profesion => v_profesion,
        p_sucursal => v_sucursal_nombre
    );

    v_cedula := '8-777';
    v_nombre := 'juan';
    v_apellido := 'avila';
    v_sexo := 'M';
    v_fecha_nacimiento := TO_DATE('01-06-1990');
    v_email := 'a.juan@empresa.com';
    v_tipo_correo := 'laboral';
    v_telefono := '6622';
    v_tipo_telefono := 'celular';
    v_profesion := 'ing. electrico';
    v_sucursal_nombre := 'via españa';

    InsertarCliente(
        p_cedula => v_cedula,
        p_nombre => v_nombre,
        p_apellido => v_apellido,
        p_sexo => v_sexo,
        p_fecha_nacimiento => v_fecha_nacimiento,
        p_email => v_email,
        p_tipo_correo => v_tipo_correo,
        p_telefono => v_telefono,
        p_tipo_telefono => v_tipo_telefono,
        p_profesion => v_profesion,
        p_sucursal => v_sucursal_nombre
    );

    v_cedula := '8-222';
    v_nombre := 'sara';
    v_apellido := 'hernandez';
    v_sexo := 'F';
    v_fecha_nacimiento := TO_DATE('28-06-1958');
    v_email := 'h.sara@gmail.com';
    v_tipo_correo := 'personal';
    v_telefono := '6699';
    v_tipo_telefono := 'celular';
    v_profesion := 'doctora';
    v_sucursal_nombre := 'avenida balboa';

    InsertarCliente(
        p_cedula => v_cedula,
        p_nombre => v_nombre,
        p_apellido => v_apellido,
        p_sexo => v_sexo,
        p_fecha_nacimiento => v_fecha_nacimiento,
        p_email => v_email,
        p_tipo_correo => v_tipo_correo,
        p_telefono => v_telefono,
        p_tipo_telefono => v_tipo_telefono,
        p_profesion => v_profesion,
        p_sucursal => v_sucursal_nombre
    );

    v_cedula := '8-333';
    v_nombre := 'mariana';
    v_apellido := 'ramos';
    v_sexo := 'F';
    v_fecha_nacimiento := TO_DATE('09-03-1999');
    v_email := 'r.marina@universidad.com';
    v_tipo_correo := 'academico';
    v_telefono := '2233';
    v_tipo_telefono := 'residencia';
    v_profesion := 'ing. civil';
    v_sucursal_nombre := 'el dorado';

    InsertarCliente(
        p_cedula => v_cedula,
        p_nombre => v_nombre,
        p_apellido => v_apellido,
        p_sexo => v_sexo,
        p_fecha_nacimiento => v_fecha_nacimiento,
        p_email => v_email,
        p_tipo_correo => v_tipo_correo,
        p_telefono => v_telefono,
        p_tipo_telefono => v_tipo_telefono,
        p_profesion => v_profesion,
        p_sucursal => v_sucursal_nombre
    );

    DBMS_OUTPUT.PUT_LINE('Cliente insertado correctamente');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar el cliente');
COMMIT;
END;
/

-- PRESTAMOS
DECLARE
    v_cliente_cedula Cliente.cedula%TYPE;
    v_tipo_prestamo Tipo_Prestamo.tipo_prestamo%TYPE;
    v_fecha_aprobado Prestamo.fecha_aprobado%TYPE;
    v_monto_aprobado Prestamo.monto_aprobado%TYPE;
    v_tasa_interes Prestamo.tasa_interes%TYPE;
    v_letra_mensual Prestamo.letra_mensual%TYPE;
    v_fecha_pago Prestamo.fecha_pago%TYPE;
    v_nombre_sucursal Sucursal.nombre_sucursal%TYPE;
    v_usuario Prestamo.usuario%TYPE;
BEGIN
    BEGIN

    v_cliente_cedula := '8-888';
    v_tipo_prestamo := 'personal';
    v_fecha_aprobado := TO_DATE('09-01-2023', 'DD-MM-YYYY');
    v_monto_aprobado := 30000;
    v_tasa_interes := 8;
    v_letra_mensual := 700;
    v_fecha_pago := TO_DATE('01-05-2027', 'DD-MM-YYYY');
    v_nombre_sucursal := 'calle 50';
    v_usuario := 'lic. juan perez';

    InsertarPrestamo(
        p_cliente_cedula => v_cliente_cedula,
        p_tipo_prestamo => v_tipo_prestamo,
        p_fecha_aprobado => v_fecha_aprobado,
        p_monto_aprobado => v_monto_aprobado,
        p_tasa_interes => v_tasa_interes,
        p_letra_mensual => v_letra_mensual,
        p_fecha_pago => v_fecha_pago,
        p_nombre_sucursal => v_nombre_sucursal,
        p_usuario => v_usuario
    );
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar el préstamo');
    END;
        BEGIN

    v_cliente_cedula := '8-222';
    v_tipo_prestamo := 'auto';
    v_fecha_aprobado := TO_DATE('25-04-2023', 'DD-MM-YYYY');
    v_monto_aprobado := 45000;
    v_tasa_interes := 9;
    v_letra_mensual := 750;
    v_fecha_pago := TO_DATE('01-05-2028', 'DD-MM-YYYY');
    v_nombre_sucursal := 'avenida balboa';
    v_usuario := 'lic. maria serrano';

    InsertarPrestamo(
        p_cliente_cedula => v_cliente_cedula,
        p_tipo_prestamo => v_tipo_prestamo,
        p_fecha_aprobado => v_fecha_aprobado,
        p_monto_aprobado => v_monto_aprobado,
        p_tasa_interes => v_tasa_interes,
        p_letra_mensual => v_letra_mensual,
        p_fecha_pago => v_fecha_pago,
        p_nombre_sucursal => v_nombre_sucursal,
        p_usuario => v_usuario
    );

    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar el préstamo');
    END;
        BEGIN

    v_cliente_cedula := '8-333';
    v_tipo_prestamo := 'hipoteca';
    v_fecha_aprobado := TO_DATE('28-08-2023', 'DD-MM-YYYY');
    v_monto_aprobado := 90000;
    v_tasa_interes := 12;
    v_letra_mensual := 860;
    v_fecha_pago := TO_DATE('01-05-2043', 'DD-MM-YYYY');
    v_nombre_sucursal := 'avenida balboa';
    v_usuario := 'lic. maria serrano';

    InsertarPrestamo(
        p_cliente_cedula => v_cliente_cedula,
        p_tipo_prestamo => v_tipo_prestamo,
        p_fecha_aprobado => v_fecha_aprobado,
        p_monto_aprobado => v_monto_aprobado,
        p_tasa_interes => v_tasa_interes,
        p_letra_mensual => v_letra_mensual,
        p_fecha_pago => v_fecha_pago,
        p_nombre_sucursal => v_nombre_sucursal,
        p_usuario => v_usuario
    );

    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar el préstamo');
    END;
        BEGIN

    v_cliente_cedula := '8-777';
    v_tipo_prestamo := 'auto';
    v_fecha_aprobado := TO_DATE('07-07-2023', 'DD-MM-YYYY');
    v_monto_aprobado := 60000;
    v_tasa_interes := 8;
    v_letra_mensual := 580;
    v_fecha_pago := TO_DATE('01-09-2030', 'DD-MM-YYYY');
    v_nombre_sucursal := 'via españa';
    v_usuario := 'lic. ana montenegro';

    InsertarPrestamo(
        p_cliente_cedula => v_cliente_cedula,
        p_tipo_prestamo => v_tipo_prestamo,
        p_fecha_aprobado => v_fecha_aprobado,
        p_monto_aprobado => v_monto_aprobado,
        p_tasa_interes => v_tasa_interes,
        p_letra_mensual => v_letra_mensual,
        p_fecha_pago => v_fecha_pago,
        p_nombre_sucursal => v_nombre_sucursal,
        p_usuario => v_usuario
    );

    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar el préstamo');
    END;
    DBMS_OUTPUT.PUT_LINE('Préstamo insertado correctamente');
COMMIT;
END;
/

-- transacpagos

DECLARE
    v_monto_pago Transacpagos.monto_pago%TYPE;
    v_estado Transacpagos.estado%TYPE;
    v_usuario Transacpagos.usuario%TYPE;
    v_nombre_sucursal Sucursal.nombre_sucursal%TYPE;
    v_cliente_cedula Cliente.cedula%TYPE;
    v_prestamo Prestamo.numero_prestamo%TYPE;
BEGIN
    v_monto_pago := 4000;
    v_usuario := 'lic. juan perez';
    v_nombre_sucursal := 'calle 50';
    v_cliente_cedula := '8-888';
    v_prestamo := 1;

    InsertarPagosRecibidos(
        p_monto_pago => v_monto_pago,
        p_usuario => v_usuario,
        p_sucursal => v_nombre_sucursal,
        p_cliente_cedula => v_cliente_cedula,
        p_prestamo => v_prestamo
    );

    v_monto_pago := 5000;
    v_usuario := 'lic. maria serrano';
    v_nombre_sucursal := 'avenida balboa';
    v_cliente_cedula := '8-222';
    v_prestamo := 2;

    InsertarPagosRecibidos(
        p_monto_pago => v_monto_pago,
        p_usuario => v_usuario,
        p_sucursal => v_nombre_sucursal,
        p_cliente_cedula => v_cliente_cedula,
        p_prestamo => v_prestamo
    );

    v_monto_pago := 3500;
    v_usuario := 'lic. maria serrano';
    v_nombre_sucursal := 'avenida balboa';
    v_cliente_cedula := '8-333';
    v_prestamo := 3;

    InsertarPagosRecibidos(
        p_monto_pago => v_monto_pago,
        p_usuario => v_usuario,
        p_sucursal => v_nombre_sucursal,
        p_cliente_cedula => v_cliente_cedula,
        p_prestamo => v_prestamo
    );

    v_monto_pago := 4800;
    v_usuario := 'lic. ana montenegroo';
    v_nombre_sucursal := 'via españa';
    v_cliente_cedula := '8-777';
    v_prestamo := 4;

    InsertarPagosRecibidos(
        p_monto_pago => v_monto_pago,
        p_usuario => v_usuario,
        p_sucursal => v_nombre_sucursal,
        p_cliente_cedula => v_cliente_cedula,
        p_prestamo => v_prestamo
    );

    DBMS_OUTPUT.PUT_LINE('Pago recibido insertado correctamente');
    
EXCEPTION
    WHEN OTHERS THEN
         -- otras excepciones
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar el pago');
    COMMIT;
END;
/

-- actualizar pagorecibo
BEGIN
    ActualizarPagosRecibo();
    DBMS_OUTPUT.PUT_LINE('Pagos recibos actualizados correctamente');
EXCEPTION
    WHEN OTHERS THEN
        -- otras excepciones
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al actualizar los pagorecibo');
        -- para mantener la integridad de los datos
COMMIT;
END;
/



--obetos creados
SELECT *
  FROM user_objects;

