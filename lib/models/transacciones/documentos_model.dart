class Documentos {
  List<Documento> items = [];

  Documentos();

  Documentos.fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) return;

    for (var item in jsonList) {
      final usuario = Documento.fromJsonMap(item);
      items.add(usuario);
    }
  }
}

class Documento {
  String? idTransaccion;
  String? secuencialFacturaE;
  String? secuencialFacturaF;
  String? secuencialRetencion;
  String? secuencialNotaCredito;
  String? secuencialLiquidacion;
  String? secuencialDebito;
  String? secuencialProforma;
  String? tipo;
  String? fechaRegistro;
  String? subtotal12;
  String? subtotal0;
  String? subtotalEXENTO;
  String? subtotalNOBJETO; 
  String? valorIce;
  String? detalle;
  String? subtotal;
  String? descuento;
  String? iva;
  String? total;
  String? totalRetencion;
  String? totalPagar;
  String? observacion;
  String? metodoPago;
  String? idUsuario;
  String? idCliente;
  String? estado;
  String? claveDocumento;
  String? enviadoCliente;
  String? autorizado;
  String? documentoAnulado;
  String? fechaAutorizacion;
  String? idProveedor;
  String? estadoCompra;
  String? numeroFacturaNotaCredito;
  String? motivoNotaCredito;
  String? tipoNotaCredito;
  String? claveFacturaRetencion;
  String? fechaFacturaRetencion;
  String? secuencialFacturaRetencion;
  String? motivoBaja;
  String? cabaceraCompra;
  String? codigoDocumentoCompra;
  String? codCliente;
  String? cedulaCliente;
  String? nombreCliente;
  String? emailCliente;
  String? direccionCliente;
  String? tarifaImpuesto;
  String? totalPaginas;
  String? paginaActual;

  Documento(
      {required this.idTransaccion,
      required this.secuencialFacturaE,
      required this.secuencialFacturaF,
      required this.secuencialRetencion,
      required this.secuencialNotaCredito,
      required this.secuencialLiquidacion,
      required this.secuencialDebito,
      required this.secuencialProforma,
      required this.tipo,
      required this.fechaRegistro,
      required this.subtotal12,
      required this.subtotal0,
      required this.subtotalEXENTO,
      required this.subtotalNOBJETO, 
      required this.valorIce,
      required this.detalle,
      required this.subtotal,
      required this.descuento,
      required this.iva,
      required this.total,
      required this.totalRetencion,
      required this.totalPagar,
      required this.observacion,
      required this.metodoPago,
      required this.idUsuario,
      required this.idCliente,
      required this.estado,
      required this.claveDocumento,
      required this.enviadoCliente,
      required this.autorizado,
      required this.documentoAnulado,
      required this.fechaAutorizacion,
      required this.idProveedor,
      required this.estadoCompra,
      required this.numeroFacturaNotaCredito,
      required this.motivoNotaCredito,
      required this.tipoNotaCredito,
      required this.claveFacturaRetencion,
      required this.fechaFacturaRetencion,
      required this.secuencialFacturaRetencion,
      required this.motivoBaja,
      required this.cabaceraCompra,
      required this.codigoDocumentoCompra,
      required this.codCliente,
      required this.cedulaCliente,
      required this.nombreCliente,
      required this.emailCliente,
      required this.direccionCliente,
      required this.tarifaImpuesto,
      required this.totalPaginas,
      required this.paginaActual});

  Documento.fromJsonMap(Map<String, dynamic> json) {
    idTransaccion = json["COD_TRAC"].toString();
    secuencialFacturaE = json["NUM_TRAC"].toString();
    secuencialFacturaF = json["NUM_TRACFIC"].toString();
    secuencialRetencion = json["NUMRETCOM_TRAC"].toString();
    secuencialNotaCredito = json["NUM_TRACNOT"].toString();
    secuencialLiquidacion = json["NUM_LIQ"].toString();
    secuencialDebito = json["NUM_DEB"].toString();
    secuencialProforma = json["NUM_TRACPROF"].toString();
    tipo = json["TIP_TRAC"].toString();
    fechaRegistro = json["FEC_TRAC"].toString();
    subtotal12 = json["SUB12_TRAC"].toString();
    subtotalEXENTO = json["	SUBEXENTO_TRAC"].toString();
    subtotalNOBJETO = json["SUBNOBJETO_TRAC"].toString();
    subtotal0 = json["SUB0_TRAC"].toString();
    valorIce = json["VALICE_TRAC"].toString();
    detalle = json["DET_TRAC"].toString();
    subtotal = json["SUB_TRAC"].toString();
    descuento = json["DES_TRAC"].toString();
    iva = json["IVA_TRAC"].toString();
    total = json["TOT_TRAC"].toString();
    totalRetencion = json["TOTRET_TRAC"].toString();
    totalPagar = json["TOTPAG_TRAC"].toString();
    observacion = json["OBS_TRAC"].toString();
    metodoPago = json["METPAG_TRAC"].toString();
    idUsuario = json["FK_COD_USU"].toString();
    idCliente = json["FK_COD_CLI"].toString();
    estado = json["estado"].toString();
    claveDocumento = json["claveFactura"].toString();
    enviadoCliente = json["enviado"].toString();
    autorizado = json["autorizado"].toString();
    documentoAnulado = json["documentoAnulado"].toString();
    fechaAutorizacion = json["fechaAutorizado"].toString();
    idProveedor = json["FK_COD_PROVE"].toString();
    estadoCompra = json["EST_COMP"].toString();
    numeroFacturaNotaCredito = json["NUMFACNOT_TRAC"].toString();
    motivoNotaCredito = json["motivoNota"].toString();
    tipoNotaCredito = json["tipo_nota"].toString();
    claveFacturaRetencion = json["claveFacturaRet"].toString();
    fechaFacturaRetencion = json["fechaFacturaRet"].toString();
    secuencialFacturaRetencion = json["secuencialFacturaRet"].toString();
    motivoBaja = json["motivoBaja"].toString();
    cabaceraCompra = json["cabecera_compra"].toString();
    codigoDocumentoCompra = json["codigoDocCompra"].toString();
    codCliente = json["COD_CLI"].toString();
    cedulaCliente = json["CED_CLI"].toString();
    nombreCliente = json["NOM_CLI"].toString();
    emailCliente = json["EMA_CLI"].toString();
    direccionCliente = json["DIR_CLI"].toString();
    tarifaImpuesto = json["TARIFAIVA_TRAC"].toString();
    totalPaginas = json["totalPaginas"].toString();
    paginaActual = json["paginaActual"].toString();

  }
}
