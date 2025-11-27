class Planes {
  List<Plan> items = [];

  Planes();

  Planes.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final orden = Plan.fromJsonMap(item);
      items.add(orden);
    }
  }
}

class Plan {
  String? id;
  String? numero;
  String? nombre;
  String? precio;
  String? descripcion;
  String? imagen;

  Plan(
      {required this.id,
      required this.numero,
      required this.nombre,
      required this.precio,
      required this.descripcion,
      required this.imagen});

  Plan.fromJsonMap(Map<String, dynamic> json) {
    id = json["idPlan"].toString();
    numero = json["numeroDocumento"].toString();
    precio = json["precio"].toString();
    nombre = json["nombrePlan"].toString();
    precio = json["precioPlan"].toString();
    descripcion = json["descripPlan"].toString();
    imagen = json["imagenPlan"].toString();
  }
}
