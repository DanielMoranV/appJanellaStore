import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:janella_store/constants/app_constants.dart';
import 'package:janella_store/data/repositories/abonos_repository.dart';
import 'package:go_router/go_router.dart';

class ClienteCreditosScreen extends ConsumerStatefulWidget {
  final int idCliente;

  const ClienteCreditosScreen({super.key, required this.idCliente});

  @override
  ConsumerState<ClienteCreditosScreen> createState() => _ClienteCreditosScreenState();
}

class _ClienteCreditosScreenState extends ConsumerState<ClienteCreditosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                'El abono se distribuira automaticamente a las ventas mas antiguas primero (FIFO).',
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
                    return 'Ingrese un monto valido';
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
    final abonosRepo = ref.read(abonosRepositoryProvider);
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creditos del Cliente'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            tooltip: 'Estado de Cuenta',
            onPressed: () => context.push('/clientes/${widget.idCliente}/estado-cuenta'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'Saldados'),
          ],
        ),
      ),
      body: FutureBuilder(
        future: Future.wait([
          clientesRepo.obtenerPorId(widget.idCliente),
          creditosRepo.obtenerCreditosActivosCliente(widget.idCliente),
          creditosRepo.obtenerCreditosSaldadosCliente(widget.idCliente),
          creditosRepo.obtenerTodosCreditosCliente(widget.idCliente),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al cargar datos'));
          }

          final cliente = snapshot.data![0] as Cliente?;
          final creditosPendientes = snapshot.data![1] as List<Credito>;
          final creditosSaldados = snapshot.data![2] as List<Credito>;
          final todosCreditos = snapshot.data![3] as List<Credito>;

          if (cliente == null) {
            return const Center(child: Text('Cliente no encontrado'));
          }

          // Estadisticas
          final totalOtorgado = todosCreditos.fold<double>(0.0, (sum, c) => sum + c.montoTotal);
          final saldoPendiente = creditosPendientes.fold<double>(0.0, (sum, c) => sum + c.saldoActual);
          final totalPagado = totalOtorgado - saldoPendiente;

          return Column(
            children: [
              // Tarjeta resumen del cliente
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Text(
                        cliente.nombre[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cliente.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Estadisticas en fila
                    Row(
                      children: [
                        Expanded(
                          child: _StatItem(
                            label: 'Otorgado',
                            value: currencyFormat.format(totalOtorgado),
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            label: 'Pagado',
                            value: currencyFormat.format(totalPagado),
                          ),
                        ),
                        Expanded(
                          child: _StatItem(
                            label: 'Pendiente',
                            value: currencyFormat.format(saldoPendiente),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tabs content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab Pendientes
                    _CreditosList(
                      creditos: creditosPendientes,
                      abonosRepo: abonosRepo,
                      currencyFormat: currencyFormat,
                      emptyMessage: 'No hay creditos pendientes',
                      emptyIcon: Icons.check_circle_outline,
                      isPendiente: true,
                    ),
                    // Tab Saldados
                    _CreditosList(
                      creditos: creditosSaldados,
                      abonosRepo: abonosRepo,
                      currencyFormat: currencyFormat,
                      emptyMessage: 'No hay creditos saldados',
                      emptyIcon: Icons.history,
                      isPendiente: false,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FutureBuilder(
        future: Future.wait([
          creditosRepo.obtenerCreditosActivosCliente(widget.idCliente),
          clientesRepo.obtenerPorId(widget.idCliente),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          final creditos = snapshot.data![0] as List<Credito>;
          final cliente = snapshot.data![1] as Cliente?;
          if (creditos.isEmpty || cliente == null) return const SizedBox.shrink();

          final deudaTotal = creditos.fold<double>(0.0, (sum, c) => sum + c.saldoActual);
          return FloatingActionButton.extended(
            onPressed: () => _registrarAbono(context, cliente, deudaTotal),
            icon: const Icon(Icons.add),
            label: const Text('Registrar Abono'),
            backgroundColor: Colors.green,
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _CreditosList extends StatelessWidget {
  final List<Credito> creditos;
  final AbonosRepository abonosRepo;
  final NumberFormat currencyFormat;
  final String emptyMessage;
  final IconData emptyIcon;
  final bool isPendiente;

  const _CreditosList({
    required this.creditos,
    required this.abonosRepo,
    required this.currencyFormat,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.isPendiente,
  });

  @override
  Widget build(BuildContext context) {
    if (creditos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: creditos.length,
      itemBuilder: (context, index) {
        final credito = creditos[index];
        final porcentajePagado = credito.montoTotal > 0
            ? ((credito.montoTotal - credito.saldoActual) / credito.montoTotal) * 100
            : 0.0;

        return FutureBuilder<Abono?>(
          future: abonosRepo.obtenerUltimoAbonoCredito(credito.idCredito),
          builder: (context, abonoSnapshot) {
            final ultimoAbono = abonoSnapshot.data;

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
                                isPendiente ? Icons.receipt_long : Icons.check_circle,
                                color: isPendiente ? Colors.orange.shade600 : Colors.green,
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
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isPendiente
                                    ? currencyFormat.format(credito.saldoActual)
                                    : currencyFormat.format(credito.montoTotal),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isPendiente ? Colors.orange : Colors.green,
                                ),
                              ),
                              if (isPendiente)
                                Text(
                                  'de ${currencyFormat.format(credito.montoTotal)}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                          porcentajePagado >= 100 ? Colors.green : (porcentajePagado > 50 ? Colors.green : Colors.orange),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${porcentajePagado.toStringAsFixed(1)}% pagado',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          if (ultimoAbono != null)
                            Text(
                              'Ultimo abono: ${DateFormat('dd/MM').format(ultimoAbono.fecha)}',
                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
