import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/clientes_repository.dart';
import 'package:janella_store/data/repositories/productos_repository.dart';
import 'package:janella_store/data/repositories/proveedores_repository.dart';
import 'package:janella_store/data/repositories/ingresos_repository.dart';
import 'package:janella_store/data/repositories/ventas_repository.dart';
import 'package:janella_store/data/repositories/creditos_repository.dart';
import 'package:janella_store/data/repositories/abonos_repository.dart';

// Provider de la base de datos
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Providers de repositorios
final clientesRepositoryProvider = Provider<ClientesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ClientesRepository(db);
});

final productosRepositoryProvider = Provider<ProductosRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProductosRepository(db);
});

final proveedoresRepositoryProvider = Provider<ProveedoresRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProveedoresRepository(db);
});

final creditosRepositoryProvider = Provider<CreditosRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CreditosRepository(db);
});

final abonosRepositoryProvider = Provider<AbonosRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final creditosRepo = ref.watch(creditosRepositoryProvider);
  return AbonosRepository(db, creditosRepo);
});

final ingresosRepositoryProvider = Provider<IngresosRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final productosRepo = ref.watch(productosRepositoryProvider);
  return IngresosRepository(db, productosRepo);
});

final ventasRepositoryProvider = Provider<VentasRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final productosRepo = ref.watch(productosRepositoryProvider);
  final creditosRepo = ref.watch(creditosRepositoryProvider);
  return VentasRepository(db, productosRepo, creditosRepo);
});

// Stream providers para datos en tiempo real
final clientesStreamProvider = StreamProvider<List<Cliente>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.clientes).watch();
});

final productosStreamProvider = StreamProvider<List<Producto>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.productos).watch();
});

final proveedoresStreamProvider = StreamProvider<List<Proveedore>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.proveedores).watch();
});

final creditosActivosStreamProvider = StreamProvider<List<CreditoConCliente>>((ref) async* {
  final db = ref.watch(databaseProvider);
  yield* Stream.periodic(const Duration(seconds: 1), (_) async {
    return await db.getCreditosActivos();
  }).asyncMap((event) => event);
});
