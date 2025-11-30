import 'package:janella_store/data/database/database.dart';
import 'package:drift/drift.dart';
import 'package:janella_store/data/repositories/ventas_repository.dart';
import 'package:janella_store/data/repositories/ingresos_repository.dart';
import 'package:janella_store/data/repositories/creditos_repository.dart';
import 'package:janella_store/data/repositories/productos_repository.dart';
import 'package:janella_store/data/repositories/abonos_repository.dart';

/// Modelo para las estadísticas financieras del negocio
class EstadisticasFinancieras {
  final double totalInvertido;      // Total invertido en mercadería (ingresos)
  final double totalVendido;        // Total vendido (ventas)
  final double totalEfectivo;       // Efectivo recibido (ventas efectivo + abonos)
  final double deudasPendientes;    // Deudas por cobrar
  final double stockPorVender;      // Valor del stock disponible a precio de venta
  final double utilidadBruta;       // Total vendido - Total invertido
  final double rentabilidad;        // % de rentabilidad

  // Desglose adicional
  final double ventasEfectivo;      // Ventas directas en efectivo
  final double ventasCredito;       // Ventas a crédito
  final double abonos;              // Abonos recibidos
  final int cantidadVentas;         // Número de ventas
  final int cantidadCreditosActivos; // Créditos pendientes

  EstadisticasFinancieras({
    required this.totalInvertido,
    required this.totalVendido,
    required this.totalEfectivo,
    required this.deudasPendientes,
    required this.stockPorVender,
    required this.utilidadBruta,
    required this.rentabilidad,
    required this.ventasEfectivo,
    required this.ventasCredito,
    required this.abonos,
    required this.cantidadVentas,
    required this.cantidadCreditosActivos,
  });
}

/// Servicio para calcular estadísticas financieras
class ReportesService {
  final AppDatabase _db;
  final VentasRepository _ventasRepo;
  final IngresosRepository _ingresosRepo;
  final CreditosRepository _creditosRepo;
  final ProductosRepository _productosRepo;
  final AbonosRepository _abonosRepo;

  ReportesService({
    required AppDatabase db,
    required VentasRepository ventasRepo,
    required IngresosRepository ingresosRepo,
    required CreditosRepository creditosRepo,
    required ProductosRepository productosRepo,
    required AbonosRepository abonosRepo,
  }) : _db = db,
       _ventasRepo = ventasRepo,
       _ingresosRepo = ingresosRepo,
       _creditosRepo = creditosRepo,
       _productosRepo = productosRepo,
       _abonosRepo = abonosRepo;

  /// Calcula estadísticas financieras para un rango de fechas
  Future<EstadisticasFinancieras> calcularEstadisticas({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      // Ejecutar todos los cálculos en paralelo para mejor rendimiento
      final resultados = await Future.wait([
        _calcularTotalInvertido(fechaInicio, fechaFin),
        _calcularVentasDelPeriodo(fechaInicio, fechaFin),
        _calcularAbonos(fechaInicio, fechaFin),
        _calcularDeudasPendientes(),
        _calcularStockPorVender(),
      ]);

      final totalInvertido = resultados[0] as double;
      final ventasInfo = resultados[1] as Map<String, dynamic>;
      final abonos = resultados[2] as double;
      final deudasPendientes = resultados[3] as double;
      final stockPorVender = resultados[4] as double;

      final totalVendido = ventasInfo['total'] as double;
      final ventasEfectivo = ventasInfo['efectivo'] as double;
      final ventasCredito = ventasInfo['credito'] as double;
      final cantidadVentas = ventasInfo['cantidad'] as int;

      // El total en efectivo incluye ventas directas + abonos recibidos
      final totalEfectivo = ventasEfectivo + abonos;

      // Calcular utilidad y rentabilidad
      final utilidadBruta = totalVendido - totalInvertido;
      final rentabilidad = totalInvertido > 0 ? (utilidadBruta / totalInvertido) * 100 : 0.0;

      // Obtener cantidad de créditos activos
      final cantidadCreditosActivos = await _creditosRepo.obtenerCantidadCreditosActivos();

      return EstadisticasFinancieras(
        totalInvertido: totalInvertido,
        totalVendido: totalVendido,
        totalEfectivo: totalEfectivo,
        deudasPendientes: deudasPendientes,
        stockPorVender: stockPorVender,
        utilidadBruta: utilidadBruta,
        rentabilidad: rentabilidad,
        ventasEfectivo: ventasEfectivo,
        ventasCredito: ventasCredito,
        abonos: abonos,
        cantidadVentas: cantidadVentas,
        cantidadCreditosActivos: cantidadCreditosActivos,
      );
    } catch (e) {
      print('Error calculando estadísticas: $e');
      // Retornar estadísticas vacías en caso de error
      return EstadisticasFinancieras(
        totalInvertido: 0.0,
        totalVendido: 0.0,
        totalEfectivo: 0.0,
        deudasPendientes: 0.0,
        stockPorVender: 0.0,
        utilidadBruta: 0.0,
        rentabilidad: 0.0,
        ventasEfectivo: 0.0,
        ventasCredito: 0.0,
        abonos: 0.0,
        cantidadVentas: 0,
        cantidadCreditosActivos: 0,
      );
    }
  }

  /// Calcula el total invertido en mercadería en un rango de fechas
  Future<double> _calcularTotalInvertido(DateTime fechaInicio, DateTime fechaFin) async {
    final query = _db.selectOnly(_db.ingresosMercaderia)
      ..addColumns([_db.ingresosMercaderia.totalInversion.sum()])
      ..where(_db.ingresosMercaderia.fecha.isBetweenValues(fechaInicio, fechaFin.add(const Duration(days: 1))));

    final result = await query.getSingle();
    return result.read(_db.ingresosMercaderia.totalInversion.sum()) ?? 0.0;
  }

  /// Calcula información de ventas del período
  Future<Map<String, dynamic>> _calcularVentasDelPeriodo(DateTime fechaInicio, DateTime fechaFin) async {
    final ventas = await _ventasRepo.obtenerPorRangoFechas(
      fechaInicio,
      fechaFin.add(const Duration(days: 1)),
    );

    double totalVendido = 0.0;
    double ventasEfectivo = 0.0;
    double ventasCredito = 0.0;

    for (final venta in ventas) {
      totalVendido += venta.total;
      if (venta.esCredito) {
        ventasCredito += venta.total;
      } else {
        ventasEfectivo += venta.total;
      }
    }

    return {
      'total': totalVendido,
      'efectivo': ventasEfectivo,
      'credito': ventasCredito,
      'cantidad': ventas.length,
    };
  }

  /// Calcula el total de abonos recibidos en un rango de fechas
  Future<double> _calcularAbonos(DateTime fechaInicio, DateTime fechaFin) async {
    final query = _db.selectOnly(_db.abonos)
      ..addColumns([_db.abonos.montoAbono.sum()])
      ..where(_db.abonos.fecha.isBetweenValues(fechaInicio, fechaFin.add(const Duration(days: 1))));

    final result = await query.getSingle();
    return result.read(_db.abonos.montoAbono.sum()) ?? 0.0;
  }

  /// Calcula las deudas pendientes (total de créditos activos)
  Future<double> _calcularDeudasPendientes() async {
    return await _creditosRepo.obtenerTotalDeudasActivas();
  }

  /// Calcula el valor total del stock disponible a precio de venta
  Future<double> _calcularStockPorVender() async {
    final productos = await _productosRepo.obtenerTodos();
    
    double valorStock = 0.0;
    for (final producto in productos) {
      valorStock += (producto.stock * producto.precioVenta);
    }
    
    return valorStock;
  }

  /// Obtiene estadísticas predeterminadas para el mes actual
  Future<EstadisticasFinancieras> obtenerEstadisticasMesActual() async {
    final ahora = DateTime.now();
    final inicioMes = DateTime(ahora.year, ahora.month, 1);
    final finMes = DateTime(ahora.year, ahora.month + 1, 0);
    
    return await calcularEstadisticas(
      fechaInicio: inicioMes,
      fechaFin: finMes,
    );
  }

  /// Obtiene estadísticas para los últimos 30 días
  Future<EstadisticasFinancieras> obtenerEstadisticasUltimos30Dias() async {
    final ahora = DateTime.now();
    final inicio = ahora.subtract(const Duration(days: 30));
    
    return await calcularEstadisticas(
      fechaInicio: inicio,
      fechaFin: ahora,
    );
  }
}