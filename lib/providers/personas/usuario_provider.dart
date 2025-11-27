// ignore_for_file: deprecated_member_use

import 'package:facturaloapp2025/common/api.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class UsuarioProvider {
  // ignore: unused_field
  final bool _cargando = false;
  final api = Api();

  /* -------------------------------------------------------------------------- */
  /*                               GUARDAR USUARIO                              */
  /* -------------------------------------------------------------------------- */
  saveUser(cedula, nombres, password, email, telefono) async {
    try {
      final resp = await http.post(
          Uri.parse('${api.apiNode}/api/usuarios/registrarUsuario'),
          body: <String, String>{
            'cedula': cedula,
            'nombres': nombres,
            'password': password,
            'email': email,
            'telefono': telefono
          });

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                    LOGIN                                   */
  /* -------------------------------------------------------------------------- */
  loginUser(email, clave) async {
    try {
      final resp = await http.post(
          Uri.parse('${api.apiNode}/api/usuarios/iniciarSesion'),
          body: <String, String>{'usuario': email, 'password': clave});

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      print(e);
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                      ACTUALIZAR LA EMPRESA DEL USUARIO                     */
  /* -------------------------------------------------------------------------- */
  upload(
      cedula,
      razonSocial,
      nombreComercial,
      ciudad,
      direccion,
      celular,
      codigoArtesanal,
      email,
      opcionObligado,
      opcionTipoContribuyente,
      opcionAgenteRetencion,
      firma,
      claveFirma,
      impuesto,
      imagen,
      token,
      idEmpresa) async {
    try {
      // string to uri
      var uri = Uri.parse("${api.apiPHP}/sistema/empresa/actualizarEmpresa");

      var request = http.MultipartRequest("POST", uri);
      if (firma != null) {
        var stream = http.ByteStream(DelegatingStream.typed(firma.openRead()));
        var length = await firma.length();
        var multipartFile = http.MultipartFile(
          'firmaElectronica',
          stream,
          length,
          filename: basename(firma.path),
        );
        request.files.add(multipartFile);
      } else {
        request.fields['firmaElectronica'] = '';
      }

      if (imagen != null) {
        // open a bytestream
        var stream1 =
            http.ByteStream(DelegatingStream.typed(imagen.openRead()));
        // get file length
        var length1 = await imagen.length();

        // multipart that takes file
        var multipartFileImagen = http.MultipartFile(
            'imgEmpresa', stream1, length1,
            filename: basename(imagen.path));

        // add file to multipart
        request.files.add(multipartFileImagen);
      } else {
        request.fields['imgEmpresa'] = '';
      }

      // print(request.files);
      request.fields['token'] = token;
      request.fields['claveFirma'] = claveFirma;
      request.fields['proveedorFirma'] = '';
      request.fields['ruc'] = cedula;
      request.fields['razonSocial'] = razonSocial;
      request.fields['nombreComercial'] = nombreComercial;
      request.fields['ciudad'] = ciudad;
      request.fields['direccion'] = direccion;
      request.fields['contacto'] = celular;
      request.fields['email'] = email;
      request.fields['codigoArtesanal'] = codigoArtesanal;
      request.fields['llevaContabilidad'] = opcionObligado;
      request.fields['tipoContribuyente'] = opcionTipoContribuyente;
      request.fields['agenteRetencion'] = opcionAgenteRetencion;
      request.fields['tarifaImpuesto'] = impuesto;
      request.fields['idEmpresa'] = idEmpresa;
      // send
      var response = await request.send();

      // listen for response
      return response;
    } catch (e) {
      return "{'status' : 'false' , 'message' : $e}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              ACTUALIZAR IMAGEN                             */
  /* -------------------------------------------------------------------------- */
  uploadImg(imagen, token, idEmpresa) async {
    try {
      // open a bytestream
      // get file length

      // string to uri
      var uri = Uri.parse("${api.apiPHP}/sistema/empresa/actualizarImgEmpresa");

      var request = http.MultipartRequest("POST", uri);

      try {
        // open a bytestream
        var stream1 =
            http.ByteStream(DelegatingStream.typed(imagen.openRead()));
        // get file length
        var length1 = await imagen.length();

        // multipart that takes file
        var multipartFileImagen = http.MultipartFile(
            'imgEmpresa', stream1, length1,
            filename: basename(imagen.path));

        // add file to multipart
        request.files.add(multipartFileImagen);
      } catch (e) {
        request.fields['imgEmpresa'] = '';
      }

      // print(request.files);
      request.fields['token'] = token;
      request.fields['idEmpresa'] = idEmpresa;
      // send
      var response = await request.send();

      // listen for response

      return response;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               CONSULTAR DATA                               */
  /* -------------------------------------------------------------------------- */
  consultarData(documento) async {
    try {
      final resp = await http.post(
          Uri.parse(
              'https://sistema.cm-salud.com/radiografia/ajax/pacientes.ajax.php'),
          body: <String, String>{'documento': documento});

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               CONSULTAR DATA                               */
  /* -------------------------------------------------------------------------- */
  consultaRimpe(documento) async {
    final resp = await http.post(
        Uri.parse(
            'https://sistema.cm-salud.com/radiografia/ajax/pacientes.ajax.php'),
        body: <String, String>{'ruc': documento, 'consultarRimpe': 'ok'});

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                         VALIDAR EMAIL RECUPERACION                         */
  /* -------------------------------------------------------------------------- */
  validarEmail(email) async {
    final resp = await http.put(
        Uri.parse('${api.apiNode}/api/usuarios/enviarcodigo'),
        body: <String, String>{'email': email});

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                         VALIDAR CODIGO RECUPERACION                        */
  /* -------------------------------------------------------------------------- */
  validarCodigo(codigo, email) async {
    final resp = await http.post(
        Uri.parse('${api.apiNode}/api/usuarios/validarcodigo'),
        body: <String, String>{'email': email, 'codv': codigo});

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                              ACTUALIZAR CLAVE                              */
  /* -------------------------------------------------------------------------- */
  actualizarClave(clave, email) async {
    final resp = await http.put(
        Uri.parse('${api.apiNode}/api/usuarios/actualizarpassword'),
        body: <String, String>{'newpassword': clave, 'email': email});

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                                 CREAR PING                                 */
  /* -------------------------------------------------------------------------- */
  crearPing(idUsuario, token, ping) async {
    final resp = await http.post(
        Uri.parse('${api.apiNode}/api/usuarios/crearPin'),
        body: <String, String>{
          'idUsuario': idUsuario,
          'pin': ping,
          'token': token
        });

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                                VALIDAR PING                                */
  /* -------------------------------------------------------------------------- */
  validarPing(ping, token, idUsuario) async {
    final resp = await http.post(
        Uri.parse('${api.apiNode}/api/usuarios/validarPin'),
        body: <String, String>{
          'idUsuario': idUsuario,
          'pin': ping,
          'token': token
        });

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                         NUEVO PING - (RECUPERACION)                        */
  /* -------------------------------------------------------------------------- */
  nuevoPing(ping, token, idUsuario) async {
    final resp = await http.put(
        Uri.parse('${api.apiNode}/api/usuarios/actualizarpin'),
        body: <String, String>{
          'newpin': ping,
          'iduser': idUsuario,
          'token': token
        });

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  /* -------------------------------------------------------------------------- */
  /*                           MODIFICAR DATOS USUARIO                          */
  /* -------------------------------------------------------------------------- */
  updateUser(
      idUsuario, identificacion, nombre, clave, pin, email, token) async {
    final resp = await http.put(
        Uri.parse('${api.apiNode}/api/usuarios/actualizarusuario'),
        body: <String, String>{
          'idUsuario': idUsuario,
          'identificacion': identificacion,
          'nombres': nombre,
          'clave': clave,
          'pin': pin,
          'email': email,
          'token': token
        });

    if (resp.body.isEmpty) return '';

    return resp.body;
  }

  eliminarCuenta(idUsuario, token) async {
    final resp = await http.post(
        Uri.parse('${api.apiPHP}/sistema/empresa/eliminarusuarioempresa'),
        body: <String, String>{'idUsuario': idUsuario, 'token': token});

    if (resp.body.isEmpty) return '';

    return resp.body;
  }
}
