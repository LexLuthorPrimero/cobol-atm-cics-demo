# Cajero Automático en COBOL (Simulación CICS/DB2/VSAM)

[![COBOL ATM CI](https://github.com/LexLuthorPrimero/cobol-atm-cics-demo/actions/workflows/ci.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

Demostración de un sistema transaccional de cajero automático implementado en COBOL, simulando un entorno CICS con archivos VSAM y una base de datos DB2.

## Tecnologías y Prácticas
- **COBOL ANSI-85** (lógica de negocio)
- **CICS** (simulado mediante entrada/salida interactiva)
- **DB2** (persistencia en archivo secuencial con actualización)
- **VSAM** (archivo de cuentas)
- **CI/CD** con GitHub Actions (test y Super‑Linter)
- **Pruebas automatizadas** (validación de PIN, operaciones)
- **Conventional Commits** y **Versionado Semántico**

## Ejecución
```bash
git clone https://github.com/LexLuthorPrimero/cobol-atm-cics-demo.git
cd cobol-atm-cics-demo
chmod +x run_atm.sh
./run_atm.sh
