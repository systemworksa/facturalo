import 'dart:convert';
import 'package:facturaloapp2025/common/api.dart';
import 'package:facturaloapp2025/models/transacciones/planes_model.dart';
import 'package:http/http.dart' as http;

class PlanesProvider {
  bool _cargando = false;
  final api = Api();
  Future<List<Plan>> _procesaRespuesta(res) async {
    final resp = await http.get(Uri.parse(res));
    final decodedData = json.decode("[" + resp.body + "]");
    final gestiones = Planes.fromJsonList(decodedData[0]["planes"]);

    return gestiones.items;
  }

  //OBTENER DATOS DE DOCTORES POR MEDIO DE LA CEDULA
  getPlanes(String token) async {
    if (_cargando) return [];

    _cargando = true;

    final resp = "${api.apiNode}/api/planes/consultarPlanes/$token?busqueda=";
    _cargando = false;

    return await _procesaRespuesta(resp);
  }

  generarPlan(token, idEmpresa, idPlan) async {
    try {
      final resp = await http.post(
          Uri.parse('${api.apiNode}/api/planes/comprarPlan'),
          body: <String, String>{
            'codPlan': idPlan,
            'idEmpresa': idEmpresa,
            'token': token,
          });

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "[{'status' : 'false' , 'message' : $e}]";
    }
  }
}
