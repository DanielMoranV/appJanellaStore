# Janella Store - Aplicación de Gestión de Ventas

Aplicación móvil Flutter completamente offline para gestión de inventario, ventas y créditos.

## 🎯 Características

- ✅ **100% Offline** - No requiere conexión a internet
- ✅ **Sin Login** - Acceso directo a la aplicación
- ✅ **Gestión de Productos** - Catálogo completo con stock
- ✅ **Gestión de Clientes Mejorada** - Registro, seguimiento y búsqueda avanzada de clientes
- ✅ **Carrito de Compras** - Ventas con múltiples productos
- ✅ **Ventas en Efectivo y Crédito** - Soporte para ambos métodos de pago, incluyendo **anulación de ventas con restauración de stock**
- ✅ **Gestión Avanzada de Créditos** - Sistema completo de deudas, abonos, con historial detallado por cliente y **visualización de créditos pendientes/saldados**.
- ✅ **Historial de Ingresos y Anulación** - Control de compras e inventario con **historial de ingresos y capacidad de anular ingresos** (revirtiendo stock).
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



1.  **Agregar Productos al Carrito**

    *   Navegar a "Productos".

    *   Buscar o seleccionar productos.

    *   Tocar el botón de carrito en cada producto.

2.  **Realizar Venta**

    *   Ir al carrito (ícono en la parte superior).

    *   Ajustar cantidades si es necesario.

    *   Seleccionar "Vender en Efectivo" o "Vender a Crédito".

    *   Elegir el cliente (ahora con función de búsqueda).

    *   Confirmar la venta.

3.  **Anular Venta**

    *   Desde la pantalla "Historial de Ventas" (accesible desde el menú principal o "Reportes").

    *   Expandir el detalle de una venta.

    *   Seleccionar la opción "Anular Venta". Esto restaurará el stock y eliminará el crédito si aplicaba.

### Gestión de Créditos



1.  **Ver Créditos de Cliente**:

    *   Navegar a "Clientes" y seleccionar un cliente.

    *   En la pantalla de detalles del cliente, ir a "Créditos" o "Estado de Cuenta".

    *   La pantalla de créditos mostrará pestañas para **Créditos Pendientes** y **Créditos Saldados**.

2.  **Ver Estado de Cuenta**:

    *   Desde la pantalla de créditos del cliente, acceder a "Estado de Cuenta" para ver el timeline de movimientos.

    *   Filtrar por rango de fechas para ver movimientos específicos.

3.  **Registrar Abono**:

    *   Desde la pantalla de créditos del cliente, tocar "Registrar Abono".

    *   Ingresar el monto y confirmar. El abono se distribuirá automáticamente.

4.  **Eliminar Abono**:

    *   Desde el detalle de un crédito (accesible desde la pantalla de créditos del cliente), se puede eliminar un abono específico. El saldo del crédito se ajustará.

### Ingreso de Mercadería



1.  **Registrar Compra**

    *   Navegar a "Ingresos" (desde el menú principal).

    *   Tocar el botón flotante "+" para "Nuevo Ingreso".

    *   Seleccionar proveedor (opcional).

    *   Agregar productos con cantidad y costo unitario.

    *   Guardar ingreso.

2.  **Ver Historial de Ingresos**

    *   Desde la pantalla "Ingresos", se mostrará el historial de compras.

    *   Filtrar por rango de fechas.

    *   Expandir cada ingreso para ver los productos.

3.  **Anular Ingreso**

    *   Desde el detalle expandido de un ingreso en el historial, se puede anular el ingreso. Esto revertirá el stock de los productos.

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

## ✨ Nuevas Funcionalidades Recientes

Hemos implementado importantes mejoras para una gestión más robusta y detallada:

-   **Estado de Cuenta del Cliente**: Nueva pantalla dedicada donde se visualiza un timeline cronológico de todos los cargos (ventas a crédito) y abonos (pagos) realizados por un cliente. Incluye:
    *   Cálculo de saldo corrido tras cada transacción.
    *   Estadísticas resumen de movimientos (Total Cargado, Total Abonado, Saldo Actual).
    *   Filtro por rango de fechas para análisis específicos.
-   **Mejora en la Vista de Créditos del Cliente**: La pantalla de créditos ahora presenta pestañas para separar los **Créditos Pendientes** de los **Créditos Saldados**, facilitando la visualización y seguimiento.
-   **Anulación de Ventas**: Funcionalidad para anular una venta completa. Al anularse, el stock de los productos vendidos se restaura automáticamente. Si la venta fue a crédito, el crédito asociado y todos sus abonos también son eliminados, restaurando la situación previa.
-   **Historial de Ingresos y Anulación**: Se añadió una pantalla para revisar el historial de ingresos de mercancía. Es posible anular un ingreso, lo que decrementará automáticamente el stock de los productos que se habían registrado.
-   **Eliminación de Abonos Individuales**: Ahora es posible eliminar abonos específicos desde el detalle de un crédito. Al hacerlo, el saldo del crédito se ajusta automáticamente, incrementándose el monto correspondiente al abono eliminado.
-   **Búsqueda en Selección de Clientes**: El diálogo para seleccionar clientes (ej. en el POS) ahora incluye una barra de búsqueda para encontrar clientes de forma más rápida y eficiente.

---

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
