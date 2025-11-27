class Establecimientos {
  List<Establecimiento> items = [];

  Establecimientos();

  Establecimientos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final usuario = Establecimiento.fromJsonMap(item);
      items.add(usuario);
    }
  }
}

class Establecimiento {
  String? id;
  String? nombre;
  String? direccion;
  String? secuencialEstablecimiento;
  String? secuencialEmision;
  String? secuencialElectronico;
  String? secuencialFisico;
  String? estado;
  String? limiteFactura;
  bool? seleccionado;
  String? secuencialComprobante;
  String? imagen;
  String? datosTransportista;

  Establecimiento({
    this.id,
    this.nombre,
    this.direccion,
    required this.secuencialEstablecimiento,
    required this.secuencialEmision,
    required this.secuencialElectronico,
    required this.secuencialFisico,
    required this.estado,
    required this.limiteFactura,
    required this.seleccionado,
    required this.secuencialComprobante,
    required this.imagen,
    required this.datosTransportista,
  });

  Establecimiento.fromJsonMap(Map<String, dynamic> json) {
    id = json["idPuntoEmision"].toString();
    nombre = json["nombrePuntoEmision"].toString();
    direccion = json["direccionPuntoEmision"].toString();
    secuencialEstablecimiento = json["secuencialEstablecimiento"].toString();
    secuencialEmision = json["secuencialEmision"].toString();
    secuencialElectronico = json["secuencialElectronico"].toString();
    secuencialFisico = json["secuencialFisico"].toString();
    estado = json["estado"].toString();
    limiteFactura = json["limiteFactura"].toString();    
    seleccionado = json["seleccionar"];
    secuencialComprobante = json["secuencial"].toString();   
    imagen = json["imagen"].toString(); 
    datosTransportista = json["datosTransportista"].toString();   
  }
}
