#!/bin/bash
echo "Test: Compilar y probar cajero automático"
rm -f atm

cobc -x -o atm ATM.cob || { echo "ERROR: compilación"; exit 1; }

echo "Prueba 1: cuenta correcta y consulta de saldo"
printf "00001\n1234\n3\nS\n" | ./atm > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Transacción correcta"
else
    echo "❌ Fallo"
    exit 1
fi

echo "Prueba 2: PIN incorrecto"
if printf "00001\n9999\nS\n" | ./atm 2>&1 | grep -q "INCORRECTO"; then
    echo "✅ Detectado PIN incorrecto"
else
    echo "❌ No detectó PIN incorrecto"
    exit 1
fi

echo "✅ Todos los tests pasaron"
