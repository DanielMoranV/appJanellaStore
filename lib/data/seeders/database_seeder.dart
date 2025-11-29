import 'package:janella_store/data/database/database.dart';
import 'package:janella_store/data/repositories/productos_repository.dart';

/// Seeder para poblar la base de datos con productos de ejemplo
/// Tienda de ropa: Polos, Camisas, Vestidos, Pantalones, Blusas
class DatabaseSeeder {
  final AppDatabase db;
  final ProductosRepository productosRepo;

  DatabaseSeeder({required this.db, required this.productosRepo});

  /// Ejecutar seeder de productos
  Future<void> seed() async {
    print('🌱 Iniciando seeder de productos...');

    await _seedProductos();

    print('✅ Seeder completado exitosamente!');
  }

  /// Crear productos de ropa con stock inicial en 0
  Future<void> _seedProductos() async {
    print('👕 Creando productos de ropa...');

    final productos = [
      // POLOS
      {
        'nombre': 'Polo Básico',
        'descripcion': 'Polo de algodón 100%',
        'tamano': 'S',
        'precio': 25.00,
      },
      {
        'nombre': 'Polo Básico',
        'descripcion': 'Polo de algodón 100%',
        'tamano': 'M',
        'precio': 25.00,
      },
      {
        'nombre': 'Polo Básico',
        'descripcion': 'Polo de algodón 100%',
        'tamano': 'L',
        'precio': 25.00,
      },
      {
        'nombre': 'Polo Básico',
        'descripcion': 'Polo de algodón 100%',
        'tamano': 'XL',
        'precio': 25.00,
      },

      {
        'nombre': 'Polo Deportivo',
        'descripcion': 'Polo dry-fit para deporte',
        'tamano': 'S',
        'precio': 35.00,
      },
      {
        'nombre': 'Polo Deportivo',
        'descripcion': 'Polo dry-fit para deporte',
        'tamano': 'M',
        'precio': 35.00,
      },
      {
        'nombre': 'Polo Deportivo',
        'descripcion': 'Polo dry-fit para deporte',
        'tamano': 'L',
        'precio': 35.00,
      },
      {
        'nombre': 'Polo Deportivo',
        'descripcion': 'Polo dry-fit para deporte',
        'tamano': 'XL',
        'precio': 35.00,
      },

      {
        'nombre': 'Polo Premium',
        'descripcion': 'Polo pima de alta calidad',
        'tamano': 'S',
        'precio': 45.00,
      },
      {
        'nombre': 'Polo Premium',
        'descripcion': 'Polo pima de alta calidad',
        'tamano': 'M',
        'precio': 45.00,
      },
      {
        'nombre': 'Polo Premium',
        'descripcion': 'Polo pima de alta calidad',
        'tamano': 'L',
        'precio': 45.00,
      },
      {
        'nombre': 'Polo Premium',
        'descripcion': 'Polo pima de alta calidad',
        'tamano': 'XL',
        'precio': 45.00,
      },

      // CAMISAS
      {
        'nombre': 'Camisa Casual',
        'descripcion': 'Camisa manga larga casual',
        'tamano': 'S',
        'precio': 55.00,
      },
      {
        'nombre': 'Camisa Casual',
        'descripcion': 'Camisa manga larga casual',
        'tamano': 'M',
        'precio': 55.00,
      },
      {
        'nombre': 'Camisa Casual',
        'descripcion': 'Camisa manga larga casual',
        'tamano': 'L',
        'precio': 55.00,
      },
      {
        'nombre': 'Camisa Casual',
        'descripcion': 'Camisa manga larga casual',
        'tamano': 'XL',
        'precio': 55.00,
      },

      {
        'nombre': 'Camisa Formal',
        'descripcion': 'Camisa de vestir elegante',
        'tamano': 'S',
        'precio': 75.00,
      },
      {
        'nombre': 'Camisa Formal',
        'descripcion': 'Camisa de vestir elegante',
        'tamano': 'M',
        'precio': 75.00,
      },
      {
        'nombre': 'Camisa Formal',
        'descripcion': 'Camisa de vestir elegante',
        'tamano': 'L',
        'precio': 75.00,
      },
      {
        'nombre': 'Camisa Formal',
        'descripcion': 'Camisa de vestir elegante',
        'tamano': 'XL',
        'precio': 75.00,
      },

      {
        'nombre': 'Camisa Lino',
        'descripcion': 'Camisa de lino fresca',
        'tamano': 'S',
        'precio': 85.00,
      },
      {
        'nombre': 'Camisa Lino',
        'descripcion': 'Camisa de lino fresca',
        'tamano': 'M',
        'precio': 85.00,
      },
      {
        'nombre': 'Camisa Lino',
        'descripcion': 'Camisa de lino fresca',
        'tamano': 'L',
        'precio': 85.00,
      },
      {
        'nombre': 'Camisa Lino',
        'descripcion': 'Camisa de lino fresca',
        'tamano': 'XL',
        'precio': 85.00,
      },

      // VESTIDOS
      {
        'nombre': 'Vestido Casual',
        'descripcion': 'Vestido cómodo para el día',
        'tamano': 'S',
        'precio': 65.00,
      },
      {
        'nombre': 'Vestido Casual',
        'descripcion': 'Vestido cómodo para el día',
        'tamano': 'M',
        'precio': 65.00,
      },
      {
        'nombre': 'Vestido Casual',
        'descripcion': 'Vestido cómodo para el día',
        'tamano': 'L',
        'precio': 65.00,
      },
      {
        'nombre': 'Vestido Casual',
        'descripcion': 'Vestido cómodo para el día',
        'tamano': 'XL',
        'precio': 65.00,
      },

      {
        'nombre': 'Vestido Elegante',
        'descripcion': 'Vestido de noche sofisticado',
        'tamano': 'S',
        'precio': 120.00,
      },
      {
        'nombre': 'Vestido Elegante',
        'descripcion': 'Vestido de noche sofisticado',
        'tamano': 'M',
        'precio': 120.00,
      },
      {
        'nombre': 'Vestido Elegante',
        'descripcion': 'Vestido de noche sofisticado',
        'tamano': 'L',
        'precio': 120.00,
      },
      {
        'nombre': 'Vestido Elegante',
        'descripcion': 'Vestido de noche sofisticado',
        'tamano': 'XL',
        'precio': 120.00,
      },

      {
        'nombre': 'Vestido Verano',
        'descripcion': 'Vestido ligero floral',
        'tamano': 'S',
        'precio': 55.00,
      },
      {
        'nombre': 'Vestido Verano',
        'descripcion': 'Vestido ligero floral',
        'tamano': 'M',
        'precio': 55.00,
      },
      {
        'nombre': 'Vestido Verano',
        'descripcion': 'Vestido ligero floral',
        'tamano': 'L',
        'precio': 55.00,
      },
      {
        'nombre': 'Vestido Verano',
        'descripcion': 'Vestido ligero floral',
        'tamano': 'XL',
        'precio': 55.00,
      },

      // PANTALONES
      {
        'nombre': 'Pantalón Jean',
        'descripcion': 'Jean clásico azul',
        'tamano': '28',
        'precio': 70.00,
      },
      {
        'nombre': 'Pantalón Jean',
        'descripcion': 'Jean clásico azul',
        'tamano': '30',
        'precio': 70.00,
      },
      {
        'nombre': 'Pantalón Jean',
        'descripcion': 'Jean clásico azul',
        'tamano': '32',
        'precio': 70.00,
      },
      {
        'nombre': 'Pantalón Jean',
        'descripcion': 'Jean clásico azul',
        'tamano': '34',
        'precio': 70.00,
      },
      {
        'nombre': 'Pantalón Jean',
        'descripcion': 'Jean clásico azul',
        'tamano': '36',
        'precio': 70.00,
      },

      {
        'nombre': 'Pantalón Drill',
        'descripcion': 'Pantalón casual drill',
        'tamano': '28',
        'precio': 60.00,
      },
      {
        'nombre': 'Pantalón Drill',
        'descripcion': 'Pantalón casual drill',
        'tamano': '30',
        'precio': 60.00,
      },
      {
        'nombre': 'Pantalón Drill',
        'descripcion': 'Pantalón casual drill',
        'tamano': '32',
        'precio': 60.00,
      },
      {
        'nombre': 'Pantalón Drill',
        'descripcion': 'Pantalón casual drill',
        'tamano': '34',
        'precio': 60.00,
      },
      {
        'nombre': 'Pantalón Drill',
        'descripcion': 'Pantalón casual drill',
        'tamano': '36',
        'precio': 60.00,
      },

      // BLUSAS
      {
        'nombre': 'Blusa Casual',
        'descripcion': 'Blusa manga corta',
        'tamano': 'S',
        'precio': 40.00,
      },
      {
        'nombre': 'Blusa Casual',
        'descripcion': 'Blusa manga corta',
        'tamano': 'M',
        'precio': 40.00,
      },
      {
        'nombre': 'Blusa Casual',
        'descripcion': 'Blusa manga corta',
        'tamano': 'L',
        'precio': 40.00,
      },
      {
        'nombre': 'Blusa Casual',
        'descripcion': 'Blusa manga corta',
        'tamano': 'XL',
        'precio': 40.00,
      },

      {
        'nombre': 'Blusa Elegante',
        'descripcion': 'Blusa de seda',
        'tamano': 'S',
        'precio': 65.00,
      },
      {
        'nombre': 'Blusa Elegante',
        'descripcion': 'Blusa de seda',
        'tamano': 'M',
        'precio': 65.00,
      },
      {
        'nombre': 'Blusa Elegante',
        'descripcion': 'Blusa de seda',
        'tamano': 'L',
        'precio': 65.00,
      },
      {
        'nombre': 'Blusa Elegante',
        'descripcion': 'Blusa de seda',
        'tamano': 'XL',
        'precio': 65.00,
      },
    ];

    for (var p in productos) {
      await productosRepo.crearProducto(
        nombre: p['nombre'] as String,
        descripcion: p['descripcion'] as String?,
        tamano: p['tamano'] as String,
        precioVenta: p['precio'] as double,
        stock: 0, // Stock inicial en 0
      );
    }

    print('   ✓ ${productos.length} productos creados con stock inicial en 0');
  }
}
