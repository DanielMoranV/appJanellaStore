import 'package:drift/drift.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/productos_repository.dart';

class IngresosRepository {
  final AppDatabase _db;
  final ProductosRepository _productosRepo;

  IngresosRepository(this._db, this._productosRepo);

  // Registrar ingreso de mercadería
  Future<int> registrarIngreso({
    int? idProveedor,
    required DateTime fecha,
    required List<DetalleIngreso> detalles,
  }) async {
    // Calcular total de inversión
    final totalInversion = detalles.fold<double>(
      0.0,
      (sum, detalle) => sum + detalle.subtotal,
    );

    // Insertar el ingreso
    final idIngreso = await _db.into(_db.ingresosMercaderia).insert(
          IngresosMercaderiaCompanion.insert(
            idProveedor: Value(idProveedor),
            fecha: fecha,
            totalInversion: totalInversion,
          ),
        );

    // Insertar los detalles y actualizar stock
    for (final detalle in detalles) {
      await _db.into(_db.ingresosDetalle).insert(
            IngresosDetalleCompanion.insert(
              idIngreso: idIngreso,
              idProducto: detalle.idProducto,
              cantidad: detalle.cantidad,
              costoUnitario: detalle.costoUnitario,
              subtotal: detalle.subtotal,
            ),
          );

      // Incrementar stock del producto
      await _productosRepo.incrementarStock(detalle.idProducto, detalle.cantidad);
    }

    return idIngreso;
  }

  // Obtener todos los ingresos
  Future<List<IngresosMercaderiaData>> obtenerTodos() {
    return (_db.select(_db.ingresosMercaderia)..orderBy([(i) => OrderingTerm.desc(i.fecha)])).get();
  }

  // Obtener ingreso por ID
  Future<IngresosMercaderiaData?> obtenerPorId(int id) {
    return (_db.select(_db.ingresosMercaderia)..where((i) => i.idIngreso.equals(id))).getSingleOrNull();
  }

  // Obtener detalles de un ingreso
  Future<List<IngresosDetalleConProducto>> obtenerDetalles(int idIngreso) async {
    final query = _db.select(_db.ingresosDetalle).join([
      innerJoin(_db.productos, _db.productos.idProducto.equalsExp(_db.ingresosDetalle.idProducto)),
    ])
      ..where(_db.ingresosDetalle.idIngreso.equals(idIngreso));

    final result = await query.get();
    return result.map((row) {
      return IngresosDetalleConProducto(
        detalle: row.readTable(_db.ingresosDetalle),
        producto: row.readTable(_db.productos),
      );
    }).toList();
  }

  // Obtener ingresos por proveedor
  Future<List<IngresosMercaderiaData>> obtenerPorProveedor(int idProveedor) {
    return (_db.select(_db.ingresosMercaderia)
          ..where((i) => i.idProveedor.equals(idProveedor))
          ..orderBy([(i) => OrderingTerm.desc(i.fecha)]))
        .get();
  }

  // Obtener total invertido
  Future<double> obtenerTotalInvertido() async {
    final query = _db.selectOnly(_db.ingresosMercaderia)
      ..addColumns([_db.ingresosMercaderia.totalInversion.sum()]);

    final result = await query.getSingle();
    return result.read(_db.ingresosMercaderia.totalInversion.sum()) ?? 0.0;
  }

  // Obtener ingresos por rango de fechas
  Future<List<IngresosMercaderiaData>> obtenerPorRangoFechas(DateTime inicio, DateTime fin) {
    return (_db.select(_db.ingresosMercaderia)
          ..where((i) => i.fecha.isBetweenValues(inicio, fin))
          ..orderBy([(i) => OrderingTerm.desc(i.fecha)]))
        .get();
  }
}

// Clase auxiliar para detalles de ingreso
class DetalleIngreso {
  final int idProducto;
  final int cantidad;
  final double costoUnitario;
  final double subtotal;

  DetalleIngreso({
    required this.idProducto,
    required this.cantidad,
    required this.costoUnitario,
    required this.subtotal,
  });
}

// Clase auxiliar para detalles con producto
class IngresosDetalleConProducto {
  final IngresosDetalleData detalle;
  final Producto producto;

  IngresosDetalleConProducto({
    required this.detalle,
    required this.producto,
  });
}
