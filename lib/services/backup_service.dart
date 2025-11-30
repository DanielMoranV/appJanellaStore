import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:janella_store/data/database/database.dart';

class BackupService {
  static const String _dbName = 'janella_store_db.sqlite';

  /// Exporta la base de datos actual a un archivo
  Future<void> exportDatabase(BuildContext context) async {
    try {
      // 1. Obtener la ruta de la base de datos actual
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbFolder.path, _dbName);
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        throw Exception('No se encontró la base de datos en $dbPath');
      }

      // 2. Crear una copia temporal con un nombre descriptivo
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final backupFileName = 'janella_store_backup_$timestamp.sqlite';
      final backupPath = p.join(tempDir.path, backupFileName);
      
      await dbFile.copy(backupPath);

      // 3. Compartir el archivo
      final result = await Share.shareXFiles(
        [XFile(backupPath)],
        text: 'Copia de seguridad de Janella Store - $timestamp',
      );

      if (result.status == ShareResultStatus.success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copia de seguridad exportada exitosamente')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e'), backgroundColor: Colors.red),
        );
      }
      rethrow;
    }
  }

  /// Importa una base de datos desde un archivo seleccionado
  Future<bool> importDatabase(BuildContext context, AppDatabase currentDb) async {
    try {
      // 1. Seleccionar archivo
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Seleccionar archivo de respaldo',
        type: FileType.any, // Android a veces no reconoce extensiones custom
      );

      if (result == null || result.files.single.path == null) {
        return false; // Cancelado por el usuario
      }

      final selectedPath = result.files.single.path!;
      final selectedFile = File(selectedPath);

      // Validación básica
      if (!selectedPath.endsWith('.sqlite') && !selectedPath.endsWith('.db')) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El archivo seleccionado no parece ser una base de datos válida (.sqlite)'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return false;
      }

      // 2. Confirmación del usuario
      if (!context.mounted) return false;
      
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ Restaurar Base de Datos'),
          content: const Text(
            'Esta acción REEMPLAZARÁ todos los datos actuales con los del archivo seleccionado.\n\n'
            '¿Estás seguro de que deseas continuar? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Restaurar'),
            ),
          ],
        ),
      );

      if (confirm != true) return false;

      // 3. Cerrar conexión actual (Idealmente)
      await currentDb.close();

      // 4. Reemplazar archivo de base de datos
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbFolder.path, _dbName);
      final dbFile = File(dbPath);

      // Backup de seguridad antes de reemplazar (por si falla la copia)
      if (await dbFile.exists()) {
        final tempDir = await getTemporaryDirectory();
        await dbFile.copy(p.join(tempDir.path, 'pre_restore_backup.sqlite'));
      }

      await selectedFile.copy(dbPath);

      // 5. Notificar éxito y reiniciar (o pedir reinicio)
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Restauración Completada'),
            content: const Text(
              'La base de datos ha sido restaurada exitosamente.\n\n'
              'Es necesario reiniciar la aplicación para aplicar los cambios.',
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  // En Flutter no hay una forma nativa limpia de reiniciar la app completa
                  // Lo mejor es salir o navegar al inicio forzando recarga
                  // Aquí simplemente cerramos el diálogo y dejamos que el usuario reinicie o navegamos a home
                  Navigator.pop(context);
                  // Opcional: SystemNavigator.pop(); para cerrar la app
                },
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      }
      
      return true;

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al importar: $e'), backgroundColor: Colors.red),
        );
      }
      rethrow;
    }
  }
}
