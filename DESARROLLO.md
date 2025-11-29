# Janella Store - Guía de Desarrollo y Distribución

## 🚀 Comandos Útiles para Desarrollo

### Iniciar Emulador Android

```bash
# Ver emuladores disponibles
flutter emulators

# Iniciar emulador (método optimizado para mejor rendimiento)
~/Android/Sdk/emulator/emulator -avd Medium_Phone_API_36.0 -gpu swiftshader_indirect -no-snapshot -no-audio &

# Esperar ~30 segundos para que el emulador arranque completamente

# Verificar que el emulador esté conectado
flutter devices
```

### Ejecutar la Aplicación en Desarrollo

```bash
# Ejecutar en el emulador Android
flutter run -d emulator-5554

# O simplemente (Flutter elegirá el dispositivo automáticamente)
flutter run

# Hot reload durante desarrollo: presionar 'r' en la terminal
# Hot restart: presionar 'R' en la terminal
# Salir: presionar 'q' en la terminal
```

### Compilar APK para Distribución

#### APK de Release (Recomendado)

```bash
# Compilar APK optimizado para producción
flutter build apk --release

# El APK se generará en:
# build/app/outputs/flutter-apk/app-release.apk
```

#### APK de Debug (Solo para pruebas)

```bash
# Compilar APK de debug (más grande, con herramientas de desarrollo)
flutter build apk --debug

# El APK se generará en:
# build/app/outputs/flutter-apk/app-debug.apk
```

### Ubicación del APK Compilado

```bash
# Ver el APK generado
ls -lh build/app/outputs/flutter-apk/

# Copiar APK al escritorio para fácil acceso
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/JanellaStore.apk
```

## 📱 Instalar APK en Dispositivos Reales

### Método 1: Vía USB (ADB)

```bash
# Conectar el dispositivo Android por USB
# Habilitar "Depuración USB" en el dispositivo

# Verificar que el dispositivo esté conectado
adb devices

# Instalar el APK
adb install build/app/outputs/flutter-apk/app-release.apk

# O forzar reinstalación si ya está instalado
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Método 2: Transferencia Manual

1. Copiar el archivo `app-release.apk` al dispositivo (por USB, email, WhatsApp, etc.)
2. En el dispositivo Android, abrir el archivo APK
3. Permitir instalación de "Fuentes desconocidas" si se solicita
4. Seguir las instrucciones de instalación

### Método 3: Compartir por Red Local

```bash
# Iniciar un servidor HTTP simple en el directorio del APK
cd build/app/outputs/flutter-apk/
python3 -m http.server 8000

# Desde el dispositivo Android, abrir el navegador y visitar:
# http://[IP-DE-TU-PC]:8000/app-release.apk
```

## 🔧 Mantenimiento y Actualización

### Limpiar Proyecto

```bash
# Limpiar archivos de compilación
flutter clean

# Reinstalar dependencias
flutter pub get

# Regenerar código de Drift
dart run build_runner build --delete-conflicting-outputs
```

### Actualizar Dependencias

```bash
# Ver dependencias desactualizadas
flutter pub outdated

# Actualizar dependencias
flutter pub upgrade

# Regenerar código después de actualizar
dart run build_runner build --delete-conflicting-outputs
```

## 📊 Análisis y Pruebas

### Análisis de Código

```bash
# Analizar código en busca de problemas
flutter analyze

# Análisis sin mostrar info (solo warnings y errors)
flutter analyze --no-fatal-infos
```

### Verificar Configuración

```bash
# Verificar instalación de Flutter y dependencias
flutter doctor -v
```

## 🎯 Workflow Completo de Desarrollo

### 1. Iniciar Sesión de Desarrollo

```bash
# Terminal 1: Iniciar emulador
~/Android/Sdk/emulator/emulator -avd Medium_Phone_API_36.0 -gpu swiftshader_indirect -no-snapshot -no-audio &

# Esperar ~30 segundos

# Terminal 2: Ejecutar app
cd /home/maeldev/Code/appJanellaStore
flutter run
```

### 2. Hacer Cambios y Probar

```bash
# Editar código en VS Code o tu editor preferido
# Guardar cambios

# En la terminal donde corre Flutter, presionar:
# 'r' para hot reload (recarga rápida)
# 'R' para hot restart (reinicio completo)
```

### 3. Compilar para Distribución

```bash
# Asegurarse de que todo esté actualizado
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Compilar APK de release
flutter build apk --release

# Verificar el APK
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Copiar a ubicación accesible
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/JanellaStore_v1.0.apk
```

## 📦 Distribución del APK

### Ubicaciones del APK Compilado

- **Ruta completa**: `/home/maeldev/Code/appJanellaStore/build/app/outputs/flutter-apk/app-release.apk`
- **Tamaño aproximado**: ~55 MB (optimizado con tree-shaking)

### Métodos de Distribución

1. **Google Drive / Dropbox**
   - Subir el APK
   - Compartir enlace de descarga

2. **WhatsApp / Telegram**
   - Enviar el archivo APK directamente

3. **Email**
   - Adjuntar el APK (verificar límite de tamaño del servidor)

4. **Servidor Web Propio**
   - Subir a servidor web
   - Compartir URL de descarga

## 🔐 Firma del APK (Opcional para Play Store)

Si planeas publicar en Google Play Store, necesitarás firmar el APK:

```bash
# Generar keystore (solo una vez)
keytool -genkey -v -keystore ~/janella-store-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias janella-store

# Configurar en android/key.properties
# Luego compilar con firma
flutter build apk --release
```

## 💡 Tips y Trucos

### Acelerar Compilación

```bash
# Usar compilación en paralelo
flutter build apk --release --split-per-abi

# Esto genera 3 APKs más pequeños (uno por arquitectura):
# - app-armeabi-v7a-release.apk (~25 MB)
# - app-arm64-v8a-release.apk (~27 MB)
# - app-x86_64-release.apk (~28 MB)
```

### Reducir Tamaño del APK

```bash
# Compilar con ofuscación de código
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### Depurar en Dispositivo Real

```bash
# Conectar dispositivo por USB
# Habilitar depuración USB en el dispositivo

# Ejecutar en modo debug
flutter run --debug

# Ver logs en tiempo real
flutter logs
```

## 📝 Notas Importantes

- **Moneda**: La aplicación usa Soles (S/) como moneda predeterminada
- **Offline**: La app funciona 100% offline, no requiere internet
- **Base de Datos**: SQLite local, los datos se almacenan en el dispositivo
- **Permisos**: No requiere permisos especiales de Android

## 🆘 Solución de Problemas

### El emulador no inicia

```bash
# Verificar que el emulador existe
flutter emulators

# Crear nuevo emulador si es necesario
flutter emulators --create

# Iniciar con configuración básica
~/Android/Sdk/emulator/emulator -avd Medium_Phone_API_36.0
```

### Error al compilar

```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

### APK no instala en dispositivo

- Verificar que "Fuentes desconocidas" esté habilitado
- Desinstalar versión anterior si existe
- Verificar espacio disponible en el dispositivo
- Intentar con `adb install -r` para forzar reinstalación

## 📞 Soporte

Para problemas o preguntas sobre el desarrollo:
- Revisar logs: `flutter logs`
- Analizar código: `flutter analyze`
- Verificar configuración: `flutter doctor -v`
