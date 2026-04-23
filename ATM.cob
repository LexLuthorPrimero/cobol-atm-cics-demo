       IDENTIFICATION DIVISION.
       PROGRAM-ID. ATM.
       AUTHOR. LUCAS-CANETE.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS-FILE ASSIGN TO 'ACCOUNTS.DAT'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-ACCOUNTS-STATUS.
       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNTS-FILE.
       01  ACCOUNT-RECORD.
           05  ACC-ID         PIC 9(5).
           05  ACC-PIN        PIC 9(4).
           05  ACC-NAME       PIC X(20).
           05  ACC-BALANCE    PIC 9(7)V99.

       WORKING-STORAGE SECTION.
       01  WS-ACCOUNTS-STATUS PIC X(2).
           88  ACCOUNTS-OK    VALUE '00'.
           88  ACCOUNTS-EOF   VALUE '10'.

       01  WS-INPUT-ID        PIC 9(5).
       01  WS-INPUT-PIN       PIC 9(4).
       01  WS-CHOICE          PIC X.
       01  WS-AMOUNT          PIC 9(7)V99.
       01  WS-FOUND           PIC X VALUE 'N'.
           88  ACCOUNT-FOUND  VALUE 'S'.
       01  WS-CURRENT-INDEX   PIC 9(2) VALUE 0.
       01  WS-MAX-CUENTAS     PIC 9(2) VALUE 5.
       01  WS-TEMP            PIC X(36).

       01  WS-CUENTAS-TABLE.
           05  WS-CUENTA OCCURS 5 TIMES INDEXED BY I.
               10  WS-CUENTA-ID      PIC 9(5).
               10  WS-CUENTA-PIN     PIC 9(4).
               10  WS-CUENTA-NAME    PIC X(20).
               10  WS-CUENTA-BALANCE PIC 9(7)V99.

       01  WS-IDX              PIC 9(2).

       PROCEDURE DIVISION.
       MAIN.
           PERFORM CARGA-TABLA
           DISPLAY '============================================'
           DISPLAY '   CAJERO AUTOMATICO - SIMULACION CICS      '
           DISPLAY '============================================'
           DISPLAY 'INGRESE SU ID: ' WITH NO ADVANCING
           ACCEPT WS-INPUT-ID
           DISPLAY 'INGRESE SU PIN: ' WITH NO ADVANCING
           ACCEPT WS-INPUT-PIN

           PERFORM VALIDAR-USUARIO
           IF NOT ACCOUNT-FOUND
               DISPLAY 'CUENTA NO ENCONTRADA O PIN INCORRECTO'
               PERFORM GUARDAR-TABLA
               STOP RUN
           END-IF

           PERFORM MENU UNTIL WS-CHOICE = 'S' OR WS-CHOICE = 's'
           PERFORM GUARDAR-TABLA
           DISPLAY 'GRACIAS POR SU VISITA'
           STOP RUN.

       CARGA-TABLA.
           OPEN INPUT ACCOUNTS-FILE
           IF NOT ACCOUNTS-OK
               DISPLAY 'ERROR AL ABRIR CUENTAS'
               STOP RUN
           END-IF
           MOVE 0 TO WS-IDX
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WS-MAX-CUENTAS
               READ ACCOUNTS-FILE INTO WS-CUENTA(I)
                   AT END CONTINUE
               END-READ
           END-PERFORM
           CLOSE ACCOUNTS-FILE.

       VALIDAR-USUARIO.
           MOVE 'N' TO WS-FOUND
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > WS-MAX-CUENTAS
                        OR ACCOUNT-FOUND
               IF WS-CUENTA-ID(I) = WS-INPUT-ID AND
                  WS-CUENTA-PIN(I) = WS-INPUT-PIN
                   SET ACCOUNT-FOUND TO TRUE
                   MOVE I TO WS-CURRENT-INDEX
               END-IF
           END-PERFORM.

       MENU.
           DISPLAY ' '
           DISPLAY 'BIENVENIDO/A ' WS-CUENTA-NAME(WS-CURRENT-INDEX)
           DISPLAY 'SALDO ACTUAL: $' WS-CUENTA-BALANCE(WS-CURRENT-INDEX)
           DISPLAY ' '
           DISPLAY 'Opciones:'
           DISPLAY '  1. DEPOSITAR'
           DISPLAY '  2. RETIRAR'
           DISPLAY '  3. CONSULTAR SALDO'
           DISPLAY '  S. SALIR'
           DISPLAY 'ELIJA UNA OPCION: ' WITH NO ADVANCING
           ACCEPT WS-CHOICE

           EVALUATE WS-CHOICE
               WHEN '1' PERFORM DO-DEPOSIT
               WHEN '2' PERFORM DO-WITHDRAW
               WHEN '3' PERFORM SHOW-BALANCE
               WHEN 'S' CONTINUE
               WHEN 's' CONTINUE
               WHEN OTHER DISPLAY 'OPCION NO VALIDA'
           END-EVALUATE.

       DO-DEPOSIT.
           DISPLAY 'MONTO A DEPOSITAR: ' WITH NO ADVANCING
           ACCEPT WS-AMOUNT
           IF WS-AMOUNT <= 0
               DISPLAY 'MONTO INVALIDO'
           ELSE
               ADD WS-AMOUNT TO WS-CUENTA-BALANCE(WS-CURRENT-INDEX)
               DISPLAY 'DEPOSITO EXITOSO'
           END-IF.

       DO-WITHDRAW.
           DISPLAY 'MONTO A RETIRAR: ' WITH NO ADVANCING
           ACCEPT WS-AMOUNT
           IF WS-AMOUNT > WS-CUENTA-BALANCE(WS-CURRENT-INDEX)
               DISPLAY 'FONDOS INSUFICIENTES'
           ELSE IF WS-AMOUNT <= 0
               DISPLAY 'MONTO INVALIDO'
           ELSE
               SUBTRACT WS-AMOUNT FROM
                   WS-CUENTA-BALANCE(WS-CURRENT-INDEX)
               DISPLAY 'RETIRO EXITOSO'
           END-IF.

       SHOW-BALANCE.
           DISPLAY 'SALDO DISPONIBLE: $'
               WS-CUENTA-BALANCE(WS-CURRENT-INDEX).

       GUARDAR-TABLA.
           OPEN OUTPUT ACCOUNTS-FILE
           IF NOT ACCOUNTS-OK
               DISPLAY 'ERROR AL GUARDAR CAMBIOS'
           ELSE
               PERFORM VARYING I FROM 1 BY 1 UNTIL I > WS-MAX-CUENTAS
                   MOVE WS-CUENTA(I) TO ACCOUNT-RECORD
                   WRITE ACCOUNT-RECORD
               END-PERFORM
           END-IF
           CLOSE ACCOUNTS-FILE.
