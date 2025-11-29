import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/constants/app_constants.dart';
import 'package:intl/intl.dart';

/// Pantalla de Historial de Ventas con filtros
class HistorialVentasScreen extends ConsumerStatefulWidget {
  const HistorialVentasScreen({super.key});

  @override
  ConsumerState<HistorialVentasScreen> createState() =>
      _HistorialVentasScreenState();
}

class _HistorialVentasScreenState extends ConsumerState<HistorialVentasScreen> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  Cliente? _clienteSeleccionado;
  List<Venta> _ventas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Por defecto, mostrar ventas del mes actual
    final now = DateTime.now();
    _fechaInicio = DateTime(now.year, now.month, 1);
    _fechaFin = DateTime(now.year, now.month + 1, 0);
    _cargarVentas();
  }

  Future<void> _cargarVentas() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    final ventasRepo = ref.read(ventasRepositoryProvider);
    final db = ref.read(databaseProvider);

    try {
      List<Venta> ventas;

      if (_clienteSeleccionado != null) {
        // Filtrar por cliente
        ventas = await ventasRepo.obtenerPorCliente(
          _clienteSeleccionado!.idCliente,
        );
      } else if (_fechaInicio != null && _fechaFin != null) {
        // Filtrar por rango de fechas
        ventas =
            await (db.select(db.ventas)
                  ..where(
                    (v) =>
                        v.fecha.isBiggerOrEqualValue(_fechaInicio!) &
                        v.fecha.isSmallerOrEqualValue(
                          _fechaFin!.add(const Duration(days: 1)),
                        ),
                  )
                  ..orderBy([(v) => OrderingTerm.desc(v.fecha)]))
                .get();
      } else {
        // Todas las ventas
        ventas = await (db.select(
          db.ventas,
        )..orderBy([(v) => OrderingTerm.desc(v.fecha)])).get();
      }

      if (mounted) {
        setState(() {
          _ventas = ventas;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando ventas: $e'); // Debug
      if (mounted) {
        setState(() {
          _ventas = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar ventas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _seleccionarCliente() async {
    final clientesRepo = ref.read(clientesRepositoryProvider);
    final clientes = await clientesRepo.obtenerTodos();

    if (!mounted) return;

    final cliente = await showDialog<Cliente?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por Cliente'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('Todos los clientes'),
                onTap: () => Navigator.pop(context, null),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final c = clientes[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(c.nombre[0])),
                      title: Text(c.nombre),
                      subtitle: Text(c.telefono),
                      onTap: () => Navigator.pop(context, c),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    setState(() => _clienteSeleccionado = cliente);
    await _cargarVentas();
  }

  Future<void> _seleccionarRangoFechas() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _fechaInicio != null && _fechaFin != null
          ? DateTimeRange(start: _fechaInicio!, end: _fechaFin!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _fechaInicio = picked.start;
        _fechaFin = picked.end;
        _clienteSeleccionado = null; // Limpiar filtro de cliente
      });
      await _cargarVentas();
    }
  }

  void _filtrarPorMes(int mes) {
    final now = DateTime.now();
    setState(() {
      _fechaInicio = DateTime(now.year, mes, 1);
      _fechaFin = DateTime(now.year, mes + 1, 0);
      _clienteSeleccionado = null;
    });
    _cargarVentas();
  }

  double get _totalVentas {
    return _ventas.fold(0.0, (sum, v) => sum + v.total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Ventas'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarVentas,
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filtros
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.indigo.shade50,
              child: Column(
                children: [
                  // Filtro por cliente
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _seleccionarCliente,
                          icon: const Icon(Icons.person),
                          label: Text(
                            _clienteSeleccionado?.nombre ??
                                'Todos los clientes',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _seleccionarRangoFechas,
                        icon: const Icon(Icons.date_range),
                        label: const Text('Fechas'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Filtros rápidos por mes
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 1; i <= 12; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                DateFormat(
                                  'MMM',
                                  'es',
                                ).format(DateTime(2024, i)),
                              ),
                              selected:
                                  _fechaInicio?.month == i &&
                                  _clienteSeleccionado == null,
                              onSelected: (_) => _filtrarPorMes(i),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rango actual
                  if (_fechaInicio != null &&
                      _fechaFin != null &&
                      _clienteSeleccionado == null)
                    Text(
                      'Del ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)} al ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                ],
              ),
            ),
            // Resumen
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.indigo.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Total Ventas',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${_ventas.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Monto Total', style: TextStyle(fontSize: 12)),
                      Text(
                        AppConstants.currencyFormat.format(_totalVentas),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Lista de ventas
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Cargando ventas...'),
                        ],
                      ),
                    )
                  : _ventas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay ventas en este período',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                final now = DateTime.now();
                                _fechaInicio = DateTime(now.year, now.month, 1);
                                _fechaFin = DateTime(
                                  now.year,
                                  now.month + 1,
                                  0,
                                );
                                _clienteSeleccionado = null;
                              });
                              _cargarVentas();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Recargar'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _ventas.length,
                      itemBuilder: (context, index) {
                        final venta = _ventas[index];
                        return FutureBuilder<Cliente?>(
                          future: ref
                              .read(clientesRepositoryProvider)
                              .obtenerPorId(venta.idCliente),
                          builder: (context, snapshot) {
                            final cliente = snapshot.data;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                  backgroundColor: venta.esCredito
                                      ? Colors.orange
                                      : Colors.green,
                                  child: Icon(
                                    venta.esCredito
                                        ? Icons.credit_card
                                        : Icons.attach_money,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  cliente?.nombre ?? 'Cargando...',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat(
                                    'dd/MM/yyyy HH:mm',
                                  ).format(venta.fecha),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppConstants.currencyFormat.format(
                                        venta.total,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      venta.esCredito ? 'Crédito' : 'Efectivo',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: venta.esCredito
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  FutureBuilder<List<DetalleVentaConProducto>>(
                                    future: ref
                                        .read(databaseProvider)
                                        .getDetallesVenta(venta.idVenta),
                                    builder: (context, detallesSnapshot) {
                                      if (!detallesSnapshot.hasData) {
                                        return const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      final detalles = detallesSnapshot.data!;
                                      return Column(
                                        children: detalles.map((item) {
                                          return ListTile(
                                            dense: true,
                                            title: Text(item.producto.nombre),
                                            subtitle: Text(
                                              '${item.detalle.cantidad} × ${AppConstants.currencyFormat.format(item.detalle.precioUnitario)}',
                                            ),
                                            trailing: Text(
                                              AppConstants.currencyFormat
                                                  .format(
                                                    item.detalle.subtotal,
                                                  ),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
