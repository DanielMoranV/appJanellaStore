import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/constants/app_constants.dart';
import 'package:janella_store/data/database/database.dart';

/// Modelo para agrupar créditos por cliente
class ClienteConDeuda {
  final Cliente cliente;
  final double deudaTotal;
  final int cantidadCreditos;

  ClienteConDeuda({
    required this.cliente,
    required this.deudaTotal,
    required this.cantidadCreditos,
  });
}

class CreditosScreen extends ConsumerStatefulWidget {
  const CreditosScreen({super.key});

  @override
  ConsumerState<CreditosScreen> createState() => _CreditosScreenState();
}

class _CreditosScreenState extends ConsumerState<CreditosScreen> {
  // Key para forzar rebuild del FutureBuilder
  int _refreshKey = 0;

  void _refresh() {
    setState(() {
      _refreshKey++;
    });
  }

  Future<List<ClienteConDeuda>> _obtenerClientesConDeuda() async {
    final creditosRepo = ref.read(creditosRepositoryProvider);

    // Obtener todos los créditos activos con clientes
    final creditosActivos = await creditosRepo.obtenerCreditosActivos();

    // Agrupar por cliente
    final Map<int, ClienteConDeuda> clientesMap = {};

    for (final item in creditosActivos) {
      final idCliente = item.cliente.idCliente;

      if (clientesMap.containsKey(idCliente)) {
        // Actualizar deuda y cantidad de créditos
        final actual = clientesMap[idCliente]!;
        clientesMap[idCliente] = ClienteConDeuda(
          cliente: actual.cliente,
          deudaTotal: actual.deudaTotal + item.credito.saldoActual,
          cantidadCreditos: actual.cantidadCreditos + 1,
        );
      } else {
        // Crear nueva entrada
        clientesMap[idCliente] = ClienteConDeuda(
          cliente: item.cliente,
          deudaTotal: item.credito.saldoActual,
          cantidadCreditos: 1,
        );
      }
    }

    // Convertir a lista y ordenar por deuda (mayor a menor)
    final clientes = clientesMap.values.toList();
    clientes.sort((a, b) => b.deudaTotal.compareTo(a.deudaTotal));

    return clientes;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créditos por Cliente'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ClienteConDeuda>>(
        key: ValueKey(_refreshKey), // Forzar rebuild cuando cambia la key
        future: _obtenerClientesConDeuda(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final clientesConDeuda = snapshot.data ?? [];
          final totalDeudas = clientesConDeuda.fold<double>(
            0.0,
            (sum, c) => sum + c.deudaTotal,
          );

          return Column(
            children: [
              // Resumen total
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Deudas Activas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(totalDeudas),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${clientesConDeuda.length} ${clientesConDeuda.length == 1 ? 'cliente' : 'clientes'} con deuda',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de clientes
              Expanded(
                child: clientesConDeuda.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay créditos activos',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '¡Todas las deudas están saldadas!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: clientesConDeuda.length,
                        itemBuilder: (context, index) {
                          final item = clientesConDeuda[index];
                          final cliente = item.cliente;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            child: InkWell(
                              onTap: () async {
                                await context.push('/clientes/${cliente.idCliente}/creditos');
                                // Refrescar al volver de la pantalla de detalle
                                _refresh();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.orange.shade100,
                                      child: Text(
                                        cliente.nombre[0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.receipt_long,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${item.cantidadCreditos} ${item.cantidadCreditos == 1 ? 'venta' : 'ventas'} pendiente${item.cantidadCreditos == 1 ? '' : 's'}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          currencyFormat.format(item.deudaTotal),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade50,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Ver detalle',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.orange.shade700,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 10,
                                                color: Colors.orange.shade700,
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
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
