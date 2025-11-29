import 'package:drift/drift.dart';
import 'package:janella_store/data/database/database.dart';

class ProveedoresRepository {
  final AppDatabase _db;

  ProveedoresRepository(this._db);

  // Crear proveedor
  Future<int> crearProveedor({
    required String nombre,
    required String direccion,
    required String telefono,
  }) {
    return _db.into(_db.proveedores).insert(
          ProveedoresCompanion.insert(
            nombre: nombre,
            direccion: direccion,
            telefono: telefono,
          ),
        );
  }

  // Obtener todos los proveedores
  Future<List<Proveedore>> obtenerTodos() {
    return (_db.select(_db.proveedores)..orderBy([(p) => OrderingTerm.asc(p.nombre)])).get();
  }

  // Obtener proveedor por ID
  Future<Proveedore?> obtenerPorId(int id) {
    return (_db.select(_db.proveedores)..where((p) => p.idProveedor.equals(id))).getSingleOrNull();
  }

  // Actualizar proveedor
  Future<bool> actualizar(Proveedore proveedor) {
    return _db.update(_db.proveedores).replace(proveedor);
  }

  // Eliminar proveedor
  Future<int> eliminar(int id) {
    return (_db.delete(_db.proveedores)..where((p) => p.idProveedor.equals(id))).go();
  }

  // Buscar proveedores por nombre
  Future<List<Proveedore>> buscarPorNombre(String nombre) {
    return (_db.select(_db.proveedores)
          ..where((p) => p.nombre.like('%$nombre%'))
          ..orderBy([(p) => OrderingTerm.asc(p.nombre)]))
        .get();
  }
}
