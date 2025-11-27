import 'dart:convert';

import 'package:facturaloapp2025/models/transacciones/detalle_model.dart';

class DetalleProvider {
  bool _cargando = false;
  Future<List<Detalle>> _procesaRespuesta(res) async {
    final decodedData = await json.decode(res);
    final gestiones = DetalleOrdenes.fromJsonList(decodedData);

    return gestiones.items;
  }

  //OBTENER DATOS DE DOCTORES POR MEDIO DE LA CEDULA
  addDetalle(String res) async {
    if (_cargando) return [];

    _cargando = true;

    _cargando = false;

    return await _procesaRespuesta(res);
  }

  //OBTENER DATOS DE DOCTORES POR MEDIO DE LA CEDULA
  addCombos(String res) async {
    if (_cargando) return [];

    _cargando = true;

    _cargando = false;

    return await _procesaRespuesta(res);
  }

  addDetallePagos(String res) async {
    if (_cargando) return [];

    _cargando = true;

    _cargando = false;

    return await _procesaRespuesta(res);
  }
}
