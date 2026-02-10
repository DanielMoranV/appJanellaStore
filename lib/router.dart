import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:janella_store/screens/home_screen.dart';
import 'package:janella_store/screens/productos_screen.dart';
import 'package:janella_store/screens/producto_form_screen.dart';
import 'package:janella_store/screens/cart_screen.dart';
import 'package:janella_store/screens/clientes_screen.dart';
import 'package:janella_store/screens/cliente_form_screen.dart';
import 'package:janella_store/screens/cliente_detail_screen.dart';
import 'package:janella_store/screens/cliente_creditos_screen.dart';
import 'package:janella_store/screens/creditos_screen.dart';
import 'package:janella_store/screens/credito_detail_screen.dart';
import 'package:janella_store/screens/ingreso_screen.dart';
import 'package:janella_store/screens/reportes_screen.dart';
import 'package:janella_store/screens/proveedores_screen.dart';
import 'package:janella_store/screens/pos_screen.dart';
import 'package:janella_store/screens/kardex_screen.dart';
import 'package:janella_store/screens/historial_ventas_screen.dart';
import 'package:janella_store/screens/historial_ingresos_screen.dart';
import 'package:janella_store/screens/seeder_screen.dart';
import 'package:janella_store/screens/settings_screen.dart';
import 'package:janella_store/screens/estado_cuenta_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/productos',
      name: 'productos',
      builder: (context, state) => const ProductosScreen(),
    ),
    GoRoute(
      path: '/productos/nuevo',
      name: 'producto-nuevo',
      builder: (context, state) => const ProductoFormScreen(),
    ),
    GoRoute(
      path: '/productos/:id',
      name: 'producto-editar',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductoFormScreen(idProducto: id);
      },
    ),
    GoRoute(
      path: '/carrito',
      name: 'carrito',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/clientes',
      name: 'clientes',
      builder: (context, state) => const ClientesScreen(),
    ),
    GoRoute(
      path: '/clientes/nuevo',
      name: 'cliente-nuevo',
      builder: (context, state) => const ClienteFormScreen(),
    ),
    GoRoute(
      path: '/clientes/:id',
      name: 'cliente-detalle',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ClienteDetailScreen(idCliente: id);
      },
    ),
    GoRoute(
      path: '/clientes/:id/creditos',
      name: 'cliente-creditos',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ClienteCreditosScreen(idCliente: id);
      },
    ),
    GoRoute(
      path: '/clientes/:id/estado-cuenta',
      name: 'estado-cuenta',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return EstadoCuentaScreen(idCliente: id);
      },
    ),
    GoRoute(
      path: '/creditos',
      name: 'creditos',
      builder: (context, state) => const CreditosScreen(),
    ),
    GoRoute(
      path: '/creditos/:id',
      name: 'credito-detalle',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CreditoDetailScreen(idCredito: id);
      },
    ),
    GoRoute(
      path: '/ingresos',
      name: 'ingresos',
      builder: (context, state) => const HistorialIngresosScreen(),
    ),
    GoRoute(
      path: '/ingresos/nuevo',
      name: 'ingreso-nuevo',
      builder: (context, state) => const IngresoScreen(),
    ),
    GoRoute(
      path: '/reportes',
      name: 'reportes',
      builder: (context, state) => const ReportesScreen(),
    ),
    GoRoute(
      path: '/proveedores',
      name: 'proveedores',
      builder: (context, state) => const ProveedoresScreen(),
    ),
    GoRoute(
      path: '/pos',
      name: 'pos',
      builder: (context, state) => const PosScreen(),
    ),
    GoRoute(
      path: '/kardex',
      name: 'kardex',
      builder: (context, state) => const KardexScreen(),
    ),
    GoRoute(
      path: '/historial-ventas',
      name: 'historial-ventas',
      builder: (context, state) => const HistorialVentasScreen(),
    ),
    GoRoute(
      path: '/seeder',
      name: 'seeder',
      builder: (context, state) => const SeederScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
