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

       01  WS-ACCOUNT-1.
           05  WS1-ID         PIC 9(5).
           05  WS1-PIN        PIC 9(4).
           05  WS1-NAME       PIC X(20).
           05  WS1-BALANCE    PIC 9(7)V99.
       01  WS-ACCOUNT-2.
           05  WS2-ID         PIC 9(5).
           05  WS2-PIN        PIC 9(4).
           05  WS2-NAME       PIC X(20).
           05  WS2-BALANCE    PIC 9(7)V99.
       01  WS-ACCOUNT-3.
           05  WS3-ID         PIC 9(5).
           05  WS3-PIN        PIC 9(4).
           05  WS3-NAME       PIC X(20).
           05  WS3-BALANCE    PIC 9(7)V99.
       01  WS-ACCOUNT-4.
           05  WS4-ID         PIC 9(5).
           05  WS4-PIN        PIC 9(4).
           05  WS4-NAME       PIC X(20).
           05  WS4-BALANCE    PIC 9(7)V99.
       01  WS-ACCOUNT-5.
           05  WS5-ID         PIC 9(5).
           05  WS5-PIN        PIC 9(4).
           05  WS5-NAME       PIC X(20).
           05  WS5-BALANCE    PIC 9(7)V99.

       01  WS-CURRENT-INDEX   PIC 9 VALUE 0.
       01  WS-FOUND           PIC X VALUE 'N'.
           88  ACCOUNT-FOUND  VALUE 'S'.

       01  WS-CURRENT-NAME    PIC X(20).
       01  WS-CURRENT-BALANCE PIC 9(7)V99.

       PROCEDURE DIVISION.
       MAIN.
           PERFORM CARGA-CUENTAS
           DISPLAY '============================================'
           DISPLAY '   CAJERO AUTOMATICO - SIMULACION CICS      '
           DISPLAY '============================================'
           DISPLAY 'INGRESE SU ID: ' WITH NO ADVANCING
           ACCEPT WS-INPUT-ID
           DISPLAY 'INGRESE SU PIN: ' WITH NO ADVANCING
           ACCEPT WS-INPUT-PIN

           PERFORM VALIDAR-CUENTA
           IF NOT ACCOUNT-FOUND
               DISPLAY 'CUENTA NO ENCONTRADA O PIN INCORRECTO'
               PERFORM GUARDAR-CUENTAS
               STOP RUN
           END-IF

           MOVE WS-CURRENT-NAME TO WS-CURRENT-NAME
           MOVE WS-CURRENT-BALANCE TO WS-CURRENT-BALANCE
           PERFORM MENU UNTIL WS-CHOICE = 'S' OR WS-CHOICE = 's'

           PERFORM GUARDAR-CUENTAS
           DISPLAY 'GRACIAS POR SU VISITA'
           STOP RUN.

       CARGA-CUENTAS.
           OPEN INPUT ACCOUNTS-FILE
           IF NOT ACCOUNTS-OK
               DISPLAY 'ERROR AL ABRIR CUENTAS'
               STOP RUN
           END-IF

           READ ACCOUNTS-FILE INTO WS-ACCOUNT-1
           READ ACCOUNTS-FILE INTO WS-ACCOUNT-2
           READ ACCOUNTS-FILE INTO WS-ACCOUNT-3
           READ ACCOUNTS-FILE INTO WS-ACCOUNT-4
           READ ACCOUNTS-FILE INTO WS-ACCOUNT-5

           CLOSE ACCOUNTS-FILE.

       VALIDAR-CUENTA.
           MOVE 'N' TO WS-FOUND
           IF WS-INPUT-ID = WS1-ID AND WS-INPUT-PIN = WS1-PIN
               MOVE 1 TO WS-CURRENT-INDEX
               MOVE 'S' TO WS-FOUND
           END-IF
           IF WS-INPUT-ID = WS2-ID AND WS-INPUT-PIN = WS2-PIN
               MOVE 2 TO WS-CURRENT-INDEX
               MOVE 'S' TO WS-FOUND
           END-IF
           IF WS-INPUT-ID = WS3-ID AND WS-INPUT-PIN = WS3-PIN
               MOVE 3 TO WS-CURRENT-INDEX
               MOVE 'S' TO WS-FOUND
           END-IF
           IF WS-INPUT-ID = WS4-ID AND WS-INPUT-PIN = WS4-PIN
               MOVE 4 TO WS-CURRENT-INDEX
               MOVE 'S' TO WS-FOUND
           END-IF
           IF WS-INPUT-ID = WS5-ID AND WS-INPUT-PIN = WS5-PIN
               MOVE 5 TO WS-CURRENT-INDEX
               MOVE 'S' TO WS-FOUND
           END-IF.

       MENU.
           DISPLAY ' '
           EVALUATE WS-CURRENT-INDEX
               WHEN 1 DISPLAY 'BIENVENIDO/A ' WS1-NAME
                      DISPLAY 'SALDO ACTUAL: $' WS1-BALANCE
               WHEN 2 DISPLAY 'BIENVENIDO/A ' WS2-NAME
                      DISPLAY 'SALDO ACTUAL: $' WS2-BALANCE
               WHEN 3 DISPLAY 'BIENVENIDO/A ' WS3-NAME
                      DISPLAY 'SALDO ACTUAL: $' WS3-BALANCE
               WHEN 4 DISPLAY 'BIENVENIDO/A ' WS4-NAME
                      DISPLAY 'SALDO ACTUAL: $' WS4-BALANCE
               WHEN 5 DISPLAY 'BIENVENIDO/A ' WS5-NAME
                      DISPLAY 'SALDO ACTUAL: $' WS5-BALANCE
           END-EVALUATE
           DISPLAY ' '
           DISPLAY 'Opciones:'
           DISPLAY '  1. DEPOSITAR'
           DISPLAY '  2. RETIRAR'
           DISPLAY '  3. CONSULTAR SALDO'
           DISPLAY '  S. SALIR'
           DISPLAY 'ELIJA UNA OPCION: ' WITH NO ADVANCING
           ACCEPT WS-CHOICE

           EVALUATE WS-CHOICE
               WHEN '1' PERFORM DEPOSITAR
               WHEN '2' PERFORM RETIRAR
               WHEN '3' PERFORM MOSTRAR-SALDO
               WHEN 'S' CONTINUE
               WHEN 's' CONTINUE
               WHEN OTHER DISPLAY 'OPCION NO VALIDA'
           END-EVALUATE.

       DEPOSITAR.
           DISPLAY 'MONTO A DEPOSITAR: ' WITH NO ADVANCING
           ACCEPT WS-AMOUNT
           IF WS-AMOUNT <= 0
               DISPLAY 'MONTO INVALIDO'
           ELSE
               EVALUATE WS-CURRENT-INDEX
                   WHEN 1 ADD WS-AMOUNT TO WS1-BALANCE
                   WHEN 2 ADD WS-AMOUNT TO WS2-BALANCE
                   WHEN 3 ADD WS-AMOUNT TO WS3-BALANCE
                   WHEN 4 ADD WS-AMOUNT TO WS4-BALANCE
                   WHEN 5 ADD WS-AMOUNT TO WS5-BALANCE
               END-EVALUATE
               DISPLAY 'DEPOSITO EXITOSO'
           END-IF.

       RETIRAR.
           DISPLAY 'MONTO A RETIRAR: ' WITH NO ADVANCING
           ACCEPT WS-AMOUNT
           IF WS-AMOUNT <= 0
               DISPLAY 'MONTO INVALIDO'
           ELSE
               EVALUATE WS-CURRENT-INDEX
                   WHEN 1 IF WS-AMOUNT > WS1-BALANCE
                           DISPLAY 'FONDOS INSUFICIENTES'
                          ELSE
                           SUBTRACT WS-AMOUNT FROM WS1-BALANCE
                           DISPLAY 'RETIRO EXITOSO'
                          END-IF
                   WHEN 2 IF WS-AMOUNT > WS2-BALANCE
                           DISPLAY 'FONDOS INSUFICIENTES'
                          ELSE
                           SUBTRACT WS-AMOUNT FROM WS2-BALANCE
                           DISPLAY 'RETIRO EXITOSO'
                          END-IF
                   WHEN 3 IF WS-AMOUNT > WS3-BALANCE
                           DISPLAY 'FONDOS INSUFICIENTES'
                          ELSE
                           SUBTRACT WS-AMOUNT FROM WS3-BALANCE
                           DISPLAY 'RETIRO EXITOSO'
                          END-IF
                   WHEN 4 IF WS-AMOUNT > WS4-BALANCE
                           DISPLAY 'FONDOS INSUFICIENTES'
                          ELSE
                           SUBTRACT WS-AMOUNT FROM WS4-BALANCE
                           DISPLAY 'RETIRO EXITOSO'
                          END-IF
                   WHEN 5 IF WS-AMOUNT > WS5-BALANCE
                           DISPLAY 'FONDOS INSUFICIENTES'
                          ELSE
                           SUBTRACT WS-AMOUNT FROM WS5-BALANCE
                           DISPLAY 'RETIRO EXITOSO'
                          END-IF
               END-EVALUATE
           END-IF.

       MOSTRAR-SALDO.
           EVALUATE WS-CURRENT-INDEX
               WHEN 1 DISPLAY 'SALDO DISPONIBLE: $' WS1-BALANCE
               WHEN 2 DISPLAY 'SALDO DISPONIBLE: $' WS2-BALANCE
               WHEN 3 DISPLAY 'SALDO DISPONIBLE: $' WS3-BALANCE
               WHEN 4 DISPLAY 'SALDO DISPONIBLE: $' WS4-BALANCE
               WHEN 5 DISPLAY 'SALDO DISPONIBLE: $' WS5-BALANCE
           END-EVALUATE.

       GUARDAR-CUENTAS.
           OPEN OUTPUT ACCOUNTS-FILE
           WRITE ACCOUNT-RECORD FROM WS-ACCOUNT-1
           WRITE ACCOUNT-RECORD FROM WS-ACCOUNT-2
           WRITE ACCOUNT-RECORD FROM WS-ACCOUNT-3
           WRITE ACCOUNT-RECORD FROM WS-ACCOUNT-4
           WRITE ACCOUNT-RECORD FROM WS-ACCOUNT-5
           CLOSE ACCOUNTS-FILE.
