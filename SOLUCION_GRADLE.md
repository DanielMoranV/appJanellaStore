# Solución al Error de Gradle Daemon Crash

## Problema Detectado

Durante la compilación del APK con `flutter build apk --release`, el daemon de Gradle se crasheó con el siguiente error:

```
Gradle build daemon disappeared unexpectedly (it may have been killed or may have crashed)
JVM crash log found: file:///C:/DesarrolloWeb/appJanellaStore/android/hs_err_pid21620.log
```

## Soluciones Aplicadas

### 1. Limpieza de Cache de Gradle ✅
- Eliminados procesos Java/Gradle en ejecución
- Limpiado cache de Gradle en `%USERPROFILE%\.gradle\caches`

### 2. Configuración de Memoria
El archivo `android/gradle.properties` ya tiene configuración óptima:
```properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m
```

## Pasos para Compilar el APK

### Opción 1: Reiniciar PowerShell y Compilar (Recomendado)

1. **Cerrar PowerShell actual** (para cargar Flutter en PATH)
2. **Abrir nueva PowerShell**
3. **Navegar al proyecto:**
   ```powershell
   cd C:\DesarrolloWeb\appJanellaStore
   ```

4. **Limpiar proyecto:**
   ```powershell
   flutter clean
   ```

5. **Obtener dependencias:**
   ```powershell
   flutter pub get
   ```

6. **Generar código de Drift:**
   ```powershell
   dart run build_runner build --delete-conflicting-outputs
   ```

7. **Compilar APK:**
   ```powershell
   flutter build apk --release
   ```

### Opción 2: Usar Ruta Completa de Flutter

Si no quieres reiniciar PowerShell, usa la ruta completa:

```powershell
# Reemplaza C:\src\flutter con tu ruta de instalación de Flutter
C:\src\flutter\bin\flutter clean
C:\src\flutter\bin\flutter pub get
C:\src\flutter\bin\dart run build_runner build --delete-conflicting-outputs
C:\src\flutter\bin\flutter build apk --release
```

### Opción 3: Compilar con Gradle Directamente

```powershell
cd android
.\gradlew clean
.\gradlew assembleRelease
```

El APK estará en: `build\app\outputs\flutter-apk\app-release.apk`

## Alternativa: Ejecutar en Emulador (Modo Debug)

Si solo quieres probar la app, es más rápido ejecutarla en modo debug:

1. **Iniciar emulador:**
   ```powershell
   # Opción A: Con Flutter
   flutter emulators --launch Medium_Phone_API_36
   
   # Opción B: Directamente
   & "$env:LOCALAPPDATA\Android\Sdk\emulator\emulator.exe" -avd Medium_Phone_API_36
   ```

2. **Esperar ~30 segundos** a que el emulador inicie

3. **Ejecutar app:**
   ```powershell
   flutter run
   ```

## Solución de Problemas Adicionales

### Si el error persiste:

1. **Reducir memoria de Gradle** (si tu PC tiene poca RAM):
   
   Edita `android/gradle.properties`:
   ```properties
   org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:ReservedCodeCacheSize=256m
   ```

2. **Deshabilitar daemon de Gradle:**
   
   Agrega a `android/gradle.properties`:
   ```properties
   org.gradle.daemon=false
   ```

3. **Compilar con más información de debug:**
   ```powershell
   flutter build apk --release --verbose
   ```

4. **Verificar espacio en disco:**
   - La compilación necesita ~2-3 GB de espacio libre
   - Verifica con: `Get-PSDrive C`

5. **Actualizar Gradle:**
   
   Edita `android/gradle/wrapper/gradle-wrapper.properties`:
   ```properties
   distributionUrl=https\://services.gradle.org/distributions/gradle-8.12-all.zip
   ```

## Comandos de Referencia Rápida

```powershell
# Limpiar todo
flutter clean
rm -r -fo build
rm -r -fo android\.gradle

# Reinstalar dependencias
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Compilar APK
flutter build apk --release

# Compilar APK por arquitectura (más pequeños)
flutter build apk --release --split-per-abi

# Ver dispositivos conectados
flutter devices

# Ejecutar en emulador (debug)
flutter run

# Ver logs
flutter logs
```

## Ubicación del APK Compilado

Una vez compilado exitosamente:

```
C:\DesarrolloWeb\appJanellaStore\build\app\outputs\flutter-apk\app-release.apk
```

Tamaño aproximado: ~55 MB

## Próximos Pasos

1. Reinicia PowerShell
2. Ejecuta los comandos de la Opción 1
3. Si el error persiste, prueba ejecutar en modo debug en el emulador primero
4. Revisa el log de crash si es necesario: `android/hs_err_pid*.log`
