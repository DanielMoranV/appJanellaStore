import 'package:drift/drift.dart';
import 'package:janella_store/data/database/database.dart';

class ProductosRepository {
  final AppDatabase _db;

  ProductosRepository(this._db);

  // Crear producto
  Future<int> crearProducto({
    required String nombre,
    String? descripcion,
    required String tamano,
    required double precioVenta,
    int stock = 0,
  }) {
    return _db.into(_db.productos).insert(
          ProductosCompanion.insert(
            nombre: nombre,
            descripcion: Value(descripcion),
            tamano: tamano,
            precioVenta: precioVenta,
            stock: Value(stock),
          ),
        );
  }

  // Obtener todos los productos
  Future<List<Producto>> obtenerTodos() {
    return (_db.select(_db.productos)..orderBy([(p) => OrderingTerm.asc(p.nombre)])).get();
  }

  // Obtener producto por ID
  Future<Producto?> obtenerPorId(int id) {
    return (_db.select(_db.productos)..where((p) => p.idProducto.equals(id))).getSingleOrNull();
  }

  // Actualizar producto
  Future<bool> actualizar(Producto producto) {
    return _db.update(_db.productos).replace(producto);
  }

  // Eliminar producto
  Future<int> eliminar(int id) {
    return (_db.delete(_db.productos)..where((p) => p.idProducto.equals(id))).go();
  }

  // Buscar productos por nombre
  Future<List<Producto>> buscarPorNombre(String nombre) {
    return (_db.select(_db.productos)
          ..where((p) => p.nombre.like('%$nombre%'))
          ..orderBy([(p) => OrderingTerm.asc(p.nombre)]))
        .get();
  }

  // Actualizar stock
  Future<void> actualizarStock(int idProducto, int nuevoStock) async {
    final producto = await obtenerPorId(idProducto);
    if (producto != null) {
      await _db.update(_db.productos).replace(
            producto.copyWith(stock: nuevoStock),
          );
    }
  }

  // Incrementar stock (para ingresos)
  Future<void> incrementarStock(int idProducto, int cantidad) async {
    final producto = await obtenerPorId(idProducto);
    if (producto != null) {
      await actualizarStock(idProducto, producto.stock + cantidad);
    }
  }

  // Decrementar stock (para ventas)
  Future<void> decrementarStock(int idProducto, int cantidad) async {
    final producto = await obtenerPorId(idProducto);
    if (producto != null) {
      final nuevoStock = producto.stock - cantidad;
      if (nuevoStock < 0) {
        throw Exception('Stock insuficiente para el producto ${producto.nombre}');
      }
      await actualizarStock(idProducto, nuevoStock);
    }
  }

  // Obtener productos con stock bajo
  Future<List<Producto>> obtenerProductosBajoStock() {
    return _db.getProductosBajoStock();
  }

  // Verificar si hay stock suficiente
  Future<bool> hayStockSuficiente(int idProducto, int cantidadRequerida) async {
    final producto = await obtenerPorId(idProducto);
    if (producto == null) return false;
    return producto.stock >= cantidadRequerida;
  }
}
