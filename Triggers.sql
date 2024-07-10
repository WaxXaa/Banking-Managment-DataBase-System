  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------                                lAB 6                               --------------------------------------------------
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

  CREATE SEQUENCE audit_prest_id_seq
START WITH 1 INCREMENT BY 1;

CREATE TABLE
  auditoria_prestamos (
    auditoria_prestamos_id NUMBER CONSTRAINT AUDIT_PREST_ID_PK PRIMARY KEY, --secuencia
    tabla VARCHAR2(25),
    id_cliente_ap NUMBER NOT NULL,
    tipo_prestamo_ap NUMBER NOT NULL,
    tipo_transaccion_ap VARCHAR2(25) NOT NULL, --pago o aprobacion
    monto_aplicar NUMBER,
    saldo_actual NUMBER, --antes de la aplicacion
    saldo_final NUMBER, --despues de la aplicacion
    usuario_ap VARCHAR2(25) NOT NULL,
    fecha TIMESTAMP(3) NOT NULL,
    CONSTRAINT AP_id_cliente_ap_fk FOREIGN KEY (id_cliente_ap) REFERENCES Cliente(cliente_id),
    CONSTRAINT AP_tipo_prestamo_ap_fk FOREIGN KEY (Tipo_prestamo_ap) REFERENCES Tipo_prestamo(tipo_prestamo_id)
  );
  
  
  --------------------------------------------------------------------------------------------------------------------------------
  ------------------------------------------                  TRIGGERS                --------------------------------------------
  --------------------------------------------------------------------------------------------------------------------------------


 -- Para las acumulaciones en la tabla de sucursales una vez se haya afectado la tabla de prestamos

-- Insert
CREATE OR REPLACE TRIGGER tr_acumular_sucursal_insert 
AFTER INSERT ON Prestamo
FOR EACH ROW
BEGIN
  UPDATE Sucursal
  SET montoprestamo = montoprestamo + :NEW.monto_aprobado
  WHERE cod_sucursal = :NEW.sucursal;
  
EXCEPTION
/*WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUTLINE ('No se encontro el registro.')*/
WHEN others THEN
 DBMS_OUTPUT.PUT_LINE('Ocurrio un error trigger de insert prestamo para sucursal.');
 END;
 /

--Update
CREATE OR REPLACE TRIGGER tr_acumular_sucursal_update
AFTER UPDATE of saldo_actual ON Prestamo
FOR EACH ROW
  BEGIN
    UPDATE Sucursal
    SET montoprestamo = montoprestamo - (:OLD.saldo_actual - :NEW.saldo_actual)
    WHERE
      cod_sucursal = :NEW.sucursal;
EXCEPTION
/*WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUTLINE ('No se encontro el registro.')*/
WHEN others THEN
 DBMS_OUTPUT.PUT_LINE('Ocurrio un error trigger de update prestamo para sucursal.');
END;
/


--  Para las acumulaciones en la tabla de sucursales tipos de préstamos una vez e haya afectado la tabla de préstamos.


CREATE OR REPLACE TRIGGER tr_suc_tipo_prestamo_ins
AFTER INSERT ON Prestamo
FOR EACH ROW
BEGIN
  -- Intentar actualizar el registro existente
  BEGIN
    UPDATE Sucursal_TipoPrestamo
    SET montoprestamo = montoprestamo + :NEW.monto_aprobado
    WHERE sucursal = :NEW.sucursal AND Tipo_Prestamo = :NEW.Tipo_Prestamo;

    IF SQL%ROWCOUNT = 0 THEN
      -- Si no se actualiza ningún registro, significa que no existe, entonces insertar
      INSERT INTO Sucursal_TipoPrestamo (sucursal, Tipo_Prestamo, montoprestamo)
      VALUES (:NEW.sucursal, :NEW.Tipo_Prestamo, :NEW.monto_aprobado);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Ocurrió un error en el trigger de insert prestamo para suc_tipoprestamo');
  END;
END;
/


CREATE OR REPLACE TRIGGER tr_suc_tipo_prestamo_update
AFTER UPDATE of saldo_actual ON Prestamo
FOR EACH ROW
BEGIN
  UPDATE Sucursal_TipoPrestamo
  SET
    montoprestamo = montoprestamo - (:OLD.saldo_actual - :NEW.saldo_actual)
  WHERE
    sucursal = :NEW.sucursal AND Tipo_Prestamo = :NEW.Tipo_Prestamo;
EXCEPTION
/*WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUTLINE ('No se encontro el registro.')*/
WHEN others THEN
 DBMS_OUTPUT.PUT_LINE('Ocurrio un error trigger de update prestamo para suc_tipoprestamo.');
END;
/

CREATE OR REPLACE TRIGGER tr_auditar_prestamo_insert
  AFTER INSERT ON Prestamo
  FOR EACH ROW
  BEGIN
    INSERT INTO auditoria_prestamos (
      auditoria_prestamos_id,
      tabla,
      id_cliente_ap,
      Tipo_prestamo_ap,
      tipo_transaccion_ap,
      saldo_actual, -- Debito del usuario,
      monto_aplicar, -- Letra mensual ?,
      saldo_final, -- Como queda el saldo luego de la transaccion,
      usuario_ap,
      fecha
      ) VALUES (
        audit_prest_id_seq.NEXTVAL,
        'Prestamos',
        :NEW.cliente,
        :NEW.Tipo_Prestamo,
        'aprobacion',
        0, --Porque se esta insertando y no hay valor anterior.
        :NEW.letra_mensual,
        :NEW.monto_aprobado,
        :NEW.usuario,
        SYSDATE
      );
END;
/

CREATE OR REPLACE TRIGGER tr_auditar_prestamo_update
  AFTER UPDATE ON Prestamo
  FOR EACH ROW
  BEGIN
  
    INSERT INTO auditoria_prestamos(
      auditoria_prestamos_id,
      tabla,
      id_cliente_ap,
      Tipo_prestamo_ap,
      tipo_transaccion_ap,
      saldo_actual, -- Debito del usuario,
      monto_aplicar, -- Letra mensual ?,
      saldo_final, -- Como queda el saldo luego de la transaccion,
      usuario_ap,
      fecha
    ) VALUES (
      audit_prest_id_seq.NEXTVAL,
      'Prestamos',
      :NEW.cliente,
      :NEW.Tipo_Prestamo,
      'pago',
      :OLD.saldo_actual,
      :NEW.letra_mensual,
      :NEW.saldo_actual,
      :NEW.usuario,
      SYSDATE
    );
END;
/



CREATE OR REPLACE TRIGGER tr_auditar_prestamo_delete
  AFTER DELETE ON Prestamo
  FOR EACH ROW
  BEGIN
    INSERT INTO auditoria_prestamos(
      auditoria_prestamos_id,
      tabla,
      id_cliente_ap,
      tipo_prestamo_ap,
      tipo_transaccion_ap,
      saldo_actual, -- Debito del usuario,
      monto_aplicar, -- Letra mensual ?,
      saldo_final, -- Como queda el saldo luego de la transaccion,
      usuario_ap,
      fecha
    ) VALUES (
      audit_prest_id_seq.NEXTVAL,
      'Prestamos',
      :OLD.cliente,
      :OLD.Tipo_Prestamo,
      'pago',
      :OLD.saldo_actual,
      :OLD.letra_mensual,
      0,
      :OLD.usuario,
      SYSDATE
    );
  END;
/