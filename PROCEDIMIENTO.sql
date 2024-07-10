CREATE OR REPLACE PROCEDURE InsertarTipoTelefono (
    p_tipo_telefono_id IN Tipo_Telefono.tipo_telefono_id%TYPE,
    p_tipo_telefono IN Tipo_Telefono.tipo_telefono%TYPE
    ) AS
    BEGIN
    INSERT INTO Tipo_Telefono (tipo_telefono_id, tipo_telefono)
        VALUES (p_tipo_telefono_id, p_tipo_telefono);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            -- de clave primaria duplicada
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            -- Maneja otras excepciones
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');
    

    END InsertarTipoTelefono;
    / 
 
CREATE OR REPLACE PROCEDURE InsertarTipoCorreo (
    p_tipo_correo_id IN Tipo_Email.tipo_email_id%TYPE,
    p_tipo_correo IN Tipo_Email.tipo_email%TYPE
    ) AS
    BEGIN
    INSERT INTO Tipo_Email (tipo_email_id, tipo_email)
        VALUES (p_tipo_correo_id, p_tipo_correo);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            -- de clave primaria duplicada
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            -- Maneja otras excepciones
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');

    COMMIT;

    END InsertarTipoCorreo;
    /

CREATE OR REPLACE PROCEDURE InsertarProfesion (
    p_nombre_profesion IN Profesion.profesion%TYPE,
    p_cliente IN Cliente.cliente_id%TYPE
    ) AS
    BEGIN
    INSERT INTO Profesion (profesion_id, profesion, cliente)
        VALUES (profesion_id_seq.NEXTVAL, p_nombre_profesion, p_cliente); 
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            -- de clave primaria duplicada
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            -- Maneja otras excepciones
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');

    COMMIT;
    END InsertarProfesion;
    /

CREATE OR REPLACE PROCEDURE InsertarSucursal(
    p_cod_sucursal IN Sucursal.cod_sucursal%TYPE,
    p_nombre_sucursal IN Sucursal.nombre_sucursal%TYPE
    ) AS
    v_montoprestamo Sucursal.montoprestamo%TYPE := 0;
    BEGIN
        INSERT INTO Sucursal (cod_sucursal, nombre_sucursal, montoprestamo)
            VALUES (p_cod_sucursal, p_nombre_sucursal, v_montoprestamo);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            -- de clave primaria duplicada
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            -- Maneja otras excepciones
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');

COMMIT;
END InsertarSucursal;
/

CREATE OR REPLACE PROCEDURE InsertarTipoPrestamo (
    p_tipo_prestamo_id IN Tipo_Prestamo.tipo_prestamo_id%TYPE,
    p_tipo_prestamo IN Tipo_Prestamo.tipo_prestamo%TYPE
    ) AS
    BEGIN
    INSERT INTO Tipo_Prestamo (tipo_prestamo_id, tipo_prestamo)
        VALUES (p_tipo_prestamo_id, p_tipo_prestamo);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            -- de clave primaria duplicada
            DBMS_OUTPUT.PUT_LINE('La clave primaria ya existe. No se puede insertar.');
        WHEN OTHERS THEN
            -- Maneja otras excepciones
            DBMS_OUTPUT.PUT_LINE('Ocurrió un error al insertar la sucursal');

    COMMIT;

    END InsertarTipoPrestamo;
    /

CREATE OR REPLACE FUNCTION CalcularEdad(
    p_fecha_nacimiento Cliente.fecha_nacimiento%TYPE
) RETURN NUMBER IS
    v_edad Cliente.edad%TYPE;
BEGIN
    v_edad := FLOOR(MONTHS_BETWEEN(SYSDATE, p_fecha_nacimiento) / 12);
    RETURN v_edad;
END CalcularEdad;
/

CREATE OR REPLACE PROCEDURE InsertarCliente(
    p_cedula IN Cliente.cedula%TYPE,
    p_nombre IN Cliente.nombre%TYPE,
    p_apellido IN Cliente.apellido%TYPE,
    p_sexo IN Cliente.sexo%TYPE,
    p_fecha_nacimiento IN Cliente.fecha_nacimiento%TYPE,
    p_email IN Email.email%TYPE,
    p_tipo_correo IN Tipo_Email.tipo_email%TYPE,
    p_telefono IN Telefono.telefono%TYPE,
    p_tipo_telefono IN Tipo_Telefono.tipo_telefono%TYPE,
    p_profesion IN Profesion.profesion%TYPE,
    p_sucursal IN Sucursal.nombre_sucursal%TYPE
    ) AS
    v_tipo_correo Tipo_Email.tipo_email_id%TYPE;
    v_tipo_telefono Tipo_Telefono.tipo_telefono_id%TYPE;
    v_cliente_id Cliente.cliente_id%TYPE;
    v_edad Cliente.edad%TYPE;
    v_sucursal Sucursal.cod_sucursal%TYPE;
    BEGIN

    SELECT cod_sucursal INTO v_sucursal
    FROM sucursal WHERE nombre_sucursal = p_sucursal;
    SELECT tipo_telefono_id INTO v_tipo_telefono
    FROM Tipo_Telefono WHERE tipo_telefono = p_tipo_telefono;
    SELECT tipo_email_id INTO v_tipo_correo
    FROM Tipo_Email WHERE tipo_email = p_tipo_correo;

    v_edad := CalcularEdad(p_fecha_nacimiento);

    INSERT INTO Cliente (cliente_id, cedula, nombre, apellido, sexo, fecha_nacimiento, edad, sucursal)
    VALUES (cliente_id_seq.NEXTVAL, p_cedula, p_nombre, p_apellido, p_sexo, p_fecha_nacimiento, v_edad, v_sucursal);
    SELECT cliente_id INTO v_cliente_id
    FROM Cliente WHERE cedula = p_cedula;
    InsertarProfesion(p_profesion, v_cliente_id);
    INSERT INTO Email (email, cliente, tipo_emaiL)
    VALUES (p_email, v_cliente_id, v_tipo_correo);

    INSERT INTO Telefono (telefono, cliente, tipo_telefono)
    VALUES (p_telefono, v_cliente_id, v_tipo_telefono);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- cuando no se encuentra el valor en la tabla
        DBMS_OUTPUT.PUT_LINE('Valor no encontrado.');
    WHEN OTHERS THEN
        -- otras excepciones
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error en la inserción.');
        -- para mantener la integridad de los datos

COMMIT;

END InsertarCliente;
/


-- CREATE OR REPLACE FUNCTION RevisarSucTipoPre(
--     p_sucursal IN Sucursal_TipoPrestamo.sucursal%TYPE,
--     p_tipo_prestamo IN Sucursal_TipoPrestamo.tipo_prestamo%TYPE
-- ) RETURN BOOLEAN IS 
--    v_count NUMBER;
-- BEGIN 
--    SELECT COUNT(*)
--      INTO v_count
--      FROM Sucursal_TipoPrestamo
--     WHERE Sucursal = p_sucursal AND Tipo_Prestamo = p_tipo_prestamo;

--    RETURN v_count > 0;
-- EXCEPTION
--    WHEN OTHERS THEN
--       DBMS_OUTPUT.PUT_LINE('ERROR');
-- END RevisarSucTipoPre;
-- /



CREATE OR REPLACE PROCEDURE InsertarPrestamo(
    p_cliente_cedula IN Cliente.cedula%TYPE,
    p_tipo_prestamo IN Tipo_Prestamo.tipo_prestamo%TYPE,
    p_fecha_aprobado IN Prestamo.fecha_aprobado%TYPE,
    p_monto_aprobado IN Prestamo.monto_aprobado%TYPE,
    p_tasa_interes IN Prestamo.tasa_interes%TYPE,
    p_letra_mensual IN Prestamo.letra_mensual%TYPE,
    p_fecha_pago IN Prestamo.fecha_pago%TYPE,
    p_nombre_sucursal IN Sucursal.nombre_sucursal%TYPE,
    p_usuario IN Prestamo.usuario%TYPE
) AS
v_cliente_id Cliente.cliente_id%TYPE;
v_sucursal Sucursal.cod_sucursal%TYPE;
v_tipo_prestamo Tipo_Prestamo.tipo_prestamo_id%TYPE;
BEGIN

SELECT cliente_id INTO v_cliente_id
FROM Cliente WHERE cedula = p_cliente_cedula;
SELECT cod_sucursal INTO v_sucursal
FROM Sucursal WHERE nombre_sucursal = p_nombre_sucursal;
  BEGIN
      SELECT tipo_prestamo_id INTO v_tipo_prestamo
      FROM Tipo_Prestamo WHERE tipo_prestamo = p_tipo_prestamo;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Tipo de préstamo ' || p_tipo_prestamo || ' no encontrado.');
  END;

    INSERT INTO Prestamo (
        numero_prestamo,
        cliente,
        tipo_prestamo,
        fecha_aprobado,
        monto_aprobado,
        tasa_interes,
        letra_mensual,
        monto_pagado,
        fecha_pago,
        sucursal,
        saldo_actual,
        interes_pagado,
        usuario
    )
    VALUES (
        prestamo_id_seq.NEXTVAL,
        v_cliente_id,
        v_tipo_prestamo,
        p_fecha_aprobado,
        p_monto_aprobado,
        p_tasa_interes,
        p_letra_mensual,
        0,
        p_fecha_pago,
        v_sucursal,
        p_monto_aprobado,
        0,
        p_usuario
    );

    -- UPDATE Sucursal
    -- SET montoprestamo = montoprestamo - p_monto_aprobado
    -- WHERE cod_sucursal = v_sucursal;
    -- COMMIT;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- cuando no se encuentra el valor en la tabla
        DBMS_OUTPUT.PUT_LINE('Valor no encontrado.');
    WHEN OTHERS THEN
        -- otras excepciones
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error en la inserción del prestamo.');
        -- para mantener la integridad de los datos
COMMIT;
END;
/





CREATE OR REPLACE PROCEDURE InsertarPagosRecibidos(
    p_monto_pago IN Transacpagos.monto_pago%TYPE,
    p_usuario IN Transacpagos.usuario%TYPE,
    p_sucursal IN Sucursal.nombre_sucursal%TYPE,
    p_cliente_cedula IN Cliente.cedula%TYPE,
    p_prestamo IN Prestamo.numero_prestamo%TYPE
) AS

v_cliente_id Cliente.cliente_id%TYPE;
v_sucursal Sucursal.cod_sucursal%TYPE;
BEGIN

SELECT cliente_id INTO v_cliente_id
FROM Cliente WHERE cedula = p_cliente_cedula;
SELECT cod_sucursal INTO v_sucursal
FROM Sucursal WHERE nombre_sucursal = p_sucursal;

INSERT INTO transacpagos (
    transaccion_id,
    fecha_transaccion,
    monto_pago,
    estado,
    fecha_insercion,
    usuario,
    sucursal,
    cliente,
    prestamo
)
VALUES(
    transaccion_id_seq.NEXTVAL,
    SYSDATE,
    p_monto_pago,
    'E',
    SYSDATE,
    p_usuario,
    v_sucursal,
    v_cliente_id,
    p_prestamo
);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- cuando no se encuentra el valor en la tabla
        DBMS_OUTPUT.PUT_LINE('Valor no encontrado.');
    WHEN OTHERS THEN
        -- otras excepciones
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error en la inserción.');
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error en la inserción.');
        -- para mantener la integridad de los datos
COMMIT;
END InsertarPagosRecibidos;
/

 CREATE OR REPLACE FUNCTION calcularInteres(
    p_saldo_prestamo Prestamo.saldo_actual%TYPE,
    p_tasa_interes Prestamo.tasa_interes%TYPE
 )  RETURN NUMBER IS
BEGIN
    RETURN p_saldo_prestamo * p_tasa_interes / 100;
END calcularInteres;
/



CREATE OR REPLACE PROCEDURE ActualizarPagosRecibo AS
  CURSOR c_pagos IS
    SELECT transaccion_id, cliente, prestamo, monto_pago, sucursal
    FROM Transacpagos;

  v_interes Prestamo.interes_pagado%TYPE;
  v_monto_sobrante Prestamo.saldo_actual%TYPE;
  v_saldo Prestamo.saldo_actual%TYPE;
BEGIN
  FOR r_pago IN c_pagos LOOP
    SELECT tasa_interes, saldo_actual INTO v_interes, v_saldo
    FROM Prestamo WHERE numero_prestamo = r_pago.prestamo AND cliente = r_pago.cliente;

    v_interes := calcularInteres(
                    p_saldo_prestamo => v_saldo,
                    p_tasa_interes => v_interes
                 );

    v_monto_sobrante := r_pago.monto_pago - v_interes;

    IF v_monto_sobrante > 0 THEN
      UPDATE Prestamo
      SET saldo_actual = saldo_actual - v_monto_sobrante,
          interes_pagado = interes_pagado + v_interes
      WHERE numero_prestamo = r_pago.prestamo AND cliente = r_pago.cliente;
    ELSIF v_monto_sobrante = 0 THEN
      UPDATE Prestamo
      SET interes_pagado = interes_pagado + r_pago.monto_pago
      WHERE numero_prestamo = r_pago.prestamo AND cliente = r_pago.cliente;
    ELSE
      UPDATE Prestamo
      SET interes_pagado = interes_pagado + r_pago.monto_pago,
          saldo_actual = saldo_actual + v_monto_sobrante
      WHERE numero_prestamo = r_pago.prestamo AND cliente = r_pago.cliente;
    END IF;

    UPDATE Prestamo
    SET monto_pagado = r_pago.monto_pago
    WHERE numero_prestamo = r_pago.prestamo AND cliente = r_pago.cliente;
  END LOOP;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Valor no encontrado.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ocurrió un error en la inserción.');

COMMIT;

END ActualizarPagosRecibo;

/