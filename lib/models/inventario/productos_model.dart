class Productos {
  List<Producto> items = [];

  Productos();

  Productos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final usuario = Producto.fromJsonMap(item);
      items.add(usuario);
    }
  }
}

class Producto {
  String? id;
  String? imagen;
  String? codigo;
  String? nombre;
  String? costo;
  String? precio;
  String? precioMayorista;
  String? precioDistribuidor;
  String? precioLiquidacion;
  String? fechaRegistro;
  String? descripcion;
  String? impuesto;
  String? codigoimpuesto;
  String? tarifaIce;
  String? codigoIce;
  String? tipoice;
  String? valorIce;
  String? pvpManual;
  String? idProducto;

  Producto({
    this.id,
    this.imagen,
    this.codigo,
    required this.nombre,
    required this.costo,
    required this.precio,
    required this.fechaRegistro,
    required this.descripcion,
    required this.impuesto,
    required this.codigoimpuesto,
    required this.codigoIce,
    required this.tarifaIce,
    required this.tipoice,
    required this.valorIce,
    required this.pvpManual,
    required this.precioMayorista,
    required this.precioDistribuidor,
    required this.precioLiquidacion,
    required this.idProducto,
  });

  Producto.fromJsonMap(Map<String, dynamic> json) {
    id = json["idProducto"].toString();
    imagen = json["imagen"].toString();
    codigo = json["codigo"].toString();
    nombre = json["nombre"].toString();
    costo = json["costo"];
    precio = json["precioP"];
    fechaRegistro = json["fechaRegistro"].toString();
    descripcion = json["descripcion"].toString();
    impuesto = json["impuesto"].toString();
    codigoimpuesto = json["codigoimpuesto"].toString();
    tarifaIce = json["tarifaIce"].toString();
    codigoIce = json["codigoIce"].toString();
    tipoice = json["tipoIce"].toString();
    valorIce = json["valorIce"].toString();
    pvpManual = json["pvpManual"].toString();
    precioMayorista = json["precioMayorista"].toString();
    precioDistribuidor = json["precioDistribuidor"].toString();
    precioLiquidacion = json["precioLiquidacion"].toString();
    idProducto = json["idProducto"].toString();
  }
}
