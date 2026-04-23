#!/bin/bash
echo "=========================================="
echo "  SIMULADOR DE TRANSACCIÓN CICS - CAJERO"
echo "=========================================="
echo "Fecha: $(date)"
echo ""
if ! command -v cobc &> /dev/null; then
    echo "ERROR: GnuCOBOL no instalado."
    exit 1
fi
echo ">>> Compilando ATM.cob..."
cobc -x -o atm ATM.cob
if [ $? -ne 0 ]; then
    echo "ERROR: Falló la compilación."
    exit 1
fi
echo ">>> Ejecutando cajero automático..."
./atm
