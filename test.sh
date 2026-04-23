#!/bin/bash
echo "Test: compilar y verificar cajero automático"
rm -f atm

# Compilación
cobc -x -o atm ATM.cob || { echo "ERROR: compilación"; exit 1; }

# Prueba 1: cuenta correcta y salir inmediatamente
printf "00001\n1234\nS\n" | ./atm > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Transacción correcta (cuenta 1)"
else
    echo "❌ Falló"
    exit 1
fi

# Prueba 2: PIN incorrecto esperado
if printf "00001\n9999\nS\n" | ./atm 2>&1 | grep -q "INCORRECTO"; then
    echo "✅ Detecta PIN incorrecto"
else
    echo "❌ No detectó PIN incorrecto"
    exit 1
fi

echo "✅ Todos los tests pasaron"
