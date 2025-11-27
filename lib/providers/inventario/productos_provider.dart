import 'dart:convert';

import 'package:facturaloapp2025/common/api.dart';
import 'package:facturaloapp2025/models/inventario/productos_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class ProductoProvider {
  // ignore: unused_field
  bool _cargando = false;
  bool _cargandoIce = false;
  final api = Api();

  /* -------------------------------------------------------------------------- */
  /*                              REPUESTA API REST                             */
  /* -------------------------------------------------------------------------- */
  Future<List<Producto>> _procesaRespuesta(String url) async {
  try {
    final resp = await http.get(Uri.parse(url));
    final decodedData = json.decode(resp.body);
    final gestiones = Productos.fromJsonList(decodedData["consultarProductos"]);
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
      //print(decodedData);
      return [consultarICE, tarifaImpuesto];
    } catch (e) {
      return [];
    }
  }


  /* -------------------------------------------------------------------------- */
  /*                              OBTENER PRODUCTOS                             */
  /* -------------------------------------------------------------------------- */
  getProductos(llave, idEmpresa) async {
    if (_cargando) return [];

    _cargando = true;

    final resp =
        '${api.apiNode}/api/productos/consultarProductos/$llave/$idEmpresa';

    _cargando = false;
    
    return await _procesaRespuesta(resp);
  }

  /* -------------------------------------------------------------------------- */
  /*                              OBTENER LISTADO ICE                           */
  /* -------------------------------------------------------------------------- */
  getCodigosICE(llave, idEmpresa) async {
    if (_cargandoIce) return [];

    _cargandoIce = true;

    final resp =
        '${api.apiNode}/api/productos/consultarIce/$llave/$idEmpresa';

    _cargandoIce = false;     
    return await procesaRespuesta2(resp);
  }

  saveProducto(
      codigo,
      nombre,
      descripcion,
      impuesto,
      imagen,
      preciomanual,
      precioCosto,
      precioPublico,
      precioDistribuidor,
      precioMayorista,
      precioLiquidacion,
      opcionAplicaImpuestoICE,
      opcionCodigoImpuestoICE,
      valorTarifaImpuestoICE,
      token,
      idEmpresa) async {
    try {
      // open a bytestream
      // ignore: deprecated_member_use
      // get file length

      // string to uri
      var uri = Uri.parse("${api.apiNode}/api/productos/guardarproducto");

      var request = http.MultipartRequest("POST", uri);

      try {
        // open a bytestream
        // ignore: deprecated_member_use
        var stream1 =
            // ignore: deprecated_member_use
            http.ByteStream(DelegatingStream.typed(imagen.openRead()));
        // get file length
        var length1 = await imagen.length();

        // multipart that takes file
        var multipartFileImagen = http.MultipartFile('imagen', stream1, length1,
            filename: basename(imagen.path));

        // add file to multipart
        request.files.add(multipartFileImagen);
      } catch (e) {
        request.fields['imagen'] = '';
      }

      request.fields['token'] = token;
      request.fields['idEmpresa'] = idEmpresa;
      request.fields['estado'] = '1';
      request.fields['codigo'] = codigo;
      request.fields['codigoAuxiliar'] = codigo;
      request.fields['nombrePro'] = nombre;
      request.fields['descripcionPro'] = descripcion;
      request.fields['precioCosto'] = precioCosto;
      request.fields['precioPublico'] = precioPublico;
      request.fields['preDist'] = precioDistribuidor;
      request.fields['preMay'] = precioMayorista;
      request.fields['preLiq'] = precioLiquidacion;
      request.fields['codigoImpuesto'] = impuesto.toString();
      request.fields['tipoIce'] = opcionAplicaImpuestoICE.toString();
      request.fields['codigoIce'] = opcionCodigoImpuestoICE.toString();
      request.fields['valorIce'] = valorTarifaImpuestoICE.toString();
      request.fields['pvpManual'] = preciomanual.toString();  
      // send
      var response = await request.send();

      // listen for response      
      return response;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'false'}";
    }
  }

  updateProducto(
      idProducto,
      codigo,
      nombre,
      descripcion,
      impuesto,
      imagen,
      preciomanual,
      precioCosto,
      precioPublico,
      precioDistribuidor,
      precioMayorista,
      precioLiquidacion,      
      opcionAplicaImpuestoICE,
      opcionCodigoImpuestoICE,
      valorTarifaImpuestoICE,
      token,
      idEmpresa) async {
    try {
      // open a bytestream
      // ignore: deprecated_member_use
      // get file length

      // string to uri
      var uri = Uri.parse("${api.apiNode}/api/productos/modificarproducto");

      var request = http.MultipartRequest("PUT", uri);

      try {
        // open a bytestream
        // ignore: deprecated_member_use
        if (imagen != null) {
          var stream1 =
              // ignore: deprecated_member_use
              http.ByteStream(DelegatingStream.typed(imagen.openRead()));
          // get file length
          var length1 = await imagen.length();

          // multipart that takes file
          var multipartFileImagen = http.MultipartFile('imagen', stream1, length1,
              filename: basename(imagen.path));

          // add file to multipart
          request.files.add(multipartFileImagen);
        }else{
          request.fields['imagen'] = '';
        }  
      } catch (e) {
        request.fields['imagen'] = '';
      }

      // print(request.files);
      request.fields['idProducto'] = idProducto;
      request.fields['token'] = token;
      request.fields['idEmpresa'] = idEmpresa;
      request.fields['estado'] = '1';
      request.fields['codigo'] = codigo;
      request.fields['codigoAuxiliar'] = codigo;
      request.fields['nombrePro'] = nombre;
      request.fields['descripcionPro'] = descripcion;
      request.fields['precioCosto'] = precioCosto;
      request.fields['precioPublico'] = precioPublico;
      request.fields['preDist'] = precioDistribuidor;
      request.fields['preMay'] = precioMayorista;
      request.fields['preLiq'] = precioLiquidacion;      
      request.fields['codigoImpuesto'] = impuesto.toString();
      request.fields['tipoIce'] = opcionAplicaImpuestoICE.toString();
      request.fields['codigoIce'] = opcionCodigoImpuestoICE.toString();
      request.fields['valorIce'] = valorTarifaImpuestoICE.toString();      
      request.fields['pvpManual'] = preciomanual.toString();
      // send
      var response = await request.send();

      // listen for response

      return response;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  eliminarProducto(idCliente, token) async {
    try {
      final resp = await http.delete(
          Uri.parse('${api.apiNode}/api/productos/eliminarproducto'),
          body: <String, String>{'idProducto': idCliente, 'token': token});

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }
}
