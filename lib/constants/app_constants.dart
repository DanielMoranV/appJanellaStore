import 'package:intl/intl.dart';

/// Constantes de la aplicación
class AppConstants {
  // Formato de moneda - Soles peruanos
  static final currencyFormat = NumberFormat.currency(
    symbol: 'S/ ',
    decimalDigits: 2,
  );
  
  // Símbolo de moneda
  static const String currencySymbol = 'S/';
  
  // Nombre de la moneda
  static const String currencyName = 'Soles';
}
