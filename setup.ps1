Write-Host "=== Configuracion del Entorno Flutter para Janella Store ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/6] Verificando Flutter..." -ForegroundColor Yellow
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue

if ($flutterPath) {
    Write-Host "OK Flutter encontrado: $($flutterPath.Source)" -ForegroundColor Green
    flutter --version
}
else {
    Write-Host "X Flutter NO encontrado en PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "ACCION REQUERIDA:" -ForegroundColor Yellow
    Write-Host "1. Descarga Flutter desde: https://docs.flutter.dev/get-started/install/windows"
    Write-Host "2. Extrae el archivo ZIP en C:\src\flutter"
    Write-Host "3. Agrega C:\src\flutter\bin al PATH del sistema"
    Write-Host "4. Reinicia PowerShell y ejecuta este script nuevamente"
    Write-Host ""
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "[2/6] Verificando Android SDK..." -ForegroundColor Yellow
$androidSdkPath = "$env:LOCALAPPDATA\Android\Sdk"

if (Test-Path $androidSdkPath) {
    Write-Host "OK Android SDK encontrado: $androidSdkPath" -ForegroundColor Green
}
else {
    Write-Host "X Android SDK NO encontrado" -ForegroundColor Red
    Write-Host "Instala Android Studio desde: https://developer.android.com/studio"
    Read-Host "Presiona Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "[3/6] Verificando emuladores Android..." -ForegroundColor Yellow
$emulatorExe = "$androidSdkPath\emulator\emulator.exe"

if (Test-Path $emulatorExe) {
    $avds = & $emulatorExe -list-avds 2>$null
    if ($avds) {
        Write-Host "OK Emuladores encontrados:" -ForegroundColor Green
        foreach ($avd in $avds) {
            Write-Host "  - $avd" -ForegroundColor Cyan
        }
    }
    else {
        Write-Host "X No hay emuladores configurados" -ForegroundColor Red
        Write-Host "Crea un emulador desde Android Studio > Tools > Device Manager"
    }
}
else {
    Write-Host "X Emulador no encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "[4/6] Ejecutando flutter doctor..." -ForegroundColor Yellow
flutter doctor

Write-Host ""
Write-Host "[5/6] Instalando dependencias del proyecto..." -ForegroundColor Yellow
$projectPath = "C:\DesarrolloWeb\appJanellaStore"

if (Test-Path $projectPath) {
    Set-Location $projectPath
    Write-Host "Ejecutando: flutter pub get" -ForegroundColor Cyan
    flutter pub get
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK Dependencias instaladas correctamente" -ForegroundColor Green
    }
    else {
        Write-Host "X Error al instalar dependencias" -ForegroundColor Red
    }
}
else {
    Write-Host "X Proyecto no encontrado en: $projectPath" -ForegroundColor Red
}

Write-Host ""
Write-Host "[6/6] Generando codigo de Drift..." -ForegroundColor Yellow
Write-Host "Ejecutando: dart run build_runner build --delete-conflicting-outputs" -ForegroundColor Cyan
dart run build_runner build --delete-conflicting-outputs

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK Codigo de Drift generado correctamente" -ForegroundColor Green
}
else {
    Write-Host "X Error al generar codigo de Drift" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Configuracion Completada ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Comandos utiles:" -ForegroundColor Yellow
Write-Host "  1. Iniciar emulador:" -ForegroundColor White
Write-Host "     flutter emulators --launch Medium_Phone_API_36" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Ejecutar aplicacion:" -ForegroundColor White
Write-Host "     flutter run" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Compilar APK:" -ForegroundColor White
Write-Host "     flutter build apk --release" -ForegroundColor Gray
Write-Host ""
Read-Host "Presiona Enter para finalizar"
