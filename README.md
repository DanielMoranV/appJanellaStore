# Janella Store - Aplicación de Gestión de Ventas

Aplicación móvil Flutter completamente offline para gestión de inventario, ventas y créditos.

## 🎯 Características

- ✅ **100% Offline** - No requiere conexión a internet
- ✅ **Sin Login** - Acceso directo a la aplicación
- ✅ **Gestión de Productos** - Catálogo completo con stock
- ✅ **Gestión de Clientes** - Registro y seguimiento de clientes
- ✅ **Carrito de Compras** - Ventas con múltiples productos
- ✅ **Ventas en Efectivo y Crédito** - Soporte para ambos métodos de pago
- ✅ **Sistema de Créditos** - Gestión completa de deudas y abonos
- ✅ **Ingreso de Mercadería** - Control de compras e inventario
- ✅ **Reportes Visuales** - Gráficos y estadísticas de ventas
- ✅ **Proveedores** - Gestión de proveedores

## 🛠 Tecnologías

- **Flutter 3.x** - Framework de desarrollo
- **Drift ORM** - Base de datos SQLite local
- **Riverpod** - Manejo de estado
- **GoRouter** - Navegación
- **fl_chart** - Gráficos y reportes visuales

## 📦 Instalación

### Requisitos Previos

- Flutter SDK 3.9.0 o superior
- Android SDK (para compilación Android)
- Dart SDK

### Pasos de Instalación

1. **Clonar o navegar al proyecto**
   ```bash
   cd /home/maeldev/Code/appJanellaStore
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Generar código de Drift**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 📱 Uso de la Aplicación

### Pantalla Principal

La pantalla principal muestra un menú con acceso rápido a:
- Productos
- Clientes
- Créditos
- Ingresos de Mercadería
- Reportes
- Proveedores

### Flujo de Venta

1. **Agregar Productos al Carrito**
   - Navegar a "Productos"
   - Buscar o seleccionar productos
   - Tocar el botón de carrito en cada producto

2. **Realizar Venta**
   - Ir al carrito (ícono en la parte superior)
   - Ajustar cantidades si es necesario
   - Seleccionar "Vender en Efectivo" o "Vender a Crédito"
   - Elegir el cliente
   - Confirmar la venta

### Gestión de Créditos

1. **Ver Créditos Activos**
   - Navegar a "Créditos"
   - Ver lista de clientes con deudas pendientes

2. **Registrar Abono**
   - Seleccionar un crédito
   - Tocar "Registrar Abono"
   - Ingresar el monto
   - Confirmar

### Ingreso de Mercadería

1. **Registrar Compra**
   - Navegar a "Ingresos"
   - Seleccionar proveedor (opcional)
   - Agregar productos con cantidad y costo unitario
   - Guardar ingreso

### Reportes

La pantalla de reportes muestra:
- Ventas del día
- Total de deudas activas
- Total invertido
- Créditos activos
- Gráfico de productos más vendidos

## 🗄 Estructura de la Base de Datos

### Tablas Principales

- **clientes** - Información de clientes
- **productos** - Catálogo de productos con stock
- **proveedores** - Proveedores de mercadería
- **ingresos_mercaderia** - Registro de compras
- **ingresos_detalle** - Detalles de cada compra
- **ventas** - Registro de ventas
- **ventas_detalle** - Productos vendidos en cada venta
- **creditos** - Créditos activos
- **abonos** - Pagos realizados a créditos

## 📂 Estructura del Proyecto

```
lib/
├── data/
│   ├── database/
│   │   └── database.dart          # Definición de tablas Drift
│   └── repositories/              # Repositorios para acceso a datos
│       ├── clientes_repository.dart
│       ├── productos_repository.dart
│       ├── proveedores_repository.dart
│       ├── ingresos_repository.dart
│       ├── ventas_repository.dart
│       ├── creditos_repository.dart
│       └── abonos_repository.dart
├── providers/
│   ├── providers.dart             # Providers de Riverpod
│   └── cart_provider.dart         # Estado del carrito
├── screens/                       # Pantallas de la aplicación
│   ├── home_screen.dart
│   ├── productos_screen.dart
│   ├── cart_screen.dart
│   ├── clientes_screen.dart
│   ├── creditos_screen.dart
│   ├── ingreso_screen.dart
│   ├── reportes_screen.dart
│   └── ...
├── widgets/                       # Widgets reutilizables
│   └── product_card.dart
├── router.dart                    # Configuración de rutas
└── main.dart                      # Punto de entrada
```

## 🔧 Desarrollo

### Regenerar Código de Drift

Cuando modifiques las tablas de la base de datos:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Análisis de Código

```bash
flutter analyze
```

### Compilar para Android

```bash
flutter build apk --release
```

## 🎨 Diseño

La aplicación utiliza Material Design 3 con:
- Tema claro y minimalista
- Tarjetas con elevación
- Gradientes en elementos destacados
- Indicadores visuales de stock
- Badges para el carrito
- Gráficos interactivos

## 📝 Notas Importantes

- **Offline First**: Todos los datos se almacenan localmente en SQLite
- **Actualización Automática de Stock**: El stock se actualiza automáticamente al registrar ventas e ingresos
- **Validación de Stock**: No se permite vender más unidades de las disponibles
- **Gestión de Créditos**: Los créditos se crean automáticamente al vender a crédito
- **Abonos**: Los abonos reducen el saldo del crédito automáticamente

## 🐛 Solución de Problemas

### Error al compilar

Si encuentras errores de compilación:

1. Limpia el proyecto:
   ```bash
   flutter clean
   ```

2. Reinstala dependencias:
   ```bash
   flutter pub get
   ```

3. Regenera código de Drift:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Base de datos corrupta

Si la base de datos presenta problemas:

1. Desinstala la aplicación del dispositivo
2. Vuelve a instalar

## 📄 Licencia

Este proyecto es privado y está desarrollado para uso específico de Janella Store.

## 👨‍💻 Desarrollo

Desarrollado con Flutter y Drift ORM para proporcionar una experiencia offline completa y robusta.
