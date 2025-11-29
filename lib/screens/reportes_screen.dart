import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/services/reportes_service.dart';
import 'package:intl/intl.dart';
import 'package:janella_store/constants/app_constants.dart';

class ReportesScreen extends ConsumerStatefulWidget {
  const ReportesScreen({super.key});

  @override
  ConsumerState<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends ConsumerState<ReportesScreen> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  String _tipoReporte = 'mes_actual'; // mes_actual, ultimos_30, personalizado
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _configurarFechasPredeterminadas();
  }

  void _configurarFechasPredeterminadas() {
    final ahora = DateTime.now();
    setState(() {
      _fechaInicio = DateTime(ahora.year, ahora.month, 1);
      _fechaFin = DateTime(ahora.year, ahora.month + 1, 0);
    });
  }

  void _cambiarTipoReporte(String tipo) {
    final ahora = DateTime.now();
    setState(() {
      _tipoReporte = tipo;
      _refreshKey++;
      
      switch (tipo) {
        case 'mes_actual':
          _fechaInicio = DateTime(ahora.year, ahora.month, 1);
          _fechaFin = DateTime(ahora.year, ahora.month + 1, 0);
          break;
        case 'ultimos_30':
          _fechaInicio = ahora.subtract(const Duration(days: 30));
          _fechaFin = ahora;
          break;
        case 'personalizado':
          // Mantener las fechas actuales para que el usuario las modifique
          break;
      }
    });
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
        _tipoReporte = 'personalizado';
        _refreshKey++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportesService = ref.read(reportesServiceProvider);
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes Financieros'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _refreshKey++),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filtros de período
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.teal.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Período de análisis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Botones de período predefinido
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FiltroChip(
                          label: 'Mes actual',
                          isSelected: _tipoReporte == 'mes_actual',
                          onTap: () => _cambiarTipoReporte('mes_actual'),
                        ),
                        const SizedBox(width: 8),
                        _FiltroChip(
                          label: 'Últimos 30 días',
                          isSelected: _tipoReporte == 'ultimos_30',
                          onTap: () => _cambiarTipoReporte('ultimos_30'),
                        ),
                        const SizedBox(width: 8),
                        _FiltroChip(
                          label: 'Personalizado',
                          isSelected: _tipoReporte == 'personalizado',
                          onTap: _seleccionarRangoFechas,
                          icon: Icons.date_range,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Mostrar rango actual
                  if (_fechaInicio != null && _fechaFin != null)
                    Text(
                      'Del ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)} al ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            // Contenido de estadísticas
            Expanded(
              child: FutureBuilder<EstadisticasFinancieras>(
                key: ValueKey(_refreshKey),
                future: _fechaInicio != null && _fechaFin != null
                    ? reportesService.calcularEstadisticas(
                        fechaInicio: _fechaInicio!,
                        fechaFin: _fechaFin!,
                      )
                    : reportesService.obtenerEstadisticasMesActual(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Calculando estadísticas...'),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => setState(() => _refreshKey++),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  final stats = snapshot.data!;
                  
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Resumen principal
                      _ResumenPrincipal(stats: stats, currencyFormat: currencyFormat),
                      const SizedBox(height: 20),
                      
                      // Análisis de efectivo
                      _AnalisisEfectivo(stats: stats, currencyFormat: currencyFormat),
                      const SizedBox(height: 20),
                      
                      // Análisis de inventario
                      _AnalisisInventario(stats: stats, currencyFormat: currencyFormat),
                      const SizedBox(height: 20),
                      
                      // Métricas de performance
                      _MetricasPerformance(stats: stats, currencyFormat: currencyFormat),
                    ],
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

// Widget para filtros tipo chip
class _FiltroChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _FiltroChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.teal,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.teal,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de resumen principal
class _ResumenPrincipal extends StatelessWidget {
  final EstadisticasFinancieras stats;
  final NumberFormat currencyFormat;

  const _ResumenPrincipal({
    required this.stats,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen Financiero',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Total Invertido',
                    value: currencyFormat.format(stats.totalInvertido),
                    icon: Icons.trending_down,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    title: 'Total Vendido',
                    value: currencyFormat.format(stats.totalVendido),
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Utilidad Bruta',
                    value: currencyFormat.format(stats.utilidadBruta),
                    icon: stats.utilidadBruta >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: stats.utilidadBruta >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    title: 'Rentabilidad',
                    value: '${stats.rentabilidad.toStringAsFixed(1)}%',
                    icon: stats.rentabilidad >= 0 ? Icons.percent : Icons.trending_down,
                    color: stats.rentabilidad >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de análisis de efectivo
class _AnalisisEfectivo extends StatelessWidget {
  final EstadisticasFinancieras stats;
  final NumberFormat currencyFormat;

  const _AnalisisEfectivo({
    required this.stats,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Análisis de Efectivo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetalleEfectivo(
              titulo: 'Total en Efectivo',
              valor: currencyFormat.format(stats.totalEfectivo),
              subtitulo: 'Dinero realmente recibido',
              color: Colors.green,
              isMain: true,
            ),
            const Divider(),
            _DetalleEfectivo(
              titulo: 'Ventas en Efectivo',
              valor: currencyFormat.format(stats.ventasEfectivo),
              subtitulo: 'Ventas directas sin crédito',
            ),
            _DetalleEfectivo(
              titulo: 'Abonos Recibidos',
              valor: currencyFormat.format(stats.abonos),
              subtitulo: 'Pagos de deudas anteriores',
            ),
            const Divider(),
            _DetalleEfectivo(
              titulo: 'Deudas Pendientes',
              valor: currencyFormat.format(stats.deudasPendientes),
              subtitulo: '${stats.cantidadCreditosActivos} créditos activos',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de análisis de inventario
class _AnalisisInventario extends StatelessWidget {
  final EstadisticasFinancieras stats;
  final NumberFormat currencyFormat;

  const _AnalisisInventario({
    required this.stats,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.inventory_2, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Análisis de Inventario',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Stock por Vender',
                    value: currencyFormat.format(stats.stockPorVender),
                    subtitle: 'Valor a precio de venta',
                    icon: Icons.store,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Potencial de Ingresos',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Si vendes todo el stock actual, podrías generar ${currencyFormat.format(stats.stockPorVender)} adicionales.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de métricas de performance
class _MetricasPerformance extends StatelessWidget {
  final EstadisticasFinancieras stats;
  final NumberFormat currencyFormat;

  const _MetricasPerformance({
    required this.stats,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  'Métricas de Performance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Total de Ventas',
                    value: stats.cantidadVentas.toString(),
                    subtitle: 'Transacciones realizadas',
                    icon: Icons.receipt_long,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    title: 'Ticket Promedio',
                    value: stats.cantidadVentas > 0 
                        ? currencyFormat.format(stats.totalVendido / stats.cantidadVentas)
                        : currencyFormat.format(0),
                    subtitle: 'Valor promedio por venta',
                    icon: Icons.calculate,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para métricas individuales
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 11,
                color: color.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Widget para detalles de efectivo
class _DetalleEfectivo extends StatelessWidget {
  final String titulo;
  final String valor;
  final String? subtitulo;
  final Color? color;
  final bool isMain;

  const _DetalleEfectivo({
    required this.titulo,
    required this.valor,
    this.subtitulo,
    this.color,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.grey.shade700;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMain ? 8 : 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: isMain ? 16 : 14,
                    fontWeight: isMain ? FontWeight.bold : FontWeight.w600,
                    color: effectiveColor,
                  ),
                ),
                if (subtitulo != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitulo!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: isMain ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
        ],
      ),
    );
  }
}