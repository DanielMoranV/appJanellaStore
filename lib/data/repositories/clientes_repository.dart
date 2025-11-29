import 'package:drift/drift.dart';
import 'package:janella_store/data/database/database.dart';

class ClientesRepository {
  final AppDatabase _db;

  ClientesRepository(this._db);

  // Crear cliente
  Future<int> crearCliente({
    required String nombre,
    required String direccion,
    required String telefono,
  }) {
    return _db.into(_db.clientes).insert(
          ClientesCompanion.insert(
            nombre: nombre,
            direccion: direccion,
            telefono: telefono,
          ),
        );
  }

  // Obtener todos los clientes
  Future<List<Cliente>> obtenerTodos() {
    return _db.select(_db.clientes).get();
  }

  // Obtener cliente por ID
  Future<Cliente?> obtenerPorId(int id) {
    return (_db.select(_db.clientes)..where((c) => c.idCliente.equals(id))).getSingleOrNull();
  }

  // Actualizar cliente
  Future<bool> actualizar(Cliente cliente) {
    return _db.update(_db.clientes).replace(cliente);
  }

  // Eliminar cliente
  Future<int> eliminar(int id) {
    return (_db.delete(_db.clientes)..where((c) => c.idCliente.equals(id))).go();
  }

  // Buscar clientes por nombre
  Future<List<Cliente>> buscarPorNombre(String nombre) {
    return (_db.select(_db.clientes)
          ..where((c) => c.nombre.like('%$nombre%'))
          ..orderBy([(c) => OrderingTerm.asc(c.nombre)]))
        .get();
  }

  // Obtener historial de ventas del cliente
  Future<List<Venta>> obtenerVentas(int idCliente) {
    return _db.getVentasCliente(idCliente);
  }

  // Obtener créditos del cliente
  Future<List<Credito>> obtenerCreditos(int idCliente) {
    return _db.getCreditosCliente(idCliente);
  }

  // Obtener total de deuda del cliente
  Future<double> obtenerTotalDeuda(int idCliente) async {
    final creditos = await (_db.select(_db.creditos)
          ..where((c) => c.idCliente.equals(idCliente) & c.saldoActual.isBiggerThanValue(0)))
        .get();

    return creditos.fold<double>(0.0, (sum, credito) => sum + credito.saldoActual);
  }

  // Obtener clientes con deudas activas
  Future<List<Cliente>> obtenerClientesConDeudas() {
    return _db.getClientesConDeudas();
  }
}
