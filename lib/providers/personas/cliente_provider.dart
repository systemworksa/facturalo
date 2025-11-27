import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:facturaloapp2025/common/api.dart';
import 'package:facturaloapp2025/models/personas/clientes_model.dart';
import 'package:http/http.dart' as http;

class ClienteProvider {
  // ignore: unused_field
  bool _cargando = false;
  final api = Api();

  /* -------------------------------------------------------------------------- */
  /*                              REPUESTA API REST                             */
  /* -------------------------------------------------------------------------- */
  Future<List<Cliente>> _procesaRespuesta(String url) async {
    try {
      final resp = await http.get(Uri.parse(url));

      final decodedData = json.decode("[" + resp.body + "]");

      final gestiones =
          Clientes.fromJsonList(decodedData[0]["consultaClientes"]);

      return gestiones.items;
    } catch (e) {
      return [];
    }
  }

  Future<List<Cliente>> _procesaRespuesta2(String url) async {
    try {
      final resp = await http.get(Uri.parse(url));

      final decodedData = json.decode("[" + resp.body + "]");

      final gestiones = Clientes.fromJsonList(decodedData);
      return gestiones.items;
    } catch (e) {
      return [];
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          OBTENER TOTAL DE PAGINAS                          */
  /* -------------------------------------------------------------------------- */
  getPaginado(llave, idEmpresa, limite, busqueda) async {
    try {
      if (_cargando) return [];

      _cargando = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("idEmpresa")?.isEmpty ?? true) {
        idEmpresa = "0";
      } else {
        idEmpresa = prefs.getString("idEmpresa")!;
      }
      final resp =
          '${api.apiNode}/api/clientes/consultarTotalRegistrosClientes/$llave/$idEmpresa/$limite/?busqueda=$busqueda';
      _cargando = false;

      return await _procesaRespuesta2(resp);
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               OBTENER ORDENES                              */
  /* -------------------------------------------------------------------------- */
  getClientes(llave, idEmpresa, pagina, limite, busqueda) async {
    try {
      if (_cargando) return [];

      _cargando = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("idEmpresa")?.isEmpty ?? true) {
        idEmpresa = "0";
      } else {
        idEmpresa = prefs.getString("idEmpresa")!;
      }

      final resp =
          '${api.apiNode}/api/clientes/consultarClientes/$llave/$idEmpresa/$pagina/$limite/?busqueda=$busqueda';

      _cargando = false;

      return await _procesaRespuesta(resp);
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                CREAR CLIENTE                               */
  /* -------------------------------------------------------------------------- */
  crearCliente(idEmpresa, cedula, nombre, telefono, email, direccion,
      tipoIdentificacion, token) async {
    try {
      final resp = await http.post(
          Uri.parse('${api.apiNode}/api/clientes/registrarCliente'),
          body: <String, String>{
            'cedula': cedula,
            'nombres': nombre,
            'nombreComercial': nombre,
            'correo': email,
            'direccion': direccion,
            'telefono': telefono,
            'idEmpresa': idEmpresa,
            'tipoIdentificacion': tipoIdentificacion,
            'token': token
          });

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               EDITAR CLIENTE                               */
  /* -------------------------------------------------------------------------- */
  editarCliente(idEmpresa, idCliente, cedula, nombre, telefono, email,
      direccion, tipoIdentificacion, token) async {
    try {
      final resp = await http.put(
          Uri.parse('${api.apiNode}/api/clientes/editarCliente'),
          body: <String, String>{
            'cedula': cedula,
            'idCliente': idCliente,
            'nombres': nombre,
            'nombreComercial': nombre,
            'correo': email,
            'direccion': direccion,
            'telefono': telefono,
            'idEmpresa': idEmpresa,
            'tipoIdentificacion': tipoIdentificacion,
            'token': token
          });

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "[{'status' : 'false' , 'message' : 'error'}]";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              ELIMINAR CLIENTE                              */
  /* -------------------------------------------------------------------------- */
  eliminarCliente(idCliente, token) async {
    try {
      final resp = await http.delete(
          Uri.parse('${api.apiNode}/api/clientes/eliminarCliente'),
          body: <String, String>{'idCliente': idCliente, 'token': token});

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  getClienteSearch(llave, idEmpresa, busqueda) async {
    try {
      if (_cargando) return [];

      _cargando = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("idEmpresa")?.isEmpty ?? true) {
        idEmpresa = "0";
      } else {
        idEmpresa = prefs.getString("idEmpresa")!;
      }

      final resp =
          '${api.apiNode}/api/clientes/consultarClientesAtributo/$llave/$idEmpresa/?busqueda=$busqueda';

      _cargando = false;

      return await _procesaRespuesta(resp);
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  getItemCliente(llave, idEmpresa, item, valor) async {
    try {
      if (_cargando) return [];

      _cargando = true;

      final resp =
          '${api.apiNode}/api/clientes/consultarClientePorCampo/$llave/$idEmpresa/?campo=$item&valor=$valor';

      _cargando = false;

      return await _procesaRespuesta(resp);
    } catch (e) {
      return "{'status' : 'false' , 'message' : 'error'}";
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                             BUSCAR DATA PERSONA                            */
  /* -------------------------------------------------------------------------- */
  getDataPersona(llave, identificacion) async {
    if (_cargando) return [];

    _cargando = true;

    final resp =
        'https://api-rest.wilyfam.com/sistema/data-personas/$llave/$identificacion';

    _cargando = false;

    return await _procesaRespuesta(resp);
  }

  getDataPersona2(cedula) async {
    try {
      final resp = await http.post(
          Uri.parse('${api.apiSistema}/factumatic/ajax/registrocivil.ajax.php'),
          body: <String, String>{'cedula': cedula});

      if (resp.body.isEmpty) return '';

      return resp.body;
    } catch (e) {
      return "[{'status' : 'false' , 'message' : 'error'}]";
    }
  }
}
