import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart';
import 'package:janella_store/providers/providers.dart';

class ProductoFormScreen extends ConsumerStatefulWidget {
  final int? idProducto;

  const ProductoFormScreen({super.key, this.idProducto});

  @override
  ConsumerState<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends ConsumerState<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _tamanoController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.idProducto != null;
    if (_isEditing) {
      _loadProducto();
    }
  }

  Future<void> _loadProducto() async {
    final repo = ref.read(productosRepositoryProvider);
    final producto = await repo.obtenerPorId(widget.idProducto!);
    if (producto != null) {
      _nombreController.text = producto.nombre;
      _descripcionController.text = producto.descripcion ?? '';
      _tamanoController.text = producto.tamano;
      _precioController.text = producto.precioVenta.toString();
      _stockController.text = producto.stock.toString();
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(productosRepositoryProvider);

      if (_isEditing) {
        final producto = await repo.obtenerPorId(widget.idProducto!);
        if (producto != null) {
          await repo.actualizar(
            producto.copyWith(
              nombre: _nombreController.text,
              descripcion: Value(_descripcionController.text.isEmpty
                  ? null
                  : _descripcionController.text),
              tamano: _tamanoController.text,
              precioVenta: double.parse(_precioController.text),
              stock: int.parse(_stockController.text),
            ),
          );
        }
      } else {
        await repo.crearProducto(
          nombre: _nombreController.text,
          descripcion: _descripcionController.text.isEmpty
              ? null
              : _descripcionController.text,
          tamano: _tamanoController.text,
          precioVenta: double.parse(_precioController.text),
          stock: int.parse(_stockController.text),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? 'Producto actualizado'
                : 'Producto creado'),
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

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _tamanoController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Producto' : 'Nuevo Producto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre *',
                prefixIcon: Icon(Icons.inventory_2),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tamanoController,
              decoration: const InputDecoration(
                labelText: 'Tamaño *',
                prefixIcon: Icon(Icons.straighten),
                hintText: 'Ej: 500ml, Grande, etc.',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El tamaño es requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio de Venta *',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El precio es requerido';
                }
                final precio = double.tryParse(value);
                if (precio == null || precio <= 0) {
                  return 'Ingrese un precio válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stock Inicial *',
                prefixIcon: Icon(Icons.inventory),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El stock es requerido';
                }
                final stock = int.tryParse(value);
                if (stock == null || stock < 0) {
                  return 'Ingrese un stock válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _guardar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Actualizar' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
