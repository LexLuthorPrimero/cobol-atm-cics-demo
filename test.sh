#!/bin/bash
echo "🧪 Iniciando suite de pruebas del cajero (CICS)..."
rm -f atm TEST-REPORT.TXT

# Prueba 1: Compilación exitosa
echo "▶ Prueba 1: Compilación"
cobc -x -o atm ATM.cob
if [ $? -ne 0 ]; then
    echo "❌ Error de compilación"
    exit 1
fi
echo "✅ Compilación exitosa"

# Prueba 2: Cuenta válida (ID=00001, PIN=1234)
echo "▶ Prueba 2: Autenticación correcta"
echo -e "00001\n1234\nS\n" | ./atm > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Transacción de consulta exitosa"
else
    echo "❌ Falló la autenticación"
    exit 1
fi

# Prueba 3: Cuenta inválida
echo "▶ Prueba 3: Pin incorrecto"
echo -e "00001\n9999\nS\n" | ./atm > /dev/null
if grep -q "INCORRECTO" <<< "$(echo -e '00001\n9999\nS\n' | ./atm)"; then
    echo "✅ Se detectó PIN incorrecto"
else
    echo "❌ No se manejó error de PIN"
    exit 1
fi

echo "✅ Todos los tests superados"
