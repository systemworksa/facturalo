import 'dart:convert';
import 'package:facturaloapp2025/models/transacciones/documentos_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:facturaloapp2025/common/api.dart';
import 'package:http/http.dart' as http;

class DocumentosProvider {
  // ignore: unused_field
  bool _cargando = false;
  final api = Api();

  /* -------------------------------------------------------------------------- */
  /*                              REPUESTA API REST                             */
  /* -------------------------------------------------------------------------- */
  Future<List<Documento>> _procesaRespuesta(String url) async {
    final resp = await http.get(Uri.parse(url));

    final decodedData = json.decode("[" + resp.body + "]");

    final gestiones = Documentos.fromJsonList(decodedData[0]["documentos"]);
    return gestiones.items;
  }

  Future<List<Documento>> _procesaRespuesta2(String url) async {
    final resp = await http.get(Uri.parse(url));

    final decodedData = json.decode("[" + resp.body + "]");

    final gestiones = Documentos.fromJsonList(decodedData);
    return gestiones.items;
  }

  /* -------------------------------------------------------------------------- */
  /*                          OBTENER TOTAL DE PAGINAS                          */
  /* -------------------------------------------------------------------------- */
  getPaginado(llave, idEmpresa, limite, busqueda) async {
    if (_cargando) return [];

    _cargando = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("idEmpresa")?.isEmpty ?? true) {
      idEmpresa = "0";
    } else {
      idEmpresa = prefs.getString("idEmpresa")!;
    }

    // http: //app-facturacion.contamatic-erp.com:3001/api/documentos/consultartotalesfacturaselec/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZFVzdWFyaW8iOiIiLCJpYXQiOjE2NjMyNTA4NDN9.cziVVNXXCDiHk335uj_Fv5tHdD_APuqetzv9OVjZUIU/Electronica/251/10
    final resp =
        '${api.apiNode}/api/documentos/consultartotalesfacturaselec/$llave/Electronica/$idEmpresa/vacio/vacio/10';
    _cargando = false;

    return await _procesaRespuesta2(resp);
  }

  /* -------------------------------------------------------------------------- */
  /*                               OBTENER ORDENES                              */
  /* -------------------------------------------------------------------------- */
  getDocumentos(
      llave, idEmpresa, pagina, limite, busqueda, fechaInicio, fechaFin) async {
    if (_cargando) return [];

    _cargando = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("idEmpresa")?.isEmpty ?? true) {
      idEmpresa = "0";
    } else {
      idEmpresa = prefs.getString("idEmpresa")!;
    }

    final resp =
        '${api.apiNode}/api/documentos/consultarfacturaselec/$llave/Electronica/$idEmpresa/$fechaInicio/$fechaFin/$pagina/$limite/?busqueda=$busqueda';

    _cargando = false;

    return await _procesaRespuesta(resp);
  }

/* -------------------------------------------------------------------------- */
/*                               GUARDAR FACTURA                              */
/* -------------------------------------------------------------------------- */
  guardarFactura(
      token,
      idUsuario,
      idEmpresa,
      idCliente,
      idEstablecimiento,
      opcionTipoVenta,
      fecha,
      totalFinal12,
      totalFinal0,
      totalFinalExento,
      totalFinalNObjeto,
      detalleFactura,
      subtotalFinal,
      ivaFinal,
      iceFinal,
      totalPagar,
      observacion,
      opcionMetodoPago,
      tarifaIva) async {
    try {
      final resp = await http.post(
          Uri.parse('${api.apiPHP}/sistema/transacciones/crearVenta'),
          body: <String, String>{
            'token': token,
            'idUsuario': idUsuario,
            'idEmpresa': idEmpresa,
            'idCliente': idCliente,
            'idEstablecimiento': idEstablecimiento,
            'tipo': opcionTipoVenta,
            'fecha': fecha,
            'subtotalIVA': totalFinal12,
            'subtotalCero': totalFinal0,
            'subtotalEXENTO': totalFinalExento,
            'subtotalNOBJETO': totalFinalNObjeto,
            'listaProductos': detalleFactura,
            'subtotal': subtotalFinal,
            'iva': ivaFinal,
            'ice': iceFinal,
            'totalFactura': totalPagar,
            'totalPagar': totalPagar,
            'observacion': observacion,
            'metodo': opcionMetodoPago,
            'tarifaIva': tarifaIva
          });

      if (resp.body.isEmpty) return '';

      return resp.body;

      /*final resp = await http.post(
        Uri.parse('${api.apiPHP}/sistema/transacciones/crearVenta'),
      );
      
      print(resp.body);
      if (resp.body.isEmpty) return '';

      return resp.body;*/
    } catch (e) {
      return "{'status' : 'false' , 'message' : $e}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               EDITAR FACTURA                               */
  /* -------------------------------------------------------------------------- */
  editarFactura(
      token,
      idUsuario,
      idEmpresa,
      idCliente,
      opcionTipoVenta,
      fecha,
      totalFinal12,
      totalFinal0,
      totalFinalExento,
      totalFinalNObjeto,
      detalleFactura,
      subtotalFinal,
      ivaFinal,
      iceFinal,
      totalPagar,
      observacion,
      opcionMetodoPago,
      tarifaIva,
      idFactura,
      descuento) async {
    final resp = await http.post(
        Uri.parse('${api.apiPHP}/sistema/transacciones/editarVenta'),
        body: <String, String>{
          'token': token,
          'idDocumento': idFactura,
          'idUsuario': idUsuario,
          'idEmpresa': idEmpresa,
          'idCliente': idCliente,
          'tipo': opcionTipoVenta,
          'fecha': fecha,
          'subtotalIVA': totalFinal12,
          'subtotalCero': totalFinal0,
          'subtotalEXENTO': totalFinalExento,
          'subtotalNOBJETO': totalFinalNObjeto,
          'listaProductos': detalleFactura,
          'subtotal': subtotalFinal,
          'iva': ivaFinal,
          'ice': iceFinal,
          'totalFactura': totalPagar,
          'totalPagar': totalPagar,
          'observacion': observacion,
          'metodo': opcionMetodoPago,
          'tarifaIva': tarifaIva,
          'totaldescuento': descuento,
        });

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

/* -------------------------------------------------------------------------- */
/*                                ENVIAR AL SRI                               */
/* -------------------------------------------------------------------------- */
  enviarSRI(token, idEmpresa, idDocumento) async {
    print('${api.apiPHP}/sistema/transacciones/enviarSriVenta');
    print({
          'token': token,
          'idDocumento': idDocumento,
          'idEmpresa': idEmpresa,
        });
    final resp = await http.post(
        Uri.parse('${api.apiPHP}/sistema/transacciones/enviarSriVenta'),
        body: <String, String>{
          'token': token,
          'idDocumento': idDocumento,
          'idEmpresa': idEmpresa,
        });

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                                GENERAR RIDE                                */
  /* -------------------------------------------------------------------------- */
  generarRIDE(token, idEmpresa, idDocumento) async {
    final resp = await http.get(
      Uri.parse(
          '${api.apiPHP}/sistema/transacciones/imprimirFactura/$token/$idEmpresa/$idDocumento'),
    );

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                                GENERAR RIDE                                */
  /* -------------------------------------------------------------------------- */
  generarTicket(token, idEmpresa, idDocumento) async {
    final resp = await http.get(
      Uri.parse(
          '${api.apiPHP}/sistema/transacciones/imprimirTicket/$token/$idEmpresa/$idDocumento'),
    );

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                                   VER XML                                  */
  /* -------------------------------------------------------------------------- */

  verXML(token, idEmpresa, idDocumento) async {
    print(
        '${api.apiPHP}/sistema/transacciones/imprimirxml/$token/$idEmpresa/$idDocumento');
    final resp = await http.get(
      Uri.parse(
          '${api.apiPHP}/sistema/transacciones/imprimirxml/$token/$idEmpresa/$idDocumento'),
    );

    if (resp.body.isEmpty) return '';

    return resp.body;
  }
}
