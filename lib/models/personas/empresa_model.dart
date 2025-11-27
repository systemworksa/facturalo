class Empresas {
  List<Empresa> items = [];

  Empresas();

  Empresas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final usuario = Empresa.fromJsonMap(item);
      items.add(usuario);
    }
  }
}

class Empresa {
  String? idEmpresa;
  String? razonSocial;
  String? rucEmpresa;
  String? nombreComercial;
  String? ciudadEmpresa;
  String? emailEmpresa;
  String? telefonoEmpresa;
  String? obligadoLLevarContabilidad;
  String? imgEmpresa;
  String? firmaElectronica;
  String? claveFirma;
  String? tipoAmbiente;
  String? regimenEmpresa;
  String? proveedorFirma;
  String? totalIngresos;
  String? totalGastos;
  String? documentosDisponibles;
  String? documentosUtilizados;
  String? idDetallePlan;
  String? estadoPlan;

  Empresa(
      {this.idEmpresa,
      this.razonSocial,
      required this.rucEmpresa,
      required this.nombreComercial,
      required this.ciudadEmpresa,
      required this.emailEmpresa,
      required this.telefonoEmpresa,
      required this.obligadoLLevarContabilidad,
      required this.imgEmpresa,
      required this.firmaElectronica,
      required this.claveFirma,
      required this.tipoAmbiente,
      required this.regimenEmpresa,
      required this.proveedorFirma,
      required this.totalIngresos,
      required this.totalGastos,
      required this.documentosDisponibles,
      required this.documentosUtilizados,
      required this.idDetallePlan,
      required this.estadoPlan});

  Empresa.fromJsonMap(Map<String, dynamic> json) {
    idEmpresa = json["idEmpresa"];
    razonSocial = json["razonSocial"];
    rucEmpresa = json["rucEmpresa"];
    ciudadEmpresa = json["ciudadEmpresa"];
    emailEmpresa = json["emailEmpresa"];
    telefonoEmpresa = json["telefonoEmpresa"];
    obligadoLLevarContabilidad = json["obligadoLLevarContabilidad"];
    imgEmpresa = json["imgEmpresa"];
    firmaElectronica = json["firmaElectronica"];
    claveFirma = json["claveFirma"];
    tipoAmbiente = json["tipoAmbiente"];
    regimenEmpresa = json["regimenEmpresa"];
    proveedorFirma = json["proveedorFirma"];
    totalIngresos = json["totalIngresos"];
    totalGastos = json["totalGastos"];
    documentosDisponibles = json["documentosDisponibles"];
    documentosUtilizados = json["documentosUtilizados"];
    idDetallePlan = json["idDetallePlan"];
    estadoPlan = json["estadoPlan"];
  }
}
