import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/data/seeders/database_seeder.dart';
import 'package:janella_store/providers/providers.dart';

/// Pantalla para ejecutar el seeder desde la app
class SeederScreen extends ConsumerStatefulWidget {
  const SeederScreen({super.key});

  @override
  ConsumerState<SeederScreen> createState() => _SeederScreenState();
}

class _SeederScreenState extends ConsumerState<SeederScreen> {
  bool _isRunning = false;
  bool _isCompleted = false;
  String _message = '';

  Future<void> _runSeeder() async {
    setState(() {
      _isRunning = true;
      _message = 'Ejecutando seeder...';
    });

    try {
      final db = ref.read(databaseProvider);
      final productosRepo = ref.read(productosRepositoryProvider);

      final seeder = DatabaseSeeder(db: db, productosRepo: productosRepo);

      await seeder.seed();

      setState(() {
        _isRunning = false;
        _isCompleted = true;
        _message =
            '¡Seeder completado exitosamente!\n\n'
            '✓ 60 productos de ropa creados\n'
            '✓ Stock inicial: 0 unidades\n'
            '✓ Categorías: Polos, Camisas, Vestidos, Pantalones, Blusas';
      });
    } catch (e) {
      setState(() {
        _isRunning = false;
        _message = 'Error al ejecutar seeder:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seeder de Base de Datos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isCompleted ? Icons.check_circle : Icons.storage,
                size: 80,
                color: _isCompleted ? Colors.green : Colors.deepPurple,
              ),
              const SizedBox(height: 24),
              Text(
                _isCompleted ? 'Base de Datos Poblada' : 'Poblar Base de Datos',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_message.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isCompleted
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: _isCompleted
                          ? Colors.green.shade900
                          : Colors.black87,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              if (!_isCompleted && !_isRunning)
                ElevatedButton.icon(
                  onPressed: _runSeeder,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Ejecutar Seeder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              if (_isRunning)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Creando productos...'),
                  ],
                ),
              if (_isCompleted)
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Continuar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
