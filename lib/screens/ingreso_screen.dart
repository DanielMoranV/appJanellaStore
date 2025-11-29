import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/ingresos_repository.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:janella_store/constants/app_constants.dart';

class IngresoScreen extends ConsumerStatefulWidget {
  const IngresoScreen({super.key});

  @override
  ConsumerState<IngresoScreen> createState() => _IngresoScreenState();
}

class _IngresoScreenState extends ConsumerState<IngresoScreen> {
  Proveedore? _proveedorSeleccionado;
  final List<_DetalleIngresoItem> _detalles = [];
  bool _isLoading = false;

  Future<void> _seleccionarProveedor() async {
    final proveedoresRepo = ref.read(proveedoresRepositoryProvider);
    final proveedores = await proveedoresRepo.obtenerTodos();

    if (!mounted) return;

    final proveedor = await showDialog<Proveedore>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Proveedor'),
        content: SizedBox(
          width: double.maxFinite,
          child: proveedores.isEmpty
              ? const Center(child: Text('No hay proveedores'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: proveedores.length,
                  itemBuilder: (context, index) {
                    final prov = proveedores[index];
                    return ListTile(
                      title: Text(prov.nombre),
                      subtitle: Text(prov.telefono),
                      onTap: () => Navigator.pop(context, prov),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );

    if (proveedor != null) {
      setState(() {
        _proveedorSeleccionado = proveedor;
      });
    }
  }

  Future<void> _agregarProducto() async {
    final productosRepo = ref.read(productosRepositoryProvider);
    final productos = await productosRepo.obtenerTodos();

    if (!mounted) return;

    final producto = await showDialog<Producto>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Producto'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final prod = productos[index];
              return ListTile(
                title: Text(prod.nombre),
                subtitle: Text(prod.tamano),
                onTap: () => Navigator.pop(context, prod),
              );
            },
          ),
        ),
      ),
    );

    if (producto != null) {
      setState(() {
        _detalles.add(_DetalleIngresoItem(producto: producto));
      });
    }
  }

  Future<void> _guardarIngreso() async {
    if (_detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agregue al menos un producto'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validar que todos los detalles tengan cantidad y costo
    for (final detalle in _detalles) {
      if (detalle.cantidad <= 0 || detalle.costoUnitario <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complete todos los campos'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final ingresosRepo = ref.read(ingresosRepositoryProvider);
      
      final detalles = _detalles.map((d) {
        return DetalleIngreso(
          idProducto: d.producto.idProducto,
          cantidad: d.cantidad,
          costoUnitario: d.costoUnitario,
          subtotal: d.cantidad * d.costoUnitario,
        );
      }).toList();

      await ingresosRepo.registrarIngreso(
        idProveedor: _proveedorSeleccionado?.idProveedor,
        fecha: DateTime.now(),
        detalles: detalles,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ingreso registrado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  double get _totalInversion {
    return _detalles.fold(0.0, (sum, d) => sum + (d.cantidad * d.costoUnitario));
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingreso de Mercadería'),
      ),
      body: Column(
        children: [
          // Proveedor
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.local_shipping),
              title: Text(_proveedorSeleccionado?.nombre ?? 'Sin proveedor'),
              subtitle: const Text('Toque para seleccionar'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _seleccionarProveedor,
            ),
          ),
          // Lista de productos
          Expanded(
            child: _detalles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_shopping_cart,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay productos agregados',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _detalles.length,
                    itemBuilder: (context, index) {
                      final detalle = _detalles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      detalle.producto.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _detalles.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Cantidad',
                                        isDense: true,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          detalle.cantidad = int.tryParse(value) ?? 0;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Costo Unit.',
                                        isDense: true,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          detalle.costoUnitario =
                                              double.tryParse(value) ?? 0;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Subtotal: ${currencyFormat.format(detalle.cantidad * detalle.costoUnitario)}',
                                style: const TextStyle(
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
          // Total y botones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Inversión:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currencyFormat.format(_totalInversion),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _agregarProducto,
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Producto'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _guardarIngreso,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.save),
                          label: const Text('Guardar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetalleIngresoItem {
  final Producto producto;
  int cantidad;
  double costoUnitario;

  _DetalleIngresoItem({
    required this.producto,
    this.cantidad = 0,
    this.costoUnitario = 0,
  });
}
