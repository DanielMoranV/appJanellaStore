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

  String _calcularAntiguedad(DateTime fecha) {
    final dias = DateTime.now().difference(fecha).inDays;
    if (dias == 0) return 'Hoy';
    if (dias == 1) return 'Hace 1 dia';
    if (dias < 30) return 'Hace $dias dias';
    if (dias < 60) return 'Hace 1 mes';
    final meses = (dias / 30).floor();
    return 'Hace $meses meses';
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
                    return 'Ingrese un monto valido';
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

  /// Calcula el saldo corrido para cada abono.
  /// Los abonos vienen ordenados desc (más reciente primero).
  /// El saldo corrido se calcula desde el montoTotal restando abonos en orden cronológico.
  List<double> _calcularSaldosCorridos(double montoTotal, List<Abono> abonosDesc) {
    // Invertir para procesar en orden cronológico (más antiguo primero)
    final abonosAsc = abonosDesc.reversed.toList();
    final saldos = <double>[];
    double saldo = montoTotal;
    for (final abono in abonosAsc) {
      saldo -= abono.montoAbono;
      saldos.add(saldo);
    }
    // Invertir de vuelta para que coincida con el orden desc original
    return saldos.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final creditosRepo = ref.read(creditosRepositoryProvider);
    final abonosRepo = ref.read(abonosRepositoryProvider);
    final clientesRepo = ref.read(clientesRepositoryProvider);
    final db = ref.read(databaseProvider);
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Credito'),
      ),
      body: FutureBuilder(
        key: ValueKey(_refreshKey),
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
            return const Center(child: Text('Credito no encontrado'));
          }

          final porcentajePagado = credito.montoTotal > 0
              ? ((credito.montoTotal - credito.saldoActual) / credito.montoTotal) * 100
              : 0.0;

          // Calcular saldos corridos
          final saldosCorridos = _calcularSaldosCorridos(credito.montoTotal, abonos);

          return FutureBuilder(
            future: Future.wait([
              clientesRepo.obtenerPorId(credito.idCliente),
              db.getDetallesVenta(credito.idVenta),
            ]),
            builder: (context, AsyncSnapshot<List<dynamic>> extraSnapshot) {
              final cliente = extraSnapshot.data?[0] as Cliente?;
              final detallesVenta = extraSnapshot.data?[1] as List<DetalleVentaConProducto>? ?? [];

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header con nombre del cliente
                  if (cliente != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.orange.shade100,
                            child: Text(
                              cliente.nombre[0].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cliente.nombre,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Venta #${credito.idVenta}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Tarjeta resumen del credito
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        // Fecha de venta y antiguedad
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.white70, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(credito.fecha),
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.white70, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  _calcularAntiguedad(credito.fecha),
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Productos de la venta
                  if (detallesVenta.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Productos de la Venta',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: detallesVenta.map((detalle) {
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.inventory_2, size: 20),
                            title: Text(
                              detalle.producto.nombre,
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              '${detalle.detalle.cantidad} x ${currencyFormat.format(detalle.detalle.precioUnitario)}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            trailing: Text(
                              currencyFormat.format(detalle.detalle.subtotal),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  // Historial de abonos
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Historial de Abonos',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${abonos.length} abonos',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (abonos.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No hay abonos registrados')),
                      ),
                    )
                  else
                    ...List.generate(abonos.length, (index) {
                      final abono = abonos[index];
                      final saldoDespues = saldosCorridos[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.attach_money, color: Colors.white),
                          ),
                          title: Text(
                            currencyFormat.format(abono.montoAbono),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('dd/MM/yyyy HH:mm').format(abono.fecha)),
                              const SizedBox(height: 2),
                              Text(
                                'Saldo: ${currencyFormat.format(saldoDespues)}',
                                style: TextStyle(
                                  color: saldoDespues <= 0 ? Colors.green : Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Eliminar Abono'),
                                  content: const Text(
                                      '¿Esta seguro de eliminar este abono? El saldo del credito sera restaurado.'),
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
                    }),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<Credito?>(
        key: ValueKey('fab_$_refreshKey'),
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
