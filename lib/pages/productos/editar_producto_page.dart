// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';

import 'package:facturaloapp2025/common/colorExadecimal.dart';
import 'package:facturaloapp2025/common/custom_input.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/models/inventario/productos_model.dart';
import 'package:facturaloapp2025/providers/inventario/productos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
import 'package:facturaloapp2025/providers/personas/empresa_provider.dart';
class EditarProductoPage extends StatefulWidget {
  const EditarProductoPage({Key? key}) : super(key: key);

  @override
  State<EditarProductoPage> createState() => _EditarProductoPageState();
}

class _EditarProductoPageState extends State<EditarProductoPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  final productos = ProductoProvider();
  final codigoController = TextEditingController();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  bool preciomanual = false;
  final precioCostoController = TextEditingController();
  final precioPublicoController = TextEditingController();
  final precioDistribuidorController = TextEditingController();
  final precioMayoristaController = TextEditingController();
  final precioLiquidacionController = TextEditingController();
  final empresa =  EmpresaProvider();
  int totalPaginas = 3;
  String opcionImpuesto = '0';
  String tarifaImpuesto = '12';

  bool mostrarSegundoListado = false;
  String cadenaTipoICE = '';
  String opcionAplicaImpuestoICE = 'No aplica';
  String opcionCodigoImpuestoICE= 'Ninguno';  
  final valorTarifaImpuestoICE= TextEditingController();
  String selectedValue = '';

  String opcionImagen = 'Presione aquí para subir imagen';
  final message = ToastMessage();
  File? imagen;
  final producto = ProductoProvider();
  Producto? productoConsulta;
  String idProducto = "";
  int conP = 0;
  final Color color = HexColor.fromHex('#262f69');
  final load = Load();
  bool _isLoading = false;

  List<dynamic> listadoCodigosICE = [];
  List<DropdownMenuItem<String>>? dropdownItems;
  List<DropdownMenuItem<String>> listadoCodigosTiposICE = [];
 // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();

  bool _isLoadingIce = false;
  @override
  void initState() {    
    super.initState(); 
    getCodigosIce();  
    obtenerYMostrarImpuestos();
    _controller = TabController(
      vsync: this,
      length: totalPaginas,
      initialIndex: 0,
    );
 //   _internetDialog = InternetDialog(context);
  //  _connectivitySubscription =
  //  _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    conP++;
    if (conP == 1) {
      setState(() {
        productoConsulta =
            ModalRoute.of(context)!.settings.arguments as Producto?;
        codigoController.text = productoConsulta!.codigo.toString();
        nombreController.text = productoConsulta!.nombre.toString();
        descripcionController.text = productoConsulta!.descripcion.toString();

        opcionImpuesto = productoConsulta!.codigoimpuesto?.isEmpty ?? true
            ? ""
            : productoConsulta!.codigoimpuesto!;
        preciomanual =
            productoConsulta!.pvpManual.toString() == "1" ? true : false;
        precioCostoController.text = productoConsulta!.costo.toString();

        precioPublicoController.text = productoConsulta!.precio.toString();
        precioDistribuidorController.text =
            productoConsulta!.precioDistribuidor.toString() != "null"
                ? productoConsulta!.precioDistribuidor.toString()
                : "";
        precioMayoristaController.text =
            productoConsulta!.precioMayorista.toString() != "null"
                ? productoConsulta!.precioMayorista.toString()
                : "";
        precioLiquidacionController.text =
            productoConsulta!.precioLiquidacion.toString() != "null"
                ? productoConsulta!.precioLiquidacion.toString()
                : "";

        idProducto = productoConsulta!.idProducto.toString();
        
        //APLICA EL ICE
        
        opcionAplicaImpuestoICE = productoConsulta!.tipoice ?? 'No aplica';
        mostrarSegundoListado = opcionAplicaImpuestoICE == 'Por porcentaje' || opcionAplicaImpuestoICE == 'Valor fijo';
        if (opcionAplicaImpuestoICE == 'Por porcentaje') {
            cadenaTipoICE = "Tarifa ICE por porcentaje %";   
            opcionCodigoImpuestoICE  =productoConsulta!.codigoIce.toString(); 
            valorTarifaImpuestoICE.text =productoConsulta!.valorIce.toString();               
        } else if (opcionAplicaImpuestoICE == 'Valor fijo') {
            cadenaTipoICE = "Tarifa ICE por valor fijo";
            opcionCodigoImpuestoICE  =productoConsulta!.codigoIce.toString(); 
            valorTarifaImpuestoICE.text =productoConsulta!.valorIce.toString(); 
        }
        getCodigosIce();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Editar producto / servicio',
              style: TextStyle(fontSize: 15.0),
            ),
            actions: [
              const SizedBox(
                width: 5.0,
              ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  guardarProducto();
                },
                child: Row(
                  children: const [
                    Icon(Icons.save, color: Colors.white, size: 20.0),
                    Text(
                      ' GUARDAR',
                      style: TextStyle(color: Colors.white, fontSize: 11.0),
                    ),
                  ],
                ),
              ),
            ],
            bottom: TabBar(
                controller: _controller,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child:Text('DATOS GENERALES',
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Icon(Icons.list),
                      ],
                    ),
                  ),  
                  Tab(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(                        
                          child:Text('PRECIOS',
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Icon(Icons.price_change),
                      ],
                    ),
                  ),
                  Tab(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(                        
                          child:Text('ICE',
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Icon(Icons.addchart),
                      ],
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
              controller: _controller,
              children: [seccionDatosGenerales(), seccionPrecios(), seccionICE()]),
        ),
      ),
    );
  }

  Widget seccionDatosGenerales() {
    return ListView(
      children: [
        const SizedBox(height: 50.0),
        _isLoading ? load.loading() : Container(),
        MyCustomInputBox(
          label: 'Código (Obligatorio)',
          inputHint: 'Ingrese un código...',
          inputController: codigoController,
          textInputType: TextInputType.text,
          formatter: true,
          maxLength: 24,
          allowSpaces:false
        ),
        MyCustomInputBox(
          label: 'Nombre (Obligatorio)',
          inputHint: 'Ingrese un código...',
          inputController: nombreController,
          textInputType: TextInputType.text,
          formatter: true,
        ),
        MyCustomInputBox(
          label: 'Descripción (Obligatorio)',
          inputHint: 'Ingrese un código...',
          inputController: descripcionController,
          textInputType: TextInputType.text,
          formatter: true,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 8),
            child: Text(
              'Impuesto (Obligatorio)',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 40, 15),
          child: DropdownButtonFormField(
            value: opcionImpuesto,
            items: dropdownItems,
            onChanged: (opt) {
              setState(() {                
                opcionImpuesto = opt.toString();
              });
            },
            style: const TextStyle(fontSize: 19, color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Seleccione impuesto',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[350],
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              focusColor: const Color(0xff0962ff),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xff0962ff)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.grey[350]!,
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 8),
            child: Text(
              'Imagen producto (Opcional)',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          height: 35,
          // for an exact replicate, remove the padding.
          // pour une réplique exact, enlever le padding.
          padding: const EdgeInsets.only(top: 5, left: 30, right: 100),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: const BorderSide(color: Colors.white),
              )),
            ),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png'],
              );

              if (result != null) {
                File file = File(result.files.single.path!);
                if (result.files.single.extension.toString().toLowerCase() != "jpg" &&
                    result.files.single.extension.toString().toLowerCase() !=
                        "png" &&
                    result.files.single.extension.toString().toLowerCase() !=
                        "jpeg") {
                  message.showToast(
                      'El archivo subido no tiene un formato permitido');
                  setState(() {
                    opcionImagen = 'Presione aquí para subir imagen';
                  });
                } else {
                  imagen = file;
                  setState(() {
                    opcionImagen = result.files.single.name;
                  });
                }
              } else {}
            },
            child: Text(
              opcionImagen,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 8),
            child: Text(
              '¿Desea modificar el precio al facturar?',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Checkbox(
            value: preciomanual,
            onChanged: (value) {
              setState(() {
                preciomanual = value!;
              });
            })
      ],
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          OPCIONES SELECT OBLIGADO                          */
  /* -------------------------------------------------------------------------- */
  Future<List<DropdownMenuItem<String>>> getImpuesto() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var impuestos = await empresa.obtenerImpuestos(prefs.getString('token'));

    List<DropdownMenuItem<String>> listaImpuesto = [];

     // Iterar sobre la lista de impuestos y agregar cada uno a listaImpuesto
  impuestos["impuestos"].forEach((impuesto) {
    listaImpuesto.add(
      DropdownMenuItem(
        child: Text(
          "${impuesto["nombre"]} (${impuesto["valor"]}%)", // Mostrar nombre y valor del impuesto
          style: const TextStyle(fontSize: 14),
        ),
        value: impuesto["codigo"].toString(), // El valor del DropdownMenuItem será el código convertido a String
      ),
    );
  });
    return listaImpuesto;
  }

// Define una función asíncrona para manejar la obtención de los impuestos
void obtenerYMostrarImpuestos() async {
  // Espera a que se obtengan los impuestos
  List<DropdownMenuItem<String>> listaImpuestos = await getImpuesto();

  setState(() {
    dropdownItems = listaImpuestos; // Suponiendo que dropdownItems es una variable de estado donde se almacenan los elementos del DropdownButton
  });
}

  Widget seccionPrecios() {
    return ListView(
      children: [
        const SizedBox(height: 50.0),
        _isLoading ? load.loading() : Container(),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, bottom: 8),
            child: Text(
              'Precio costo (Obligatorio)',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 15),
          child: TextField(
            controller: precioCostoController,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            ],
            onChanged: (opt) {
              setState(() {});
            },
            style: const TextStyle(fontSize: 16.5, color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Ingrese precio costo',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[350],
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              focusColor: const Color(0xff0962ff),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xff0962ff)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.grey[350]!,
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, bottom: 8),
            child: Text(
              'Precio público (Obligatorio)',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 15),
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus == false) {
                setState(() {
                  String cajaTexto = precioPublicoController.text;
                  if (cajaTexto.contains("/") &&
                      cajaTexto.split("/")[0] != "") {
                    double p = double.parse(cajaTexto.split("/")[0]);
                    p = p / 1.12;
                    precioPublicoController.text = p.toStringAsFixed(2);
                  }
                });
              }
            },
            child: TextField(
              controller: precioPublicoController,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              //inputFormatters: [
              //FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              //],
              onChanged: (opt) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 16.5, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Ingrese precio público',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[350],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                focusColor: const Color(0xff0962ff),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xff0962ff)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey[350]!,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, bottom: 8),
            child: Text(
              'Precio distribuidor (Opcional)',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 15),
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus == false) {
                setState(() {
                  String cajaTexto = precioDistribuidorController.text;
                  if (cajaTexto.contains("/") &&
                      cajaTexto.split("/")[0] != "") {
                    double p = double.parse(cajaTexto.split("/")[0]);
                    p = p / 1.12;
                    precioDistribuidorController.text = p.toStringAsFixed(2);
                  }
                });
              }
            },
            child: TextField(
              controller: precioDistribuidorController,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              onChanged: (opt) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 16.5, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Ingrese precio distribuidor',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[350],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                focusColor: const Color(0xff0962ff),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xff0962ff)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey[350]!,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, bottom: 8),
            child: Text(
              'Precio mayorista (Opcional)',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 15),
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus == false) {
                setState(() {
                  String cajaTexto = precioMayoristaController.text;
                  if (cajaTexto.contains("/") &&
                      cajaTexto.split("/")[0] != "") {
                    double p = double.parse(cajaTexto.split("/")[0]);
                    p = p / 1.12;
                    precioMayoristaController.text = p.toStringAsFixed(2);
                  }
                });
              }
            },
            child: TextField(
              controller: precioMayoristaController,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              onChanged: (opt) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 16.5, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Ingrese precio mayorista',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[350],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                focusColor: const Color(0xff0962ff),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xff0962ff)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey[350]!,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, bottom: 8),
            child: Text(
              'Precio Liquidación (Opcional)',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 15),
          child: Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus == false) {
                setState(() {
                  String cajaTexto = precioLiquidacionController.text;
                  if (cajaTexto.contains("/") &&
                      cajaTexto.split("/")[0] != "") {
                    double p = double.parse(cajaTexto.split("/")[0]);
                    p = p / 1.12;
                    precioLiquidacionController.text = p.toStringAsFixed(2);
                  }
                });
              }
            },
            child: TextField(
              controller: precioLiquidacionController,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              onChanged: (opt) {
                setState(() {});
              },
              style: const TextStyle(fontSize: 16.5, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Ingrese precio liquidación',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[350],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                focusColor: const Color(0xff0962ff),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xff0962ff)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey[350]!,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  

  Widget seccionICE() {
    var dropdownButtonFormField = DropdownButtonFormField(
        isExpanded: true,
        value: opcionCodigoImpuestoICE,
        items: listadoCodigosTiposICE,
        onChanged: (opt) { 
          setState(() {
            opcionCodigoImpuestoICE = opt.toString();
            // Obtén el valor de porcentajeICE del elemento seleccionado
            final codigoSeleccionado = listadoCodigosICE.firstWhere(
              (dato) => dato['codigoICE'].toString() == opcionCodigoImpuestoICE,
              orElse: () => null,
            );
            final porcentajeICE = codigoSeleccionado != null ? codigoSeleccionado['porcentajeICE'].toString() : '';
            final valorfijoICE = codigoSeleccionado != null ? codigoSeleccionado['valorICE'].toString() : '';
            // Actualiza el valor del inputController con porcentajeICE
            if (opcionAplicaImpuestoICE == 'Por porcentaje' && opcionCodigoImpuestoICE!='Ninguno') {
              valorTarifaImpuestoICE.text = porcentajeICE;       
            } else if (opcionAplicaImpuestoICE == 'Valor fijo' && opcionCodigoImpuestoICE!='Ninguno') {
              valorTarifaImpuestoICE.text = valorfijoICE;
            }                     
          });
        },
        style: const TextStyle(fontSize: 19, color: Colors.black),                  
        decoration: InputDecoration(
          hintText: 'Seleccione Código ICE',
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey[350],
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          focusColor: const Color(0xff0962ff),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xff0962ff)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.grey[350]!,
            ),
          ),
        ),
      );
    return ListView(
      
      children: [
        const SizedBox(height: 50.0),
        Container(  
          alignment: Alignment.centerLeft,        
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255), // Color de fondo del recuadro
            borderRadius: BorderRadius.circular(8), // Bordes redondeados
          ),
          padding: const  EdgeInsets.only(left: 30.0, bottom: 8),
          child: const Text(
            
            'El ICE se grava sobre determinados productos específicos, como bebidas alcohólicas, cigarrillos, combustibles, vehículos, entre otros.',
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 11, 112)),
          ),
        ),
        const SizedBox(height: 5.0),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 8),
            child: Text(
              'Impuesto Valor Agregado (ICE)',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 40, 15),
          child: Column(
            children: [
              DropdownButtonFormField(
                value: opcionAplicaImpuestoICE,
                items: getAplicaICE(),
                onChanged: (opt) {
                  setState(() {
                    opcionAplicaImpuestoICE = opt.toString();
                    mostrarSegundoListado = opcionAplicaImpuestoICE == 'Por porcentaje' || opcionAplicaImpuestoICE == 'Valor fijo';
                    if (opcionAplicaImpuestoICE == 'Por porcentaje') {
                      cadenaTipoICE = "Tarifa ICE por porcentaje %";                   
                    } else if (opcionAplicaImpuestoICE == 'Valor fijo') {
                      cadenaTipoICE = "Tarifa ICE por valor fijo";
                    }
                    opcionCodigoImpuestoICE= 'Ninguno';
                    valorTarifaImpuestoICE.text = ''; 
                  });
                },
                style: const TextStyle(fontSize: 19, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Seleccione impuesto',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[350],
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  focusColor: const Color(0xff0962ff),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xff0962ff)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey[350]!,
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),

        const SizedBox(height: 10.0),
        _isLoading ? load.loading() : Container(),
        if (mostrarSegundoListado) ...[
          const SizedBox(
            height: 10,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 30.0, bottom: 8),
              child: Text(
                'Código ICE',
                style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),            
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 40, 15),
            child: Column(
              children: [
                dropdownButtonFormField,                      
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),                          
          MyCustomInputBox(
            label: cadenaTipoICE,
            inputHint: 'Ingrese un código...',
            inputController: valorTarifaImpuestoICE,           
            formatter: true,
          ),
        ]
        
      ],
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                              GUARDAR PRODUCTO                              */
  /* -------------------------------------------------------------------------- */
  guardarProducto() async {
    if (codigoController.text == '') {
      message.showToast(
          'Ingrese el código del producto, se encuentra en la pestaña de datos generales');
      return;
    }

    if (nombreController.text == '') {
      message.showToast(
          'Ingrese el nombre del producto, se encuentra en la pestaña de datos generales');
      return;
    }

    if (opcionImpuesto == '') {
      message.showToast(
          'Seleccione el impuesto del producto, se encuentra en la pestaña de datos generales');
      return;
    }

    if (opcionImpuesto == '') {
      message.showToast(
          'Seleccione el impuesto del producto, se encuentra en la pestaña de datos generales');
      return;
    }

    if (precioPublicoController.text == '') {
      message.showToast(
          'Seleccione el precio del producto al publico, se encuentra en la pestaña de precios');
      return;
    }

    /*******************************************************************************************
     * VALIDAR CAMPOS DEL ICE
     ******************************************************************************************/ 

    if ((opcionAplicaImpuestoICE == 'Por porcentaje' || opcionAplicaImpuestoICE == 'Valor fijo')) {
      if(opcionCodigoImpuestoICE== 'Ninguno'){
        message.showToast(
            'Seleccione un Código ICE');
        return;
      }
      if(valorTarifaImpuestoICE.text== ''){
        message.showToast(
            'Ingrese un valor en la tarifa del ICE');
        return;
      }      
    }

    if ((opcionAplicaImpuestoICE == 'Por porcentaje')) {
      if(valorTarifaImpuestoICE.text== ''){
        message.showToast(
            'Ingrese un valor en la tarifa del ICE');
        return;
      }  

    }

    setState(() {
      _isLoading = true;
    });

print(opcionImpuesto);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final registro = await producto.updateProducto(
        idProducto,
        codigoController.text,
        nombreController.text,
        descripcionController.text,
        opcionImpuesto,
        imagen,
        preciomanual ? 1 : 0,
        precioCostoController.text,
        precioPublicoController.text,
        precioDistribuidorController.text,
        precioMayoristaController.text,
        precioLiquidacionController.text,
        opcionAplicaImpuestoICE,
        opcionCodigoImpuestoICE,
        valorTarifaImpuestoICE.text,
        prefs.getString('token'),
        prefs.getString('idEmpresa'));
    registro.stream.transform(utf8.decoder).listen((value) {
      final List<dynamic> json = jsonDecode("[$value]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["status"]) {
          setState(() {
            _isLoading = false;
          });

          message.showToast('Producto ingresado correctamente');
          Navigator.pushNamed(context, 'listar-productos');
        } else {
          message.showToast(child["msg"]);
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Está seguro que desea cancelar la acción?',
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
                onTap: () => Navigator.pushNamed(context, 'listar-productos'),
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

  /* -------------------------------------------------------------------------- */
  /*                              OBTENER LISTADO ICE                           */
  /* -------------------------------------------------------------------------- */
  getCodigosIce() async {
    setState(() {
      _isLoadingIce = true;
      listadoCodigosICE.clear();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await producto.getCodigosICE(prefs.getString('token'), prefs.getString('idEmpresa'));
    setState(() {
      setState(() {
        listadoCodigosICE = data[0]; 
        tarifaImpuesto = data[1].toString(); 
        _isLoadingIce = false;
        getImpuestoICE();
      });
    });


    


  }

  /* -------------------------------------------------------------------------- */
  /*                          OPCIONES APLICA ICE                               */
  /* -------------------------------------------------------------------------- */
  List<DropdownMenuItem<String>> getAplicaICE() {
    List<DropdownMenuItem<String>> listaAplicaICE = [];

    listaAplicaICE.add(const DropdownMenuItem(
      child: Text(
        'No Aplica',
        style: TextStyle(fontSize: 14),
      ),
      value: 'No aplica',
    ));

    listaAplicaICE.add(const DropdownMenuItem(
      child: Text(
        'Por porcentaje',
        style: TextStyle(fontSize: 14),
      ),
      value: 'Por porcentaje',
    ));

    listaAplicaICE.add(const DropdownMenuItem(
      child: Text(
        'Valor fijo',
        style: TextStyle(fontSize: 14),
      ),
      value: 'Valor fijo',
    ));

    return listaAplicaICE;
  }

  /* -------------------------------------------------------------------------- */
  /*                          OPCIONES SELECT ICE                               */
  /* -------------------------------------------------------------------------- */
  List<DropdownMenuItem<String>> getImpuestoICE() {
    listadoCodigosTiposICE.clear();

    listadoCodigosTiposICE.add(const DropdownMenuItem(
      child: Text(
        'Selecciona un código',
        style: TextStyle(fontSize: 14),
      ),
      value: 'Ninguno',
    ));

    for (var dato in listadoCodigosICE) {
      listadoCodigosTiposICE.add(DropdownMenuItem(
        child: Text(
          '${dato['codigoICE']} - ${dato['descripcionICE']}',
          style: const TextStyle(fontSize: 14),
        ),
        value: dato['codigoICE'].toString(),
      ));
    }

    return listadoCodigosTiposICE;
  }
  

  
}
