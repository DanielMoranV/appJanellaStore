import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:intl/intl.dart';
import 'package:janella_store/constants/app_constants.dart';

class ClienteDetailScreen extends ConsumerWidget {
  final int idCliente;

  const ClienteDetailScreen({super.key, required this.idCliente});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientesRepo = ref.read(clientesRepositoryProvider);
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Cliente'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          clientesRepo.obtenerPorId(idCliente),
          clientesRepo.obtenerVentas(idCliente),
          clientesRepo.obtenerCreditos(idCliente),
          clientesRepo.obtenerTotalDeuda(idCliente),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al cargar datos'));
          }

          final cliente = snapshot.data![0] as Cliente?;
          final ventas = snapshot.data![1] as List<Venta>;
          final creditos = snapshot.data![2] as List<Credito>;
          final totalDeuda = snapshot.data![3] as double;

          if (cliente == null) {
            return const Center(child: Text('Cliente no encontrado'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Información del cliente
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              cliente.nombre[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cliente.nombre,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16),
                                    const SizedBox(width: 4),
                                    Text(cliente.telefono),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 16),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(cliente.direccion)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Resumen de deuda
              if (totalDeuda > 0)
                Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Deuda Total',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                currencyFormat.format(totalDeuda),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Historial de ventas
              const Text(
                'Historial de Ventas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (ventas.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('No hay ventas registradas')),
                  ),
                )
              else
                ...ventas.take(5).map((venta) {
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        venta.esCredito ? Icons.credit_card : Icons.attach_money,
                        color: venta.esCredito ? Colors.orange : Colors.green,
                      ),
                      title: Text(currencyFormat.format(venta.total)),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(venta.fecha),
                      ),
                      trailing: Chip(
                        label: Text(
                          venta.esCredito ? 'Crédito' : 'Efectivo',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: venta.esCredito
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
