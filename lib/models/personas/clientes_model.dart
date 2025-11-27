class Clientes {
  List<Cliente> items = [];

  Clientes();

  Clientes.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final usuario = Cliente.fromJsonMap(item);
      items.add(usuario);
    }
  }
}

class Cliente {
  String? idCliente;
  String? cedula;
  String? nombre;
  String? nombreComercial;
  String? provincia;
  String? telefono;
  String? email;
  String? genero;
  String? extrangero;
  String? pagina;
  String? paginaActual;
  String? direccion;
  String? tipoIdentificacion;
  String? razonsocial;
  Cliente({
    this.idCliente,
    this.cedula,
    this.nombre,
    required this.nombreComercial,
    required this.provincia,
    required this.telefono,
    required this.email,
    required this.genero,
    required this.extrangero,
    required this.pagina,
    required this.paginaActual,
    required this.direccion,
    required this.tipoIdentificacion,
  });

  Cliente.fromJsonMap(Map<String, dynamic> json) {
    idCliente = json["idCliente"].toString();
    cedula = json["cedula"];
    nombre = json["nombres"];
    nombreComercial = json["nombreComercial"];
    provincia = json["provincia"];
    telefono = json["telefono"];
    email = json["correo"];
    genero = json["genero"];
    extrangero = json["extrangero"];
    pagina = json["totalPaginas"].toString();
    paginaActual = json["paginaActual"];
    direccion = json["direccion"];
    tipoIdentificacion = json["tipoIdentificacion"];
    razonsocial = json["razonsocial"];
  }
}
