class Usuarios {
  List<Usuario> items = [];

  Usuarios();

  Usuarios.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final usuario = Usuario.fromJsonMap(item);
      items.add(usuario);
    }
  }
}

class Usuario {
  String? id;
  String? nombre;
  String? email;
  String? password;
  String? token;
  String? imagen;
  String? estado;
  String? sucursal;
  String? perfil;
  String? identificacion;
  String? ping;
  int? estatus;
  String? detalle;
  String? mensaje;
  String? pendiente;
  String? entregado;
  String? facturado;
  String? total;
  String? ventas;
  String? idVerificacion;
  String? establecimiento;
  String? msj;
  int? posicion;

  Usuario(
      {this.id,
      this.nombre,
      required this.email,
      required this.password,
      required this.token,
      required this.imagen,
      required this.estado,
      required this.sucursal,
      required this.perfil,
      required this.identificacion,
      required this.ping,
      required this.mensaje,
      required this.pendiente,
      required this.entregado,
      required this.facturado,
      required this.total,
      required this.ventas,
      required this.idVerificacion,
      required this.msj,
      required this.establecimiento,
      required this.posicion});

  Usuario.fromJsonMap(Map<String, dynamic> json) {
    id = json["COD_USU"];
    nombre = json["NOM_USU"];
    email = json["EMA_USU"];
    password = json["PASS_USU"];
    token = json["TOCK_USU"];
    imagen = json["img"];
    estado = json["EST_USU"];
    sucursal = json["FK_COD_SURC"];
    perfil = json["PERF_USU"];
    identificacion = json["IDEN_USU"];
    ping = json["PIN"];
    estatus = json["estatus"];
    detalle = json["detalle"];
    mensaje = json["mensaje"];
    pendiente = json["pendiente"];
    entregado = json["entregado"];
    facturado = json["facturado"];
    total = json["total"];
    ventas = json["ventas"];
    idVerificacion = json["b80bb7740288f"];
    msj = json["msj"];
    establecimiento = json["ESTBL_USU"];
    posicion = json["posicion"];
  }
}
