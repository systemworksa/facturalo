import 'dart:convert';

import 'package:facturaloapp2025/common/api.dart';
import 'package:http/http.dart' as http;

class EmpresaProvider {
  // ignore: unused_field
  final bool _cargando = false;
  final api = Api();

  /* -------------------------------------------------------------------------- */
  /*                                    LOGIN                                   */
  /* -------------------------------------------------------------------------- */
  obtenerResumen(idEmpresa, idUsuario, token) async {
    try {
      final resp = await http.post(
          Uri.parse('${api.apiNode}/api/empresas/consultarInformacionEmpresa'),
          body: <String, String>{
            'idEmpresa': idEmpresa,
            'idUsuario': idUsuario,
            'token': token
          });

      if (resp.body.isEmpty)
        return "{'status' : 'false' , 'message' : 'error'}";

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  obtenerInformacion(idEmpresa, token) async {
    try {
      final resp = await http.post(
          Uri.parse(
              '${api.apiNode}/api/empresas/consultarConfiguracionEmpresa'),
          body: <String, String>{'idEmpresa': idEmpresa, 'token': token});

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  anucios(token) async {
    try {
      print('${api.apiPHP}/sistema/empresa/mostraranuncio/$token');
      final resp = await http.get(
          Uri.parse('${api.apiPHP}/sistema/empresa/mostraranuncio/$token'));

      if (resp.body.isEmpty)
        return "{'status' : 'false' , 'message' : 'error'}";

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  obtenerImpuestos(token) async {
    try {
      final url = '${api.apiNode}/api/empresas/listadoImpuestos/$token';
      final resp = await http.get(Uri.parse(url));
      if (resp.body.isEmpty) return '';
      return json.decode(resp.body);
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }
}
