import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:intl/intl.dart';
import 'package:janella_store/constants/app_constants.dart';

class CreditoDetailScreen extends ConsumerStatefulWidget {
  final int idCredito;

  const CreditoDetailScreen({super.key, required this.idCredito});

  @override
  ConsumerState<CreditoDetailScreen> createState() => _CreditoDetailScreenState();
}

class _CreditoDetailScreenState extends ConsumerState<CreditoDetailScreen> {
  int _refreshKey = 0;

  void _refresh() {
    setState(() {
      _refreshKey++;
    });
  }

  Future<void> _registrarAbono(BuildContext context, WidgetRef ref, Credito credito) async {
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
            children: [
              Text(
                'Saldo actual: ${AppConstants.currencyFormat.format(credito.saldoActual)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: montoController,
                decoration: const InputDecoration(
                  labelText: 'Monto del Abono',
                  prefixIcon: Icon(Icons.attach_money),
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
                  if (monto > credito.saldoActual) {
                    return 'El monto no puede ser mayor al saldo';
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
            child: const Text('Registrar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      final abonosRepo = ref.read(abonosRepositoryProvider);
      final monto = double.parse(montoController.text);

      await abonosRepo.registrarAbono(
        idCredito: widget.idCredito,
        fecha: DateTime.now(),
        montoAbono: monto,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Abono registrado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _refresh(); // Refrescar la pantalla automáticamente
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final creditosRepo = ref.read(creditosRepositoryProvider);
    final abonosRepo = ref.read(abonosRepositoryProvider);
    final clientesRepo = ref.read(clientesRepositoryProvider);
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Crédito'),
      ),
      body: FutureBuilder(
        key: ValueKey(_refreshKey), // Forzar rebuild cuando cambia la key
        future: Future.wait([
          creditosRepo.obtenerPorId(widget.idCredito),
          abonosRepo.obtenerPorCredito(widget.idCredito),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al cargar datos'));
          }

          final credito = snapshot.data![0] as Credito?;
          final abonos = snapshot.data![1] as List<Abono>;

          if (credito == null) {
            return const Center(child: Text('Crédito no encontrado'));
          }

          // Calcular el porcentaje pagado usando el montoTotal de la estructura
          final porcentajePagado = credito.montoTotal > 0 
              ? ((credito.montoTotal - credito.saldoActual) / credito.montoTotal) * 100
              : 0.0;

          return Column(
            children: [
              // Resumen del crédito
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: credito.saldoActual > 0
                        ? [Colors.orange.shade400, Colors.orange.shade600]
                        : [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Saldo Actual',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(credito.saldoActual),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'de ${currencyFormat.format(credito.montoTotal)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: porcentajePagado / 100,
                      backgroundColor: Colors.white30,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${porcentajePagado.toStringAsFixed(1)}% pagado',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Historial de abonos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Historial de Abonos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${abonos.length} abonos',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: abonos.isEmpty
                    ? const Center(child: Text('No hay abonos registrados'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: abonos.length,
                        itemBuilder: (context, index) {
                          final abono = abonos[index];
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                currencyFormat.format(abono.montoAbono),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(abono.fecha),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Eliminar Abono'),
                                      content: const Text(
                                          '¿Está seguro de eliminar este abono? El saldo del crédito será restaurado.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    try {
                                      await abonosRepo.eliminar(abono.idAbono);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Abono eliminado'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        _refresh();
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
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
      floatingActionButton: FutureBuilder<Credito?>(
        future: creditosRepo.obtenerPorId(widget.idCredito),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.saldoActual <= 0) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton.extended(
            onPressed: () => _registrarAbono(context, ref, snapshot.data!),
            icon: const Icon(Icons.add),
            label: const Text('Registrar Abono'),
            backgroundColor: Colors.green,
          );
        },
      ),
    );
  }
}
