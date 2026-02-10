import 'package:drift/drift.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/productos_repository.dart';
import 'package:janella_store/data/repositories/creditos_repository.dart';

class VentasRepository {
  final AppDatabase _db;
  final ProductosRepository _productosRepo;
  final CreditosRepository _creditosRepo;

  VentasRepository(this._db, this._productosRepo, this._creditosRepo);

  // Registrar venta
  Future<int> registrarVenta({
    required int idCliente,
    required DateTime fecha,
    required List<DetalleVenta> detalles,
    required bool esCredito,
  }) async {
    // Validar stock antes de proceder
    for (final detalle in detalles) {
      final hayStock = await _productosRepo.hayStockSuficiente(
        detalle.idProducto,
        detalle.cantidad,
      );
      if (!hayStock) {
        final producto = await _productosRepo.obtenerPorId(detalle.idProducto);
        throw Exception('Stock insuficiente para ${producto?.nombre ?? "producto"}');
      }
    }

    // Calcular total
    final total = detalles.fold<double>(
      0.0,
      (sum, detalle) => sum + detalle.subtotal,
    );

    // Insertar la venta
    final idVenta = await _db.into(_db.ventas).insert(
          VentasCompanion.insert(
            idCliente: idCliente,
            fecha: fecha,
            total: total,
            esCredito: Value(esCredito),
          ),
        );

    // Insertar los detalles y actualizar stock
    for (final detalle in detalles) {
      await _db.into(_db.ventasDetalle).insert(
            VentasDetalleCompanion.insert(
              idVenta: idVenta,
              idProducto: detalle.idProducto,
              cantidad: detalle.cantidad,
              precioUnitario: detalle.precioUnitario,
              subtotal: detalle.subtotal,
            ),
          );

      // Decrementar stock del producto
      await _productosRepo.decrementarStock(detalle.idProducto, detalle.cantidad);
    }

    // Si es a crédito, crear el registro de crédito
    if (esCredito) {
      await _creditosRepo.crearCredito(
        idVenta: idVenta,
        idCliente: idCliente,
        montoTotal: total,
        fecha: fecha,
      );
    }

    return idVenta;
  }

  // Obtener todas las ventas
  Future<List<Venta>> obtenerTodas() {
    return (_db.select(_db.ventas)..orderBy([(v) => OrderingTerm.desc(v.fecha)])).get();
  }

  // Obtener venta por ID
  Future<Venta?> obtenerPorId(int id) {
    return (_db.select(_db.ventas)..where((v) => v.idVenta.equals(id))).getSingleOrNull();
  }

  // Obtener detalles de una venta
  Future<List<DetalleVentaConProducto>> obtenerDetalles(int idVenta) {
    return _db.getDetallesVenta(idVenta);
  }

  // Obtener ventas del día
  Future<List<Venta>> obtenerVentasDelDia(DateTime fecha) {
    return _db.getVentasDelDia(fecha);
  }

  // Obtener total de ventas del día
  Future<double> obtenerTotalVentasDelDia(DateTime fecha) {
    return _db.getTotalVentasDelDia(fecha);
  }

  // Obtener ventas por cliente
  Future<List<Venta>> obtenerPorCliente(int idCliente) {
    return _db.getVentasCliente(idCliente);
  }

  // Obtener ventas por rango de fechas
  Future<List<Venta>> obtenerPorRangoFechas(DateTime inicio, DateTime fin) {
    return (_db.select(_db.ventas)
          ..where((v) => v.fecha.isBetweenValues(inicio, fin))
          ..orderBy([(v) => OrderingTerm.desc(v.fecha)]))
        .get();
  }

  // Obtener total de ventas por rango de fechas
  Future<double> obtenerTotalPorRangoFechas(DateTime inicio, DateTime fin) async {
    final query = _db.selectOnly(_db.ventas)
      ..addColumns([_db.ventas.total.sum()])
      ..where(_db.ventas.fecha.isBetweenValues(inicio, fin));

    final result = await query.getSingle();
    return result.read(_db.ventas.total.sum()) ?? 0.0;
  }

  // Obtener ventas en efectivo
  Future<List<Venta>> obtenerVentasEfectivo() {
    return (_db.select(_db.ventas)
          ..where((v) => v.esCredito.equals(false))
          ..orderBy([(v) => OrderingTerm.desc(v.fecha)]))
        .get();
  }

  // Obtener ventas a crédito
  Future<List<Venta>> obtenerVentasCredito() {
    return (_db.select(_db.ventas)
          ..where((v) => v.esCredito.equals(true))
          ..orderBy([(v) => OrderingTerm.desc(v.fecha)]))
        .get();
  }

  // Obtener productos más vendidos
  Future<List<ProductoVendido>> obtenerProductosMasVendidos({int limit = 10}) {
    return _db.getProductosMasVendidos(limit: limit);
  }

  // Obtener ventas con cliente (optimizado)
  Future<List<VentaConCliente>> obtenerVentasConCliente({
    DateTime? inicio,
    DateTime? fin,
    int? idCliente,
  }) {
    return _db.getVentasConCliente(
      inicio: inicio,
      fin: fin,
      idCliente: idCliente,
    );
  }

  // Eliminar venta (Anular) y restaurar stock
  Future<void> eliminarVenta(int idVenta) async {
    // 1. Obtener detalles de la venta
    final detalles = await obtenerDetalles(idVenta);

    // 2. Restaurar stock (incrementar)
    for (final item in detalles) {
      await _productosRepo.incrementarStock(
        item.detalle.idProducto,
        item.detalle.cantidad,
      );
    }

    // 3. Si es crédito, eliminar el crédito
    final credito = await _creditosRepo.obtenerPorIdVenta(idVenta);
    if (credito != null) {
      // Abonos tiene cascade desde Creditos, así que borrar Credito borra Abonos.
      await (_db.delete(_db.creditos)
            ..where((c) => c.idCredito.equals(credito.idCredito)))
          .go();
    }

    // 4. Eliminar la venta (los detalles tienen cascade)
    await (_db.delete(_db.ventas)..where((v) => v.idVenta.equals(idVenta))).go();
  }
}

// Clase auxiliar para detalles de venta
class DetalleVenta {
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  DetalleVenta({
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
}
