import 'package:drift/drift.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/creditos_repository.dart';

class AbonosRepository {
  final AppDatabase _db;
  final CreditosRepository _creditosRepo;

  AbonosRepository(this._db, this._creditosRepo);

  // Registrar abono
  Future<int> registrarAbono({
    required int idCredito,
    required DateTime fecha,
    required double montoAbono,
  }) async {
    // Obtener el crédito
    final credito = await _creditosRepo.obtenerPorId(idCredito);
    if (credito == null) {
      throw Exception('Crédito no encontrado');
    }

    // Validar que el abono no sea mayor al saldo actual
    if (montoAbono > credito.saldoActual) {
      throw Exception('El abono no puede ser mayor al saldo actual');
    }

    // Insertar el abono
    final idAbono = await _db.into(_db.abonos).insert(
          AbonosCompanion.insert(
            idCredito: idCredito,
            fecha: fecha,
            montoAbono: montoAbono,
          ),
        );

    // Actualizar el saldo del crédito
    final nuevoSaldo = credito.saldoActual - montoAbono;
    await _creditosRepo.actualizarSaldo(idCredito, nuevoSaldo);

    return idAbono;
  }

  /// Registra un abono y lo distribuye automáticamente entre los créditos
  /// activos del cliente en orden FIFO (más antiguos primero)
  /// 
  /// Ejemplo: Cliente debe S/ 80 (ventas: S/ 50, S/ 20, S/ 10)
  /// Si abona S/ 75:
  /// - Venta 1: SALDADA (S/ 50)
  /// - Venta 2: SALDADA (S/ 20)
  /// - Venta 3: Quedan S/ 5 de deuda
  Future<List<int>> registrarAbonoDistribuido({
    required int idCliente,
    required double montoAbono,
    required DateTime fecha,
  }) async {
    // 1. Obtener créditos activos del cliente ordenados por fecha (FIFO)
    final creditos = await _creditosRepo.obtenerCreditosActivosClienteOrdenados(idCliente);
    
    if (creditos.isEmpty) {
      throw Exception('El cliente no tiene créditos activos');
    }
    
    // Validar que el abono no exceda la deuda total
    final deudaTotal = creditos.fold<double>(0.0, (sum, c) => sum + c.saldoActual);
    if (montoAbono > deudaTotal + 0.01) { // Tolerancia para decimales
      throw Exception('El abono (S/ ${montoAbono.toStringAsFixed(2)}) excede la deuda total (S/ ${deudaTotal.toStringAsFixed(2)})');
    }
    
    double montoRestante = montoAbono;
    final abonosCreados = <int>[];
    
    // 2. Distribuir el abono entre los créditos (FIFO)
    for (final credito in creditos) {
      if (montoRestante <= 0.01) break; // Tolerancia para decimales
      
      // Calcular cuánto se puede abonar a este crédito
      final montoAAbonar = montoRestante >= credito.saldoActual
          ? credito.saldoActual
          : montoRestante;
      
      // 3. Registrar el abono para este crédito específico
      final idAbono = await _db.into(_db.abonos).insert(
        AbonosCompanion.insert(
          idCredito: credito.idCredito,
          fecha: fecha,
          montoAbono: montoAAbonar,
        ),
      );
      
      abonosCreados.add(idAbono);
      
      // 4. Actualizar el saldo del crédito
      final nuevoSaldo = credito.saldoActual - montoAAbonar;
      await _creditosRepo.actualizarSaldo(credito.idCredito, nuevoSaldo);
      
      // 5. Reducir el monto restante
      montoRestante -= montoAAbonar;
    }
    
    return abonosCreados;
  }

  // Obtener todos los abonos
  Future<List<Abono>> obtenerTodos() {
    return (_db.select(_db.abonos)..orderBy([(a) => OrderingTerm.desc(a.fecha)])).get();
  }

  // Obtener abono por ID
  Future<Abono?> obtenerPorId(int id) {
    return (_db.select(_db.abonos)..where((a) => a.idAbono.equals(id))).getSingleOrNull();
  }

  // Obtener abonos de un crédito
  Future<List<Abono>> obtenerPorCredito(int idCredito) {
    return _db.getAbonosCredito(idCredito);
  }

  // Obtener total de abonos de un crédito
  Future<double> obtenerTotalAbonosCredito(int idCredito) async {
    final query = _db.selectOnly(_db.abonos)
      ..addColumns([_db.abonos.montoAbono.sum()])
      ..where(_db.abonos.idCredito.equals(idCredito));

    final result = await query.getSingle();
    return result.read(_db.abonos.montoAbono.sum()) ?? 0.0;
  }

  // Obtener abonos por rango de fechas
  Future<List<Abono>> obtenerPorRangoFechas(DateTime inicio, DateTime fin) {
    return (_db.select(_db.abonos)
          ..where((a) => a.fecha.isBetweenValues(inicio, fin))
          ..orderBy([(a) => OrderingTerm.desc(a.fecha)]))
        .get();
  }

  // Obtener total de abonos por rango de fechas
  Future<double> obtenerTotalPorRangoFechas(DateTime inicio, DateTime fin) async {
    final query = _db.selectOnly(_db.abonos)
      ..addColumns([_db.abonos.montoAbono.sum()])
      ..where(_db.abonos.fecha.isBetweenValues(inicio, fin));

    final result = await query.getSingle();
    return result.read(_db.abonos.montoAbono.sum()) ?? 0.0;
  }

  // Obtener todos los abonos de un cliente
  Future<List<AbonoConCredito>> obtenerPorCliente(int idCliente) {
    return _db.getAbonosCliente(idCliente);
  }

  // Obtener último abono de un crédito específico
  Future<Abono?> obtenerUltimoAbonoCredito(int idCredito) {
    return (_db.select(_db.abonos)
          ..where((a) => a.idCredito.equals(idCredito))
          ..orderBy([(a) => OrderingTerm.desc(a.fecha)])
          ..limit(1))
        .getSingleOrNull();
  }

  // Eliminar abono (en caso de error)
  Future<int> eliminar(int id) async {
    // Obtener el abono antes de eliminarlo
    final abono = await obtenerPorId(id);
    if (abono == null) {
      throw Exception('Abono no encontrado');
    }

    // Obtener el crédito y restaurar el saldo
    final credito = await _creditosRepo.obtenerPorId(abono.idCredito);
    if (credito != null) {
      final nuevoSaldo = credito.saldoActual + abono.montoAbono;
      await _creditosRepo.actualizarSaldo(abono.idCredito, nuevoSaldo);
    }

    // Eliminar el abono
    return (_db.delete(_db.abonos)..where((a) => a.idAbono.equals(id))).go();
  }
}
