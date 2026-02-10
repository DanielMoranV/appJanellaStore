import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:janella_store/constants/app_constants.dart';

/// Entrada unificada del timeline: puede ser un cargo (venta a credito) o un abono (pago).
class _TimelineEntry {
  final DateTime fecha;
  final bool esCargo; // true = venta a credito, false = abono
  final double monto;
  final double saldoDespues;
  final int? idVenta;
  final int? idCredito;

  _TimelineEntry({
    required this.fecha,
    required this.esCargo,
    required this.monto,
    required this.saldoDespues,
    this.idVenta,
    this.idCredito,
  });
}

class EstadoCuentaScreen extends ConsumerStatefulWidget {
  final int idCliente;

  const EstadoCuentaScreen({super.key, required this.idCliente});

  @override
  ConsumerState<EstadoCuentaScreen> createState() => _EstadoCuentaScreenState();
}

class _EstadoCuentaScreenState extends ConsumerState<EstadoCuentaScreen> {
  DateTimeRange? _rangoFechas;

  Future<void> _seleccionarRango(BuildContext context) async {
    final ahora = DateTime.now();
    final rango = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: ahora,
      initialDateRange: _rangoFechas ??
          DateTimeRange(
            start: ahora.subtract(const Duration(days: 90)),
            end: ahora,
          ),
    );
    if (rango != null) {
      setState(() {
        _rangoFechas = rango;
      });
    }
  }

  void _limpiarFiltro() {
    setState(() {
      _rangoFechas = null;
    });
  }

  /// Construye el timeline combinando creditos y abonos en orden cronologico,
  /// calculando el saldo corrido.
  List<_TimelineEntry> _buildTimeline(List<Credito> creditos, List<AbonoConCredito> abonos) {
    // Crear lista de eventos
    final eventos = <_TimelineEntry>[];

    for (final credito in creditos) {
      eventos.add(_TimelineEntry(
        fecha: credito.fecha,
        esCargo: true,
        monto: credito.montoTotal,
        saldoDespues: 0, // Se calcula despues
        idVenta: credito.idVenta,
        idCredito: credito.idCredito,
      ));
    }

    // Agrupar abonos por fecha/hora exacta (los abonos distribuidos comparten timestamp)
    final abonosAgrupados = <DateTime, double>{};
    for (final ac in abonos) {
      abonosAgrupados.update(
        ac.abono.fecha,
        (total) => total + ac.abono.montoAbono,
        ifAbsent: () => ac.abono.montoAbono,
      );
    }

    for (final entry in abonosAgrupados.entries) {
      eventos.add(_TimelineEntry(
        fecha: entry.key,
        esCargo: false,
        monto: entry.value,
        saldoDespues: 0,
      ));
    }

    // Ordenar cronologicamente (mas antiguo primero)
    eventos.sort((a, b) => a.fecha.compareTo(b.fecha));

    // Calcular saldo corrido
    double saldo = 0;
    final resultado = <_TimelineEntry>[];
    for (final evento in eventos) {
      if (evento.esCargo) {
        saldo += evento.monto;
      } else {
        saldo -= evento.monto;
      }
      resultado.add(_TimelineEntry(
        fecha: evento.fecha,
        esCargo: evento.esCargo,
        monto: evento.monto,
        saldoDespues: saldo,
        idVenta: evento.idVenta,
        idCredito: evento.idCredito,
      ));
    }

    // Aplicar filtro de fechas si existe
    if (_rangoFechas != null) {
      final inicio = _rangoFechas!.start;
      final fin = _rangoFechas!.end.add(const Duration(days: 1));
      return resultado
          .where((e) => e.fecha.isAfter(inicio.subtract(const Duration(seconds: 1))) && e.fecha.isBefore(fin))
          .toList();
    }

    // Invertir para mostrar mas reciente primero
    return resultado.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final clientesRepo = ref.read(clientesRepositoryProvider);
    final creditosRepo = ref.read(creditosRepositoryProvider);
    final abonosRepo = ref.read(abonosRepositoryProvider);
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Cuenta'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (_rangoFechas != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Limpiar filtro',
              onPressed: _limpiarFiltro,
            ),
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: 'Filtrar por fechas',
            onPressed: () => _seleccionarRango(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          clientesRepo.obtenerPorId(widget.idCliente),
          creditosRepo.obtenerTodosCreditosCliente(widget.idCliente),
          abonosRepo.obtenerPorCliente(widget.idCliente),
          creditosRepo.obtenerTotalDeudaCliente(widget.idCliente),
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
          final abonos = snapshot.data![2] as List<AbonoConCredito>;
          final saldoActual = snapshot.data![3] as double;

          if (cliente == null) {
            return const Center(child: Text('Cliente no encontrado'));
          }

          final timeline = _buildTimeline(creditos, abonos);
          final totalCreditos = creditos.fold<double>(0.0, (sum, c) => sum + c.montoTotal);
          final totalAbonos = abonos.fold<double>(0.0, (sum, a) => sum + a.abono.montoAbono);

          return Column(
            children: [
              // Header del cliente
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade400, Colors.indigo.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Text(
                            cliente.nombre[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade600,
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
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                cliente.telefono,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Saldo Actual',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            Text(
                              currencyFormat.format(saldoActual),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatChip(
                            label: 'Total Cargos',
                            value: currencyFormat.format(totalCreditos),
                            color: Colors.red.shade200,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatChip(
                            label: 'Total Abonos',
                            value: currencyFormat.format(totalAbonos),
                            color: Colors.green.shade200,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Filtro activo
              if (_rangoFechas != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Chip(
                    label: Text(
                      '${DateFormat('dd/MM/yyyy').format(_rangoFechas!.start)} - ${DateFormat('dd/MM/yyyy').format(_rangoFechas!.end)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: _limpiarFiltro,
                  ),
                ),

              // Timeline header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Movimientos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${timeline.length} registros',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Timeline
              Expanded(
                child: timeline.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No hay movimientos',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: timeline.length,
                        itemBuilder: (context, index) {
                          final entry = timeline[index];
                          return _TimelineTile(
                            entry: entry,
                            currencyFormat: currencyFormat,
                            isFirst: index == 0,
                            isLast: index == timeline.length - 1,
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

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final _TimelineEntry entry;
  final NumberFormat currencyFormat;
  final bool isFirst;
  final bool isLast;

  const _TimelineTile({
    required this.entry,
    required this.currencyFormat,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = entry.esCargo ? Colors.red : Colors.green;
    final icon = entry.esCargo ? Icons.shopping_cart : Icons.payments;
    final signo = entry.esCargo ? '+' : '-';
    final tipo = entry.esCargo ? 'Venta a credito' : 'Abono';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(child: Container(width: 2, color: Colors.grey[300]))
                else
                  const Expanded(child: SizedBox()),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: Colors.grey[300]))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: color.withValues(alpha: 0.1),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tipo,
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                              Text(
                                '$signo${currencyFormat.format(entry.monto)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(entry.fecha),
                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              ),
                              Text(
                                'Saldo: ${currencyFormat.format(entry.saldoDespues)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: entry.saldoDespues > 0 ? Colors.orange.shade700 : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          if (entry.idVenta != null && entry.esCargo)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                'Venta #${entry.idVenta}',
                                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
