#!/bin/bash
echo "Test: Compilar y ejecutar cajero (prueba rápida)"
rm -f atm

cobc -x -o atm ATM.cob
if [ $? -ne 0 ]; then
    echo "ERROR: compilación"
    exit 1
fi

echo "Prueba 1: cuenta correcta"
echo -e "00001\n1234\nS\n" | ./atm > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Transacción correcta"
else
    echo "❌ Fallo"
    exit 1
fi

echo "✅ Todos los tests pasaron"
