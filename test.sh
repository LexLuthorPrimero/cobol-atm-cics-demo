#!/bin/bash
echo "Test: compilar y probar autenticacion"
rm -f atm

cobc -x -o atm ATM.cob || { echo "ERROR: compilacion"; exit 1; }

# Prueba 1: cuenta válida
printf "00001\n1234\n" | ./atm | grep -q "BIENVENIDO" || {
    echo "Fallo: no se autenticó cuenta válida"
    exit 1
}

# Prueba 2: PIN incorrecto
printf "00001\n9999\n" | ./atm | grep -q "INCORRECTO" || {
    echo "Fallo: no detectó PIN incorrecto"
    exit 1
}

echo "✅ Tests superados"
