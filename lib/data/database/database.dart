import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ============================================================================
// TABLAS
// ============================================================================

/// Tabla de Clientes
class Clientes extends Table {
  IntColumn get idCliente => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get direccion => text().withLength(max: 200)();
  TextColumn get telefono => text().withLength(max: 20)();
}

/// Tabla de Productos
class Productos extends Table {
  IntColumn get idProducto => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get descripcion => text().nullable()();
  TextColumn get tamano => text().withLength(max: 50)();
  RealColumn get precioVenta => real()();
  IntColumn get stock => integer().withDefault(const Constant(0))();
}

/// Tabla de Proveedores
class Proveedores extends Table {
  IntColumn get idProveedor => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get direccion => text().withLength(max: 200)();
  TextColumn get telefono => text().withLength(max: 20)();
}

/// Tabla de Ingresos de Mercadería (Compras)
class IngresosMercaderia extends Table {
  IntColumn get idIngreso => integer().autoIncrement()();
  IntColumn get idProveedor => integer().nullable().references(Proveedores, #idProveedor)();
  DateTimeColumn get fecha => dateTime()();
  RealColumn get totalInversion => real()();
}

/// Tabla de Detalles de Ingresos
class IngresosDetalle extends Table {
  IntColumn get idDetalleIngreso => integer().autoIncrement()();
  IntColumn get idIngreso => integer().references(IngresosMercaderia, #idIngreso, onDelete: KeyAction.cascade)();
  IntColumn get idProducto => integer().references(Productos, #idProducto)();
  IntColumn get cantidad => integer()();
  RealColumn get costoUnitario => real()();
  RealColumn get subtotal => real()();
}

/// Tabla de Ventas
class Ventas extends Table {
  IntColumn get idVenta => integer().autoIncrement()();
  IntColumn get idCliente => integer().references(Clientes, #idCliente)();
  DateTimeColumn get fecha => dateTime()();
  RealColumn get total => real()();
  BoolColumn get esCredito => boolean().withDefault(const Constant(false))();
}

/// Tabla de Detalles de Ventas
class VentasDetalle extends Table {
  IntColumn get idDetalle => integer().autoIncrement()();
  IntColumn get idVenta => integer().references(Ventas, #idVenta, onDelete: KeyAction.cascade)();
  IntColumn get idProducto => integer().references(Productos, #idProducto)();
  IntColumn get cantidad => integer()();
  RealColumn get precioUnitario => real()();
  RealColumn get subtotal => real()();
}

/// Tabla de Créditos
class Creditos extends Table {
  IntColumn get idCredito => integer().autoIncrement()();
  IntColumn get idVenta => integer().references(Ventas, #idVenta)();
  IntColumn get idCliente => integer().references(Clientes, #idCliente)();
  RealColumn get montoTotal => real()();
  RealColumn get saldoActual => real()();
  DateTimeColumn get fecha => dateTime()();
}

/// Tabla de Abonos
class Abonos extends Table {
  IntColumn get idAbono => integer().autoIncrement()();
  IntColumn get idCredito => integer().references(Creditos, #idCredito, onDelete: KeyAction.cascade)();
  DateTimeColumn get fecha => dateTime()();
  RealColumn get montoAbono => real()();
}

// ============================================================================
// DATABASE
// ============================================================================

@DriftDatabase(tables: [
  Clientes,
  Productos,
  Proveedores,
  IngresosMercaderia,
  IngresosDetalle,
  Ventas,
  VentasDetalle,
  Creditos,
  Abonos,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ============================================================================
  // QUERIES PERSONALIZADAS
  // ============================================================================

  // Obtener productos con stock bajo (menos de 5 unidades)
  Future<List<Producto>> getProductosBajoStock() {
    return (select(productos)..where((p) => p.stock.isSmallerThanValue(5))).get();
  }

  // Obtener clientes con deudas activas
  Future<List<Cliente>> getClientesConDeudas() async {
    final query = selectOnly(creditos)
      ..addColumns([creditos.idCliente])
      ..where(creditos.saldoActual.isBiggerThanValue(0))
      ..groupBy([creditos.idCliente]);

    final result = await query.get();
    final clienteIds = result.map((row) => row.read(creditos.idCliente)!).toList();

    return (select(clientes)..where((c) => c.idCliente.isIn(clienteIds))).get();
  }

  // Obtener ventas del día
  Future<List<Venta>> getVentasDelDia(DateTime fecha) {
    final inicio = DateTime(fecha.year, fecha.month, fecha.day);
    final fin = inicio.add(const Duration(days: 1));

    return (select(ventas)
          ..where((v) => v.fecha.isBetweenValues(inicio, fin))
          ..orderBy([(v) => OrderingTerm.desc(v.fecha)]))
        .get();
  }

  // Obtener total de ventas del día
  Future<double> getTotalVentasDelDia(DateTime fecha) async {
    final inicio = DateTime(fecha.year, fecha.month, fecha.day);
    final fin = inicio.add(const Duration(days: 1));

    final query = selectOnly(ventas)
      ..addColumns([ventas.total.sum()])
      ..where(ventas.fecha.isBetweenValues(inicio, fin));

    final result = await query.getSingle();
    return result.read(ventas.total.sum()) ?? 0.0;
  }

  // Obtener productos más vendidos
  Future<List<ProductoVendido>> getProductosMasVendidos({int limit = 10}) async {
    final query = selectOnly(ventasDetalle)
      ..addColumns([
        ventasDetalle.idProducto,
        ventasDetalle.cantidad.sum(),
      ])
      ..groupBy([ventasDetalle.idProducto])
      ..orderBy([OrderingTerm.desc(ventasDetalle.cantidad.sum())])
      ..limit(limit);

    final result = await query.get();
    final productosVendidos = <ProductoVendido>[];

    for (final row in result) {
      final idProducto = row.read(ventasDetalle.idProducto)!;
      final cantidadTotal = row.read(ventasDetalle.cantidad.sum())!;
      final producto = await (select(productos)..where((p) => p.idProducto.equals(idProducto))).getSingle();

      productosVendidos.add(ProductoVendido(
        producto: producto,
        cantidadVendida: cantidadTotal,
      ));
    }

    return productosVendidos;
  }

  // Obtener detalles de una venta
  Future<List<DetalleVentaConProducto>> getDetallesVenta(int idVenta) async {
    final query = select(ventasDetalle).join([
      innerJoin(productos, productos.idProducto.equalsExp(ventasDetalle.idProducto)),
    ])
      ..where(ventasDetalle.idVenta.equals(idVenta));

    final result = await query.get();
    return result.map((row) {
      return DetalleVentaConProducto(
        detalle: row.readTable(ventasDetalle),
        producto: row.readTable(productos),
      );
    }).toList();
  }

  // Obtener créditos de un cliente
  Future<List<Credito>> getCreditosCliente(int idCliente) {
    return (select(creditos)
          ..where((c) => c.idCliente.equals(idCliente))
          ..orderBy([(c) => OrderingTerm.desc(c.fecha)]))
        .get();
  }

  // Obtener créditos activos (con saldo pendiente)
  Future<List<CreditoConCliente>> getCreditosActivos() async {
    final query = select(creditos).join([
      innerJoin(clientes, clientes.idCliente.equalsExp(creditos.idCliente)),
    ])
      ..where(creditos.saldoActual.isBiggerThanValue(0))
      ..orderBy([OrderingTerm.desc(creditos.fecha)]);

    final result = await query.get();
    return result.map((row) {
      return CreditoConCliente(
        credito: row.readTable(creditos),
        cliente: row.readTable(clientes),
      );
    }).toList();
  }

  // Obtener abonos de un crédito
  Future<List<Abono>> getAbonosCredito(int idCredito) {
    return (select(abonos)
          ..where((a) => a.idCredito.equals(idCredito))
          ..orderBy([(a) => OrderingTerm.desc(a.fecha)]))
        .get();
  }

  // Obtener historial de ventas de un cliente
  Future<List<Venta>> getVentasCliente(int idCliente) {
    return (select(ventas)
          ..where((v) => v.idCliente.equals(idCliente))
          ..orderBy([(v) => OrderingTerm.desc(v.fecha)]))
        .get();
  }
}

// ============================================================================
// CLASES AUXILIARES
// ============================================================================

class ProductoVendido {
  final Producto producto;
  final int cantidadVendida;

  ProductoVendido({
    required this.producto,
    required this.cantidadVendida,
  });
}

class DetalleVentaConProducto {
  final VentasDetalleData detalle;
  final Producto producto;

  DetalleVentaConProducto({
    required this.detalle,
    required this.producto,
  });
}

class CreditoConCliente {
  final Credito credito;
  final Cliente cliente;

  CreditoConCliente({
    required this.credito,
    required this.cliente,
  });
}

// ============================================================================
// CONEXIÓN A LA BASE DE DATOS
// ============================================================================

QueryExecutor _openConnection() {
  return driftDatabase(name: 'janella_store_db');
}
