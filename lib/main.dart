import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/router.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/services/auto_seeder_service.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isSeederRunning = false;
  bool _seederCompleted = false;

  @override
  void initState() {
    super.initState();
    // Ejecutar seeder automáticamente en la primera instalación
    _runAutoSeeder();
  }

  Future<void> _runAutoSeeder() async {
    try {
      // Verificar si ya fue ejecutado antes de mostrar loading
      final alreadyExecuted = await AutoSeederService.isSeederExecuted();
      
      if (!alreadyExecuted) {
        setState(() {
          _isSeederRunning = true;
        });
      }
      
      // Esperar un frame para que los providers estén listos
      await Future.delayed(const Duration(milliseconds: 100));
      
      final db = ref.read(databaseProvider);
      final productosRepo = ref.read(productosRepositoryProvider);
      
      await AutoSeederService.runSeederIfFirstTime(
        db: db,
        productosRepo: productosRepo,
      );

      if (!alreadyExecuted) {
        setState(() {
          _isSeederRunning = false;
          _seederCompleted = true;
        });
        
        // Pequeña pausa para mostrar el mensaje de éxito
        await Future.delayed(const Duration(milliseconds: 800));
        
        setState(() {
          _seederCompleted = false;
        });
      }
    } catch (e) {
      // Si hay error, ocultar loading y continuar sin seeder
      setState(() {
        _isSeederRunning = false;
        _seederCompleted = false;
      });
      
      // Log del error
      print('Error en seeder automático: $e');
      // La app continuará funcionando normalmente sin los datos iniciales
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si el seeder está ejecutándose, mostrar pantalla de carga
    if (_isSeederRunning) {
      return MaterialApp(
        title: 'Janella Store',
        debugShowCheckedModeBanner: false,
        home: _SeederLoadingScreen(),
      );
    }

    // Si el seeder se completó, mostrar mensaje de éxito brevemente
    if (_seederCompleted) {
      return MaterialApp(
        title: 'Janella Store',
        debugShowCheckedModeBanner: false,
        home: _SeederSuccessScreen(),
      );
    }

    // App normal
    return MaterialApp.router(
      title: 'Janella Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
      ),
      routerConfig: router,
    );
  }
}

// Pantalla de carga durante el seeder
class _SeederLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.store,
                    size: 64,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Janella Store',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Configurando tu tienda...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Creando productos de ejemplo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de éxito después del seeder
class _SeederSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Listo!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tienda configurada exitosamente',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '60 productos creados',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
