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

       01  WS-CURRENT-RECORD  PIC X(36).
       01  WS-UPDATED-RECORD  PIC X(36).

       01  WS-CURRENT-NAME    PIC X(20).
       01  WS-CURRENT-BALANCE PIC 9(7)V99.

       01  WS-TEMP-RECORD     PIC X(36).

       01  WS-MESSAGE         PIC X(60).

       PROCEDURE DIVISION.
       MAIN.
           DISPLAY '============================================'
           DISPLAY '   CAJERO AUTOMATICO - SIMULACION CICS      '
           DISPLAY '============================================'
           DISPLAY 'INGRESE SU ID: ' WITH NO ADVANCING
           ACCEPT WS-INPUT-ID
           DISPLAY 'INGRESE SU PIN: ' WITH NO ADVANCING
           ACCEPT WS-INPUT-PIN

           PERFORM VALIDATE-ACCOUNT
           IF NOT ACCOUNT-FOUND
               DISPLAY 'CUENTA NO ENCONTRADA O PIN INCORRECTO'
               STOP RUN
           END-IF

           PERFORM MENU UNTIL WS-CHOICE = 'S' OR WS-CHOICE = 's'.

           DISPLAY 'GRACIAS POR SU VISITA'
           STOP RUN.

       VALIDATE-ACCOUNT.
           OPEN INPUT ACCOUNTS-FILE
           IF NOT ACCOUNTS-OK
               DISPLAY 'ERROR AL ABRIR ARCHIVO DE CUENTAS'
               STOP RUN
           END-IF

           MOVE 'N' TO WS-FOUND
           PERFORM UNTIL ACCOUNT-FOUND OR ACCOUNTS-EOF
               READ ACCOUNTS-FILE INTO ACCOUNT-RECORD
                   AT END
                       CONTINUE
                   NOT AT END
                       IF ACC-ID = WS-INPUT-ID AND
                          ACC-PIN = WS-INPUT-PIN
                           MOVE 'S' TO WS-FOUND
                           MOVE ACC-NAME TO WS-CURRENT-NAME
                           MOVE ACC-BALANCE TO WS-CURRENT-BALANCE
                           MOVE ACCOUNT-RECORD TO WS-CURRENT-RECORD
                       END-IF
               END-READ
           END-PERFORM
           CLOSE ACCOUNTS-FILE.

       MENU.
           DISPLAY ' '
           DISPLAY 'BIENVENIDO/A ' WS-CURRENT-NAME
           DISPLAY 'SALDO ACTUAL: $' WS-CURRENT-BALANCE
           DISPLAY ' '
           DISPLAY 'Opciones:'
           DISPLAY '  1. DEPOSITAR'
           DISPLAY '  2. RETIRAR'
           DISPLAY '  3. CONSULTAR SALDO'
           DISPLAY '  S. SALIR'
           DISPLAY 'ELIJA UNA OPCION: ' WITH NO ADVANCING
           ACCEPT WS-CHOICE

           EVALUATE WS-CHOICE
               WHEN '1'
                   PERFORM DO-DEPOSIT
               WHEN '2'
                   PERFORM DO-WITHDRAW
               WHEN '3'
                   PERFORM SHOW-BALANCE
               WHEN 'S'
                   CONTINUE
               WHEN 's'
                   CONTINUE
               WHEN OTHER
                   DISPLAY 'OPCION NO VALIDA'
           END-EVALUATE.

       DO-DEPOSIT.
           DISPLAY 'MONTO A DEPOSITAR: ' WITH NO ADVANCING
           ACCEPT WS-AMOUNT
           IF WS-AMOUNT <= 0
               DISPLAY 'MONTO INVALIDO'
           ELSE
               ADD WS-AMOUNT TO WS-CURRENT-BALANCE
               PERFORM UPDATE-ACCOUNT
           END-IF.

       DO-WITHDRAW.
           DISPLAY 'MONTO A RETIRAR: ' WITH NO ADVANCING
           ACCEPT WS-AMOUNT
           IF WS-AMOUNT > WS-CURRENT-BALANCE
               DISPLAY 'FONDOS INSUFICIENTES'
           ELSE IF WS-AMOUNT <= 0
               DISPLAY 'MONTO INVALIDO'
           ELSE
               SUBTRACT WS-AMOUNT FROM WS-CURRENT-BALANCE
               PERFORM UPDATE-ACCOUNT
           END-IF.

       SHOW-BALANCE.
           DISPLAY 'SALDO DISPONIBLE: $' WS-CURRENT-BALANCE.

       UPDATE-ACCOUNT.
           OPEN INPUT ACCOUNTS-FILE
           OPEN OUTPUT ACCOUNTS-FILE
           IF NOT ACCOUNTS-OK
               DISPLAY 'ERROR AL ACTUALIZAR CUENTA'
               EXIT PARAGRAPH
           END-IF
           MOVE 'N' TO WS-FOUND
           PERFORM UNTIL ACCOUNTS-EOF
               READ ACCOUNTS-FILE INTO WS-TEMP-RECORD
                   AT END
                       CONTINUE
                   NOT AT END
                       IF WS-TEMP-RECORD(1:5) = WS-INPUT-ID
                           MOVE WS-INPUT-ID TO ACC-ID
                           MOVE WS-INPUT-PIN TO ACC-PIN
                           MOVE WS-CURRENT-NAME TO ACC-NAME
                           MOVE WS-CURRENT-BALANCE TO ACC-BALANCE
                           WRITE ACCOUNT-RECORD
                       ELSE
                           WRITE WS-TEMP-RECORD FROM WS-TEMP-RECORD
                       END-IF
               END-READ
           END-PERFORM
           CLOSE ACCOUNTS-FILE.
