import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:janella_store/providers/cart_provider.dart';
import 'package:janella_store/constants/app_constants.dart';
import 'package:janella_store/data/repositories/ventas_repository.dart';

/// Pantalla POS optimizada para venta rápida en móvil
class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  String _searchQuery = '';
  Cliente? _clienteSeleccionado;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarCliente() async {
    final clientesRepo = ref.read(clientesRepositoryProvider);
    final clientes = await clientesRepo.obtenerTodos();

    if (!mounted) return;

    final cliente = await showDialog<Cliente>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Cliente'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: clientes.isEmpty
              ? const Center(child: Text('No hay clientes'))
              : ListView.builder(
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
      ),
    );

    if (cliente != null) {
      setState(() => _clienteSeleccionado = cliente);
    }
  }

  Future<void> _finalizarVenta(bool esCredito) async {
    final cartState = ref.read(cartProvider);

    if (cartState.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('El carrito está vacío')));
      return;
    }

    if (_clienteSeleccionado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleccione un cliente')));
      return;
    }

    try {
      final ventasRepo = ref.read(ventasRepositoryProvider);
      final detalles = cartState.items.map((item) {
        return DetalleVenta(
          idProducto: item.producto.idProducto,
          cantidad: item.cantidad,
          precioUnitario: item.producto.precioVenta,
          subtotal: item.subtotal,
        );
      }).toList();

      await ventasRepo.registrarVenta(
        idCliente: _clienteSeleccionado!.idCliente,
        fecha: DateTime.now(),
        detalles: detalles,
        esCredito: esCredito,
      );

      ref.read(cartProvider.notifier).clear();
      setState(() => _clienteSeleccionado = null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Venta ${esCredito ? "a crédito" : "en efectivo"} registrada',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productosAsync = ref.watch(productosStreamProvider);
    final cartState = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('POS - Venta Rápida'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cliente seleccionado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.deepPurple.shade50,
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _clienteSeleccionado?.nombre ?? 'Sin cliente',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _seleccionarCliente,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Cambiar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Búsqueda de productos
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar producto...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                onChanged: (value) =>
                    setState(() => _searchQuery = value.toLowerCase()),
              ),
            ),
            // Lista de productos
            Expanded(
              flex: 3,
              child: productosAsync.when(
                data: (productos) {
                  final filtered = productos.where((p) {
                    return p.nombre.toLowerCase().contains(_searchQuery) &&
                        p.stock > 0;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('No hay productos disponibles'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final producto = filtered[index];
                      final enCarrito = cart.hasProduct(producto.idProducto);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              producto.nombre[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            producto.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${producto.tamano} • Stock: ${producto.stock}',
                            style: TextStyle(
                              color: producto.stock < 5
                                  ? Colors.orange
                                  : Colors.grey[600],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppConstants.currencyFormat.format(
                                  producto.precioVenta,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  cart.addProduct(producto);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${producto.nombre} agregado',
                                      ),
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  enCarrito
                                      ? Icons.check_circle
                                      : Icons.add_circle,
                                  color: enCarrito ? Colors.green : Colors.blue,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
            // Carrito resumen
            if (!cartState.isEmpty)
              Container(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Items del carrito
                    Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cartState.items.length,
                        itemBuilder: (context, index) {
                          final item = cartState.items[index];
                          return ListTile(
                            dense: true,
                            title: Text(item.producto.nombre),
                            subtitle: Text(
                              '${AppConstants.currencyFormat.format(item.producto.precioVenta)} x ${item.cantidad}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    size: 20,
                                  ),
                                  onPressed: () => cart.decrementQuantity(
                                    item.producto.idProducto,
                                  ),
                                ),
                                Text(
                                  '${item.cantidad}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    size: 20,
                                  ),
                                  onPressed: () => cart.incrementQuantity(
                                    item.producto.idProducto,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => cart.removeProduct(
                                    item.producto.idProducto,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    // Total y botones
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'TOTAL:',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppConstants.currencyFormat.format(
                                  cartState.total,
                                ),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _finalizarVenta(false),
                                  icon: const Icon(Icons.attach_money),
                                  label: const Text('EFECTIVO'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _finalizarVenta(true),
                                  icon: const Icon(Icons.credit_card),
                                  label: const Text('CRÉDITO'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
