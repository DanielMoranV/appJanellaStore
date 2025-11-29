import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/productos_repository.dart';
import 'package:janella_store/data/seeders/database_seeder.dart';

/// Script para ejecutar el seeder de la base de datos
/// Uso: dart run lib/scripts/run_seeder.dart
void main() async {
  print('═══════════════════════════════════════════════════════════');
  print('   SEEDER DE BASE DE DATOS - JANELLA STORE');
  print('═══════════════════════════════════════════════════════════\n');

  // Inicializar base de datos
  final db = AppDatabase();

  // Inicializar repositorios
  final productosRepo = ProductosRepository(db);

  // Crear seeder
  final seeder = DatabaseSeeder(db: db, productosRepo: productosRepo);

  try {
    // Ejecutar seeder
    await seeder.seed();

    print('\n═══════════════════════════════════════════════════════════');
    print('   ✅ BASE DE DATOS POBLADA EXITOSAMENTE');
    print('═══════════════════════════════════════════════════════════');
    print('\n📊 Resumen:');
    print('   • 60 productos de ropa creados');
    print('   • Stock inicial: 0 unidades');
    print('   • Categorías: Polos, Camisas, Vestidos, Pantalones, Blusas');
    print('   • Tallas: S, M, L, XL (y 28-36 para pantalones)');
    print('\n💡 Próximos pasos:');
    print('   1. Ejecuta la app: flutter run');
    print('   2. Usa "Ajuste de Stock" para agregar inventario');
    print('   3. Registra ventas desde el POS');
    print('\n');
  } catch (e, stackTrace) {
    print('\n❌ ERROR al ejecutar seeder:');
    print('   $e');
    print('\nStack trace:');
    print(stackTrace);
  } finally {
    // Cerrar conexión a la base de datos
    await db.close();
  }
}
