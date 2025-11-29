import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janella_store/data/database/database.dart';

// Modelo para items del carrito
class CartItem {
  final Producto producto;
  int cantidad;

  CartItem({
    required this.producto,
    this.cantidad = 1,
  });

  double get subtotal => producto.precioVenta * cantidad;

  CartItem copyWith({
    Producto? producto,
    int? cantidad,
  }) {
    return CartItem(
      producto: producto ?? this.producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}

// Estado del carrito
class CartState {
  final List<CartItem> items;

  CartState({this.items = const []});

  double get total => items.fold(0.0, (sum, item) => sum + item.subtotal);

  int get totalItems => items.fold(0, (sum, item) => sum + item.cantidad);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

// Notifier del carrito
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  // Agregar producto al carrito
  void addProduct(Producto producto, {int cantidad = 1}) {
    final items = List<CartItem>.from(state.items);
    
    // Buscar si el producto ya está en el carrito
    final index = items.indexWhere((item) => item.producto.idProducto == producto.idProducto);
    
    if (index >= 0) {
      // Si ya existe, incrementar la cantidad
      items[index] = items[index].copyWith(
        cantidad: items[index].cantidad + cantidad,
      );
    } else {
      // Si no existe, agregarlo
      items.add(CartItem(producto: producto, cantidad: cantidad));
    }
    
    state = state.copyWith(items: items);
  }

  // Actualizar cantidad de un producto
  void updateQuantity(int idProducto, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      removeProduct(idProducto);
      return;
    }

    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.producto.idProducto == idProducto);
    
    if (index >= 0) {
      items[index] = items[index].copyWith(cantidad: nuevaCantidad);
      state = state.copyWith(items: items);
    }
  }

  // Incrementar cantidad
  void incrementQuantity(int idProducto) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.producto.idProducto == idProducto);
    
    if (index >= 0) {
      items[index] = items[index].copyWith(
        cantidad: items[index].cantidad + 1,
      );
      state = state.copyWith(items: items);
    }
  }

  // Decrementar cantidad
  void decrementQuantity(int idProducto) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.producto.idProducto == idProducto);
    
    if (index >= 0) {
      final newQuantity = items[index].cantidad - 1;
      if (newQuantity <= 0) {
        removeProduct(idProducto);
      } else {
        items[index] = items[index].copyWith(cantidad: newQuantity);
        state = state.copyWith(items: items);
      }
    }
  }

  // Eliminar producto del carrito
  void removeProduct(int idProducto) {
    final items = state.items.where((item) => item.producto.idProducto != idProducto).toList();
    state = state.copyWith(items: items);
  }

  // Limpiar carrito
  void clear() {
    state = CartState();
  }

  // Obtener item del carrito
  CartItem? getItem(int idProducto) {
    try {
      return state.items.firstWhere((item) => item.producto.idProducto == idProducto);
    } catch (e) {
      return null;
    }
  }

  // Verificar si un producto está en el carrito
  bool hasProduct(int idProducto) {
    return state.items.any((item) => item.producto.idProducto == idProducto);
  }
}

// Provider del carrito
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
