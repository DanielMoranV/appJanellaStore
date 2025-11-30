import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/services/backup_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Base de Datos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Exportar Copia de Seguridad'),
            subtitle: const Text('Guarda una copia de todos tus datos'),
            onTap: () async {
              final backupService = BackupService();
              await backupService.exportDatabase(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Restaurar Copia de Seguridad'),
            subtitle: const Text('Recupera tus datos desde un archivo'),
            trailing: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            onTap: () async {
              final backupService = BackupService();
              final db = ref.read(databaseProvider);
              await backupService.importDatabase(context, db);
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Nota: Al restaurar una copia de seguridad, se reemplazarán todos los datos actuales. Asegúrate de exportar una copia antes si tienes dudas.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
