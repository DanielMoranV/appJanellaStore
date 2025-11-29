import 'package:shared_preferences/shared_preferences.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/productos_repository.dart';
import 'package:janella_store/data/seeders/database_seeder.dart';

/// Servicio para ejecutar el seeder automáticamente en la primera instalación
class AutoSeederService {
  static const String _keySeederExecuted = 'seeder_executed';

  /// Verifica si el seeder ya fue ejecutado
  static Future<bool> isSeederExecuted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySeederExecuted) ?? false;
  }

  /// Marca el seeder como ejecutado
  static Future<void> markSeederAsExecuted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySeederExecuted, true);
  }

  /// Ejecuta el seeder si es la primera vez
  static Future<void> runSeederIfFirstTime({
    required AppDatabase db,
    required ProductosRepository productosRepo,
  }) async {
    final alreadyExecuted = await isSeederExecuted();
    
    if (!alreadyExecuted) {
      print('🌱 Primera instalación detectada. Ejecutando seeder...');
      
      try {
        final seeder = DatabaseSeeder(db: db, productosRepo: productosRepo);
        await seeder.seed();
        
        await markSeederAsExecuted();
        print('✅ Seeder ejecutado exitosamente. 60 productos creados.');
        print('🎉 ¡Bienvenido a Janella Store! Tu tienda está lista.');
      } catch (e) {
        print('❌ Error al ejecutar seeder: $e');
        // No marcamos como ejecutado para que se intente de nuevo
        rethrow; // Re-lanzar el error para que se maneje en el UI
      }
    } else {
      print('ℹ️ App iniciada. Seeder ya ejecutado previamente.');
    }
  }

  /// Resetea el flag del seeder (útil para testing)
  static Future<void> resetSeederFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySeederExecuted);
    print('🔄 Flag del seeder reseteado. Próxima ejecución mostrará seeder automático.');
  }

  /// Fuerza la ejecución del seeder sin verificar si ya fue ejecutado
  /// Útil para desarrollo y testing
  static Future<void> forceRunSeeder({
    required AppDatabase db,
    required ProductosRepository productosRepo,
  }) async {
    print('🔧 Forzando ejecución del seeder...');
    
    try {
      final seeder = DatabaseSeeder(db: db, productosRepo: productosRepo);
      await seeder.seed();
      
      await markSeederAsExecuted();
      print('✅ Seeder forzado ejecutado exitosamente.');
    } catch (e) {
      print('❌ Error al forzar seeder: $e');
      rethrow;
    }
  }
}
