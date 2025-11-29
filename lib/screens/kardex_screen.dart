import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/constants/app_constants.dart';
import 'package:intl/intl.dart';

/// Pantalla de Kardex - Movimientos de inventario
class KardexScreen extends ConsumerStatefulWidget {
  const KardexScreen({super.key});

  @override
  ConsumerState<KardexScreen> createState() => _KardexScreenState();
}

class _KardexScreenState extends ConsumerState<KardexScreen> {
  Producto? _productoSeleccionado;
  List<_MovimientoKardex> _movimientos = [];
  bool _isLoading = false;

  Future<void> _seleccionarProducto() async {
    final productosRepo = ref.read(productosRepositoryProvider);
    final productos = await productosRepo.obtenerTodos();

    if (!mounted) return;

    final producto = await showDialog<Producto>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Producto'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: productos.isEmpty
              ? const Center(child: Text('No hay productos'))
              : ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final p = productos[index];
                    return ListTile(
                      title: Text(p.nombre),
                      subtitle: Text('${p.tamano} • Stock actual: ${p.stock}'),
                      onTap: () => Navigator.pop(context, p),
                    );
                  },
                ),
        ),
      ),
    );

    if (producto != null) {
      setState(() {
        _productoSeleccionado = producto;
        _isLoading = true;
      });
      await _cargarMovimientos();
    }
  }

  Future<void> _cargarMovimientos() async {
    if (_productoSeleccionado == null) return;

    final ingresosRepo = ref.read(ingresosRepositoryProvider);
    final ventasRepo = ref.read(ventasRepositoryProvider);
    final db = ref.read(databaseProvider);

    // Obtener ingresos del producto
    final ingresos = await (db.select(db.ingresosDetalle)
          ..where((d) => d.idProducto.equals(_productoSeleccionado!.idProducto)))
        .join([
      leftOuterJoin(
        db.ingresosMercaderia,
        db.ingresosMercaderia.idIngreso.equalsExp(db.ingresosDetalle.idIngreso),
      ),
    ]).get();

    // Obtener ventas del producto
    final ventas = await (db.select(db.ventasDetalle)
          ..where((d) => d.idProducto.equals(_productoSeleccionado!.idProducto)))
        .join([
      leftOuterJoin(
        db.ventas,
        db.ventas.idVenta.equalsExp(db.ventasDetalle.idVenta),
      ),
    ]).get();

    List<_MovimientoKardex> movimientos = [];

    // Agregar ingresos
    for (var row in ingresos) {
      final detalle = row.readTable(db.ingresosDetalle);
      final ingreso = row.readTable(db.ingresosMercaderia);
      movimientos.add(_MovimientoKardex(
        fecha: ingreso.fecha,
        tipo: 'INGRESO',
        cantidad: detalle.cantidad,
        precioUnitario: detalle.costoUnitario,
        total: detalle.subtotal,
        referencia: 'Compra #${ingreso.idIngreso}',
      ));
    }

    // Agregar ventas
    for (var row in ventas) {
      final detalle = row.readTable(db.ventasDetalle);
      final venta = row.readTable(db.ventas);
      movimientos.add(_MovimientoKardex(
        fecha: venta.fecha,
        tipo: 'SALIDA',
        cantidad: detalle.cantidad,
        precioUnitario: detalle.precioUnitario,
        total: detalle.subtotal,
        referencia: 'Venta #${venta.idVenta}',
      ));
    }

    // Ordenar por fecha descendente
    movimientos.sort((a, b) => b.fecha.compareTo(a.fecha));

    setState(() {
      _movimientos = movimientos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kardex de Inventario'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Selector de producto
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.inventory_2, color: Colors.teal),
              title: Text(
                _productoSeleccionado?.nombre ?? 'Seleccionar Producto',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: _productoSeleccionado != null
                  ? Text(
                      'Stock actual: ${_productoSeleccionado!.stock} • ${_productoSeleccionado!.tamano}',
                    )
                  : const Text('Toque para seleccionar'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _seleccionarProducto,
            ),
          ),
          // Resumen
          if (_productoSeleccionado != null && !_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Ingresos',
                      value: _movimientos
                          .where((m) => m.tipo == 'INGRESO')
                          .fold(0, (sum, m) => sum + m.cantidad)
                          .toString(),
                      color: Colors.green,
                      icon: Icons.arrow_downward,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Total Salidas',
                      value: _movimientos
                          .where((m) => m.tipo == 'SALIDA')
                          .fold(0, (sum, m) => sum + m.cantidad)
                          .toString(),
                      color: Colors.red,
                      icon: Icons.arrow_upward,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // Lista de movimientos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _productoSeleccionado == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Seleccione un producto\npara ver su kardex',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : _movimientos.isEmpty
                        ? const Center(child: Text('No hay movimientos registrados'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _movimientos.length,
                            itemBuilder: (context, index) {
                              final mov = _movimientos[index];
                              final isIngreso = mov.tipo == 'INGRESO';
                              
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: isIngreso
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                    child: Icon(
                                      isIngreso
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: isIngreso ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  title: Text(
                                    mov.referencia,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy HH:mm').format(mov.fecha),
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                      Text(
                                        '${mov.cantidad} unidades × ${AppConstants.currencyFormat.format(mov.precioUnitario)}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        mov.tipo,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isIngreso ? Colors.green : Colors.red,
                                        ),
                                      ),
                                      Text(
                                        AppConstants.currencyFormat.format(mov.total),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _MovimientoKardex {
  final DateTime fecha;
  final String tipo;
  final int cantidad;
  final double precioUnitario;
  final double total;
  final String referencia;

  _MovimientoKardex({
    required this.fecha,
    required this.tipo,
    required this.cantidad,
    required this.precioUnitario,
    required this.total,
    required this.referencia,
  });
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
