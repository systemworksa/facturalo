import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/models/inventario/productos_model.dart';
import 'package:facturaloapp2025/models/personas/clientes_model.dart';
import 'package:facturaloapp2025/models/transacciones/detalle_model.dart';
import 'package:facturaloapp2025/models/transacciones/documentos_model.dart';
import 'package:facturaloapp2025/providers/inventario/productos_provider.dart';
import 'package:facturaloapp2025/providers/personas/cliente_provider.dart';
import 'package:facturaloapp2025/providers/transacciones/detalle_provider.dart';
import 'package:facturaloapp2025/providers/transacciones/documentos_provider.dart';
import 'package:facturaloapp2025/providers/transacciones/visualizar_pdf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../common/colorExadecimal.dart';
import '../../../common/theme_helper.dart';
import '../../../common/toast_message.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';

class EditarVentaPage extends StatefulWidget {
  const EditarVentaPage({Key? key}) : super(key: key);

  @override
  State<EditarVentaPage> createState() => _EditarVentaPageState();
}

class _EditarVentaPageState extends State<EditarVentaPage>
    with TickerProviderStateMixin {
  bool puedePresionarBoton = true;    
  int _n = 0; //counter variable

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  static AudioCache player = AudioCache();
  final message = ToastMessage();

  bool? nuevocliente = false;
  bool? retiro = false;
  int contadorG = 0;
  int contadorEnvio = 0;

  final Color color = HexColor.fromHex('#262f69');
  final TextEditingController _inputFieldDateController =
      TextEditingController();
  final TextEditingController _inputFieldNombreController =
      TextEditingController();
  final TextEditingController _inputFieldIdentificacionController =
      TextEditingController();
  final TextEditingController _inputFieldTelefonoController =
      TextEditingController();
  final TextEditingController _inputFieldDireccionController =
      TextEditingController();
  final TextEditingController _inputFieldEmailController =
      TextEditingController();

  final TextEditingController _inputFieldObservacionController =
      TextEditingController();

  final TextEditingController _inputFieldBuscarController =
      TextEditingController();

  final TextEditingController _inputFieldValorRecargoController =
      TextEditingController();

  String idDocumento = "";

  final load = Load();

  //JSON ENCODER
  final jsonEncoder = const JsonEncoder();

  // ignore: unused_field
  bool _isLoading = false;

  //PROVIDERS
  final _clientes = ClienteProvider();
  final _producto = ProductoProvider();
  final _detalleOrden = DetalleProvider();
  final _documentos = DocumentosProvider();

  //LISTAS
  List<Cliente> clienteItem = [];
  List<String> newListaCliente = [];
  List<Producto> productoItem = [];
  List<Producto> productoItemSearch = [];
  List<Producto> newDataList = [];
  final List<TextEditingController> _controllerSD = [];
  final List<TextEditingController> _controllerDT = [];
  List<Color> listaColor = [];
  List<String> titulo = [];
  List<int> contador = [];
  List<bool> bloqueo = [];

  //ARRAYS
  var array = [];
  var arrayPosicion = [];
  var arraycaja = [];
  var arrayBanco = [];
  var arrayCredito = [];
  var arrayComboS = [];
  var arrayPosicionCombo = [];
  List<String> arrayCiudadesEntrega = [];
  List<String> arrayCombos = [];

  List<Detalle> detalle = [];

  //VARIABLES STRING
  String tarifaIva = '12';
  String opcionCiudad = "";
  String opcionTipoVenta = "Electronica";
  String opcionTipoOrden = "";
  String opcionMetodoPago = "";
  String opcionMetodoPagoMultiple = "";
  String opcionMotorizado = "";
  String opcionCiudadEnvio = "Seleccione...";
  String opcionSoluciones = "";
  String opcionCaja = "";
  String opcionBanco = "";
  String selectCliente = "";
  String idCliente = "";
  String totalPagar = "0.00";
  String totalFinal12 = "0.00";
  String totalFinal0 = "0.00";
  String totalFinalExento = "0.00";
  String totalFinalNObjeto = "0.00";
  String ivaFinal = "0.00";
  String iceFinal = "0.00";
  String subtotalFinal = "0.00";
  String opcionCombos = "Seleccione...";
  String valorRecargo = "";
  String valorStandar = "";
  late TabController _controller;
  int totalPaginas = 3;
  String perfil = '';
  double totalCancelado = 0;
  double totalPendiente = 0;
  String idFactura = "";
  int conP = 0;
  String numeroFactura = "";
  String descuento = '0.00';
  var colorBtnGuardar = Colors.white;
  final clientes = ClienteProvider();

  GestureDetector gestureDetector = GestureDetector();
 // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();

    _controller = TabController(
      vsync: this,
      length: totalPaginas,
      initialIndex: 0,
    );
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    _inputFieldDateController.text = formattedDate;
   //     _internetDialog = InternetDialog(context);
  //  _connectivitySubscription =
  //  _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);

    //_obtenerItemCliente("NOM_CLI", "CONSUMIDOR FINAL");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    conP++;
    if (conP == 1) {
      setState(() {
        Documento documento =
            ModalRoute.of(context)!.settings.arguments as Documento;
        opcionTipoVenta = documento.tipo!;
        idDocumento = documento.idTransaccion!;
        opcionMetodoPago = documento.metodoPago!;
        _inputFieldObservacionController.text = documento.observacion!;
        tarifaIva = documento.tarifaImpuesto?.isEmpty ?? true ?tarifaIva:documento.tarifaImpuesto.toString();
        _obtenerItemCliente("COD_CLI", documento.idCliente);
        final List<dynamic> json = jsonDecode(documento.detalle!);
        // Create a copy of json
        final List<dynamic> json2 = List.from(json);
        for (var child in json2) {


          array.add({
            "bodega": "CENTRAL",
            "cantidad": child["cantidad"],
            "codigo": child["codigo"],
            "codigoimpuesto": (child["codigoimpuesto"] is String && child["codigoimpuesto"]?.isEmpty == false) ? child["codigoimpuesto"] : "0",//
            "ice": child["ice"]?.isEmpty ?? true ?"":child["ice"],
            "id": child["id"],
            "impuesto": child["impuesto"],
            "nombre": child["nombre"],
            "observacion": child["observacion"],     
            "porcentajeDescuento": child["porcentajeDescuento"]!!= null ? child["porcentajeDescuento"]:"0.00",
            "precio": child["precioProducto"],
            "preciomanual": (child["preciomanual"] is String && child["preciomanual"]?.isEmpty == false) ? child["preciomanual"] : "0",
            "precioProducto": child["precioProducto"],
            "precioSinIva": child["precioSinIva"],
            "tarifaice": child["tarifaice"]?.toString() ?? 0,
            
            "tipoice": child["tipoice"]?.isEmpty ?? true?"No aplica":child["tipoice"],
            "tota": child["tota"],
            "valorDescuento": child["valorDescuento"]!!= null?child["valorDescuento"]:"0.00",
            "valores": child["valores"]?.isEmpty ?? true?[{"nombre": 'Publico',"valor": child["precioProducto"]}]:child["valores"],
            "valorice": child["valorice"]?.toString() ??"",
            
          });
          if (opcionTipoVenta == 'Electronica') {
            numeroFactura =
                documento.secuencialFacturaE.toString().substring(8);
          } else {
            numeroFactura =
                documento.secuencialFacturaF.toString().substring(8);
          }

          arrayPosicion.add(child["idProducto"]);
          
        }
        //Timer(const Duration(seconds: 2), () {
        setState(() {
              setServicios();
        });
        //});
      });
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          '¿Está seguro que desea salir de esta página?',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        content: Text(
          'Si no lo está puede cancelar esta acción',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1), fontSize: 14.0),
          ),
        ),
        actions: [
          Row(
            children: <Widget>[
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: roundedButton("Cancelar", color, color),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'listar-documentos');
                },
                child: roundedButton("  Si  ", color, color),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  /* -------------------------------------------------------------------------- */
  /*                               REDONDEAR BOTON                              */
  /* -------------------------------------------------------------------------- */
  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = Container(
      padding: const EdgeInsets.all(7.0),
      width: 90,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0xFF696969),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: GoogleFonts.lato(
          textStyle: const TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ),
    );
    return loginBtn;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
          length: 3,
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  "Editar documento ($numeroFactura)",
                  style: const TextStyle(fontSize: 15.0),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => _onBackPressed(),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      contadorG++;
                      FocusScope.of(context).unfocus();
                      if (puedePresionarBoton == true) {
                        guardarOrden();
                        contadorG = 0;
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.save, color: colorBtnGuardar, size: 20.0),
                        Text(
                          ' GUARDAR',
                          style: TextStyle(color: colorBtnGuardar, fontSize: 11.0),
                        ),
                      ],
                    ),
                  ),
                ],
                bottom: TabBar(
                  controller: _controller,
                  indicatorColor: Colors.white,
                  tabs: totalPaginas >= 3 && totalPaginas <= 3
                      ? const [
                          Icon(Icons.table_view_outlined),
                          Icon(Icons.person),
                          Icon(Icons.list_alt),
                        ]
                      : totalPaginas >= 4 && totalPaginas <= 4
                          ? opcionTipoOrden == 'envio'
                              ? [
                                  const Icon(Icons.table_view_outlined),
                                  const Icon(Icons.send_sharp),
                                  const Icon(Icons.person),
                                  const Icon(Icons.list_alt),
                                ]
                              : [
                                  const Icon(Icons.table_view_outlined),
                                  const Icon(Icons.person),
                                  const Icon(Icons.list_alt),
                                  const Icon(Icons.payment),
                                ]
                          : const [
                              Icon(Icons.table_view_outlined),
                              Icon(Icons.send_sharp),
                              Icon(Icons.person),
                              Icon(Icons.list_alt),
                              Icon(Icons.payment),
                            ],
                ),
              ),
              body: totalPaginas >= 3 && totalPaginas <= 3
                  ? TabBarView(controller: _controller, children: [
                      seccionDatosGenerales(),
                      seccionCliente(),
                      seccionDetallePedido()
                    ])
                  : totalPaginas >= 4 && totalPaginas <= 4
                      ? opcionTipoOrden == 'envio'
                          ? TabBarView(controller: _controller, children: [
                              seccionDatosGenerales(),
                              seccionCliente(),
                              seccionDetallePedido()
                            ])
                          : TabBarView(controller: _controller, children: [
                              seccionDatosGenerales(),
                              seccionCliente(),
                              seccionDetallePedido(),
                            ])
                      : TabBarView(controller: _controller, children: [
                          seccionDatosGenerales(),
                          seccionCliente(),
                          seccionDetallePedido(),
                        ]))),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                             SELECCIONAR CLIENTE                            */
  /* -------------------------------------------------------------------------- */
  Future<void> _navigateAndDisplaySelection() async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    try {
      Cliente cliente =
          await Navigator.pushNamed(context, 'listar-clientes-venta')
              as Cliente;
      // When a BuildContext is used from a StatefulWidget, the mounted property
      // must be checked after an asynchronous gap.
      if (!mounted) return;

      // After the Selection Screen returns a result, hide any previous snackbars
      // and show the new result.
      _inputFieldIdentificacionController.text =
          cliente.cedula?.isEmpty ?? true ? "" : cliente.cedula!;
      _inputFieldNombreController.text =
          cliente.nombreComercial?.isEmpty ?? true
              ? ""
              : cliente.nombreComercial!;
      _inputFieldTelefonoController.text =
          cliente.telefono?.isEmpty ?? true ? "" : cliente.telefono!;
      _inputFieldDireccionController.text =
          cliente.direccion?.isEmpty ?? true ? "" : cliente.direccion!;
      _inputFieldEmailController.text =
          cliente.email?.isEmpty ?? true ? "" : cliente.email!;
      idCliente = cliente.idCliente!;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('Cliente seleccionado correctamente')));
    } catch (e) {
      _obtenerItemCliente("NOM_CLI", "CONSUMIDOR FINAL");
      message.showToast(
          'No se pudo seleccionar ningún cliente, error capturado $e');
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                CREAR CLIENTE                               */
  /* -------------------------------------------------------------------------- */
  //A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop.
  Future<void> _navigateCrearClienteVenta() async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    try {
      final cliente = await Navigator.pushNamed(context, 'crear-cliente-venta');
      if (cliente == null) {
        _obtenerItemCliente("NOM_CLI", "CONSUMIDOR FINAL");
        message.showToast('No se creó ningun cliente.');
        return;
      }
      // When a BuildContext is used from a StatefulWidget, the mounted property
      // must be checked after an asynchronous gap.
      if (!mounted) return;

      // After the Selection Screen returns a result, hide any previous snackbars
      // and show the new result.
      _obtenerItemCliente("CED_CLI", cliente);

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('Cliente creado y seleccionado correctamente')));
    } catch (e) {
      _obtenerItemCliente("NOM_CLI", "CONSUMIDOR FINAL");
      message.showToast(
          'No se pudo seleccionar ningún cliente, error capturado $e');
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                           SECCION DATOS GENERALES                          */
  /* -------------------------------------------------------------------------- */
  Widget seccionDatosGenerales() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ListView(
        children: [
          const SizedBox(height: 30.0),
          Text('Datos generales de la factura',
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: color,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold))),
          const SizedBox(height: 10.0),
          CircleAvatar(
            backgroundColor: color,
            child: const Text('1', style: TextStyle(color: Colors.white)),
          ),
          Image.asset(
            'assets/img/datosgenerales.png',
            height: 160.0,
          ),
          const SizedBox(height: 10.0),
          _isLoading ? load.loading() : Container(),
          const SizedBox(height: 10.0),
          Container(
            child: TextField(
              controller: _inputFieldDateController,
              showCursor: true,
              readOnly: true,
              onTap: () {
                _selectDate();
              },
              enableInteractiveSelection: false,
              decoration:
                  ThemeHelper().textInputDecoration('Fecha', 'Ingrese fecha'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(height: 20.0),
          Container(
            child: DropdownButtonFormField(
              value: opcionTipoVenta,
              items: getTipoVenta(),
              onChanged: null,
              decoration: ThemeHelper().textInputDecoration(
                  'Tipo de documento', 'Seleccione tipo documento'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(height: 20.0),
          Container(
            child: DropdownButtonFormField(
              value: opcionMetodoPago,
              items: getMetodoPagos(),
              onChanged: (opt) {
                setState(() {
                  opcionMetodoPago = opt.toString();
                });
              },
              decoration: ThemeHelper().textInputDecoration(
                  'Método de pago', 'Ingrese metodo de pago'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(height: 20.0),
          Container(
            child: TextField(
              controller: _inputFieldObservacionController,
              keyboardType: TextInputType.multiline,
              decoration: ThemeHelper()
                  .textInputDecoration('Observacion', 'Ingrese observacion'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                         SECCION SELECCIONAR CLIENTE                        */
  /* -------------------------------------------------------------------------- */
  Widget seccionCliente() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: ListView(
        children: [
          const SizedBox(height: 30.0),
          Text('Datos del cliente',
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: color,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold))),
          const SizedBox(height: 10.0),
          CircleAvatar(
            backgroundColor: color,
            child: const Text('2', style: TextStyle(color: Colors.white)),
          ),
          Image.asset(
            'assets/img/cliente.png',
            height: 175.0,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _navigateAndDisplaySelection();
              });
            },
            child: Text(
              'PRESIONE AQUÍ PARA BUSCAR UN CLIENTE PREVIAMENTE REGISTRADO'
                  .toUpperCase(),
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: color),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Checkbox(
                  value: nuevocliente,
                  activeColor: color,
                  onChanged: (newValue) {
                    setState(() {
                      nuevocliente = newValue;
                      if (newValue!) {
                        _navigateCrearClienteVenta();
                      } else {
                        _obtenerItemCliente("NOM_CLI", "CONSUMIDOR FINAL");
                      }
                    });
                  }),
              Text('Nuevo cliente (Marque la casilla)',
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: color,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            width: 40.0,
            child: TextField(
              enabled: false,
              keyboardType: TextInputType.number,
              controller: _inputFieldIdentificacionController,
              decoration: ThemeHelper().textInputDecoration(
                  'Identificación', 'Ingrese identificación'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(height: 20.0),
          _isLoading ? load.loading() : Container(),
          Container(
            child: TextField(
              enabled: false,
              controller: _inputFieldNombreController,
              decoration:
                  ThemeHelper().textInputDecoration('Nombre', 'Ingrese nombre'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(height: 20.0),
          Container(
            child: TextField(
              enabled: false,
              keyboardType: TextInputType.number,
              controller: _inputFieldTelefonoController,
              decoration: ThemeHelper()
                  .textInputDecoration('Teléfono', 'Ingrese telefono'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(height: 20.0),
          Container(
            child: TextField(
              keyboardType: TextInputType.text,
              enabled: false,
              controller: _inputFieldDireccionController,
              decoration: ThemeHelper()
                  .textInputDecoration('Dirección', 'Ingrese dirección'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(height: 20.0),
          Container(
            child: TextField(
              enabled: false,
              keyboardType: TextInputType.emailAddress,
              controller: _inputFieldEmailController,
              decoration:
                  ThemeHelper().textInputDecoration('Email', 'Ingrese email'),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                           SECCION DETALLE PEDIDO                           */
  /* -------------------------------------------------------------------------- */
  Widget seccionDetallePedido() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: ListView(
        children: [
          const SizedBox(height: 30.0),
          Row(
            children: [
              Text(
                'Detalle de la factura',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: color,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                width: 10.0,
              ),
              CircleAvatar(
                backgroundColor: color,
                child: const Text('3', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          
          Row(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 75) / 2,
                height: 90.0,
                child: Text("\$ $totalPagar",
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold))),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 75) / 2,
                height: 150.0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Subtotal Iva dif 0%:   $totalFinal12',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold))),
                      Text('Subtotal 0%:   $totalFinal0',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold))),
                      Text('Exento:   $totalFinalExento',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold))),
                      Text('No Objeto:   $totalFinalNObjeto',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold))),
                      if (double.parse(descuento) > 0)
                        Text('Descuento: $descuento',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),                  
                      Text('Iva:   $ivaFinal',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold))),
                      Text('Ice:   $iceFinal',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold))),
                      Text('Subtotal:   $subtotalFinal',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold))),
                    ]),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.indigo.shade800),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(color: Colors.indigo.shade800),
              )),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: Text(
                'AÑADIR PRODUCTOS / SERVICIOS'.toUpperCase(),
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            onPressed: () {
              _inputFieldBuscarController.clear();
              newDataList.clear();
              getDataProducto();

              //After successful login we will redirect to profile page. Let's create profile page now
            },
          ),
          const SizedBox(height: 10.0),
          _isLoading ? load.loading() : Container(),
          const Divider(),
          Text('Productos seleccionados',
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: color,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold))),
          const SizedBox(
            height: 20.0,
          ),
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: detalle.length,
              itemBuilder: (context, i) => _bandDetalle(detalle[i], i))
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                              SELECCIONAR FECHA                             */
  /* -------------------------------------------------------------------------- */
  _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2050),
        locale: const Locale('es', 'ES'));

    if (picked != null) {
      setState(() {
        var arr = picked.toString().split(" ");
        _inputFieldDateController.text = arr[0];
      });
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                               GET TIPO VENTA                               */
  /* -------------------------------------------------------------------------- */
  List<DropdownMenuItem<String>> getTipoVenta() {
    List<DropdownMenuItem<String>> lista = [];

    lista.add(const DropdownMenuItem(
      child: Text('Factura Electrónica'),
      value: 'Electronica',
    ));
    lista.add(const DropdownMenuItem(
      child: Text('Recibo sin validez tributaria'),
      value: 'Fisica',
    ));

    return lista;
  }

  /* -------------------------------------------------------------------------- */
  /*                       OPCIONES SELECT METODOS DE PAGO                      */
  /* -------------------------------------------------------------------------- */
  List<DropdownMenuItem<String>> getMetodoPagos() {
    List<DropdownMenuItem<String>> lista = [];

    lista.add(const DropdownMenuItem(
      child: Text('Seleccione...'),
      value: '',
    ));

    lista.add(const DropdownMenuItem(
      child: Text('EFECTIVO'),
      value: 'EFECTIVO',
    ));
    lista.add(const DropdownMenuItem(
      child: Text('CHEQUE'),
      value: 'CHEQUE',
    ));
    lista.add(const DropdownMenuItem(
      child: Text('DEPÓSITO / TRANSFERENCIA'),
      value: 'DEPOSITO / TRANSFERENCIA',
    ));

    lista.add(const DropdownMenuItem(
      child: Text('TARJETA DE DÉBITO'),
      value: 'TARJETA DEBITO',
    ));
    lista.add(const DropdownMenuItem(
      child: Text('TARJETA DE CRÉDITO'),
      value: 'TARJETA CREDITO',
    ));
    lista.add(const DropdownMenuItem(
      child: Text('CRÉDITO'),
      value: 'CREDITO',
    ));
    return lista;
  }

  /* -------------------------------------------------------------------------- */
  /*                               SEARCH CLIENTE                               */
  /* -------------------------------------------------------------------------- */
  getSearchCliente(value) async {
    clienteItem.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final holydays = await _clientes.getClienteSearch(
        prefs.getString('token')!, prefs.getString('token')!, value);
    clienteItem.addAll(holydays);
    newListaCliente.clear();
    for (var element in clienteItem) {
      newListaCliente
          .add("${element.idCliente.toString()}, ${element.nombre.toString()}");
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                            GET CONSUMIDOR FINAL                            */
  /* -------------------------------------------------------------------------- */
  void _obtenerItemCliente(item, valor) async {
    setState(() {});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final holidays = await _clientes.getItemCliente(
        prefs.getString("token")!, prefs.getString("idEmpresa")!, item, valor);

    clienteItem = holidays;
    for (var element in clienteItem) {
      _inputFieldNombreController.text = element.nombre!;
      _inputFieldIdentificacionController.text = element.cedula!;
      _inputFieldTelefonoController.text = element.telefono!;
      _inputFieldDireccionController.text = element.direccion!;
      _inputFieldEmailController.text = element.email!;
      idCliente = element.idCliente!;
      setState(() {});
      nuevocliente = false;
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              GET DATA PRODUCTO                             */
  /* -------------------------------------------------------------------------- */
  void getDataProducto() async {
    setState(() {
      _isLoading = true;
      productoItem.clear();
      _controllerSD.clear();
      listaColor.clear();
      titulo.clear();
      contador.clear();
      bloqueo.clear();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final holidays = await _producto.getProductos(
        prefs.getString('token')!, prefs.getString('idEmpresa'));
    setState(() {
      productoItem.addAll(holidays);
      _isLoading = false;
      for (int i = 0; i < holidays.length; i++) {
        _controllerSD.add(TextEditingController());
        listaColor.add(Colors.white);
        titulo.add('Seleccionar');
        contador.add(0);
        bloqueo.add(false);
        //precios.add(holidays[i].precioPublico!);
      }

      _mostrarModalProducto();
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                           MODAL AGREGAR PRODUCTO                           */
  /* -------------------------------------------------------------------------- */
  void _mostrarModalProducto() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: SizedBox(
              child: Column(
                children: [
                  Text('GESTIÓN PRODUCTO',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: 350.0,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Container(
                      child: TextField(
                        controller: _inputFieldBuscarController,
                        onChanged: (value) {
                          onSearchTextChanged(value, setState);
                        },
                        decoration: ThemeHelper()
                            .textInputDecoration('Buscar', 'Buscar producto'),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(child: setupAlertProducto(setState)),
                  ],
                ),
              );
            }),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      setServicios();
                    });
                  },
                  child: const Text('ACEPTAR')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text('SALIR')),
            ],
          );
        });
  }

  /* -------------------------------------------------------------------------- */
  /*                               MODAL PRODUCTOS                              */
  /* -------------------------------------------------------------------------- */
  Widget setupAlertProducto(StateSetter setState) {
    return SizedBox(
        height: 300.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: newDataList.isNotEmpty ||
                _inputFieldBuscarController.text.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: newDataList.length,
                itemBuilder: (context, i) =>
                    _bandListProductos(newDataList[i], i, setState),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: productoItem.length,
                itemBuilder: (context, i) =>
                    _bandListProductos(productoItem[i], i, setState),
              ));
  }

  /* -------------------------------------------------------------------------- */
  /*                             LISTA DE PRODUCTOS                             */
  /* -------------------------------------------------------------------------- */
  Widget _bandListProductos(Producto band, int index, StateSetter setState) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/img/load1.gif',
                      image: band.imagen!,
                      width: 50.0,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/img/logoAmarillo.png',
                          width: 50.0,
                        );
                      },
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                band.nombre!.toString().length > 12
                                    ? band.nombre!
                                        .toString()
                                        .substring(0, 12)
                                        .toUpperCase()
                                    : band.nombre.toString().toUpperCase(),
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold))),
                            Text(
                                "\$ ${double.parse(band.precio!).toStringAsPrecision(3)}"),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 35,
                                width: 170,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            contador[index]++;

                                            if (contador[index] == 1) {
                                              titulo[index] = "Remover";
                                              bloqueo[index] = true;
                                              _controllerSD[index].text = '1';
                                              listaColor[index] =
                                                  Colors.grey.shade300;

                                              array.add({
                                                "bodega": "CENTRAL",
                                                "cantidad": _controllerSD[index].text,
                                                "codigo": band.codigo,
                                                "codigoimpuesto":band.codigoimpuesto,
                                                "ice":band.codigoIce,
                                                "id":band.idProducto.toString(),
                                                "impuesto":band.impuesto,
                                                "nombre":band.nombre,
                                                "observacion": "",
                                                "porcentajeDescuento": "0.00",
                                                "precio": band.precio,
                                                "preciomanual": band.pvpManual,
                                                "precioProducto": band.precio,
                                                "precioSinIva": band.precio,
                                                "tarifaice":band.tarifaIce,  
                                                "tipoice":band.tipoice,//NUEVO DESARROLLO ICE
                                                "tota": band.precio,
                                                "valorDescuento": "0.00",
                                                "valores":[{"nombre": "Público","valor": band.precio},
                                                           {"nombre": "Distribuidor","valor": band.precioDistribuidor},
                                                           {"nombre": "Mayorista","valor": band.precioMayorista},
                                                           {"nombre": "Liquidación","valor": band.precioLiquidacion}],
                                                "valorice": band.valorIce,                                                  
                                              });

                                              arrayPosicion.add(band.id);
                                            }

                                            if (contador[index] == 2) {
                                              titulo[index] = "Seleccionar";
                                              contador[index] = 0;
                                              bloqueo[index] = false;
                                              _controllerSD[index].text = '';
                                              listaColor[index] = Colors.white;

                                              array.removeAt(index);
                                              arrayPosicion.remove(band.id);
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    listaColor[index]),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)))),

                                        // foreground

                                        child: Text(
                                          titulo[index],
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    SizedBox(
                                        width: 50.0,
                                        child: Visibility(
                                          visible: false,
                                          child: TextField(
                                            controller: _controllerSD[index],
                                            decoration: InputDecoration(
                                              hintText: 'cant.',
                                              enabled: bloqueo[index],
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _controllerSD[index].text =
                                                    value;

                                                if (value != "") {
                                                  if (contador[index] == 1) {
                                                    titulo[index] = "Remover";
                                                    bloqueo[index] = true;

                                                    listaColor[index] =
                                                        Colors.grey.shade300;

                                                    array.removeAt(arrayPosicion
                                                        .indexOf(band.id));

                                                    // ignore: unused_local_variable
                                                    double res = double.parse(
                                                            band.precio!) *
                                                        double.parse(
                                                            _controllerSD[index]
                                                                .text);
                                                    array.add({
                                                      "bodega": "CENTRAL",
                                                      "cantidad": _controllerSD[index].text,
                                                      "codigo": band.codigo,
                                                      "codigoimpuesto":band.codigoimpuesto,
                                                      "ice":band.codigoIce,
                                                      "id":band.idProducto.toString(),
                                                      "impuesto":band.impuesto,
                                                      "nombre":band.nombre,
                                                      "observacion": "",
                                                      "porcentajeDescuento": "0.00",
                                                      "precio": band.precio,
                                                      "preciomanual": band.pvpManual,
                                                      "precioProducto": band.precio,
                                                      "precioSinIva": band.precio,
                                                      "tarifaice":band.tarifaIce,  
                                                      "tipoice":band.tipoice,//NUEVO DESARROLLO ICE
                                                      "tota": band.precio,
                                                      "valorDescuento": "0.00",
                                                      "valores":[{"nombre": "Público","valor": band.precio},
                                                                {"nombre": "Distribuidor","valor": band.precioDistribuidor},
                                                                {"nombre": "Mayorista","valor": band.precioMayorista},
                                                                {"nombre": "Liquidación","valor": band.precioLiquidacion}],
                                                      "valorice": band.valorIce,
                                                    });

                                                    arrayPosicion.add(band.id);
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {});

        /*updateRequerimiento(idRequerimiento, fechaRequerimiento, codigoDoctor,
            band.codCri, index1);*/
      },
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                           LISTAR SERVICIOS PEDIDO                          */
  /* -------------------------------------------------------------------------- */
  setServicios() async {
    detalle.clear();
    _controllerDT.clear();
    final holidays = await _detalleOrden.addDetalle(jsonEncode(array));
    //print(jsonEncode(array));
    detalle = holidays;

    for (int i = 0; i < holidays.length; i++) {
      _controllerDT.add(TextEditingController());
      try{
        double p = double.parse(holidays[i].precio);
        _controllerDT[i].text = p.toStringAsFixed(2);
      }catch (e) {
        _controllerDT[i].text = "0";
      }
      
      
    }
    calcularTotales();
  }

  /* -------------------------------------------------------------------------- */
  /*                              CALCULAR TOTALES                              */
  /* -------------------------------------------------------------------------- */
  calcularTotales() {    
    // ignore: unused_local_variable
    double total = 0;
    double totalIva = 0;
    double total0 = 0;
    double totalExento = 0;
    double totalNObjeto = 0;
    double iva = 0;
    double ice = 0;
    double subtotal = 0;
    double totalFi = 0;
    double descuentoproducto = 0;
    double totalDescuento = 0;
    double valorSubtotal = 0;
    
    double impuestoBaseIva  = 0;
    for (var element in detalle) {
      valorSubtotal=double.parse(element.cantidad.toString()) * double.parse(element.precio.toString());
      descuentoproducto = valorSubtotal * (double.parse(element.porcentajeDescuento.toString())/100);
      total = valorSubtotal-descuentoproducto;
      totalDescuento += descuentoproducto;      

      double valorIce = 0;
      //DESARROLLO ICE
      if(element.tipoice!="No aplica"){
          if(element.tipoice=="Por porcentaje"){
              valorSubtotal=double.parse(element.cantidad.toString()) * double.parse(element.precio.toString());
              valorIce= (valorSubtotal-descuentoproducto) * (double.parse(element.valorIce.toString())/100);
              element.tarifaIce=valorIce.toString();              
          }else if(element.tipoice=="Valor fijo"){
              valorIce= (double.parse(element.cantidad.toString()) * double.parse(element.valorIce.toString()));
              element.tarifaIce=valorIce.toString();              
          }
      }
      ice += valorIce;
      
      //VALOR TOTAL POR TIPO DE IMPUESTO
      if (int.tryParse(element.codigoimpuesto!.split(".")[0]) == 0) { //IVA CERO            
        total0 += double.parse(element.total!);
      
      } else if (int.tryParse(element.impuesto!.split(".")[0]) != 0) { //IVA VARIABLE            
        totalIva += double.parse(element.total!);
        impuestoBaseIva += (double.parse(element.total!)+ valorIce) * ((double.parse(element.impuesto!))/100);  
      } else if (int.tryParse(element.codigoimpuesto!.split(".")[0]) == 6) { //NO OBJETO            
        totalNObjeto += double.parse(element.total!);  
      } else if (int.tryParse(element.codigoimpuesto.toString()) == 7) { //EXCENTO            
        totalExento += double.parse(element.total!);
      }

      
    }    

    iva = impuestoBaseIva; //* ((double.parse(tarifaIva))/100);
    subtotal = totalIva + total0 + totalExento + totalNObjeto;
    totalFi = subtotal + iva + ice;
    totalFinal12 = totalIva.toStringAsFixed(2);
    totalFinal0 = total0.toStringAsFixed(2);
    totalFinalExento = totalExento.toStringAsFixed(2);
    totalFinalNObjeto = totalNObjeto.toStringAsFixed(2);
    totalPagar = totalFi.toStringAsFixed(2);
    subtotalFinal = subtotal.toStringAsFixed(2);
    ivaFinal = iva.toStringAsFixed(2);
    iceFinal = ice.toStringAsFixed(2);
    descuento = totalDescuento.toStringAsFixed(2);
  }

  /* -------------------------------------------------------------------------- */
  /*                                DETALLE ORDEN                               */
  /* -------------------------------------------------------------------------- */
  Widget _bandDetalle(Detalle detalles, int i) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Wrap(
              spacing: 5.0,
              runSpacing: 5.0,
              direction: Axis.horizontal,
              children: [
                FaIcon(
                  FontAwesomeIcons.bookmark,
                  color: color,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  detalles.nombre!,
                  style: GoogleFonts.lato(
                    textStyle:
                        const TextStyle(color: Colors.blue, fontSize: 12.0),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
              ]),
          const SizedBox(
            height: 10.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: Visibility(
              visible: true,
              child: TextFormField(
                controller: null,
                initialValue: detalles.observacion,
                onChanged: (value) {
                  setState(() {
                    array[i]["observacion"] = value;
                  });

                  //print(array[i]);
                },
                decoration: ThemeHelper().textInputDecoration(
                    'Observación (opcional)', 'Ingrese una observación'),
                maxLength: 280,    
              ),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(
            height: 10.0,
          ),
          
          Container(
            child: Visibility(
              visible: true,
              child: TextFormField(
                controller: null,
                initialValue: detalles.cantidad,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {                    
                    array[i]["cantidad"] = value == ""? "0": value;
                    double resp = double.parse(array[i]["cantidad"]) * double.parse(array[i]["precio"]);

                    detalles.total = resp.toStringAsFixed(2);
                    detalle[i].total = resp.toStringAsFixed(2);
                    detalle[i].cantidad = array[i]["cantidad"] == "" ? "0" : array[i]["cantidad"].toString();
                    
                    array[i]["tota"] = resp.toStringAsFixed(2);


                    //CAlCULAR TARIFA ICE
                    double totalvalorIce=0;
                    if(array[i]["tipoice"]=="Por porcentaje"){                        
                        totalvalorIce= resp * (double.parse(array[i]["valorice"])/100);
                    }else if(array[i]["tipoice"]=="Valor fijo"){
                        totalvalorIce= double.parse(array[i]["cantidad"] == "" ? "0" : array[i]["cantidad"].toString()) * double.parse(array[i]["valorice"]);
                    } 
                    array[i]["tarifaice"]=totalvalorIce.toString();

                    calcularTotales();
                  });

                  //print(array[i]);
                },
                decoration: ThemeHelper()
                    .textInputDecoration('Cantidad', 'Ingrese una cantidad'),
              ),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus == false) {
                  setState(() {
                    String cajaTexto = _controllerDT[i].text;
                    if (cajaTexto.contains("/") && cajaTexto.split("/")[0] != "") {
                      double p = double.parse(cajaTexto.split("/")[0]);
                      p = p / (1 + (double.parse(tarifaIva))/100);
                     
                      detalle[i].precio = p.toStringAsFixed(2);
                      array[i]["precio"] = p.toStringAsFixed(2);
                      double resp = double.parse(array[i]["precio"] == ""
                              ? "0"
                              : array[i]["precio"]) *
                          double.parse(array[i]["cantidad"].toString());

                      array[i]["precioSinIva"] = p.toStringAsFixed(2);
                      array[i]["precioProducto"] = p.toStringAsFixed(2);
                      detalles.total = resp.toStringAsFixed(2);
                      detalle[i].total = resp.toStringAsFixed(2);
                      array[i]["tota"] = resp.toStringAsFixed(2);
                      array[i]["TOT_PRO"] = resp.toStringAsFixed(2);
                      double s = double.parse(detalle[i].precio.toString());
                      _controllerDT[i].text = s.toStringAsFixed(2);

                        //CAlCULAR TARIFA ICE
                      double totalvalorIce=0;
                      if(array[i]["tipoice"]=="Por porcentaje"){                        
                          totalvalorIce= resp * (double.parse(array[i]["valorice"])/100);
                      }else if(array[i]["tipoice"]=="Valor fijo"){
                          totalvalorIce= double.parse(array[i]["cantidad"]) * double.parse(array[i]["valorice"]);
                      } 
                      detalle[i].valorIce=array[i]["valorice"].toString();
                      array[i]["tarifaice"]=totalvalorIce.toString();

                      calcularTotales();
                    } else {
                      detalle[i].precio = _controllerDT[i].text == "" ? "0":_controllerDT[i].text;
                      array[i]["precio"] = _controllerDT[i].text;
                      array[i]["precioSinIva"] = _controllerDT[i].text;
                      array[i]["precioProducto"] = _controllerDT[i].text;
                      double resp = double.parse(array[i]["precio"] == ""? "0": array[i]["precio"]) *double.parse(array[i]["cantidad"].toString());
                      detalles.total = resp.toStringAsFixed(2);
                      detalle[i].total = resp.toStringAsFixed(2);
                      array[i]["tota"] = resp.toStringAsFixed(2);
                      array[i]["TOT_PRO"] = resp.toStringAsFixed(2);
                      double s = double.parse(detalle[i].precio.toString());
                      _controllerDT[i].text = s.toStringAsFixed(2);

                      //CAlCULAR TARIFA ICE
                      double totalvalorIce=0;
                      if(array[i]["tipoice"]=="Por porcentaje"){                        
                          totalvalorIce= resp * (double.parse(array[i]["valorice"])/100);
                      }else if(array[i]["tipoice"]=="Valor fijo"){
                          totalvalorIce= double.parse(array[i]["cantidad"]) * double.parse(array[i]["valorice"]);
                      } 
                      detalle[i].valorIce=array[i]["valorice"].toString();
                      array[i]["tarifaice"]=totalvalorIce.toString();
                      calcularTotales();
                      
                    }
                  });
                }
              },
              child: Visibility(
                visible: true,
                child: TextFormField(
                  controller: _controllerDT[i],
                  enabled: detalles.preciomanual == "0" ? false : true,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  // initialValue: double.parse(detalles.precio!).toStringAsFixed(2),
                  onChanged: (value) {
                    setState(() {
                      //_controllerDT[i].text = value;
                    });
                  },
                  decoration: ThemeHelper()
                      .textInputDecoration('Precio', 'Ingrese valor'),
                ),
              ),
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          const SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            child: const Align(
              alignment: Alignment.center,
              child: FaIcon(
                // ignore: deprecated_member_use
                FontAwesomeIcons.trashAlt,
                color: Colors.red,
              ),
            ),
            onTap: () {
              removeItem(i, detalles);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                REMOVER ITEM                                */
  /* -------------------------------------------------------------------------- */
  void removeItem(int index, Detalle detalle) {
    setState(() {
      //detalle = List.from(detalle)..removeAt(index);
      array.removeAt(index);

      setServicios();
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                               GUARDAR CLIENTE                              */
  /* -------------------------------------------------------------------------- */
  void guardarCliente(TabController _controller) async {
    // ignore: unused_local_variable
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    String tipoIdentificacion = "";
    if (_inputFieldIdentificacionController.text.length == 13) {
      tipoIdentificacion = "RUC";
    }

    if (_inputFieldIdentificacionController.text.length == 10) {
      tipoIdentificacion = "CEDULA";
    }

    if (_inputFieldIdentificacionController.text.length != 10 &&
        _inputFieldIdentificacionController.text.length != 13) {
      message.showToast('La identificacion no tiene ni 10 ni 13 digitos');
    }

    /* Future<dynamic> resp = _clientes.guardarCliente(
        _inputFieldIdentificacionController.text,
        tipoIdentificacion,
        _inputFieldNombreController.text,
        _inputFieldDireccionController.text,
        _inputFieldTelefonoController.text,
        _inputFieldEmailController.text,
        prefs.getString("establecimiento"),
        prefs.getString("tocken"));

    resp.then((value) {
      if (value == "ok") {
        _obtenerItemCliente(
            "CED_CLI", _inputFieldIdentificacionController.text);
        message.showToast('Cliente registrado correctamente');
        Timer(const Duration(seconds: 2), () => guardarOrden());
        message.showToast('Cliente registrado correctamente');
        guardarOrden();
        setState(() {
          _isLoading = false;
        });
      } else {
        message.showToast(
            'Cliente repetido, trato de registrar un cliente que ya esta registrado busquelo o desmarque la casilla "Nuevo cliente"');
        message.showToast(
            'Cliente repetido, trato de registrar un cliente que ya esta registrado busquelo o desmarque la casilla "Nuevo cliente"');

        _controller.animateTo(1);
        idCliente = "";
        setState(() {
          _isLoading = false;
        });
      }
    });*/
  }

  /* -------------------------------------------------------------------------- */
  /*                                GUARDAR ORDEN                               */
  /* -------------------------------------------------------------------------- */
  void guardarOrden() async {

    setState(() {
      colorBtnGuardar = Colors.grey.shade600;
    });

    puedePresionarBoton = false;
    _inputFieldValorRecargoController.text = "0";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    String detalleP = "";

    if (idCliente == "") {
      message.showToast('Seleccione un cliente');
      setState(() {
        puedePresionarBoton = true;
        _isLoading = false;
        colorBtnGuardar = Colors.white;
      });
      return;
    }

    if (opcionTipoVenta == "") {
      message.showToast('Seleccione el tipo de venta');
      setState(() {
        puedePresionarBoton = true;
        _isLoading = false;
        colorBtnGuardar = Colors.white;
      });
      return;
    }

    if (opcionMetodoPago == "") {
      message.showToast('Seleccione el metodo de pago');
      setState(() {
        puedePresionarBoton = true;
        _isLoading = false;
        colorBtnGuardar = Colors.white;
      });
      return;
    }

    if (array.isEmpty) {
      message.showToast('Seleccione al menos un producto');
      setState(() {
        puedePresionarBoton = true;
        _isLoading = false;
        colorBtnGuardar = Colors.white;
      });
      return;
    }
    
    for (int i = 0; i < array.length; i++) {
      
      array[i]["precio"]=array[i]["precio"]==""?0:array[i]["precio"];
      if(double.parse(array[i]["cantidad"]) <= 0) {
        message.showToast('Debe ingresar una cantidad válida al producto ${array[i]["nombre"].toString()}');
         puedePresionarBoton = true;
        _isLoading = false;
        setState(() {
          colorBtnGuardar = Colors.white;
        });
        return; 
      }      
    }
    

    setState(() {
      _isLoading = true;
    });
    Future<dynamic> resp = _documentos.editarFactura(
        prefs.getString("token")!,
        prefs.getString("idUsuario")!,
        prefs.getString("idEmpresa")!,
        idCliente,
        opcionTipoVenta,
        _inputFieldDateController.text,
        totalFinal12,
        totalFinal0,
        totalFinalExento,
        totalFinalNObjeto,
        jsonEncode(array),
        subtotalFinal,
        ivaFinal,
        iceFinal,
        totalPagar,
        _inputFieldObservacionController.text,
        opcionMetodoPago,
        tarifaIva,
        idDocumento,
        descuento);

    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);

      for (var child in json2) {
        if (child["status"]) {
          puedePresionarBoton = true;
          if (opcionTipoVenta == 'Electronica') {
            _mostrarModalCorrecto('Factura actualizada correctamente');
          } else {
            //Su recibo sin validez tributaria realizado correctamente
            _mostrarModalCorrecto(
                'Su recibo sin validez tributaria realizado correctamente');
          }

          setState(() {
            _isLoading = false;
            idFactura = child["codigo"];
          });

          const alarmAudioPath = "sonido/correcto.mp3";
          player.load(alarmAudioPath);
          /* Timer(const Duration(seconds: 3),
              () => Navigator.pushNamed(context, "ordenes"))*/

        } else {
          message.showToast(id);
          setState(() {
            _isLoading = false;
            colorBtnGuardar = Colors.white;
          });
        }
      }
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                ENVIAR AL SRI                               */
  /* -------------------------------------------------------------------------- */
  void enviarSRI() async {
    _inputFieldValorRecargoController.text = "0";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });
    Future<dynamic> resp = _documentos.enviarSRI(
        prefs.getString("token")!, prefs.getString("idEmpresa")!, idFactura);

    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);

      for (var child in json2) {
        if (child["status"]) {
          _mostrarModalCorrecto('Enviar al SRI correctamente');
          setState(() {
            _isLoading = false;
          });

          const alarmAudioPath = "sonido/correcto.mp3";
          player.load(alarmAudioPath);
          Timer(const Duration(seconds: 1), () => generateFactura());
        } else {
          puedePresionarBoton = true;
          message.showToast(id);
          setState(() {
            _isLoading = false;
            colorBtnGuardar = Colors.white;
          });
        }
      }
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                               MODAL CORRECTO                               */
  /* -------------------------------------------------------------------------- */
  void _mostrarModalCorrecto(texto) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Column(
                children: [
                  SizedBox(
                      child: Image.asset('assets/img/checkoff.jpeg'),
                      height: 120.0),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          texto,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.green, fontSize: 15.0),
                          ),
                        ),
                        const Divider(),
                        texto == 'Factura realizada correctamente'
                            ? Text(
                                'Acciones disponibles.',
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold)),
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
              actions: [
                texto == 'Factura realizada correctamente' ||
                        texto == 'Factura actualizada correctamente' ||
                        texto == 'Nota de venta realizada correctamente' ||
                        texto ==
                            'Su recibo sin validez tributaria realizado correctamente'
                    ? TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'listar-documentos');
                        },
                        child: const Text('Salir'))
                    : Container(),
                texto == 'Factura realizada correctamente' &&
                            opcionTipoVenta == 'Electronica' ||
                        texto == 'Factura actualizada correctamente' &&
                            opcionTipoVenta == 'Electronica'
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          //generateFactura();
                          puedePresionarBoton = false;
                          enviarSRI();
                        },
                        child: const Text('Enviar al SRI'))
                    : Container(),
              ],
            ),
          );
        });
  }

  /* -------------------------------------------------------------------------- */
  /*                              BUSCAR PRODUCTOS                              */
  /* -------------------------------------------------------------------------- */
  onSearchTextChanged(String text, StateSetter setState) async {
    newDataList.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    //print(text);

    setState(() {
      productoItem.asMap().forEach((index, userDetail) {
        String nombreVendedor = "";
        String codigoVendedor = "";

        if (userDetail.nombre?.isEmpty ?? true) {
        } else {
          nombreVendedor = userDetail.nombre!;
        }

        if (userDetail.precio?.isEmpty ?? true) {
        } else {
          codigoVendedor = userDetail.precio!;
        }

        if (nombreVendedor.toUpperCase().contains(text.toUpperCase()) ||
            codigoVendedor.toUpperCase().contains(text.toUpperCase())) {
          newDataList.add(userDetail);
        }
      });
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                               GENERAR FACTURA                              */
  /* -------------------------------------------------------------------------- */
  void generateFactura() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<dynamic> resp = _documentos.generarRIDE(
        prefs.getString("token")!, prefs.getString("idEmpresa")!, idFactura);
    resp.then((value) {
      final List<dynamic> json = jsonDecode("[$value]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);

      for (var child in json2) {
        if (child["status"]) {
          String documento = child["rutaDocumento"];
          Navigator.pop(context);
          _isLoading = false;
          createFileOfPdfUrl(documento).then((f) {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFScreen(path: f.path),
                ),
              );
            });
          });
        }
      }
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                 GENERAR PDF                                */
  /* -------------------------------------------------------------------------- */
  Future<File> createFileOfPdfUrl(orden) async {
    Completer<File> completer = Completer();
    if (kDebugMode) {
      print("Start download file from internet!");
    }
    setState(() {
      _isLoading = true;
    });
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = orden;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      if (kDebugMode) {
        print("Download files");
      }
      if (kDebugMode) {
        print("${dir.path}/$filename");
      }
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}