import 'dart:convert';

import 'package:facturaloapp2025/common/api.dart';
import 'package:facturaloapp2025/models/establecimientos/establecimientos_model.dart';
import 'package:http/http.dart' as http;

class EstablecimientoProvider {
  // ignore: unused_field
  bool _cargando = false;
  final api = Api();

  /* -------------------------------------------------------------------------- */
  /*                              REPUESTA API REST                             */
  /* -------------------------------------------------------------------------- */
  Future<List<Establecimiento>> _procesaRespuesta(String url) async {
  try {
    final resp = await http.get(Uri.parse(url));
    final decodedData = json.decode(resp.body);
    final gestiones = Establecimientos.fromJsonList(decodedData["puntosEmision"]);
    return gestiones.items;
  } catch (e) {
    return [];
  }
}

  


  /* -------------------------------------------------------------------------- */
  /*                              REPUESTA API REST                             */
  /* -------------------------------------------------------------------------- */  
  Future<List<dynamic>> procesaRespuesta2(String url) async {
    try {
      final resp = await http.get(Uri.parse(url));
      final decodedData = json.decode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
      final List<dynamic> consultarICE = decodedData['consultarICE'];
      final dynamic tarifaImpuesto = decodedData['consultarImpuesto'];      
      return [consultarICE, tarifaImpuesto];
    } catch (e) {
      return [];
    }
  }


  /* -------------------------------------------------------------------------- */
  /*                              OBTENER ESTABLECIMIENTOS                      */
  /* -------------------------------------------------------------------------- */
  getEstablecimientos(llave, idEmpresa, idPuntoEmision) async {
    if (_cargando) return [];

    _cargando = true;

    final resp =
        '${api.apiNode}/api/puntosEmision/puntosDeEmisionEmpresa/$llave/$idEmpresa/$idPuntoEmision';

    _cargando = false;
    
    return await _procesaRespuesta(resp);
  }

  /* -------------------------------------------------------------------------- */
  /*                              OBTENER SIGUIENTE SECUENCIAL                  */
  /* -------------------------------------------------------------------------- */
  

  guardarEstablecimiento(nombre,direccion,secuencialEstablecimiento,secuencialEmision,token,idEmpresa) async {
    try {
      final resp = await http.post(
          Uri.parse("${api.apiNode}/api/puntosEmision/registrarPuntoEmision"),
          body: <String, String>{
            'nombrePuntoEmision': nombre,
            'direccionPuntoEmision': direccion,
            'secuencialEstablecimiento': secuencialEstablecimiento,
            'secuencialEmision': secuencialEmision,
            'token': token,
            'idEmpresa': idEmpresa
          });      

      if (resp.body.isEmpty) return '';
    
      return resp.body;
    }catch (e) {
      return "{'status' : 'false' , 'message' : 'false'}";
    } 

  }

  editarEstablecimiento(idEmpresa,token,idEstablecimiento,nombre,direccion,establecimiento,emision) async {

    try {
      final resp = await http.put(
          Uri.parse("${api.apiNode}/api/puntosEmision/editarPuntoEmision"),
          body: <String, String>{
            'nombrePuntoEmision': nombre,
            'direccionPuntoEmision': direccion,
            'secuencialEstablecimiento': establecimiento,
            'secuencialEmision': emision,
            'token': token,
            'idEmpresa': idEmpresa,
            'idPuntoEmision': idEstablecimiento,
          });      

      if (resp.body.isEmpty) return '';
    
      return resp.body;
    }catch (e) {
      return "{'status' : 'false' , 'message' : 'false'}";
    } 

}

  eliminarEstablecimiento(idPuntoEmision,idEmpresa, token) async {
    try {
      final resp = await http.delete(
          Uri.parse('${api.apiNode}/api/puntosEmision/eliminarPuntoEmision'),
          body: <String, String>{'idPuntoEmision': idPuntoEmision, 'idEmpresa':idEmpresa,'token': token});

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }


  //http://localhost:3001/api/puntosEmision/opcionesPuntoEmision/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZFVzdWFyaW8iOiIiLCJpYXQiOjE2NjQ0MDMxNzV9.Ke_vdMNe8GBdKvTpdO8pkDhVUgTSiKVVpXS-DWlVIYE/104/13/venta
  getOpcionesEstablecimientos(llave, idEmpresa, idPuntoEmision) async {      
    try {
      final url = '${api.apiNode}/api/puntosEmision/opcionesPuntoEmision/$llave/$idEmpresa/$idPuntoEmision/venta';
      final resp = await http.get(Uri.parse(url));     
      if (resp.body.isEmpty) return '';
      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  

}
