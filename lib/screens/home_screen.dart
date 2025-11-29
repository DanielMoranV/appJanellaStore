import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janella_store/providers/cart_provider.dart';
import 'package:janella_store/providers/providers.dart';
import 'package:intl/intl.dart';
import 'package:janella_store/constants/app_constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final currencyFormat = AppConstants.currencyFormat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Janella Store'),
        actions: [
          // Carrito badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => context.push('/carrito'),
              ),
              if (cartState.totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${cartState.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _MenuCard(
              icon: Icons.inventory_2,
              title: 'Productos',
              subtitle: 'Catálogo',
              color: Colors.blue,
              onTap: () => context.push('/productos'),
            ),
            _MenuCard(
              icon: Icons.people,
              title: 'Clientes',
              subtitle: 'Gestionar',
              color: Colors.green,
              onTap: () => context.push('/clientes'),
            ),
            _MenuCard(
              icon: Icons.credit_card,
              title: 'Créditos',
              subtitle: 'Deudas',
              color: Colors.orange,
              onTap: () => context.push('/creditos'),
            ),
            _MenuCard(
              icon: Icons.add_shopping_cart,
              title: 'Ingresos',
              subtitle: 'Mercadería',
              color: Colors.purple,
              onTap: () => context.push('/ingresos'),
            ),
            _MenuCard(
              icon: Icons.bar_chart,
              title: 'Reportes',
              subtitle: 'Estadísticas',
              color: Colors.teal,
              onTap: () => context.push('/reportes'),
            ),
            _MenuCard(
              icon: Icons.local_shipping,
              title: 'Proveedores',
              subtitle: 'Gestionar',
              color: Colors.indigo,
              onTap: () => context.push('/proveedores'),
            ),
            _MenuCard(
              icon: Icons.point_of_sale,
              title: 'POS',
              subtitle: 'Venta Rápida',
              color: Colors.deepPurple,
              onTap: () => context.push('/pos'),
            ),
            _MenuCard(
              icon: Icons.assignment,
              title: 'Kardex',
              subtitle: 'Movimientos',
              color: Colors.teal.shade700,
              onTap: () => context.push('/kardex'),
            ),
            _MenuCard(
              icon: Icons.history,
              title: 'Historial',
              subtitle: 'Ventas',
              color: Colors.indigo.shade700,
              onTap: () => context.push('/historial-ventas'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
