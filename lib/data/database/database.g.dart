// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idClienteMeta = const VerificationMeta(
    'idCliente',
  );
  @override
  late final GeneratedColumn<int> idCliente = GeneratedColumn<int>(
    'id_cliente',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idCliente,
    nombre,
    direccion,
    telefono,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_cliente')) {
      context.handle(
        _idClienteMeta,
        idCliente.isAcceptableOrUnknown(data['id_cliente']!, _idClienteMeta),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idCliente};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      idCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_cliente'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int idCliente;
  final String nombre;
  final String direccion;
  final String telefono;
  const Cliente({
    required this.idCliente,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_cliente'] = Variable<int>(idCliente);
    map['nombre'] = Variable<String>(nombre);
    map['direccion'] = Variable<String>(direccion);
    map['telefono'] = Variable<String>(telefono);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      idCliente: Value(idCliente),
      nombre: Value(nombre),
      direccion: Value(direccion),
      telefono: Value(telefono),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      idCliente: serializer.fromJson<int>(json['idCliente']),
      nombre: serializer.fromJson<String>(json['nombre']),
      direccion: serializer.fromJson<String>(json['direccion']),
      telefono: serializer.fromJson<String>(json['telefono']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idCliente': serializer.toJson<int>(idCliente),
      'nombre': serializer.toJson<String>(nombre),
      'direccion': serializer.toJson<String>(direccion),
      'telefono': serializer.toJson<String>(telefono),
    };
  }

  Cliente copyWith({
    int? idCliente,
    String? nombre,
    String? direccion,
    String? telefono,
  }) => Cliente(
    idCliente: idCliente ?? this.idCliente,
    nombre: nombre ?? this.nombre,
    direccion: direccion ?? this.direccion,
    telefono: telefono ?? this.telefono,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      idCliente: data.idCliente.present ? data.idCliente.value : this.idCliente,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('idCliente: $idCliente, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idCliente, nombre, direccion, telefono);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.idCliente == this.idCliente &&
          other.nombre == this.nombre &&
          other.direccion == this.direccion &&
          other.telefono == this.telefono);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> idCliente;
  final Value<String> nombre;
  final Value<String> direccion;
  final Value<String> telefono;
  const ClientesCompanion({
    this.idCliente = const Value.absent(),
    this.nombre = const Value.absent(),
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.idCliente = const Value.absent(),
    required String nombre,
    required String direccion,
    required String telefono,
  }) : nombre = Value(nombre),
       direccion = Value(direccion),
       telefono = Value(telefono);
  static Insertable<Cliente> custom({
    Expression<int>? idCliente,
    Expression<String>? nombre,
    Expression<String>? direccion,
    Expression<String>? telefono,
  }) {
    return RawValuesInsertable({
      if (idCliente != null) 'id_cliente': idCliente,
      if (nombre != null) 'nombre': nombre,
      if (direccion != null) 'direccion': direccion,
      if (telefono != null) 'telefono': telefono,
    });
  }

  ClientesCompanion copyWith({
    Value<int>? idCliente,
    Value<String>? nombre,
    Value<String>? direccion,
    Value<String>? telefono,
  }) {
    return ClientesCompanion(
      idCliente: idCliente ?? this.idCliente,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idCliente.present) {
      map['id_cliente'] = Variable<int>(idCliente.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('idCliente: $idCliente, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono')
          ..write(')'))
        .toString();
  }
}

class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idProductoMeta = const VerificationMeta(
    'idProducto',
  );
  @override
  late final GeneratedColumn<int> idProducto = GeneratedColumn<int>(
    'id_producto',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tamanoMeta = const VerificationMeta('tamano');
  @override
  late final GeneratedColumn<String> tamano = GeneratedColumn<String>(
    'tamano',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioVentaMeta = const VerificationMeta(
    'precioVenta',
  );
  @override
  late final GeneratedColumn<double> precioVenta = GeneratedColumn<double>(
    'precio_venta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idProducto,
    nombre,
    descripcion,
    tamano,
    precioVenta,
    stock,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Producto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_producto')) {
      context.handle(
        _idProductoMeta,
        idProducto.isAcceptableOrUnknown(data['id_producto']!, _idProductoMeta),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('tamano')) {
      context.handle(
        _tamanoMeta,
        tamano.isAcceptableOrUnknown(data['tamano']!, _tamanoMeta),
      );
    } else if (isInserting) {
      context.missing(_tamanoMeta);
    }
    if (data.containsKey('precio_venta')) {
      context.handle(
        _precioVentaMeta,
        precioVenta.isAcceptableOrUnknown(
          data['precio_venta']!,
          _precioVentaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioVentaMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idProducto};
  @override
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto(
      idProducto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_producto'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      tamano: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tamano'],
      )!,
      precioVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_venta'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int idProducto;
  final String nombre;
  final String? descripcion;
  final String tamano;
  final double precioVenta;
  final int stock;
  const Producto({
    required this.idProducto,
    required this.nombre,
    this.descripcion,
    required this.tamano,
    required this.precioVenta,
    required this.stock,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_producto'] = Variable<int>(idProducto);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['tamano'] = Variable<String>(tamano);
    map['precio_venta'] = Variable<double>(precioVenta);
    map['stock'] = Variable<int>(stock);
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      idProducto: Value(idProducto),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      tamano: Value(tamano),
      precioVenta: Value(precioVenta),
      stock: Value(stock),
    );
  }

  factory Producto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      idProducto: serializer.fromJson<int>(json['idProducto']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      tamano: serializer.fromJson<String>(json['tamano']),
      precioVenta: serializer.fromJson<double>(json['precioVenta']),
      stock: serializer.fromJson<int>(json['stock']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idProducto': serializer.toJson<int>(idProducto),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'tamano': serializer.toJson<String>(tamano),
      'precioVenta': serializer.toJson<double>(precioVenta),
      'stock': serializer.toJson<int>(stock),
    };
  }

  Producto copyWith({
    int? idProducto,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    String? tamano,
    double? precioVenta,
    int? stock,
  }) => Producto(
    idProducto: idProducto ?? this.idProducto,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    tamano: tamano ?? this.tamano,
    precioVenta: precioVenta ?? this.precioVenta,
    stock: stock ?? this.stock,
  );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      idProducto: data.idProducto.present
          ? data.idProducto.value
          : this.idProducto,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      tamano: data.tamano.present ? data.tamano.value : this.tamano,
      precioVenta: data.precioVenta.present
          ? data.precioVenta.value
          : this.precioVenta,
      stock: data.stock.present ? data.stock.value : this.stock,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('idProducto: $idProducto, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('tamano: $tamano, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('stock: $stock')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idProducto, nombre, descripcion, tamano, precioVenta, stock);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.idProducto == this.idProducto &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.tamano == this.tamano &&
          other.precioVenta == this.precioVenta &&
          other.stock == this.stock);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> idProducto;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<String> tamano;
  final Value<double> precioVenta;
  final Value<int> stock;
  const ProductosCompanion({
    this.idProducto = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.tamano = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.stock = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.idProducto = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    required String tamano,
    required double precioVenta,
    this.stock = const Value.absent(),
  }) : nombre = Value(nombre),
       tamano = Value(tamano),
       precioVenta = Value(precioVenta);
  static Insertable<Producto> custom({
    Expression<int>? idProducto,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? tamano,
    Expression<double>? precioVenta,
    Expression<int>? stock,
  }) {
    return RawValuesInsertable({
      if (idProducto != null) 'id_producto': idProducto,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (tamano != null) 'tamano': tamano,
      if (precioVenta != null) 'precio_venta': precioVenta,
      if (stock != null) 'stock': stock,
    });
  }

  ProductosCompanion copyWith({
    Value<int>? idProducto,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<String>? tamano,
    Value<double>? precioVenta,
    Value<int>? stock,
  }) {
    return ProductosCompanion(
      idProducto: idProducto ?? this.idProducto,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tamano: tamano ?? this.tamano,
      precioVenta: precioVenta ?? this.precioVenta,
      stock: stock ?? this.stock,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idProducto.present) {
      map['id_producto'] = Variable<int>(idProducto.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (tamano.present) {
      map['tamano'] = Variable<String>(tamano.value);
    }
    if (precioVenta.present) {
      map['precio_venta'] = Variable<double>(precioVenta.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('idProducto: $idProducto, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('tamano: $tamano, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('stock: $stock')
          ..write(')'))
        .toString();
  }
}

class $ProveedoresTable extends Proveedores
    with TableInfo<$ProveedoresTable, Proveedore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProveedoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idProveedorMeta = const VerificationMeta(
    'idProveedor',
  );
  @override
  late final GeneratedColumn<int> idProveedor = GeneratedColumn<int>(
    'id_proveedor',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idProveedor,
    nombre,
    direccion,
    telefono,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proveedores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Proveedore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_proveedor')) {
      context.handle(
        _idProveedorMeta,
        idProveedor.isAcceptableOrUnknown(
          data['id_proveedor']!,
          _idProveedorMeta,
        ),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idProveedor};
  @override
  Proveedore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Proveedore(
      idProveedor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_proveedor'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      )!,
    );
  }

  @override
  $ProveedoresTable createAlias(String alias) {
    return $ProveedoresTable(attachedDatabase, alias);
  }
}

class Proveedore extends DataClass implements Insertable<Proveedore> {
  final int idProveedor;
  final String nombre;
  final String direccion;
  final String telefono;
  const Proveedore({
    required this.idProveedor,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_proveedor'] = Variable<int>(idProveedor);
    map['nombre'] = Variable<String>(nombre);
    map['direccion'] = Variable<String>(direccion);
    map['telefono'] = Variable<String>(telefono);
    return map;
  }

  ProveedoresCompanion toCompanion(bool nullToAbsent) {
    return ProveedoresCompanion(
      idProveedor: Value(idProveedor),
      nombre: Value(nombre),
      direccion: Value(direccion),
      telefono: Value(telefono),
    );
  }

  factory Proveedore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Proveedore(
      idProveedor: serializer.fromJson<int>(json['idProveedor']),
      nombre: serializer.fromJson<String>(json['nombre']),
      direccion: serializer.fromJson<String>(json['direccion']),
      telefono: serializer.fromJson<String>(json['telefono']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idProveedor': serializer.toJson<int>(idProveedor),
      'nombre': serializer.toJson<String>(nombre),
      'direccion': serializer.toJson<String>(direccion),
      'telefono': serializer.toJson<String>(telefono),
    };
  }

  Proveedore copyWith({
    int? idProveedor,
    String? nombre,
    String? direccion,
    String? telefono,
  }) => Proveedore(
    idProveedor: idProveedor ?? this.idProveedor,
    nombre: nombre ?? this.nombre,
    direccion: direccion ?? this.direccion,
    telefono: telefono ?? this.telefono,
  );
  Proveedore copyWithCompanion(ProveedoresCompanion data) {
    return Proveedore(
      idProveedor: data.idProveedor.present
          ? data.idProveedor.value
          : this.idProveedor,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Proveedore(')
          ..write('idProveedor: $idProveedor, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idProveedor, nombre, direccion, telefono);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Proveedore &&
          other.idProveedor == this.idProveedor &&
          other.nombre == this.nombre &&
          other.direccion == this.direccion &&
          other.telefono == this.telefono);
}

class ProveedoresCompanion extends UpdateCompanion<Proveedore> {
  final Value<int> idProveedor;
  final Value<String> nombre;
  final Value<String> direccion;
  final Value<String> telefono;
  const ProveedoresCompanion({
    this.idProveedor = const Value.absent(),
    this.nombre = const Value.absent(),
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
  });
  ProveedoresCompanion.insert({
    this.idProveedor = const Value.absent(),
    required String nombre,
    required String direccion,
    required String telefono,
  }) : nombre = Value(nombre),
       direccion = Value(direccion),
       telefono = Value(telefono);
  static Insertable<Proveedore> custom({
    Expression<int>? idProveedor,
    Expression<String>? nombre,
    Expression<String>? direccion,
    Expression<String>? telefono,
  }) {
    return RawValuesInsertable({
      if (idProveedor != null) 'id_proveedor': idProveedor,
      if (nombre != null) 'nombre': nombre,
      if (direccion != null) 'direccion': direccion,
      if (telefono != null) 'telefono': telefono,
    });
  }

  ProveedoresCompanion copyWith({
    Value<int>? idProveedor,
    Value<String>? nombre,
    Value<String>? direccion,
    Value<String>? telefono,
  }) {
    return ProveedoresCompanion(
      idProveedor: idProveedor ?? this.idProveedor,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idProveedor.present) {
      map['id_proveedor'] = Variable<int>(idProveedor.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProveedoresCompanion(')
          ..write('idProveedor: $idProveedor, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono')
          ..write(')'))
        .toString();
  }
}

class $IngresosMercaderiaTable extends IngresosMercaderia
    with TableInfo<$IngresosMercaderiaTable, IngresosMercaderiaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngresosMercaderiaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idIngresoMeta = const VerificationMeta(
    'idIngreso',
  );
  @override
  late final GeneratedColumn<int> idIngreso = GeneratedColumn<int>(
    'id_ingreso',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idProveedorMeta = const VerificationMeta(
    'idProveedor',
  );
  @override
  late final GeneratedColumn<int> idProveedor = GeneratedColumn<int>(
    'id_proveedor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES proveedores (id_proveedor)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalInversionMeta = const VerificationMeta(
    'totalInversion',
  );
  @override
  late final GeneratedColumn<double> totalInversion = GeneratedColumn<double>(
    'total_inversion',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idIngreso,
    idProveedor,
    fecha,
    totalInversion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingresos_mercaderia';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngresosMercaderiaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_ingreso')) {
      context.handle(
        _idIngresoMeta,
        idIngreso.isAcceptableOrUnknown(data['id_ingreso']!, _idIngresoMeta),
      );
    }
    if (data.containsKey('id_proveedor')) {
      context.handle(
        _idProveedorMeta,
        idProveedor.isAcceptableOrUnknown(
          data['id_proveedor']!,
          _idProveedorMeta,
        ),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('total_inversion')) {
      context.handle(
        _totalInversionMeta,
        totalInversion.isAcceptableOrUnknown(
          data['total_inversion']!,
          _totalInversionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalInversionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idIngreso};
  @override
  IngresosMercaderiaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngresosMercaderiaData(
      idIngreso: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_ingreso'],
      )!,
      idProveedor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_proveedor'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      totalInversion: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_inversion'],
      )!,
    );
  }

  @override
  $IngresosMercaderiaTable createAlias(String alias) {
    return $IngresosMercaderiaTable(attachedDatabase, alias);
  }
}

class IngresosMercaderiaData extends DataClass
    implements Insertable<IngresosMercaderiaData> {
  final int idIngreso;
  final int? idProveedor;
  final DateTime fecha;
  final double totalInversion;
  const IngresosMercaderiaData({
    required this.idIngreso,
    this.idProveedor,
    required this.fecha,
    required this.totalInversion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_ingreso'] = Variable<int>(idIngreso);
    if (!nullToAbsent || idProveedor != null) {
      map['id_proveedor'] = Variable<int>(idProveedor);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    map['total_inversion'] = Variable<double>(totalInversion);
    return map;
  }

  IngresosMercaderiaCompanion toCompanion(bool nullToAbsent) {
    return IngresosMercaderiaCompanion(
      idIngreso: Value(idIngreso),
      idProveedor: idProveedor == null && nullToAbsent
          ? const Value.absent()
          : Value(idProveedor),
      fecha: Value(fecha),
      totalInversion: Value(totalInversion),
    );
  }

  factory IngresosMercaderiaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngresosMercaderiaData(
      idIngreso: serializer.fromJson<int>(json['idIngreso']),
      idProveedor: serializer.fromJson<int?>(json['idProveedor']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      totalInversion: serializer.fromJson<double>(json['totalInversion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idIngreso': serializer.toJson<int>(idIngreso),
      'idProveedor': serializer.toJson<int?>(idProveedor),
      'fecha': serializer.toJson<DateTime>(fecha),
      'totalInversion': serializer.toJson<double>(totalInversion),
    };
  }

  IngresosMercaderiaData copyWith({
    int? idIngreso,
    Value<int?> idProveedor = const Value.absent(),
    DateTime? fecha,
    double? totalInversion,
  }) => IngresosMercaderiaData(
    idIngreso: idIngreso ?? this.idIngreso,
    idProveedor: idProveedor.present ? idProveedor.value : this.idProveedor,
    fecha: fecha ?? this.fecha,
    totalInversion: totalInversion ?? this.totalInversion,
  );
  IngresosMercaderiaData copyWithCompanion(IngresosMercaderiaCompanion data) {
    return IngresosMercaderiaData(
      idIngreso: data.idIngreso.present ? data.idIngreso.value : this.idIngreso,
      idProveedor: data.idProveedor.present
          ? data.idProveedor.value
          : this.idProveedor,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      totalInversion: data.totalInversion.present
          ? data.totalInversion.value
          : this.totalInversion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngresosMercaderiaData(')
          ..write('idIngreso: $idIngreso, ')
          ..write('idProveedor: $idProveedor, ')
          ..write('fecha: $fecha, ')
          ..write('totalInversion: $totalInversion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idIngreso, idProveedor, fecha, totalInversion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngresosMercaderiaData &&
          other.idIngreso == this.idIngreso &&
          other.idProveedor == this.idProveedor &&
          other.fecha == this.fecha &&
          other.totalInversion == this.totalInversion);
}

class IngresosMercaderiaCompanion
    extends UpdateCompanion<IngresosMercaderiaData> {
  final Value<int> idIngreso;
  final Value<int?> idProveedor;
  final Value<DateTime> fecha;
  final Value<double> totalInversion;
  const IngresosMercaderiaCompanion({
    this.idIngreso = const Value.absent(),
    this.idProveedor = const Value.absent(),
    this.fecha = const Value.absent(),
    this.totalInversion = const Value.absent(),
  });
  IngresosMercaderiaCompanion.insert({
    this.idIngreso = const Value.absent(),
    this.idProveedor = const Value.absent(),
    required DateTime fecha,
    required double totalInversion,
  }) : fecha = Value(fecha),
       totalInversion = Value(totalInversion);
  static Insertable<IngresosMercaderiaData> custom({
    Expression<int>? idIngreso,
    Expression<int>? idProveedor,
    Expression<DateTime>? fecha,
    Expression<double>? totalInversion,
  }) {
    return RawValuesInsertable({
      if (idIngreso != null) 'id_ingreso': idIngreso,
      if (idProveedor != null) 'id_proveedor': idProveedor,
      if (fecha != null) 'fecha': fecha,
      if (totalInversion != null) 'total_inversion': totalInversion,
    });
  }

  IngresosMercaderiaCompanion copyWith({
    Value<int>? idIngreso,
    Value<int?>? idProveedor,
    Value<DateTime>? fecha,
    Value<double>? totalInversion,
  }) {
    return IngresosMercaderiaCompanion(
      idIngreso: idIngreso ?? this.idIngreso,
      idProveedor: idProveedor ?? this.idProveedor,
      fecha: fecha ?? this.fecha,
      totalInversion: totalInversion ?? this.totalInversion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idIngreso.present) {
      map['id_ingreso'] = Variable<int>(idIngreso.value);
    }
    if (idProveedor.present) {
      map['id_proveedor'] = Variable<int>(idProveedor.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (totalInversion.present) {
      map['total_inversion'] = Variable<double>(totalInversion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngresosMercaderiaCompanion(')
          ..write('idIngreso: $idIngreso, ')
          ..write('idProveedor: $idProveedor, ')
          ..write('fecha: $fecha, ')
          ..write('totalInversion: $totalInversion')
          ..write(')'))
        .toString();
  }
}

class $IngresosDetalleTable extends IngresosDetalle
    with TableInfo<$IngresosDetalleTable, IngresosDetalleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngresosDetalleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idDetalleIngresoMeta = const VerificationMeta(
    'idDetalleIngreso',
  );
  @override
  late final GeneratedColumn<int> idDetalleIngreso = GeneratedColumn<int>(
    'id_detalle_ingreso',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idIngresoMeta = const VerificationMeta(
    'idIngreso',
  );
  @override
  late final GeneratedColumn<int> idIngreso = GeneratedColumn<int>(
    'id_ingreso',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingresos_mercaderia (id_ingreso) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idProductoMeta = const VerificationMeta(
    'idProducto',
  );
  @override
  late final GeneratedColumn<int> idProducto = GeneratedColumn<int>(
    'id_producto',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id_producto)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costoUnitarioMeta = const VerificationMeta(
    'costoUnitario',
  );
  @override
  late final GeneratedColumn<double> costoUnitario = GeneratedColumn<double>(
    'costo_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idDetalleIngreso,
    idIngreso,
    idProducto,
    cantidad,
    costoUnitario,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingresos_detalle';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngresosDetalleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_detalle_ingreso')) {
      context.handle(
        _idDetalleIngresoMeta,
        idDetalleIngreso.isAcceptableOrUnknown(
          data['id_detalle_ingreso']!,
          _idDetalleIngresoMeta,
        ),
      );
    }
    if (data.containsKey('id_ingreso')) {
      context.handle(
        _idIngresoMeta,
        idIngreso.isAcceptableOrUnknown(data['id_ingreso']!, _idIngresoMeta),
      );
    } else if (isInserting) {
      context.missing(_idIngresoMeta);
    }
    if (data.containsKey('id_producto')) {
      context.handle(
        _idProductoMeta,
        idProducto.isAcceptableOrUnknown(data['id_producto']!, _idProductoMeta),
      );
    } else if (isInserting) {
      context.missing(_idProductoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('costo_unitario')) {
      context.handle(
        _costoUnitarioMeta,
        costoUnitario.isAcceptableOrUnknown(
          data['costo_unitario']!,
          _costoUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoUnitarioMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idDetalleIngreso};
  @override
  IngresosDetalleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngresosDetalleData(
      idDetalleIngreso: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_detalle_ingreso'],
      )!,
      idIngreso: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_ingreso'],
      )!,
      idProducto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_producto'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      costoUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}costo_unitario'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $IngresosDetalleTable createAlias(String alias) {
    return $IngresosDetalleTable(attachedDatabase, alias);
  }
}

class IngresosDetalleData extends DataClass
    implements Insertable<IngresosDetalleData> {
  final int idDetalleIngreso;
  final int idIngreso;
  final int idProducto;
  final int cantidad;
  final double costoUnitario;
  final double subtotal;
  const IngresosDetalleData({
    required this.idDetalleIngreso,
    required this.idIngreso,
    required this.idProducto,
    required this.cantidad,
    required this.costoUnitario,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_detalle_ingreso'] = Variable<int>(idDetalleIngreso);
    map['id_ingreso'] = Variable<int>(idIngreso);
    map['id_producto'] = Variable<int>(idProducto);
    map['cantidad'] = Variable<int>(cantidad);
    map['costo_unitario'] = Variable<double>(costoUnitario);
    map['subtotal'] = Variable<double>(subtotal);
    return map;
  }

  IngresosDetalleCompanion toCompanion(bool nullToAbsent) {
    return IngresosDetalleCompanion(
      idDetalleIngreso: Value(idDetalleIngreso),
      idIngreso: Value(idIngreso),
      idProducto: Value(idProducto),
      cantidad: Value(cantidad),
      costoUnitario: Value(costoUnitario),
      subtotal: Value(subtotal),
    );
  }

  factory IngresosDetalleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngresosDetalleData(
      idDetalleIngreso: serializer.fromJson<int>(json['idDetalleIngreso']),
      idIngreso: serializer.fromJson<int>(json['idIngreso']),
      idProducto: serializer.fromJson<int>(json['idProducto']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      costoUnitario: serializer.fromJson<double>(json['costoUnitario']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idDetalleIngreso': serializer.toJson<int>(idDetalleIngreso),
      'idIngreso': serializer.toJson<int>(idIngreso),
      'idProducto': serializer.toJson<int>(idProducto),
      'cantidad': serializer.toJson<int>(cantidad),
      'costoUnitario': serializer.toJson<double>(costoUnitario),
      'subtotal': serializer.toJson<double>(subtotal),
    };
  }

  IngresosDetalleData copyWith({
    int? idDetalleIngreso,
    int? idIngreso,
    int? idProducto,
    int? cantidad,
    double? costoUnitario,
    double? subtotal,
  }) => IngresosDetalleData(
    idDetalleIngreso: idDetalleIngreso ?? this.idDetalleIngreso,
    idIngreso: idIngreso ?? this.idIngreso,
    idProducto: idProducto ?? this.idProducto,
    cantidad: cantidad ?? this.cantidad,
    costoUnitario: costoUnitario ?? this.costoUnitario,
    subtotal: subtotal ?? this.subtotal,
  );
  IngresosDetalleData copyWithCompanion(IngresosDetalleCompanion data) {
    return IngresosDetalleData(
      idDetalleIngreso: data.idDetalleIngreso.present
          ? data.idDetalleIngreso.value
          : this.idDetalleIngreso,
      idIngreso: data.idIngreso.present ? data.idIngreso.value : this.idIngreso,
      idProducto: data.idProducto.present
          ? data.idProducto.value
          : this.idProducto,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      costoUnitario: data.costoUnitario.present
          ? data.costoUnitario.value
          : this.costoUnitario,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngresosDetalleData(')
          ..write('idDetalleIngreso: $idDetalleIngreso, ')
          ..write('idIngreso: $idIngreso, ')
          ..write('idProducto: $idProducto, ')
          ..write('cantidad: $cantidad, ')
          ..write('costoUnitario: $costoUnitario, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idDetalleIngreso,
    idIngreso,
    idProducto,
    cantidad,
    costoUnitario,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngresosDetalleData &&
          other.idDetalleIngreso == this.idDetalleIngreso &&
          other.idIngreso == this.idIngreso &&
          other.idProducto == this.idProducto &&
          other.cantidad == this.cantidad &&
          other.costoUnitario == this.costoUnitario &&
          other.subtotal == this.subtotal);
}

class IngresosDetalleCompanion extends UpdateCompanion<IngresosDetalleData> {
  final Value<int> idDetalleIngreso;
  final Value<int> idIngreso;
  final Value<int> idProducto;
  final Value<int> cantidad;
  final Value<double> costoUnitario;
  final Value<double> subtotal;
  const IngresosDetalleCompanion({
    this.idDetalleIngreso = const Value.absent(),
    this.idIngreso = const Value.absent(),
    this.idProducto = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.costoUnitario = const Value.absent(),
    this.subtotal = const Value.absent(),
  });
  IngresosDetalleCompanion.insert({
    this.idDetalleIngreso = const Value.absent(),
    required int idIngreso,
    required int idProducto,
    required int cantidad,
    required double costoUnitario,
    required double subtotal,
  }) : idIngreso = Value(idIngreso),
       idProducto = Value(idProducto),
       cantidad = Value(cantidad),
       costoUnitario = Value(costoUnitario),
       subtotal = Value(subtotal);
  static Insertable<IngresosDetalleData> custom({
    Expression<int>? idDetalleIngreso,
    Expression<int>? idIngreso,
    Expression<int>? idProducto,
    Expression<int>? cantidad,
    Expression<double>? costoUnitario,
    Expression<double>? subtotal,
  }) {
    return RawValuesInsertable({
      if (idDetalleIngreso != null) 'id_detalle_ingreso': idDetalleIngreso,
      if (idIngreso != null) 'id_ingreso': idIngreso,
      if (idProducto != null) 'id_producto': idProducto,
      if (cantidad != null) 'cantidad': cantidad,
      if (costoUnitario != null) 'costo_unitario': costoUnitario,
      if (subtotal != null) 'subtotal': subtotal,
    });
  }

  IngresosDetalleCompanion copyWith({
    Value<int>? idDetalleIngreso,
    Value<int>? idIngreso,
    Value<int>? idProducto,
    Value<int>? cantidad,
    Value<double>? costoUnitario,
    Value<double>? subtotal,
  }) {
    return IngresosDetalleCompanion(
      idDetalleIngreso: idDetalleIngreso ?? this.idDetalleIngreso,
      idIngreso: idIngreso ?? this.idIngreso,
      idProducto: idProducto ?? this.idProducto,
      cantidad: cantidad ?? this.cantidad,
      costoUnitario: costoUnitario ?? this.costoUnitario,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idDetalleIngreso.present) {
      map['id_detalle_ingreso'] = Variable<int>(idDetalleIngreso.value);
    }
    if (idIngreso.present) {
      map['id_ingreso'] = Variable<int>(idIngreso.value);
    }
    if (idProducto.present) {
      map['id_producto'] = Variable<int>(idProducto.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (costoUnitario.present) {
      map['costo_unitario'] = Variable<double>(costoUnitario.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngresosDetalleCompanion(')
          ..write('idDetalleIngreso: $idDetalleIngreso, ')
          ..write('idIngreso: $idIngreso, ')
          ..write('idProducto: $idProducto, ')
          ..write('cantidad: $cantidad, ')
          ..write('costoUnitario: $costoUnitario, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }
}

class $VentasTable extends Ventas with TableInfo<$VentasTable, Venta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idVentaMeta = const VerificationMeta(
    'idVenta',
  );
  @override
  late final GeneratedColumn<int> idVenta = GeneratedColumn<int>(
    'id_venta',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idClienteMeta = const VerificationMeta(
    'idCliente',
  );
  @override
  late final GeneratedColumn<int> idCliente = GeneratedColumn<int>(
    'id_cliente',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id_cliente)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _esCreditoMeta = const VerificationMeta(
    'esCredito',
  );
  @override
  late final GeneratedColumn<bool> esCredito = GeneratedColumn<bool>(
    'es_credito',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_credito" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idVenta,
    idCliente,
    fecha,
    total,
    esCredito,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Venta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_venta')) {
      context.handle(
        _idVentaMeta,
        idVenta.isAcceptableOrUnknown(data['id_venta']!, _idVentaMeta),
      );
    }
    if (data.containsKey('id_cliente')) {
      context.handle(
        _idClienteMeta,
        idCliente.isAcceptableOrUnknown(data['id_cliente']!, _idClienteMeta),
      );
    } else if (isInserting) {
      context.missing(_idClienteMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('es_credito')) {
      context.handle(
        _esCreditoMeta,
        esCredito.isAcceptableOrUnknown(data['es_credito']!, _esCreditoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idVenta};
  @override
  Venta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Venta(
      idVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_venta'],
      )!,
      idCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_cliente'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      esCredito: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_credito'],
      )!,
    );
  }

  @override
  $VentasTable createAlias(String alias) {
    return $VentasTable(attachedDatabase, alias);
  }
}

class Venta extends DataClass implements Insertable<Venta> {
  final int idVenta;
  final int idCliente;
  final DateTime fecha;
  final double total;
  final bool esCredito;
  const Venta({
    required this.idVenta,
    required this.idCliente,
    required this.fecha,
    required this.total,
    required this.esCredito,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_venta'] = Variable<int>(idVenta);
    map['id_cliente'] = Variable<int>(idCliente);
    map['fecha'] = Variable<DateTime>(fecha);
    map['total'] = Variable<double>(total);
    map['es_credito'] = Variable<bool>(esCredito);
    return map;
  }

  VentasCompanion toCompanion(bool nullToAbsent) {
    return VentasCompanion(
      idVenta: Value(idVenta),
      idCliente: Value(idCliente),
      fecha: Value(fecha),
      total: Value(total),
      esCredito: Value(esCredito),
    );
  }

  factory Venta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Venta(
      idVenta: serializer.fromJson<int>(json['idVenta']),
      idCliente: serializer.fromJson<int>(json['idCliente']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      total: serializer.fromJson<double>(json['total']),
      esCredito: serializer.fromJson<bool>(json['esCredito']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idVenta': serializer.toJson<int>(idVenta),
      'idCliente': serializer.toJson<int>(idCliente),
      'fecha': serializer.toJson<DateTime>(fecha),
      'total': serializer.toJson<double>(total),
      'esCredito': serializer.toJson<bool>(esCredito),
    };
  }

  Venta copyWith({
    int? idVenta,
    int? idCliente,
    DateTime? fecha,
    double? total,
    bool? esCredito,
  }) => Venta(
    idVenta: idVenta ?? this.idVenta,
    idCliente: idCliente ?? this.idCliente,
    fecha: fecha ?? this.fecha,
    total: total ?? this.total,
    esCredito: esCredito ?? this.esCredito,
  );
  Venta copyWithCompanion(VentasCompanion data) {
    return Venta(
      idVenta: data.idVenta.present ? data.idVenta.value : this.idVenta,
      idCliente: data.idCliente.present ? data.idCliente.value : this.idCliente,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      total: data.total.present ? data.total.value : this.total,
      esCredito: data.esCredito.present ? data.esCredito.value : this.esCredito,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Venta(')
          ..write('idVenta: $idVenta, ')
          ..write('idCliente: $idCliente, ')
          ..write('fecha: $fecha, ')
          ..write('total: $total, ')
          ..write('esCredito: $esCredito')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idVenta, idCliente, fecha, total, esCredito);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Venta &&
          other.idVenta == this.idVenta &&
          other.idCliente == this.idCliente &&
          other.fecha == this.fecha &&
          other.total == this.total &&
          other.esCredito == this.esCredito);
}

class VentasCompanion extends UpdateCompanion<Venta> {
  final Value<int> idVenta;
  final Value<int> idCliente;
  final Value<DateTime> fecha;
  final Value<double> total;
  final Value<bool> esCredito;
  const VentasCompanion({
    this.idVenta = const Value.absent(),
    this.idCliente = const Value.absent(),
    this.fecha = const Value.absent(),
    this.total = const Value.absent(),
    this.esCredito = const Value.absent(),
  });
  VentasCompanion.insert({
    this.idVenta = const Value.absent(),
    required int idCliente,
    required DateTime fecha,
    required double total,
    this.esCredito = const Value.absent(),
  }) : idCliente = Value(idCliente),
       fecha = Value(fecha),
       total = Value(total);
  static Insertable<Venta> custom({
    Expression<int>? idVenta,
    Expression<int>? idCliente,
    Expression<DateTime>? fecha,
    Expression<double>? total,
    Expression<bool>? esCredito,
  }) {
    return RawValuesInsertable({
      if (idVenta != null) 'id_venta': idVenta,
      if (idCliente != null) 'id_cliente': idCliente,
      if (fecha != null) 'fecha': fecha,
      if (total != null) 'total': total,
      if (esCredito != null) 'es_credito': esCredito,
    });
  }

  VentasCompanion copyWith({
    Value<int>? idVenta,
    Value<int>? idCliente,
    Value<DateTime>? fecha,
    Value<double>? total,
    Value<bool>? esCredito,
  }) {
    return VentasCompanion(
      idVenta: idVenta ?? this.idVenta,
      idCliente: idCliente ?? this.idCliente,
      fecha: fecha ?? this.fecha,
      total: total ?? this.total,
      esCredito: esCredito ?? this.esCredito,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idVenta.present) {
      map['id_venta'] = Variable<int>(idVenta.value);
    }
    if (idCliente.present) {
      map['id_cliente'] = Variable<int>(idCliente.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (esCredito.present) {
      map['es_credito'] = Variable<bool>(esCredito.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasCompanion(')
          ..write('idVenta: $idVenta, ')
          ..write('idCliente: $idCliente, ')
          ..write('fecha: $fecha, ')
          ..write('total: $total, ')
          ..write('esCredito: $esCredito')
          ..write(')'))
        .toString();
  }
}

class $VentasDetalleTable extends VentasDetalle
    with TableInfo<$VentasDetalleTable, VentasDetalleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasDetalleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idDetalleMeta = const VerificationMeta(
    'idDetalle',
  );
  @override
  late final GeneratedColumn<int> idDetalle = GeneratedColumn<int>(
    'id_detalle',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idVentaMeta = const VerificationMeta(
    'idVenta',
  );
  @override
  late final GeneratedColumn<int> idVenta = GeneratedColumn<int>(
    'id_venta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ventas (id_venta) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _idProductoMeta = const VerificationMeta(
    'idProducto',
  );
  @override
  late final GeneratedColumn<int> idProducto = GeneratedColumn<int>(
    'id_producto',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id_producto)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idDetalle,
    idVenta,
    idProducto,
    cantidad,
    precioUnitario,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas_detalle';
  @override
  VerificationContext validateIntegrity(
    Insertable<VentasDetalleData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_detalle')) {
      context.handle(
        _idDetalleMeta,
        idDetalle.isAcceptableOrUnknown(data['id_detalle']!, _idDetalleMeta),
      );
    }
    if (data.containsKey('id_venta')) {
      context.handle(
        _idVentaMeta,
        idVenta.isAcceptableOrUnknown(data['id_venta']!, _idVentaMeta),
      );
    } else if (isInserting) {
      context.missing(_idVentaMeta);
    }
    if (data.containsKey('id_producto')) {
      context.handle(
        _idProductoMeta,
        idProducto.isAcceptableOrUnknown(data['id_producto']!, _idProductoMeta),
      );
    } else if (isInserting) {
      context.missing(_idProductoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idDetalle};
  @override
  VentasDetalleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VentasDetalleData(
      idDetalle: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_detalle'],
      )!,
      idVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_venta'],
      )!,
      idProducto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_producto'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $VentasDetalleTable createAlias(String alias) {
    return $VentasDetalleTable(attachedDatabase, alias);
  }
}

class VentasDetalleData extends DataClass
    implements Insertable<VentasDetalleData> {
  final int idDetalle;
  final int idVenta;
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  const VentasDetalleData({
    required this.idDetalle,
    required this.idVenta,
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_detalle'] = Variable<int>(idDetalle);
    map['id_venta'] = Variable<int>(idVenta);
    map['id_producto'] = Variable<int>(idProducto);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['subtotal'] = Variable<double>(subtotal);
    return map;
  }

  VentasDetalleCompanion toCompanion(bool nullToAbsent) {
    return VentasDetalleCompanion(
      idDetalle: Value(idDetalle),
      idVenta: Value(idVenta),
      idProducto: Value(idProducto),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      subtotal: Value(subtotal),
    );
  }

  factory VentasDetalleData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VentasDetalleData(
      idDetalle: serializer.fromJson<int>(json['idDetalle']),
      idVenta: serializer.fromJson<int>(json['idVenta']),
      idProducto: serializer.fromJson<int>(json['idProducto']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idDetalle': serializer.toJson<int>(idDetalle),
      'idVenta': serializer.toJson<int>(idVenta),
      'idProducto': serializer.toJson<int>(idProducto),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'subtotal': serializer.toJson<double>(subtotal),
    };
  }

  VentasDetalleData copyWith({
    int? idDetalle,
    int? idVenta,
    int? idProducto,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
  }) => VentasDetalleData(
    idDetalle: idDetalle ?? this.idDetalle,
    idVenta: idVenta ?? this.idVenta,
    idProducto: idProducto ?? this.idProducto,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    subtotal: subtotal ?? this.subtotal,
  );
  VentasDetalleData copyWithCompanion(VentasDetalleCompanion data) {
    return VentasDetalleData(
      idDetalle: data.idDetalle.present ? data.idDetalle.value : this.idDetalle,
      idVenta: data.idVenta.present ? data.idVenta.value : this.idVenta,
      idProducto: data.idProducto.present
          ? data.idProducto.value
          : this.idProducto,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VentasDetalleData(')
          ..write('idDetalle: $idDetalle, ')
          ..write('idVenta: $idVenta, ')
          ..write('idProducto: $idProducto, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idDetalle,
    idVenta,
    idProducto,
    cantidad,
    precioUnitario,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VentasDetalleData &&
          other.idDetalle == this.idDetalle &&
          other.idVenta == this.idVenta &&
          other.idProducto == this.idProducto &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.subtotal == this.subtotal);
}

class VentasDetalleCompanion extends UpdateCompanion<VentasDetalleData> {
  final Value<int> idDetalle;
  final Value<int> idVenta;
  final Value<int> idProducto;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> subtotal;
  const VentasDetalleCompanion({
    this.idDetalle = const Value.absent(),
    this.idVenta = const Value.absent(),
    this.idProducto = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.subtotal = const Value.absent(),
  });
  VentasDetalleCompanion.insert({
    this.idDetalle = const Value.absent(),
    required int idVenta,
    required int idProducto,
    required int cantidad,
    required double precioUnitario,
    required double subtotal,
  }) : idVenta = Value(idVenta),
       idProducto = Value(idProducto),
       cantidad = Value(cantidad),
       precioUnitario = Value(precioUnitario),
       subtotal = Value(subtotal);
  static Insertable<VentasDetalleData> custom({
    Expression<int>? idDetalle,
    Expression<int>? idVenta,
    Expression<int>? idProducto,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<double>? subtotal,
  }) {
    return RawValuesInsertable({
      if (idDetalle != null) 'id_detalle': idDetalle,
      if (idVenta != null) 'id_venta': idVenta,
      if (idProducto != null) 'id_producto': idProducto,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (subtotal != null) 'subtotal': subtotal,
    });
  }

  VentasDetalleCompanion copyWith({
    Value<int>? idDetalle,
    Value<int>? idVenta,
    Value<int>? idProducto,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<double>? subtotal,
  }) {
    return VentasDetalleCompanion(
      idDetalle: idDetalle ?? this.idDetalle,
      idVenta: idVenta ?? this.idVenta,
      idProducto: idProducto ?? this.idProducto,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idDetalle.present) {
      map['id_detalle'] = Variable<int>(idDetalle.value);
    }
    if (idVenta.present) {
      map['id_venta'] = Variable<int>(idVenta.value);
    }
    if (idProducto.present) {
      map['id_producto'] = Variable<int>(idProducto.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasDetalleCompanion(')
          ..write('idDetalle: $idDetalle, ')
          ..write('idVenta: $idVenta, ')
          ..write('idProducto: $idProducto, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }
}

class $CreditosTable extends Creditos with TableInfo<$CreditosTable, Credito> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idCreditoMeta = const VerificationMeta(
    'idCredito',
  );
  @override
  late final GeneratedColumn<int> idCredito = GeneratedColumn<int>(
    'id_credito',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idClienteMeta = const VerificationMeta(
    'idCliente',
  );
  @override
  late final GeneratedColumn<int> idCliente = GeneratedColumn<int>(
    'id_cliente',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id_cliente)',
    ),
  );
  static const VerificationMeta _saldoActualMeta = const VerificationMeta(
    'saldoActual',
  );
  @override
  late final GeneratedColumn<double> saldoActual = GeneratedColumn<double>(
    'saldo_actual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaUltimaActualizacionMeta =
      const VerificationMeta('fechaUltimaActualizacion');
  @override
  late final GeneratedColumn<DateTime> fechaUltimaActualizacion =
      GeneratedColumn<DateTime>(
        'fecha_ultima_actualizacion',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    idCredito,
    idCliente,
    saldoActual,
    fechaUltimaActualizacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'creditos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Credito> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_credito')) {
      context.handle(
        _idCreditoMeta,
        idCredito.isAcceptableOrUnknown(data['id_credito']!, _idCreditoMeta),
      );
    }
    if (data.containsKey('id_cliente')) {
      context.handle(
        _idClienteMeta,
        idCliente.isAcceptableOrUnknown(data['id_cliente']!, _idClienteMeta),
      );
    } else if (isInserting) {
      context.missing(_idClienteMeta);
    }
    if (data.containsKey('saldo_actual')) {
      context.handle(
        _saldoActualMeta,
        saldoActual.isAcceptableOrUnknown(
          data['saldo_actual']!,
          _saldoActualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saldoActualMeta);
    }
    if (data.containsKey('fecha_ultima_actualizacion')) {
      context.handle(
        _fechaUltimaActualizacionMeta,
        fechaUltimaActualizacion.isAcceptableOrUnknown(
          data['fecha_ultima_actualizacion']!,
          _fechaUltimaActualizacionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaUltimaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idCredito};
  @override
  Credito map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Credito(
      idCredito: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_credito'],
      )!,
      idCliente: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_cliente'],
      )!,
      saldoActual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saldo_actual'],
      )!,
      fechaUltimaActualizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_ultima_actualizacion'],
      )!,
    );
  }

  @override
  $CreditosTable createAlias(String alias) {
    return $CreditosTable(attachedDatabase, alias);
  }
}

class Credito extends DataClass implements Insertable<Credito> {
  final int idCredito;
  final int idCliente;
  final double saldoActual;
  final DateTime fechaUltimaActualizacion;
  const Credito({
    required this.idCredito,
    required this.idCliente,
    required this.saldoActual,
    required this.fechaUltimaActualizacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_credito'] = Variable<int>(idCredito);
    map['id_cliente'] = Variable<int>(idCliente);
    map['saldo_actual'] = Variable<double>(saldoActual);
    map['fecha_ultima_actualizacion'] = Variable<DateTime>(
      fechaUltimaActualizacion,
    );
    return map;
  }

  CreditosCompanion toCompanion(bool nullToAbsent) {
    return CreditosCompanion(
      idCredito: Value(idCredito),
      idCliente: Value(idCliente),
      saldoActual: Value(saldoActual),
      fechaUltimaActualizacion: Value(fechaUltimaActualizacion),
    );
  }

  factory Credito.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Credito(
      idCredito: serializer.fromJson<int>(json['idCredito']),
      idCliente: serializer.fromJson<int>(json['idCliente']),
      saldoActual: serializer.fromJson<double>(json['saldoActual']),
      fechaUltimaActualizacion: serializer.fromJson<DateTime>(
        json['fechaUltimaActualizacion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idCredito': serializer.toJson<int>(idCredito),
      'idCliente': serializer.toJson<int>(idCliente),
      'saldoActual': serializer.toJson<double>(saldoActual),
      'fechaUltimaActualizacion': serializer.toJson<DateTime>(
        fechaUltimaActualizacion,
      ),
    };
  }

  Credito copyWith({
    int? idCredito,
    int? idCliente,
    double? saldoActual,
    DateTime? fechaUltimaActualizacion,
  }) => Credito(
    idCredito: idCredito ?? this.idCredito,
    idCliente: idCliente ?? this.idCliente,
    saldoActual: saldoActual ?? this.saldoActual,
    fechaUltimaActualizacion:
        fechaUltimaActualizacion ?? this.fechaUltimaActualizacion,
  );
  Credito copyWithCompanion(CreditosCompanion data) {
    return Credito(
      idCredito: data.idCredito.present ? data.idCredito.value : this.idCredito,
      idCliente: data.idCliente.present ? data.idCliente.value : this.idCliente,
      saldoActual: data.saldoActual.present
          ? data.saldoActual.value
          : this.saldoActual,
      fechaUltimaActualizacion: data.fechaUltimaActualizacion.present
          ? data.fechaUltimaActualizacion.value
          : this.fechaUltimaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Credito(')
          ..write('idCredito: $idCredito, ')
          ..write('idCliente: $idCliente, ')
          ..write('saldoActual: $saldoActual, ')
          ..write('fechaUltimaActualizacion: $fechaUltimaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idCredito, idCliente, saldoActual, fechaUltimaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Credito &&
          other.idCredito == this.idCredito &&
          other.idCliente == this.idCliente &&
          other.saldoActual == this.saldoActual &&
          other.fechaUltimaActualizacion == this.fechaUltimaActualizacion);
}

class CreditosCompanion extends UpdateCompanion<Credito> {
  final Value<int> idCredito;
  final Value<int> idCliente;
  final Value<double> saldoActual;
  final Value<DateTime> fechaUltimaActualizacion;
  const CreditosCompanion({
    this.idCredito = const Value.absent(),
    this.idCliente = const Value.absent(),
    this.saldoActual = const Value.absent(),
    this.fechaUltimaActualizacion = const Value.absent(),
  });
  CreditosCompanion.insert({
    this.idCredito = const Value.absent(),
    required int idCliente,
    required double saldoActual,
    required DateTime fechaUltimaActualizacion,
  }) : idCliente = Value(idCliente),
       saldoActual = Value(saldoActual),
       fechaUltimaActualizacion = Value(fechaUltimaActualizacion);
  static Insertable<Credito> custom({
    Expression<int>? idCredito,
    Expression<int>? idCliente,
    Expression<double>? saldoActual,
    Expression<DateTime>? fechaUltimaActualizacion,
  }) {
    return RawValuesInsertable({
      if (idCredito != null) 'id_credito': idCredito,
      if (idCliente != null) 'id_cliente': idCliente,
      if (saldoActual != null) 'saldo_actual': saldoActual,
      if (fechaUltimaActualizacion != null)
        'fecha_ultima_actualizacion': fechaUltimaActualizacion,
    });
  }

  CreditosCompanion copyWith({
    Value<int>? idCredito,
    Value<int>? idCliente,
    Value<double>? saldoActual,
    Value<DateTime>? fechaUltimaActualizacion,
  }) {
    return CreditosCompanion(
      idCredito: idCredito ?? this.idCredito,
      idCliente: idCliente ?? this.idCliente,
      saldoActual: saldoActual ?? this.saldoActual,
      fechaUltimaActualizacion:
          fechaUltimaActualizacion ?? this.fechaUltimaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idCredito.present) {
      map['id_credito'] = Variable<int>(idCredito.value);
    }
    if (idCliente.present) {
      map['id_cliente'] = Variable<int>(idCliente.value);
    }
    if (saldoActual.present) {
      map['saldo_actual'] = Variable<double>(saldoActual.value);
    }
    if (fechaUltimaActualizacion.present) {
      map['fecha_ultima_actualizacion'] = Variable<DateTime>(
        fechaUltimaActualizacion.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditosCompanion(')
          ..write('idCredito: $idCredito, ')
          ..write('idCliente: $idCliente, ')
          ..write('saldoActual: $saldoActual, ')
          ..write('fechaUltimaActualizacion: $fechaUltimaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $AbonosTable extends Abonos with TableInfo<$AbonosTable, Abono> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AbonosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idAbonoMeta = const VerificationMeta(
    'idAbono',
  );
  @override
  late final GeneratedColumn<int> idAbono = GeneratedColumn<int>(
    'id_abono',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idCreditoMeta = const VerificationMeta(
    'idCredito',
  );
  @override
  late final GeneratedColumn<int> idCredito = GeneratedColumn<int>(
    'id_credito',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES creditos (id_credito) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoAbonoMeta = const VerificationMeta(
    'montoAbono',
  );
  @override
  late final GeneratedColumn<double> montoAbono = GeneratedColumn<double>(
    'monto_abono',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [idAbono, idCredito, fecha, montoAbono];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'abonos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Abono> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_abono')) {
      context.handle(
        _idAbonoMeta,
        idAbono.isAcceptableOrUnknown(data['id_abono']!, _idAbonoMeta),
      );
    }
    if (data.containsKey('id_credito')) {
      context.handle(
        _idCreditoMeta,
        idCredito.isAcceptableOrUnknown(data['id_credito']!, _idCreditoMeta),
      );
    } else if (isInserting) {
      context.missing(_idCreditoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('monto_abono')) {
      context.handle(
        _montoAbonoMeta,
        montoAbono.isAcceptableOrUnknown(data['monto_abono']!, _montoAbonoMeta),
      );
    } else if (isInserting) {
      context.missing(_montoAbonoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idAbono};
  @override
  Abono map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Abono(
      idAbono: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_abono'],
      )!,
      idCredito: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_credito'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      montoAbono: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monto_abono'],
      )!,
    );
  }

  @override
  $AbonosTable createAlias(String alias) {
    return $AbonosTable(attachedDatabase, alias);
  }
}

class Abono extends DataClass implements Insertable<Abono> {
  final int idAbono;
  final int idCredito;
  final DateTime fecha;
  final double montoAbono;
  const Abono({
    required this.idAbono,
    required this.idCredito,
    required this.fecha,
    required this.montoAbono,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_abono'] = Variable<int>(idAbono);
    map['id_credito'] = Variable<int>(idCredito);
    map['fecha'] = Variable<DateTime>(fecha);
    map['monto_abono'] = Variable<double>(montoAbono);
    return map;
  }

  AbonosCompanion toCompanion(bool nullToAbsent) {
    return AbonosCompanion(
      idAbono: Value(idAbono),
      idCredito: Value(idCredito),
      fecha: Value(fecha),
      montoAbono: Value(montoAbono),
    );
  }

  factory Abono.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Abono(
      idAbono: serializer.fromJson<int>(json['idAbono']),
      idCredito: serializer.fromJson<int>(json['idCredito']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      montoAbono: serializer.fromJson<double>(json['montoAbono']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idAbono': serializer.toJson<int>(idAbono),
      'idCredito': serializer.toJson<int>(idCredito),
      'fecha': serializer.toJson<DateTime>(fecha),
      'montoAbono': serializer.toJson<double>(montoAbono),
    };
  }

  Abono copyWith({
    int? idAbono,
    int? idCredito,
    DateTime? fecha,
    double? montoAbono,
  }) => Abono(
    idAbono: idAbono ?? this.idAbono,
    idCredito: idCredito ?? this.idCredito,
    fecha: fecha ?? this.fecha,
    montoAbono: montoAbono ?? this.montoAbono,
  );
  Abono copyWithCompanion(AbonosCompanion data) {
    return Abono(
      idAbono: data.idAbono.present ? data.idAbono.value : this.idAbono,
      idCredito: data.idCredito.present ? data.idCredito.value : this.idCredito,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      montoAbono: data.montoAbono.present
          ? data.montoAbono.value
          : this.montoAbono,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Abono(')
          ..write('idAbono: $idAbono, ')
          ..write('idCredito: $idCredito, ')
          ..write('fecha: $fecha, ')
          ..write('montoAbono: $montoAbono')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idAbono, idCredito, fecha, montoAbono);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Abono &&
          other.idAbono == this.idAbono &&
          other.idCredito == this.idCredito &&
          other.fecha == this.fecha &&
          other.montoAbono == this.montoAbono);
}

class AbonosCompanion extends UpdateCompanion<Abono> {
  final Value<int> idAbono;
  final Value<int> idCredito;
  final Value<DateTime> fecha;
  final Value<double> montoAbono;
  const AbonosCompanion({
    this.idAbono = const Value.absent(),
    this.idCredito = const Value.absent(),
    this.fecha = const Value.absent(),
    this.montoAbono = const Value.absent(),
  });
  AbonosCompanion.insert({
    this.idAbono = const Value.absent(),
    required int idCredito,
    required DateTime fecha,
    required double montoAbono,
  }) : idCredito = Value(idCredito),
       fecha = Value(fecha),
       montoAbono = Value(montoAbono);
  static Insertable<Abono> custom({
    Expression<int>? idAbono,
    Expression<int>? idCredito,
    Expression<DateTime>? fecha,
    Expression<double>? montoAbono,
  }) {
    return RawValuesInsertable({
      if (idAbono != null) 'id_abono': idAbono,
      if (idCredito != null) 'id_credito': idCredito,
      if (fecha != null) 'fecha': fecha,
      if (montoAbono != null) 'monto_abono': montoAbono,
    });
  }

  AbonosCompanion copyWith({
    Value<int>? idAbono,
    Value<int>? idCredito,
    Value<DateTime>? fecha,
    Value<double>? montoAbono,
  }) {
    return AbonosCompanion(
      idAbono: idAbono ?? this.idAbono,
      idCredito: idCredito ?? this.idCredito,
      fecha: fecha ?? this.fecha,
      montoAbono: montoAbono ?? this.montoAbono,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idAbono.present) {
      map['id_abono'] = Variable<int>(idAbono.value);
    }
    if (idCredito.present) {
      map['id_credito'] = Variable<int>(idCredito.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (montoAbono.present) {
      map['monto_abono'] = Variable<double>(montoAbono.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbonosCompanion(')
          ..write('idAbono: $idAbono, ')
          ..write('idCredito: $idCredito, ')
          ..write('fecha: $fecha, ')
          ..write('montoAbono: $montoAbono')
          ..write(')'))
        .toString();
  }
}

class $AjustesStockTable extends AjustesStock
    with TableInfo<$AjustesStockTable, AjustesStockData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AjustesStockTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idAjusteMeta = const VerificationMeta(
    'idAjuste',
  );
  @override
  late final GeneratedColumn<int> idAjuste = GeneratedColumn<int>(
    'id_ajuste',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idProductoMeta = const VerificationMeta(
    'idProducto',
  );
  @override
  late final GeneratedColumn<int> idProducto = GeneratedColumn<int>(
    'id_producto',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id_producto)',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
    'motivo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenciaMeta = const VerificationMeta(
    'referencia',
  );
  @override
  late final GeneratedColumn<String> referencia = GeneratedColumn<String>(
    'referencia',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    idAjuste,
    idProducto,
    fecha,
    tipo,
    cantidad,
    motivo,
    referencia,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ajustes_stock';
  @override
  VerificationContext validateIntegrity(
    Insertable<AjustesStockData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_ajuste')) {
      context.handle(
        _idAjusteMeta,
        idAjuste.isAcceptableOrUnknown(data['id_ajuste']!, _idAjusteMeta),
      );
    }
    if (data.containsKey('id_producto')) {
      context.handle(
        _idProductoMeta,
        idProducto.isAcceptableOrUnknown(data['id_producto']!, _idProductoMeta),
      );
    } else if (isInserting) {
      context.missing(_idProductoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(
        _motivoMeta,
        motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta),
      );
    } else if (isInserting) {
      context.missing(_motivoMeta);
    }
    if (data.containsKey('referencia')) {
      context.handle(
        _referenciaMeta,
        referencia.isAcceptableOrUnknown(data['referencia']!, _referenciaMeta),
      );
    } else if (isInserting) {
      context.missing(_referenciaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idAjuste};
  @override
  AjustesStockData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AjustesStockData(
      idAjuste: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_ajuste'],
      )!,
      idProducto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_producto'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      motivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo'],
      )!,
      referencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia'],
      )!,
    );
  }

  @override
  $AjustesStockTable createAlias(String alias) {
    return $AjustesStockTable(attachedDatabase, alias);
  }
}

class AjustesStockData extends DataClass
    implements Insertable<AjustesStockData> {
  final int idAjuste;
  final int idProducto;
  final DateTime fecha;
  final String tipo;
  final int cantidad;
  final String motivo;
  final String referencia;
  const AjustesStockData({
    required this.idAjuste,
    required this.idProducto,
    required this.fecha,
    required this.tipo,
    required this.cantidad,
    required this.motivo,
    required this.referencia,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_ajuste'] = Variable<int>(idAjuste);
    map['id_producto'] = Variable<int>(idProducto);
    map['fecha'] = Variable<DateTime>(fecha);
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<int>(cantidad);
    map['motivo'] = Variable<String>(motivo);
    map['referencia'] = Variable<String>(referencia);
    return map;
  }

  AjustesStockCompanion toCompanion(bool nullToAbsent) {
    return AjustesStockCompanion(
      idAjuste: Value(idAjuste),
      idProducto: Value(idProducto),
      fecha: Value(fecha),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      motivo: Value(motivo),
      referencia: Value(referencia),
    );
  }

  factory AjustesStockData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AjustesStockData(
      idAjuste: serializer.fromJson<int>(json['idAjuste']),
      idProducto: serializer.fromJson<int>(json['idProducto']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      motivo: serializer.fromJson<String>(json['motivo']),
      referencia: serializer.fromJson<String>(json['referencia']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idAjuste': serializer.toJson<int>(idAjuste),
      'idProducto': serializer.toJson<int>(idProducto),
      'fecha': serializer.toJson<DateTime>(fecha),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<int>(cantidad),
      'motivo': serializer.toJson<String>(motivo),
      'referencia': serializer.toJson<String>(referencia),
    };
  }

  AjustesStockData copyWith({
    int? idAjuste,
    int? idProducto,
    DateTime? fecha,
    String? tipo,
    int? cantidad,
    String? motivo,
    String? referencia,
  }) => AjustesStockData(
    idAjuste: idAjuste ?? this.idAjuste,
    idProducto: idProducto ?? this.idProducto,
    fecha: fecha ?? this.fecha,
    tipo: tipo ?? this.tipo,
    cantidad: cantidad ?? this.cantidad,
    motivo: motivo ?? this.motivo,
    referencia: referencia ?? this.referencia,
  );
  AjustesStockData copyWithCompanion(AjustesStockCompanion data) {
    return AjustesStockData(
      idAjuste: data.idAjuste.present ? data.idAjuste.value : this.idAjuste,
      idProducto: data.idProducto.present
          ? data.idProducto.value
          : this.idProducto,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      referencia: data.referencia.present
          ? data.referencia.value
          : this.referencia,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AjustesStockData(')
          ..write('idAjuste: $idAjuste, ')
          ..write('idProducto: $idProducto, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('motivo: $motivo, ')
          ..write('referencia: $referencia')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idAjuste,
    idProducto,
    fecha,
    tipo,
    cantidad,
    motivo,
    referencia,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AjustesStockData &&
          other.idAjuste == this.idAjuste &&
          other.idProducto == this.idProducto &&
          other.fecha == this.fecha &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.motivo == this.motivo &&
          other.referencia == this.referencia);
}

class AjustesStockCompanion extends UpdateCompanion<AjustesStockData> {
  final Value<int> idAjuste;
  final Value<int> idProducto;
  final Value<DateTime> fecha;
  final Value<String> tipo;
  final Value<int> cantidad;
  final Value<String> motivo;
  final Value<String> referencia;
  const AjustesStockCompanion({
    this.idAjuste = const Value.absent(),
    this.idProducto = const Value.absent(),
    this.fecha = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.motivo = const Value.absent(),
    this.referencia = const Value.absent(),
  });
  AjustesStockCompanion.insert({
    this.idAjuste = const Value.absent(),
    required int idProducto,
    required DateTime fecha,
    required String tipo,
    required int cantidad,
    required String motivo,
    required String referencia,
  }) : idProducto = Value(idProducto),
       fecha = Value(fecha),
       tipo = Value(tipo),
       cantidad = Value(cantidad),
       motivo = Value(motivo),
       referencia = Value(referencia);
  static Insertable<AjustesStockData> custom({
    Expression<int>? idAjuste,
    Expression<int>? idProducto,
    Expression<DateTime>? fecha,
    Expression<String>? tipo,
    Expression<int>? cantidad,
    Expression<String>? motivo,
    Expression<String>? referencia,
  }) {
    return RawValuesInsertable({
      if (idAjuste != null) 'id_ajuste': idAjuste,
      if (idProducto != null) 'id_producto': idProducto,
      if (fecha != null) 'fecha': fecha,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (motivo != null) 'motivo': motivo,
      if (referencia != null) 'referencia': referencia,
    });
  }

  AjustesStockCompanion copyWith({
    Value<int>? idAjuste,
    Value<int>? idProducto,
    Value<DateTime>? fecha,
    Value<String>? tipo,
    Value<int>? cantidad,
    Value<String>? motivo,
    Value<String>? referencia,
  }) {
    return AjustesStockCompanion(
      idAjuste: idAjuste ?? this.idAjuste,
      idProducto: idProducto ?? this.idProducto,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      motivo: motivo ?? this.motivo,
      referencia: referencia ?? this.referencia,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idAjuste.present) {
      map['id_ajuste'] = Variable<int>(idAjuste.value);
    }
    if (idProducto.present) {
      map['id_producto'] = Variable<int>(idProducto.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (referencia.present) {
      map['referencia'] = Variable<String>(referencia.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AjustesStockCompanion(')
          ..write('idAjuste: $idAjuste, ')
          ..write('idProducto: $idProducto, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('motivo: $motivo, ')
          ..write('referencia: $referencia')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $ProveedoresTable proveedores = $ProveedoresTable(this);
  late final $IngresosMercaderiaTable ingresosMercaderia =
      $IngresosMercaderiaTable(this);
  late final $IngresosDetalleTable ingresosDetalle = $IngresosDetalleTable(
    this,
  );
  late final $VentasTable ventas = $VentasTable(this);
  late final $VentasDetalleTable ventasDetalle = $VentasDetalleTable(this);
  late final $CreditosTable creditos = $CreditosTable(this);
  late final $AbonosTable abonos = $AbonosTable(this);
  late final $AjustesStockTable ajustesStock = $AjustesStockTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientes,
    productos,
    proveedores,
    ingresosMercaderia,
    ingresosDetalle,
    ventas,
    ventasDetalle,
    creditos,
    abonos,
    ajustesStock,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ingresos_mercaderia',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ingresos_detalle', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ventas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ventas_detalle', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'creditos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('abonos', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> idCliente,
      required String nombre,
      required String direccion,
      required String telefono,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> idCliente,
      Value<String> nombre,
      Value<String> direccion,
      Value<String> telefono,
    });

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VentasTable, List<Venta>> _ventasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ventas,
    aliasName: $_aliasNameGenerator(db.clientes.idCliente, db.ventas.idCliente),
  );

  $$VentasTableProcessedTableManager get ventasRefs {
    final manager = $$VentasTableTableManager($_db, $_db.ventas).filter(
      (f) => f.idCliente.idCliente.sqlEquals($_itemColumn<int>('id_cliente')!),
    );

    final cache = $_typedResult.readTableOrNull(_ventasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CreditosTable, List<Credito>> _creditosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.creditos,
    aliasName: $_aliasNameGenerator(
      db.clientes.idCliente,
      db.creditos.idCliente,
    ),
  );

  $$CreditosTableProcessedTableManager get creditosRefs {
    final manager = $$CreditosTableTableManager($_db, $_db.creditos).filter(
      (f) => f.idCliente.idCliente.sqlEquals($_itemColumn<int>('id_cliente')!),
    );

    final cache = $_typedResult.readTableOrNull(_creditosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idCliente => $composableBuilder(
    column: $table.idCliente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ventasRefs(
    Expression<bool> Function($$VentasTableFilterComposer f) f,
  ) {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> creditosRefs(
    Expression<bool> Function($$CreditosTableFilterComposer f) f,
  ) {
    final $$CreditosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.creditos,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditosTableFilterComposer(
            $db: $db,
            $table: $db.creditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idCliente => $composableBuilder(
    column: $table.idCliente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idCliente =>
      $composableBuilder(column: $table.idCliente, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  Expression<T> ventasRefs<T extends Object>(
    Expression<T> Function($$VentasTableAnnotationComposer a) f,
  ) {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> creditosRefs<T extends Object>(
    Expression<T> Function($$CreditosTableAnnotationComposer a) f,
  ) {
    final $$CreditosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.creditos,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditosTableAnnotationComposer(
            $db: $db,
            $table: $db.creditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({bool ventasRefs, bool creditosRefs})
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idCliente = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> telefono = const Value.absent(),
              }) => ClientesCompanion(
                idCliente: idCliente,
                nombre: nombre,
                direccion: direccion,
                telefono: telefono,
              ),
          createCompanionCallback:
              ({
                Value<int> idCliente = const Value.absent(),
                required String nombre,
                required String direccion,
                required String telefono,
              }) => ClientesCompanion.insert(
                idCliente: idCliente,
                nombre: nombre,
                direccion: direccion,
                telefono: telefono,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventasRefs = false, creditosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ventasRefs) db.ventas,
                if (creditosRefs) db.creditos,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ventasRefs)
                    await $_getPrefetchedData<Cliente, $ClientesTable, Venta>(
                      currentTable: table,
                      referencedTable: $$ClientesTableReferences
                          ._ventasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ClientesTableReferences(db, table, p0).ventasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idCliente == item.idCliente,
                          ),
                      typedResults: items,
                    ),
                  if (creditosRefs)
                    await $_getPrefetchedData<Cliente, $ClientesTable, Credito>(
                      currentTable: table,
                      referencedTable: $$ClientesTableReferences
                          ._creditosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ClientesTableReferences(db, table, p0).creditosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idCliente == item.idCliente,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({bool ventasRefs, bool creditosRefs})
    >;
typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> idProducto,
      required String nombre,
      Value<String?> descripcion,
      required String tamano,
      required double precioVenta,
      Value<int> stock,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> idProducto,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<String> tamano,
      Value<double> precioVenta,
      Value<int> stock,
    });

final class $$ProductosTableReferences
    extends BaseReferences<_$AppDatabase, $ProductosTable, Producto> {
  $$ProductosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IngresosDetalleTable, List<IngresosDetalleData>>
  _ingresosDetalleRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingresosDetalle,
    aliasName: $_aliasNameGenerator(
      db.productos.idProducto,
      db.ingresosDetalle.idProducto,
    ),
  );

  $$IngresosDetalleTableProcessedTableManager get ingresosDetalleRefs {
    final manager =
        $$IngresosDetalleTableTableManager($_db, $_db.ingresosDetalle).filter(
          (f) => f.idProducto.idProducto.sqlEquals(
            $_itemColumn<int>('id_producto')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _ingresosDetalleRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VentasDetalleTable, List<VentasDetalleData>>
  _ventasDetalleRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasDetalle,
    aliasName: $_aliasNameGenerator(
      db.productos.idProducto,
      db.ventasDetalle.idProducto,
    ),
  );

  $$VentasDetalleTableProcessedTableManager get ventasDetalleRefs {
    final manager = $$VentasDetalleTableTableManager($_db, $_db.ventasDetalle)
        .filter(
          (f) => f.idProducto.idProducto.sqlEquals(
            $_itemColumn<int>('id_producto')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_ventasDetalleRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AjustesStockTable, List<AjustesStockData>>
  _ajustesStockRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ajustesStock,
    aliasName: $_aliasNameGenerator(
      db.productos.idProducto,
      db.ajustesStock.idProducto,
    ),
  );

  $$AjustesStockTableProcessedTableManager get ajustesStockRefs {
    final manager = $$AjustesStockTableTableManager($_db, $_db.ajustesStock)
        .filter(
          (f) => f.idProducto.idProducto.sqlEquals(
            $_itemColumn<int>('id_producto')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_ajustesStockRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idProducto => $composableBuilder(
    column: $table.idProducto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tamano => $composableBuilder(
    column: $table.tamano,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ingresosDetalleRefs(
    Expression<bool> Function($$IngresosDetalleTableFilterComposer f) f,
  ) {
    final $$IngresosDetalleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.ingresosDetalle,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosDetalleTableFilterComposer(
            $db: $db,
            $table: $db.ingresosDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventasDetalleRefs(
    Expression<bool> Function($$VentasDetalleTableFilterComposer f) f,
  ) {
    final $$VentasDetalleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableFilterComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ajustesStockRefs(
    Expression<bool> Function($$AjustesStockTableFilterComposer f) f,
  ) {
    final $$AjustesStockTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.ajustesStock,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AjustesStockTableFilterComposer(
            $db: $db,
            $table: $db.ajustesStock,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idProducto => $composableBuilder(
    column: $table.idProducto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tamano => $composableBuilder(
    column: $table.tamano,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idProducto => $composableBuilder(
    column: $table.idProducto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tamano =>
      $composableBuilder(column: $table.tamano, builder: (column) => column);

  GeneratedColumn<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  Expression<T> ingresosDetalleRefs<T extends Object>(
    Expression<T> Function($$IngresosDetalleTableAnnotationComposer a) f,
  ) {
    final $$IngresosDetalleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.ingresosDetalle,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosDetalleTableAnnotationComposer(
            $db: $db,
            $table: $db.ingresosDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ventasDetalleRefs<T extends Object>(
    Expression<T> Function($$VentasDetalleTableAnnotationComposer a) f,
  ) {
    final $$VentasDetalleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ajustesStockRefs<T extends Object>(
    Expression<T> Function($$AjustesStockTableAnnotationComposer a) f,
  ) {
    final $$AjustesStockTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.ajustesStock,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AjustesStockTableAnnotationComposer(
            $db: $db,
            $table: $db.ajustesStock,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          Producto,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (Producto, $$ProductosTableReferences),
          Producto,
          PrefetchHooks Function({
            bool ingresosDetalleRefs,
            bool ventasDetalleRefs,
            bool ajustesStockRefs,
          })
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idProducto = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String> tamano = const Value.absent(),
                Value<double> precioVenta = const Value.absent(),
                Value<int> stock = const Value.absent(),
              }) => ProductosCompanion(
                idProducto: idProducto,
                nombre: nombre,
                descripcion: descripcion,
                tamano: tamano,
                precioVenta: precioVenta,
                stock: stock,
              ),
          createCompanionCallback:
              ({
                Value<int> idProducto = const Value.absent(),
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                required String tamano,
                required double precioVenta,
                Value<int> stock = const Value.absent(),
              }) => ProductosCompanion.insert(
                idProducto: idProducto,
                nombre: nombre,
                descripcion: descripcion,
                tamano: tamano,
                precioVenta: precioVenta,
                stock: stock,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ingresosDetalleRefs = false,
                ventasDetalleRefs = false,
                ajustesStockRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingresosDetalleRefs) db.ingresosDetalle,
                    if (ventasDetalleRefs) db.ventasDetalle,
                    if (ajustesStockRefs) db.ajustesStock,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingresosDetalleRefs)
                        await $_getPrefetchedData<
                          Producto,
                          $ProductosTable,
                          IngresosDetalleData
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._ingresosDetalleRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).ingresosDetalleRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idProducto == item.idProducto,
                              ),
                          typedResults: items,
                        ),
                      if (ventasDetalleRefs)
                        await $_getPrefetchedData<
                          Producto,
                          $ProductosTable,
                          VentasDetalleData
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._ventasDetalleRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasDetalleRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idProducto == item.idProducto,
                              ),
                          typedResults: items,
                        ),
                      if (ajustesStockRefs)
                        await $_getPrefetchedData<
                          Producto,
                          $ProductosTable,
                          AjustesStockData
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._ajustesStockRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).ajustesStockRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idProducto == item.idProducto,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      Producto,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (Producto, $$ProductosTableReferences),
      Producto,
      PrefetchHooks Function({
        bool ingresosDetalleRefs,
        bool ventasDetalleRefs,
        bool ajustesStockRefs,
      })
    >;
typedef $$ProveedoresTableCreateCompanionBuilder =
    ProveedoresCompanion Function({
      Value<int> idProveedor,
      required String nombre,
      required String direccion,
      required String telefono,
    });
typedef $$ProveedoresTableUpdateCompanionBuilder =
    ProveedoresCompanion Function({
      Value<int> idProveedor,
      Value<String> nombre,
      Value<String> direccion,
      Value<String> telefono,
    });

final class $$ProveedoresTableReferences
    extends BaseReferences<_$AppDatabase, $ProveedoresTable, Proveedore> {
  $$ProveedoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $IngresosMercaderiaTable,
    List<IngresosMercaderiaData>
  >
  _ingresosMercaderiaRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ingresosMercaderia,
        aliasName: $_aliasNameGenerator(
          db.proveedores.idProveedor,
          db.ingresosMercaderia.idProveedor,
        ),
      );

  $$IngresosMercaderiaTableProcessedTableManager get ingresosMercaderiaRefs {
    final manager =
        $$IngresosMercaderiaTableTableManager(
          $_db,
          $_db.ingresosMercaderia,
        ).filter(
          (f) => f.idProveedor.idProveedor.sqlEquals(
            $_itemColumn<int>('id_proveedor')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _ingresosMercaderiaRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProveedoresTableFilterComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idProveedor => $composableBuilder(
    column: $table.idProveedor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ingresosMercaderiaRefs(
    Expression<bool> Function($$IngresosMercaderiaTableFilterComposer f) f,
  ) {
    final $$IngresosMercaderiaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProveedor,
      referencedTable: $db.ingresosMercaderia,
      getReferencedColumn: (t) => t.idProveedor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosMercaderiaTableFilterComposer(
            $db: $db,
            $table: $db.ingresosMercaderia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProveedoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idProveedor => $composableBuilder(
    column: $table.idProveedor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProveedoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idProveedor => $composableBuilder(
    column: $table.idProveedor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  Expression<T> ingresosMercaderiaRefs<T extends Object>(
    Expression<T> Function($$IngresosMercaderiaTableAnnotationComposer a) f,
  ) {
    final $$IngresosMercaderiaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.idProveedor,
          referencedTable: $db.ingresosMercaderia,
          getReferencedColumn: (t) => t.idProveedor,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngresosMercaderiaTableAnnotationComposer(
                $db: $db,
                $table: $db.ingresosMercaderia,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProveedoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProveedoresTable,
          Proveedore,
          $$ProveedoresTableFilterComposer,
          $$ProveedoresTableOrderingComposer,
          $$ProveedoresTableAnnotationComposer,
          $$ProveedoresTableCreateCompanionBuilder,
          $$ProveedoresTableUpdateCompanionBuilder,
          (Proveedore, $$ProveedoresTableReferences),
          Proveedore,
          PrefetchHooks Function({bool ingresosMercaderiaRefs})
        > {
  $$ProveedoresTableTableManager(_$AppDatabase db, $ProveedoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProveedoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProveedoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProveedoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idProveedor = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String> telefono = const Value.absent(),
              }) => ProveedoresCompanion(
                idProveedor: idProveedor,
                nombre: nombre,
                direccion: direccion,
                telefono: telefono,
              ),
          createCompanionCallback:
              ({
                Value<int> idProveedor = const Value.absent(),
                required String nombre,
                required String direccion,
                required String telefono,
              }) => ProveedoresCompanion.insert(
                idProveedor: idProveedor,
                nombre: nombre,
                direccion: direccion,
                telefono: telefono,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProveedoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ingresosMercaderiaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ingresosMercaderiaRefs) db.ingresosMercaderia,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ingresosMercaderiaRefs)
                    await $_getPrefetchedData<
                      Proveedore,
                      $ProveedoresTable,
                      IngresosMercaderiaData
                    >(
                      currentTable: table,
                      referencedTable: $$ProveedoresTableReferences
                          ._ingresosMercaderiaRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProveedoresTableReferences(
                            db,
                            table,
                            p0,
                          ).ingresosMercaderiaRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idProveedor == item.idProveedor,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProveedoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProveedoresTable,
      Proveedore,
      $$ProveedoresTableFilterComposer,
      $$ProveedoresTableOrderingComposer,
      $$ProveedoresTableAnnotationComposer,
      $$ProveedoresTableCreateCompanionBuilder,
      $$ProveedoresTableUpdateCompanionBuilder,
      (Proveedore, $$ProveedoresTableReferences),
      Proveedore,
      PrefetchHooks Function({bool ingresosMercaderiaRefs})
    >;
typedef $$IngresosMercaderiaTableCreateCompanionBuilder =
    IngresosMercaderiaCompanion Function({
      Value<int> idIngreso,
      Value<int?> idProveedor,
      required DateTime fecha,
      required double totalInversion,
    });
typedef $$IngresosMercaderiaTableUpdateCompanionBuilder =
    IngresosMercaderiaCompanion Function({
      Value<int> idIngreso,
      Value<int?> idProveedor,
      Value<DateTime> fecha,
      Value<double> totalInversion,
    });

final class $$IngresosMercaderiaTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngresosMercaderiaTable,
          IngresosMercaderiaData
        > {
  $$IngresosMercaderiaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProveedoresTable _idProveedorTable(_$AppDatabase db) =>
      db.proveedores.createAlias(
        $_aliasNameGenerator(
          db.ingresosMercaderia.idProveedor,
          db.proveedores.idProveedor,
        ),
      );

  $$ProveedoresTableProcessedTableManager? get idProveedor {
    final $_column = $_itemColumn<int>('id_proveedor');
    if ($_column == null) return null;
    final manager = $$ProveedoresTableTableManager(
      $_db,
      $_db.proveedores,
    ).filter((f) => f.idProveedor.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idProveedorTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IngresosDetalleTable, List<IngresosDetalleData>>
  _ingresosDetalleRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingresosDetalle,
    aliasName: $_aliasNameGenerator(
      db.ingresosMercaderia.idIngreso,
      db.ingresosDetalle.idIngreso,
    ),
  );

  $$IngresosDetalleTableProcessedTableManager get ingresosDetalleRefs {
    final manager =
        $$IngresosDetalleTableTableManager($_db, $_db.ingresosDetalle).filter(
          (f) =>
              f.idIngreso.idIngreso.sqlEquals($_itemColumn<int>('id_ingreso')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _ingresosDetalleRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngresosMercaderiaTableFilterComposer
    extends Composer<_$AppDatabase, $IngresosMercaderiaTable> {
  $$IngresosMercaderiaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idIngreso => $composableBuilder(
    column: $table.idIngreso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalInversion => $composableBuilder(
    column: $table.totalInversion,
    builder: (column) => ColumnFilters(column),
  );

  $$ProveedoresTableFilterComposer get idProveedor {
    final $$ProveedoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProveedor,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.idProveedor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableFilterComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ingresosDetalleRefs(
    Expression<bool> Function($$IngresosDetalleTableFilterComposer f) f,
  ) {
    final $$IngresosDetalleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idIngreso,
      referencedTable: $db.ingresosDetalle,
      getReferencedColumn: (t) => t.idIngreso,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosDetalleTableFilterComposer(
            $db: $db,
            $table: $db.ingresosDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngresosMercaderiaTableOrderingComposer
    extends Composer<_$AppDatabase, $IngresosMercaderiaTable> {
  $$IngresosMercaderiaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idIngreso => $composableBuilder(
    column: $table.idIngreso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalInversion => $composableBuilder(
    column: $table.totalInversion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProveedoresTableOrderingComposer get idProveedor {
    final $$ProveedoresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProveedor,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.idProveedor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableOrderingComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngresosMercaderiaTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngresosMercaderiaTable> {
  $$IngresosMercaderiaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idIngreso =>
      $composableBuilder(column: $table.idIngreso, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get totalInversion => $composableBuilder(
    column: $table.totalInversion,
    builder: (column) => column,
  );

  $$ProveedoresTableAnnotationComposer get idProveedor {
    final $$ProveedoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProveedor,
      referencedTable: $db.proveedores,
      getReferencedColumn: (t) => t.idProveedor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProveedoresTableAnnotationComposer(
            $db: $db,
            $table: $db.proveedores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ingresosDetalleRefs<T extends Object>(
    Expression<T> Function($$IngresosDetalleTableAnnotationComposer a) f,
  ) {
    final $$IngresosDetalleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idIngreso,
      referencedTable: $db.ingresosDetalle,
      getReferencedColumn: (t) => t.idIngreso,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosDetalleTableAnnotationComposer(
            $db: $db,
            $table: $db.ingresosDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngresosMercaderiaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngresosMercaderiaTable,
          IngresosMercaderiaData,
          $$IngresosMercaderiaTableFilterComposer,
          $$IngresosMercaderiaTableOrderingComposer,
          $$IngresosMercaderiaTableAnnotationComposer,
          $$IngresosMercaderiaTableCreateCompanionBuilder,
          $$IngresosMercaderiaTableUpdateCompanionBuilder,
          (IngresosMercaderiaData, $$IngresosMercaderiaTableReferences),
          IngresosMercaderiaData,
          PrefetchHooks Function({bool idProveedor, bool ingresosDetalleRefs})
        > {
  $$IngresosMercaderiaTableTableManager(
    _$AppDatabase db,
    $IngresosMercaderiaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngresosMercaderiaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngresosMercaderiaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngresosMercaderiaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> idIngreso = const Value.absent(),
                Value<int?> idProveedor = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> totalInversion = const Value.absent(),
              }) => IngresosMercaderiaCompanion(
                idIngreso: idIngreso,
                idProveedor: idProveedor,
                fecha: fecha,
                totalInversion: totalInversion,
              ),
          createCompanionCallback:
              ({
                Value<int> idIngreso = const Value.absent(),
                Value<int?> idProveedor = const Value.absent(),
                required DateTime fecha,
                required double totalInversion,
              }) => IngresosMercaderiaCompanion.insert(
                idIngreso: idIngreso,
                idProveedor: idProveedor,
                fecha: fecha,
                totalInversion: totalInversion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngresosMercaderiaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({idProveedor = false, ingresosDetalleRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingresosDetalleRefs) db.ingresosDetalle,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idProveedor) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idProveedor,
                                    referencedTable:
                                        $$IngresosMercaderiaTableReferences
                                            ._idProveedorTable(db),
                                    referencedColumn:
                                        $$IngresosMercaderiaTableReferences
                                            ._idProveedorTable(db)
                                            .idProveedor,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingresosDetalleRefs)
                        await $_getPrefetchedData<
                          IngresosMercaderiaData,
                          $IngresosMercaderiaTable,
                          IngresosDetalleData
                        >(
                          currentTable: table,
                          referencedTable: $$IngresosMercaderiaTableReferences
                              ._ingresosDetalleRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngresosMercaderiaTableReferences(
                                db,
                                table,
                                p0,
                              ).ingresosDetalleRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idIngreso == item.idIngreso,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngresosMercaderiaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngresosMercaderiaTable,
      IngresosMercaderiaData,
      $$IngresosMercaderiaTableFilterComposer,
      $$IngresosMercaderiaTableOrderingComposer,
      $$IngresosMercaderiaTableAnnotationComposer,
      $$IngresosMercaderiaTableCreateCompanionBuilder,
      $$IngresosMercaderiaTableUpdateCompanionBuilder,
      (IngresosMercaderiaData, $$IngresosMercaderiaTableReferences),
      IngresosMercaderiaData,
      PrefetchHooks Function({bool idProveedor, bool ingresosDetalleRefs})
    >;
typedef $$IngresosDetalleTableCreateCompanionBuilder =
    IngresosDetalleCompanion Function({
      Value<int> idDetalleIngreso,
      required int idIngreso,
      required int idProducto,
      required int cantidad,
      required double costoUnitario,
      required double subtotal,
    });
typedef $$IngresosDetalleTableUpdateCompanionBuilder =
    IngresosDetalleCompanion Function({
      Value<int> idDetalleIngreso,
      Value<int> idIngreso,
      Value<int> idProducto,
      Value<int> cantidad,
      Value<double> costoUnitario,
      Value<double> subtotal,
    });

final class $$IngresosDetalleTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngresosDetalleTable,
          IngresosDetalleData
        > {
  $$IngresosDetalleTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IngresosMercaderiaTable _idIngresoTable(_$AppDatabase db) =>
      db.ingresosMercaderia.createAlias(
        $_aliasNameGenerator(
          db.ingresosDetalle.idIngreso,
          db.ingresosMercaderia.idIngreso,
        ),
      );

  $$IngresosMercaderiaTableProcessedTableManager get idIngreso {
    final $_column = $_itemColumn<int>('id_ingreso')!;

    final manager = $$IngresosMercaderiaTableTableManager(
      $_db,
      $_db.ingresosMercaderia,
    ).filter((f) => f.idIngreso.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idIngresoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductosTable _idProductoTable(_$AppDatabase db) =>
      db.productos.createAlias(
        $_aliasNameGenerator(
          db.ingresosDetalle.idProducto,
          db.productos.idProducto,
        ),
      );

  $$ProductosTableProcessedTableManager get idProducto {
    final $_column = $_itemColumn<int>('id_producto')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.idProducto.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idProductoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngresosDetalleTableFilterComposer
    extends Composer<_$AppDatabase, $IngresosDetalleTable> {
  $$IngresosDetalleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idDetalleIngreso => $composableBuilder(
    column: $table.idDetalleIngreso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costoUnitario => $composableBuilder(
    column: $table.costoUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  $$IngresosMercaderiaTableFilterComposer get idIngreso {
    final $$IngresosMercaderiaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idIngreso,
      referencedTable: $db.ingresosMercaderia,
      getReferencedColumn: (t) => t.idIngreso,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosMercaderiaTableFilterComposer(
            $db: $db,
            $table: $db.ingresosMercaderia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableFilterComposer get idProducto {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngresosDetalleTableOrderingComposer
    extends Composer<_$AppDatabase, $IngresosDetalleTable> {
  $$IngresosDetalleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idDetalleIngreso => $composableBuilder(
    column: $table.idDetalleIngreso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costoUnitario => $composableBuilder(
    column: $table.costoUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngresosMercaderiaTableOrderingComposer get idIngreso {
    final $$IngresosMercaderiaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idIngreso,
      referencedTable: $db.ingresosMercaderia,
      getReferencedColumn: (t) => t.idIngreso,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngresosMercaderiaTableOrderingComposer(
            $db: $db,
            $table: $db.ingresosMercaderia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableOrderingComposer get idProducto {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngresosDetalleTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngresosDetalleTable> {
  $$IngresosDetalleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idDetalleIngreso => $composableBuilder(
    column: $table.idDetalleIngreso,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get costoUnitario => $composableBuilder(
    column: $table.costoUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  $$IngresosMercaderiaTableAnnotationComposer get idIngreso {
    final $$IngresosMercaderiaTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.idIngreso,
          referencedTable: $db.ingresosMercaderia,
          getReferencedColumn: (t) => t.idIngreso,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngresosMercaderiaTableAnnotationComposer(
                $db: $db,
                $table: $db.ingresosMercaderia,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ProductosTableAnnotationComposer get idProducto {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngresosDetalleTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngresosDetalleTable,
          IngresosDetalleData,
          $$IngresosDetalleTableFilterComposer,
          $$IngresosDetalleTableOrderingComposer,
          $$IngresosDetalleTableAnnotationComposer,
          $$IngresosDetalleTableCreateCompanionBuilder,
          $$IngresosDetalleTableUpdateCompanionBuilder,
          (IngresosDetalleData, $$IngresosDetalleTableReferences),
          IngresosDetalleData,
          PrefetchHooks Function({bool idIngreso, bool idProducto})
        > {
  $$IngresosDetalleTableTableManager(
    _$AppDatabase db,
    $IngresosDetalleTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngresosDetalleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngresosDetalleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngresosDetalleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idDetalleIngreso = const Value.absent(),
                Value<int> idIngreso = const Value.absent(),
                Value<int> idProducto = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> costoUnitario = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
              }) => IngresosDetalleCompanion(
                idDetalleIngreso: idDetalleIngreso,
                idIngreso: idIngreso,
                idProducto: idProducto,
                cantidad: cantidad,
                costoUnitario: costoUnitario,
                subtotal: subtotal,
              ),
          createCompanionCallback:
              ({
                Value<int> idDetalleIngreso = const Value.absent(),
                required int idIngreso,
                required int idProducto,
                required int cantidad,
                required double costoUnitario,
                required double subtotal,
              }) => IngresosDetalleCompanion.insert(
                idDetalleIngreso: idDetalleIngreso,
                idIngreso: idIngreso,
                idProducto: idProducto,
                cantidad: cantidad,
                costoUnitario: costoUnitario,
                subtotal: subtotal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngresosDetalleTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idIngreso = false, idProducto = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idIngreso) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idIngreso,
                                referencedTable:
                                    $$IngresosDetalleTableReferences
                                        ._idIngresoTable(db),
                                referencedColumn:
                                    $$IngresosDetalleTableReferences
                                        ._idIngresoTable(db)
                                        .idIngreso,
                              )
                              as T;
                    }
                    if (idProducto) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idProducto,
                                referencedTable:
                                    $$IngresosDetalleTableReferences
                                        ._idProductoTable(db),
                                referencedColumn:
                                    $$IngresosDetalleTableReferences
                                        ._idProductoTable(db)
                                        .idProducto,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IngresosDetalleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngresosDetalleTable,
      IngresosDetalleData,
      $$IngresosDetalleTableFilterComposer,
      $$IngresosDetalleTableOrderingComposer,
      $$IngresosDetalleTableAnnotationComposer,
      $$IngresosDetalleTableCreateCompanionBuilder,
      $$IngresosDetalleTableUpdateCompanionBuilder,
      (IngresosDetalleData, $$IngresosDetalleTableReferences),
      IngresosDetalleData,
      PrefetchHooks Function({bool idIngreso, bool idProducto})
    >;
typedef $$VentasTableCreateCompanionBuilder =
    VentasCompanion Function({
      Value<int> idVenta,
      required int idCliente,
      required DateTime fecha,
      required double total,
      Value<bool> esCredito,
    });
typedef $$VentasTableUpdateCompanionBuilder =
    VentasCompanion Function({
      Value<int> idVenta,
      Value<int> idCliente,
      Value<DateTime> fecha,
      Value<double> total,
      Value<bool> esCredito,
    });

final class $$VentasTableReferences
    extends BaseReferences<_$AppDatabase, $VentasTable, Venta> {
  $$VentasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _idClienteTable(_$AppDatabase db) =>
      db.clientes.createAlias(
        $_aliasNameGenerator(db.ventas.idCliente, db.clientes.idCliente),
      );

  $$ClientesTableProcessedTableManager get idCliente {
    final $_column = $_itemColumn<int>('id_cliente')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.idCliente.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idClienteTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VentasDetalleTable, List<VentasDetalleData>>
  _ventasDetalleRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasDetalle,
    aliasName: $_aliasNameGenerator(
      db.ventas.idVenta,
      db.ventasDetalle.idVenta,
    ),
  );

  $$VentasDetalleTableProcessedTableManager get ventasDetalleRefs {
    final manager = $$VentasDetalleTableTableManager($_db, $_db.ventasDetalle)
        .filter(
          (f) => f.idVenta.idVenta.sqlEquals($_itemColumn<int>('id_venta')!),
        );

    final cache = $_typedResult.readTableOrNull(_ventasDetalleRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VentasTableFilterComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idVenta => $composableBuilder(
    column: $table.idVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esCredito => $composableBuilder(
    column: $table.esCredito,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get idCliente {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ventasDetalleRefs(
    Expression<bool> Function($$VentasDetalleTableFilterComposer f) f,
  ) {
    final $$VentasDetalleTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVenta,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.idVenta,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableFilterComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idVenta => $composableBuilder(
    column: $table.idVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esCredito => $composableBuilder(
    column: $table.esCredito,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get idCliente {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idVenta =>
      $composableBuilder(column: $table.idVenta, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<bool> get esCredito =>
      $composableBuilder(column: $table.esCredito, builder: (column) => column);

  $$ClientesTableAnnotationComposer get idCliente {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ventasDetalleRefs<T extends Object>(
    Expression<T> Function($$VentasDetalleTableAnnotationComposer a) f,
  ) {
    final $$VentasDetalleTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVenta,
      referencedTable: $db.ventasDetalle,
      getReferencedColumn: (t) => t.idVenta,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetalleTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasDetalle,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasTable,
          Venta,
          $$VentasTableFilterComposer,
          $$VentasTableOrderingComposer,
          $$VentasTableAnnotationComposer,
          $$VentasTableCreateCompanionBuilder,
          $$VentasTableUpdateCompanionBuilder,
          (Venta, $$VentasTableReferences),
          Venta,
          PrefetchHooks Function({bool idCliente, bool ventasDetalleRefs})
        > {
  $$VentasTableTableManager(_$AppDatabase db, $VentasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idVenta = const Value.absent(),
                Value<int> idCliente = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<bool> esCredito = const Value.absent(),
              }) => VentasCompanion(
                idVenta: idVenta,
                idCliente: idCliente,
                fecha: fecha,
                total: total,
                esCredito: esCredito,
              ),
          createCompanionCallback:
              ({
                Value<int> idVenta = const Value.absent(),
                required int idCliente,
                required DateTime fecha,
                required double total,
                Value<bool> esCredito = const Value.absent(),
              }) => VentasCompanion.insert(
                idVenta: idVenta,
                idCliente: idCliente,
                fecha: fecha,
                total: total,
                esCredito: esCredito,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VentasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({idCliente = false, ventasDetalleRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ventasDetalleRefs) db.ventasDetalle,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idCliente) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idCliente,
                                    referencedTable: $$VentasTableReferences
                                        ._idClienteTable(db),
                                    referencedColumn: $$VentasTableReferences
                                        ._idClienteTable(db)
                                        .idCliente,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ventasDetalleRefs)
                        await $_getPrefetchedData<
                          Venta,
                          $VentasTable,
                          VentasDetalleData
                        >(
                          currentTable: table,
                          referencedTable: $$VentasTableReferences
                              ._ventasDetalleRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VentasTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasDetalleRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idVenta == item.idVenta,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VentasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasTable,
      Venta,
      $$VentasTableFilterComposer,
      $$VentasTableOrderingComposer,
      $$VentasTableAnnotationComposer,
      $$VentasTableCreateCompanionBuilder,
      $$VentasTableUpdateCompanionBuilder,
      (Venta, $$VentasTableReferences),
      Venta,
      PrefetchHooks Function({bool idCliente, bool ventasDetalleRefs})
    >;
typedef $$VentasDetalleTableCreateCompanionBuilder =
    VentasDetalleCompanion Function({
      Value<int> idDetalle,
      required int idVenta,
      required int idProducto,
      required int cantidad,
      required double precioUnitario,
      required double subtotal,
    });
typedef $$VentasDetalleTableUpdateCompanionBuilder =
    VentasDetalleCompanion Function({
      Value<int> idDetalle,
      Value<int> idVenta,
      Value<int> idProducto,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<double> subtotal,
    });

final class $$VentasDetalleTableReferences
    extends
        BaseReferences<_$AppDatabase, $VentasDetalleTable, VentasDetalleData> {
  $$VentasDetalleTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VentasTable _idVentaTable(_$AppDatabase db) => db.ventas.createAlias(
    $_aliasNameGenerator(db.ventasDetalle.idVenta, db.ventas.idVenta),
  );

  $$VentasTableProcessedTableManager get idVenta {
    final $_column = $_itemColumn<int>('id_venta')!;

    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.idVenta.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idVentaTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductosTable _idProductoTable(_$AppDatabase db) =>
      db.productos.createAlias(
        $_aliasNameGenerator(
          db.ventasDetalle.idProducto,
          db.productos.idProducto,
        ),
      );

  $$ProductosTableProcessedTableManager get idProducto {
    final $_column = $_itemColumn<int>('id_producto')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.idProducto.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idProductoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VentasDetalleTableFilterComposer
    extends Composer<_$AppDatabase, $VentasDetalleTable> {
  $$VentasDetalleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idDetalle => $composableBuilder(
    column: $table.idDetalle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  $$VentasTableFilterComposer get idVenta {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVenta,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.idVenta,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableFilterComposer get idProducto {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetalleTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasDetalleTable> {
  $$VentasDetalleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idDetalle => $composableBuilder(
    column: $table.idDetalle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  $$VentasTableOrderingComposer get idVenta {
    final $$VentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVenta,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.idVenta,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableOrderingComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableOrderingComposer get idProducto {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetalleTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasDetalleTable> {
  $$VentasDetalleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idDetalle =>
      $composableBuilder(column: $table.idDetalle, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  $$VentasTableAnnotationComposer get idVenta {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idVenta,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.idVenta,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableAnnotationComposer get idProducto {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetalleTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasDetalleTable,
          VentasDetalleData,
          $$VentasDetalleTableFilterComposer,
          $$VentasDetalleTableOrderingComposer,
          $$VentasDetalleTableAnnotationComposer,
          $$VentasDetalleTableCreateCompanionBuilder,
          $$VentasDetalleTableUpdateCompanionBuilder,
          (VentasDetalleData, $$VentasDetalleTableReferences),
          VentasDetalleData,
          PrefetchHooks Function({bool idVenta, bool idProducto})
        > {
  $$VentasDetalleTableTableManager(_$AppDatabase db, $VentasDetalleTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasDetalleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasDetalleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasDetalleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idDetalle = const Value.absent(),
                Value<int> idVenta = const Value.absent(),
                Value<int> idProducto = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
              }) => VentasDetalleCompanion(
                idDetalle: idDetalle,
                idVenta: idVenta,
                idProducto: idProducto,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                subtotal: subtotal,
              ),
          createCompanionCallback:
              ({
                Value<int> idDetalle = const Value.absent(),
                required int idVenta,
                required int idProducto,
                required int cantidad,
                required double precioUnitario,
                required double subtotal,
              }) => VentasDetalleCompanion.insert(
                idDetalle: idDetalle,
                idVenta: idVenta,
                idProducto: idProducto,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                subtotal: subtotal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VentasDetalleTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idVenta = false, idProducto = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idVenta) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idVenta,
                                referencedTable: $$VentasDetalleTableReferences
                                    ._idVentaTable(db),
                                referencedColumn: $$VentasDetalleTableReferences
                                    ._idVentaTable(db)
                                    .idVenta,
                              )
                              as T;
                    }
                    if (idProducto) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idProducto,
                                referencedTable: $$VentasDetalleTableReferences
                                    ._idProductoTable(db),
                                referencedColumn: $$VentasDetalleTableReferences
                                    ._idProductoTable(db)
                                    .idProducto,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VentasDetalleTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasDetalleTable,
      VentasDetalleData,
      $$VentasDetalleTableFilterComposer,
      $$VentasDetalleTableOrderingComposer,
      $$VentasDetalleTableAnnotationComposer,
      $$VentasDetalleTableCreateCompanionBuilder,
      $$VentasDetalleTableUpdateCompanionBuilder,
      (VentasDetalleData, $$VentasDetalleTableReferences),
      VentasDetalleData,
      PrefetchHooks Function({bool idVenta, bool idProducto})
    >;
typedef $$CreditosTableCreateCompanionBuilder =
    CreditosCompanion Function({
      Value<int> idCredito,
      required int idCliente,
      required double saldoActual,
      required DateTime fechaUltimaActualizacion,
    });
typedef $$CreditosTableUpdateCompanionBuilder =
    CreditosCompanion Function({
      Value<int> idCredito,
      Value<int> idCliente,
      Value<double> saldoActual,
      Value<DateTime> fechaUltimaActualizacion,
    });

final class $$CreditosTableReferences
    extends BaseReferences<_$AppDatabase, $CreditosTable, Credito> {
  $$CreditosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _idClienteTable(_$AppDatabase db) =>
      db.clientes.createAlias(
        $_aliasNameGenerator(db.creditos.idCliente, db.clientes.idCliente),
      );

  $$ClientesTableProcessedTableManager get idCliente {
    final $_column = $_itemColumn<int>('id_cliente')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.idCliente.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idClienteTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AbonosTable, List<Abono>> _abonosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.abonos,
    aliasName: $_aliasNameGenerator(db.creditos.idCredito, db.abonos.idCredito),
  );

  $$AbonosTableProcessedTableManager get abonosRefs {
    final manager = $$AbonosTableTableManager($_db, $_db.abonos).filter(
      (f) => f.idCredito.idCredito.sqlEquals($_itemColumn<int>('id_credito')!),
    );

    final cache = $_typedResult.readTableOrNull(_abonosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CreditosTableFilterComposer
    extends Composer<_$AppDatabase, $CreditosTable> {
  $$CreditosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idCredito => $composableBuilder(
    column: $table.idCredito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saldoActual => $composableBuilder(
    column: $table.saldoActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaUltimaActualizacion => $composableBuilder(
    column: $table.fechaUltimaActualizacion,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get idCliente {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> abonosRefs(
    Expression<bool> Function($$AbonosTableFilterComposer f) f,
  ) {
    final $$AbonosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCredito,
      referencedTable: $db.abonos,
      getReferencedColumn: (t) => t.idCredito,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonosTableFilterComposer(
            $db: $db,
            $table: $db.abonos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditosTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditosTable> {
  $$CreditosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idCredito => $composableBuilder(
    column: $table.idCredito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saldoActual => $composableBuilder(
    column: $table.saldoActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaUltimaActualizacion => $composableBuilder(
    column: $table.fechaUltimaActualizacion,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get idCliente {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditosTable> {
  $$CreditosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idCredito =>
      $composableBuilder(column: $table.idCredito, builder: (column) => column);

  GeneratedColumn<double> get saldoActual => $composableBuilder(
    column: $table.saldoActual,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaUltimaActualizacion => $composableBuilder(
    column: $table.fechaUltimaActualizacion,
    builder: (column) => column,
  );

  $$ClientesTableAnnotationComposer get idCliente {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCliente,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.idCliente,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> abonosRefs<T extends Object>(
    Expression<T> Function($$AbonosTableAnnotationComposer a) f,
  ) {
    final $$AbonosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCredito,
      referencedTable: $db.abonos,
      getReferencedColumn: (t) => t.idCredito,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonosTableAnnotationComposer(
            $db: $db,
            $table: $db.abonos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditosTable,
          Credito,
          $$CreditosTableFilterComposer,
          $$CreditosTableOrderingComposer,
          $$CreditosTableAnnotationComposer,
          $$CreditosTableCreateCompanionBuilder,
          $$CreditosTableUpdateCompanionBuilder,
          (Credito, $$CreditosTableReferences),
          Credito,
          PrefetchHooks Function({bool idCliente, bool abonosRefs})
        > {
  $$CreditosTableTableManager(_$AppDatabase db, $CreditosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idCredito = const Value.absent(),
                Value<int> idCliente = const Value.absent(),
                Value<double> saldoActual = const Value.absent(),
                Value<DateTime> fechaUltimaActualizacion = const Value.absent(),
              }) => CreditosCompanion(
                idCredito: idCredito,
                idCliente: idCliente,
                saldoActual: saldoActual,
                fechaUltimaActualizacion: fechaUltimaActualizacion,
              ),
          createCompanionCallback:
              ({
                Value<int> idCredito = const Value.absent(),
                required int idCliente,
                required double saldoActual,
                required DateTime fechaUltimaActualizacion,
              }) => CreditosCompanion.insert(
                idCredito: idCredito,
                idCliente: idCliente,
                saldoActual: saldoActual,
                fechaUltimaActualizacion: fechaUltimaActualizacion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CreditosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idCliente = false, abonosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (abonosRefs) db.abonos],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idCliente) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idCliente,
                                referencedTable: $$CreditosTableReferences
                                    ._idClienteTable(db),
                                referencedColumn: $$CreditosTableReferences
                                    ._idClienteTable(db)
                                    .idCliente,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (abonosRefs)
                    await $_getPrefetchedData<Credito, $CreditosTable, Abono>(
                      currentTable: table,
                      referencedTable: $$CreditosTableReferences
                          ._abonosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CreditosTableReferences(db, table, p0).abonosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idCredito == item.idCredito,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CreditosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditosTable,
      Credito,
      $$CreditosTableFilterComposer,
      $$CreditosTableOrderingComposer,
      $$CreditosTableAnnotationComposer,
      $$CreditosTableCreateCompanionBuilder,
      $$CreditosTableUpdateCompanionBuilder,
      (Credito, $$CreditosTableReferences),
      Credito,
      PrefetchHooks Function({bool idCliente, bool abonosRefs})
    >;
typedef $$AbonosTableCreateCompanionBuilder =
    AbonosCompanion Function({
      Value<int> idAbono,
      required int idCredito,
      required DateTime fecha,
      required double montoAbono,
    });
typedef $$AbonosTableUpdateCompanionBuilder =
    AbonosCompanion Function({
      Value<int> idAbono,
      Value<int> idCredito,
      Value<DateTime> fecha,
      Value<double> montoAbono,
    });

final class $$AbonosTableReferences
    extends BaseReferences<_$AppDatabase, $AbonosTable, Abono> {
  $$AbonosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CreditosTable _idCreditoTable(_$AppDatabase db) =>
      db.creditos.createAlias(
        $_aliasNameGenerator(db.abonos.idCredito, db.creditos.idCredito),
      );

  $$CreditosTableProcessedTableManager get idCredito {
    final $_column = $_itemColumn<int>('id_credito')!;

    final manager = $$CreditosTableTableManager(
      $_db,
      $_db.creditos,
    ).filter((f) => f.idCredito.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idCreditoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AbonosTableFilterComposer
    extends Composer<_$AppDatabase, $AbonosTable> {
  $$AbonosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idAbono => $composableBuilder(
    column: $table.idAbono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoAbono => $composableBuilder(
    column: $table.montoAbono,
    builder: (column) => ColumnFilters(column),
  );

  $$CreditosTableFilterComposer get idCredito {
    final $$CreditosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCredito,
      referencedTable: $db.creditos,
      getReferencedColumn: (t) => t.idCredito,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditosTableFilterComposer(
            $db: $db,
            $table: $db.creditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonosTableOrderingComposer
    extends Composer<_$AppDatabase, $AbonosTable> {
  $$AbonosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idAbono => $composableBuilder(
    column: $table.idAbono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoAbono => $composableBuilder(
    column: $table.montoAbono,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreditosTableOrderingComposer get idCredito {
    final $$CreditosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCredito,
      referencedTable: $db.creditos,
      getReferencedColumn: (t) => t.idCredito,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditosTableOrderingComposer(
            $db: $db,
            $table: $db.creditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AbonosTable> {
  $$AbonosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idAbono =>
      $composableBuilder(column: $table.idAbono, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get montoAbono => $composableBuilder(
    column: $table.montoAbono,
    builder: (column) => column,
  );

  $$CreditosTableAnnotationComposer get idCredito {
    final $$CreditosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idCredito,
      referencedTable: $db.creditos,
      getReferencedColumn: (t) => t.idCredito,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditosTableAnnotationComposer(
            $db: $db,
            $table: $db.creditos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AbonosTable,
          Abono,
          $$AbonosTableFilterComposer,
          $$AbonosTableOrderingComposer,
          $$AbonosTableAnnotationComposer,
          $$AbonosTableCreateCompanionBuilder,
          $$AbonosTableUpdateCompanionBuilder,
          (Abono, $$AbonosTableReferences),
          Abono,
          PrefetchHooks Function({bool idCredito})
        > {
  $$AbonosTableTableManager(_$AppDatabase db, $AbonosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AbonosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AbonosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AbonosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idAbono = const Value.absent(),
                Value<int> idCredito = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> montoAbono = const Value.absent(),
              }) => AbonosCompanion(
                idAbono: idAbono,
                idCredito: idCredito,
                fecha: fecha,
                montoAbono: montoAbono,
              ),
          createCompanionCallback:
              ({
                Value<int> idAbono = const Value.absent(),
                required int idCredito,
                required DateTime fecha,
                required double montoAbono,
              }) => AbonosCompanion.insert(
                idAbono: idAbono,
                idCredito: idCredito,
                fecha: fecha,
                montoAbono: montoAbono,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AbonosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({idCredito = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idCredito) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idCredito,
                                referencedTable: $$AbonosTableReferences
                                    ._idCreditoTable(db),
                                referencedColumn: $$AbonosTableReferences
                                    ._idCreditoTable(db)
                                    .idCredito,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AbonosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AbonosTable,
      Abono,
      $$AbonosTableFilterComposer,
      $$AbonosTableOrderingComposer,
      $$AbonosTableAnnotationComposer,
      $$AbonosTableCreateCompanionBuilder,
      $$AbonosTableUpdateCompanionBuilder,
      (Abono, $$AbonosTableReferences),
      Abono,
      PrefetchHooks Function({bool idCredito})
    >;
typedef $$AjustesStockTableCreateCompanionBuilder =
    AjustesStockCompanion Function({
      Value<int> idAjuste,
      required int idProducto,
      required DateTime fecha,
      required String tipo,
      required int cantidad,
      required String motivo,
      required String referencia,
    });
typedef $$AjustesStockTableUpdateCompanionBuilder =
    AjustesStockCompanion Function({
      Value<int> idAjuste,
      Value<int> idProducto,
      Value<DateTime> fecha,
      Value<String> tipo,
      Value<int> cantidad,
      Value<String> motivo,
      Value<String> referencia,
    });

final class $$AjustesStockTableReferences
    extends
        BaseReferences<_$AppDatabase, $AjustesStockTable, AjustesStockData> {
  $$AjustesStockTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductosTable _idProductoTable(_$AppDatabase db) =>
      db.productos.createAlias(
        $_aliasNameGenerator(
          db.ajustesStock.idProducto,
          db.productos.idProducto,
        ),
      );

  $$ProductosTableProcessedTableManager get idProducto {
    final $_column = $_itemColumn<int>('id_producto')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.idProducto.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idProductoTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AjustesStockTableFilterComposer
    extends Composer<_$AppDatabase, $AjustesStockTable> {
  $$AjustesStockTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idAjuste => $composableBuilder(
    column: $table.idAjuste,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductosTableFilterComposer get idProducto {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AjustesStockTableOrderingComposer
    extends Composer<_$AppDatabase, $AjustesStockTable> {
  $$AjustesStockTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idAjuste => $composableBuilder(
    column: $table.idAjuste,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductosTableOrderingComposer get idProducto {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AjustesStockTableAnnotationComposer
    extends Composer<_$AppDatabase, $AjustesStockTable> {
  $$AjustesStockTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idAjuste =>
      $composableBuilder(column: $table.idAjuste, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => column,
  );

  $$ProductosTableAnnotationComposer get idProducto {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProducto,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.idProducto,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AjustesStockTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AjustesStockTable,
          AjustesStockData,
          $$AjustesStockTableFilterComposer,
          $$AjustesStockTableOrderingComposer,
          $$AjustesStockTableAnnotationComposer,
          $$AjustesStockTableCreateCompanionBuilder,
          $$AjustesStockTableUpdateCompanionBuilder,
          (AjustesStockData, $$AjustesStockTableReferences),
          AjustesStockData,
          PrefetchHooks Function({bool idProducto})
        > {
  $$AjustesStockTableTableManager(_$AppDatabase db, $AjustesStockTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AjustesStockTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AjustesStockTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AjustesStockTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> idAjuste = const Value.absent(),
                Value<int> idProducto = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<String> motivo = const Value.absent(),
                Value<String> referencia = const Value.absent(),
              }) => AjustesStockCompanion(
                idAjuste: idAjuste,
                idProducto: idProducto,
                fecha: fecha,
                tipo: tipo,
                cantidad: cantidad,
                motivo: motivo,
                referencia: referencia,
              ),
          createCompanionCallback:
              ({
                Value<int> idAjuste = const Value.absent(),
                required int idProducto,
                required DateTime fecha,
                required String tipo,
                required int cantidad,
                required String motivo,
                required String referencia,
              }) => AjustesStockCompanion.insert(
                idAjuste: idAjuste,
                idProducto: idProducto,
                fecha: fecha,
                tipo: tipo,
                cantidad: cantidad,
                motivo: motivo,
                referencia: referencia,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AjustesStockTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idProducto = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idProducto) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idProducto,
                                referencedTable: $$AjustesStockTableReferences
                                    ._idProductoTable(db),
                                referencedColumn: $$AjustesStockTableReferences
                                    ._idProductoTable(db)
                                    .idProducto,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AjustesStockTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AjustesStockTable,
      AjustesStockData,
      $$AjustesStockTableFilterComposer,
      $$AjustesStockTableOrderingComposer,
      $$AjustesStockTableAnnotationComposer,
      $$AjustesStockTableCreateCompanionBuilder,
      $$AjustesStockTableUpdateCompanionBuilder,
      (AjustesStockData, $$AjustesStockTableReferences),
      AjustesStockData,
      PrefetchHooks Function({bool idProducto})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db, _db.proveedores);
  $$IngresosMercaderiaTableTableManager get ingresosMercaderia =>
      $$IngresosMercaderiaTableTableManager(_db, _db.ingresosMercaderia);
  $$IngresosDetalleTableTableManager get ingresosDetalle =>
      $$IngresosDetalleTableTableManager(_db, _db.ingresosDetalle);
  $$VentasTableTableManager get ventas =>
      $$VentasTableTableManager(_db, _db.ventas);
  $$VentasDetalleTableTableManager get ventasDetalle =>
      $$VentasDetalleTableTableManager(_db, _db.ventasDetalle);
  $$CreditosTableTableManager get creditos =>
      $$CreditosTableTableManager(_db, _db.creditos);
  $$AbonosTableTableManager get abonos =>
      $$AbonosTableTableManager(_db, _db.abonos);
  $$AjustesStockTableTableManager get ajustesStock =>
      $$AjustesStockTableTableManager(_db, _db.ajustesStock);
}
