#!/bin/bash
echo "Test: compilar y probar autenticacion"
rm -f atm
cobc -x -o atm ATM.cob || { echo "ERROR: compilacion"; exit 1; }
# Prueba 1: cuenta correcta
printf "00001\n1234\n" | ./atm | grep -q "BIENVENIDO" || { echo "Fallo autenticacion"; exit 1; }
# Prueba 2: PIN incorrecto
printf "00001\n9999\n" | ./atm | grep -q "INCORRECTO" || { echo "No detecto PIN incorrecto"; exit 1; }
echo "✅ Tests superados"
