import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/ingresos_repository.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/constants/app_constants.dart';
import 'package:intl/intl.dart';

class HistorialIngresosScreen extends ConsumerStatefulWidget {
  const HistorialIngresosScreen({super.key});

  @override
  ConsumerState<HistorialIngresosScreen> createState() =>
      _HistorialIngresosScreenState();
}

class _HistorialIngresosScreenState extends ConsumerState<HistorialIngresosScreen> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  List<IngresosMercaderiaData> _ingresos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fechaInicio = DateTime(now.year, now.month, 1);
    _fechaFin = DateTime(now.year, now.month + 1, 0);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarIngresos();
    });
  }

  Future<void> _cargarIngresos() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    final ingresosRepo = ref.read(ingresosRepositoryProvider);

    try {
      final ingresos = await ingresosRepo.obtenerPorRangoFechas(
        _fechaInicio!,
        _fechaFin!.add(const Duration(days: 1)),
      );

      if (mounted) {
        setState(() {
          _ingresos = ingresos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _ingresos = [];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar ingresos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
      });
      await _cargarIngresos();
    }
  }

  Future<void> _eliminarIngreso(int idIngreso) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Ingreso'),
        content: const Text(
            '¿Está seguro de eliminar este ingreso? El stock de los productos será revertido (decrementado).'),
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
        final ingresosRepo = ref.read(ingresosRepositoryProvider);
        await ingresosRepo.eliminarIngreso(idIngreso);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ingreso eliminado y stock revertido'),
              backgroundColor: Colors.green,
            ),
          );
          _cargarIngresos();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Ingresos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarIngresos,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _seleccionarRangoFechas,
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _fechaInicio != null && _fechaFin != null
                          ? '${DateFormat('dd/MM/yyyy').format(_fechaInicio!)} - ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}'
                          : 'Seleccionar Fechas',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _ingresos.isEmpty
                    ? const Center(child: Text('No hay ingresos en este período'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _ingresos.length,
                        itemBuilder: (context, index) {
                          final ingreso = _ingresos[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ExpansionTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.purple,
                                child: Icon(Icons.inventory, color: Colors.white),
                              ),
                              title: Text(
                                'Ingreso #${ingreso.idIngreso}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(ingreso.fecha),
                              ),
                              trailing: Text(
                                AppConstants.currencyFormat.format(ingreso.totalInversion),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              children: [
                                FutureBuilder<List<IngresosDetalleConProducto>>(
                                  future: ref
                                      .read(ingresosRepositoryProvider)
                                      .obtenerDetalles(ingreso.idIngreso),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    }
                                    final detalles = snapshot.data!;
                                    return Column(
                                      children: [
                                        ...detalles.map((d) => ListTile(
                                              dense: true,
                                              title: Text(d.producto.nombre),
                                              subtitle: Text(
                                                  '${d.detalle.cantidad} x ${AppConstants.currencyFormat.format(d.detalle.costoUnitario)}'),
                                              trailing: Text(
                                                AppConstants.currencyFormat.format(d.detalle.subtotal),
                                              ),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton.icon(
                                            onPressed: () => _eliminarIngreso(ingreso.idIngreso),
                                            icon: const Icon(Icons.delete, color: Colors.white),
                                            label: const Text('Eliminar Ingreso'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/ingresos/nuevo');
          _cargarIngresos();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Ingreso'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
