class DetalleOrdenes {
  List<Detalle> items = [];

  DetalleOrdenes();

  DetalleOrdenes.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final orden = Detalle.fromJsonMap(item);
      items.add(orden);
    }
  }
}

class Detalle {
  String? codigo;
  String? nombre;
  String? precio;
  String? impuesto;
  String? codigoimpuesto;
  String? cantidad;
  String? total;
  String? precioMinimo;
  bool? eliminar;
  String? nombreCombo;
  String? idCombo;
  int? posicion;
  String? importe;
  String? formaPago;
  String? fechaPago;
  String? bloquear;
  String? observacion;
  String? preciomanual;

  String? tipoice;
  String? codigoIce;
  String? valorIce;
  String? tarifaIce;
  String? porcentajeDescuento;
  
  Detalle({
    required this.codigo,
    required this.nombre,
    required this.precio,
    required this.impuesto,
    required this.codigoimpuesto,
    required this.cantidad,
    required this.total,
    required this.precioMinimo,
    required this.eliminar,
    required this.nombreCombo,
    required this.idCombo,
    required this.posicion,
    required this.importe,
    required this.formaPago,
    required this.fechaPago,
    required this.bloquear,
    required this.observacion,
    required this.preciomanual,

    required this.tipoice,
    required this.codigoIce,
    required this.valorIce,
    required this.tarifaIce,
    required this.porcentajeDescuento,
  });

  Detalle.fromJsonMap(Map<String, dynamic> json) {
    codigo = json["codigoProducto"];
    nombre = json["nombre"];
    precio = json["precio"];
    impuesto = json["impuesto"].toString();
    codigoimpuesto = json["codigoimpuesto"];
    precioMinimo = json["PREC_PUB_PRO"];
    cantidad = json["cantidad"].toString();
    total = json["tota"].toString();
    eliminar = json["eliminar"];
    nombreCombo = json["nombreCombo"];
    idCombo = json["idCombo"];
    posicion = json["posicion"];
    importe = json["importe"];
    formaPago = json["metodoPago"];
    fechaPago = json["fechaPago"];
    bloquear = json["bloquear"];
    observacion = json["observacion"];
    preciomanual = json["preciomanual"];
    tarifaIce = json["tarifaice"].toString();
    tipoice = json["tipoice"];
    codigoIce = json["codigoIce"];
    valorIce = json["valorice"].toString();
    porcentajeDescuento = json["porcentajeDescuento"].toString();
  }
}
