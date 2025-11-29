import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:janella_store/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

/// Pantalla que muestra todos los créditos (ventas a crédito) de un cliente específico
class ClienteCreditosScreen extends ConsumerStatefulWidget {
  final int idCliente;

  const ClienteCreditosScreen({super.key, required this.idCliente});

  @override
  ConsumerState<ClienteCreditosScreen> createState() => _ClienteCreditosScreenState();
}

class _ClienteCreditosScreenState extends ConsumerState<ClienteCreditosScreen> {
  Future<void> _registrarAbono(BuildContext context, Cliente cliente, double deudaTotal) async {
    final montoController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Abono'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cliente: ${cliente.nombre}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Deuda total: ${AppConstants.currencyFormat.format(deudaTotal)}',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'El abono se distribuirá automáticamente a las ventas más antiguas primero (FIFO).',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: montoController,
                decoration: const InputDecoration(
                  labelText: 'Monto del Abono',
                  prefixText: 'S/ ',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un monto';
                  }
                  final monto = double.tryParse(value);
                  if (monto == null || monto <= 0) {
                    return 'Ingrese un monto válido';
                  }
                  if (monto > deudaTotal) {
                    return 'El monto no puede ser mayor a la deuda total';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Registrar Abono'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final abonosRepo = ref.read(abonosRepositoryProvider);
      final monto = double.parse(montoController.text);

      // Usar el método de abono distribuido
      await abonosRepo.registrarAbonoDistribuido(
        idCliente: widget.idCliente,
        montoAbono: monto,
        fecha: DateTime.now(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Abono de ${AppConstants.currencyFormat.format(monto)} registrado y distribuido exitosamente',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        // Recargar la pantalla
        setState(() {});
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final creditosRepo = ref.read(creditosRepositoryProvider);
    final clientesRepo = ref.read(clientesRepositoryProvider);
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créditos del Cliente'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Future.wait([
          clientesRepo.obtenerPorId(widget.idCliente),
          creditosRepo.obtenerCreditosActivosCliente(widget.idCliente),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al cargar datos'));
          }

          final cliente = snapshot.data![0] as Cliente?;
          final creditos = snapshot.data![1] as List<Credito>;

          if (cliente == null) {
            return const Center(child: Text('Cliente no encontrado'));
          }

          final deudaTotal = creditos.fold<double>(0.0, (sum, c) => sum + c.saldoActual);

          return Column(
            children: [
              // Información del cliente y deuda total
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
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        cliente.nombre[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cliente.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cliente.telefono,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Deuda Total',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat.format(deudaTotal),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${creditos.length} ${creditos.length == 1 ? 'venta' : 'ventas'} pendiente${creditos.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de ventas a crédito
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ventas a Crédito',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ordenadas por fecha',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: creditos.isEmpty
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
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: creditos.length,
                        itemBuilder: (context, index) {
                          final credito = creditos[index];
                          final porcentajePagado = credito.montoTotal > 0
                              ? ((credito.montoTotal - credito.saldoActual) /
                                      credito.montoTotal) *
                                  100
                              : 0.0;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () => context.push('/creditos/${credito.idCredito}'),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.receipt_long,
                                              color: Colors.orange.shade600,
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Venta #${credito.idVenta}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('dd/MM/yyyy').format(credito.fecha),
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              currencyFormat.format(credito.saldoActual),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            Text(
                                              'de ${currencyFormat.format(credito.montoTotal)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    LinearProgressIndicator(
                                      value: porcentajePagado / 100,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        porcentajePagado > 50 ? Colors.green : Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${porcentajePagado.toStringAsFixed(1)}% pagado',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
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
      floatingActionButton: FutureBuilder(
        future: creditosRepo.obtenerCreditosActivosCliente(widget.idCliente),
        builder: (context, AsyncSnapshot<List<Credito>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          final creditos = snapshot.data!;
          final deudaTotal = creditos.fold<double>(0.0, (sum, c) => sum + c.saldoActual);

          return FutureBuilder<Cliente?>(
            future: clientesRepo.obtenerPorId(widget.idCliente),
            builder: (context, clienteSnapshot) {
              if (!clienteSnapshot.hasData) {
                return const SizedBox.shrink();
              }

              return FloatingActionButton.extended(
                onPressed: () => _registrarAbono(context, clienteSnapshot.data!, deudaTotal),
                icon: const Icon(Icons.add),
                label: const Text('Registrar Abono'),
                backgroundColor: Colors.green,
              );
            },
          );
        },
      ),
    );
  }
}
