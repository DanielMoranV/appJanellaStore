import 'package:drift/drift.dart';
import 'package:janella_store/data/database/database.dart';

class CreditosRepository {
  final AppDatabase _db;

  CreditosRepository(this._db);

  // Crear crédito (estructura restaurada)
  Future<int> crearCredito({
    required int idVenta,
    required int idCliente,
    required double montoTotal,
    required DateTime fecha,
  }) {
    return _db.into(_db.creditos).insert(
          CreditosCompanion.insert(
            idVenta: idVenta,
            idCliente: idCliente,
            montoTotal: montoTotal,
            saldoActual: montoTotal, // Inicialmente el saldo es igual al monto total
            fecha: fecha,
          ),
        );
  }

  // Obtener todos los créditos
  Future<List<Credito>> obtenerTodos() {
    return (_db.select(_db.creditos)
          ..orderBy([(c) => OrderingTerm.desc(c.fecha)]))
        .get();
  }

  // Obtener crédito por ID
  Future<Credito?> obtenerPorId(int id) {
    return (_db.select(_db.creditos)..where((c) => c.idCredito.equals(id)))
        .getSingleOrNull();
  }

  // Obtener crédito por ID de venta
  Future<Credito?> obtenerPorIdVenta(int idVenta) {
    return (_db.select(_db.creditos)..where((c) => c.idVenta.equals(idVenta)))
        .getSingleOrNull();
  }

  // Obtener créditos de un cliente
  Future<List<Credito>> obtenerPorCliente(int idCliente) {
    return _db.getCreditosCliente(idCliente);
  }

  // Obtener créditos activos (con saldo pendiente)
  Future<List<CreditoConCliente>> obtenerCreditosActivos() {
    return _db.getCreditosActivos();
  }

  // Obtener créditos activos de un cliente ordenados por fecha (FIFO)
  Future<List<Credito>> obtenerCreditosActivosClienteOrdenados(int idCliente) {
    return (_db.select(_db.creditos)
          ..where((c) =>
              c.idCliente.equals(idCliente) &
              c.saldoActual.isBiggerThanValue(0))
          ..orderBy([(c) => OrderingTerm.asc(c.fecha)])) // Más antiguos primero
        .get();
  }

  // Obtener créditos activos de un cliente
  Future<List<Credito>> obtenerCreditosActivosCliente(int idCliente) {
    return (_db.select(_db.creditos)
          ..where((c) =>
              c.idCliente.equals(idCliente) &
              c.saldoActual.isBiggerThanValue(0))
          ..orderBy([(c) => OrderingTerm.desc(c.fecha)]))
        .get();
  }

  // Actualizar saldo del crédito
  Future<bool> actualizarSaldo(int idCredito, double nuevoSaldo) async {
    final credito = await obtenerPorId(idCredito);
    if (credito != null) {
      return _db.update(_db.creditos).replace(
            credito.copyWith(saldoActual: nuevoSaldo),
          );
    }
    return false;
  }

  // Obtener total de deuda de un cliente
  Future<double> obtenerTotalDeudaCliente(int idCliente) async {
    final creditos = await obtenerCreditosActivosCliente(idCliente);
    return creditos.fold<double>(0.0, (sum, credito) => sum + credito.saldoActual);
  }

  // Obtener total de deudas activas
  Future<double> obtenerTotalDeudasActivas() async {
    final query = _db.selectOnly(_db.creditos)
      ..addColumns([_db.creditos.saldoActual.sum()])
      ..where(_db.creditos.saldoActual.isBiggerThanValue(0));

    final result = await query.getSingle();
    return result.read(_db.creditos.saldoActual.sum()) ?? 0.0;
  }

  // Verificar si un crédito está saldado
  Future<bool> estaSaldado(int idCredito) async {
    final credito = await obtenerPorId(idCredito);
    if (credito == null) return false;
    return credito.saldoActual <= 0;
  }

  // Obtener cantidad de créditos activos
  Future<int> obtenerCantidadCreditosActivos() async {
    final creditos = await (_db.select(_db.creditos)
          ..where((c) => c.saldoActual.isBiggerThanValue(0)))
        .get();
    return creditos.length;
  }
}
