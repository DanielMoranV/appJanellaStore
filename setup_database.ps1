# Script para regenerar codigo Drift y ejecutar seeder
# Ejecutar en una NUEVA PowerShell para que Flutter este en el PATH

Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host "   SETUP COMPLETO - JANELLA STORE" -ForegroundColor Cyan
Write-Host "===================================================================`n" -ForegroundColor Cyan

# Verificar que Flutter/Dart esten disponibles
Write-Host "[*] Verificando Flutter/Dart..." -ForegroundColor Yellow
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host "[X] ERROR: Flutter no esta en el PATH" -ForegroundColor Red
    Write-Host "`nSOLUCION:" -ForegroundColor Yellow
    Write-Host "   1. Cierra esta PowerShell" -ForegroundColor White
    Write-Host "   2. Abre una NUEVA PowerShell" -ForegroundColor White
    Write-Host "   3. Ejecuta este script nuevamente`n" -ForegroundColor White
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host "   [OK] Flutter encontrado" -ForegroundColor Green

# Paso 1: Regenerar codigo Drift
Write-Host "`n[*] Paso 1/2: Regenerando codigo de Drift..." -ForegroundColor Yellow
Write-Host "   (Esto puede tardar 1-2 minutos)`n" -ForegroundColor Gray

dart run build_runner build --delete-conflicting-outputs

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[X] ERROR al regenerar codigo Drift" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host "`n   [OK] Codigo Drift regenerado exitosamente" -ForegroundColor Green

# Paso 2: Ejecutar seeder
Write-Host "`n[*] Paso 2/2: Ejecutando seeder de productos..." -ForegroundColor Yellow

dart run lib/scripts/run_seeder.dart

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[X] ERROR al ejecutar seeder" -ForegroundColor Red
    Read-Host "Presiona Enter para salir"
    exit 1
}

# Resumen final
Write-Host "`n===================================================================" -ForegroundColor Cyan
Write-Host "   [OK] SETUP COMPLETADO EXITOSAMENTE" -ForegroundColor Green
Write-Host "===================================================================`n" -ForegroundColor Cyan

Write-Host "Base de datos lista con:" -ForegroundColor White
Write-Host "   * 60 productos de ropa (stock inicial: 0)" -ForegroundColor White
Write-Host "   * Sistema de creditos por cliente" -ForegroundColor White
Write-Host "   * Sistema de ajustes de stock preparado`n" -ForegroundColor White

Write-Host "PROXIMOS PASOS:" -ForegroundColor Yellow
Write-Host "   1. Iniciar emulador:" -ForegroundColor White
Write-Host "      flutter emulators --launch Medium_Phone_API_36`n" -ForegroundColor Gray
Write-Host "   2. Ejecutar app:" -ForegroundColor White
Write-Host "      flutter run`n" -ForegroundColor Gray

Read-Host "Presiona Enter para salir"
