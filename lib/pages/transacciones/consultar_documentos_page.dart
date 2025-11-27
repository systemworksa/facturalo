import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:facturaloapp2025/common/colorExadecimal.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/theme_helper.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/models/transacciones/documentos_model.dart';
import 'package:facturaloapp2025/providers/transacciones/documentos_provider.dart';
import 'package:facturaloapp2025/providers/transacciones/visualizar_pdf.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
class ListarDocumentosPage extends StatefulWidget {
  const ListarDocumentosPage({Key? key}) : super(key: key);

  @override
  State<ListarDocumentosPage> createState() => _ListarDocumentosPageState();
}

class _ListarDocumentosPageState extends State<ListarDocumentosPage> {
  bool puedePresionarBoton = true;
  final Color color = HexColor.fromHex('#262f69');
  final TextEditingController _inputFieldBuscador = TextEditingController();
  int _page = 0;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  final documentos = DocumentosProvider();
  String fechaInicial = 'vacio';
  String fechaFinal = 'vacio';
  // ignore: unused_field
  bool _isLoading = false;
  List<Documento> documentoItem = [];
  final load = Load();
  final TextEditingController _inputFieldFechaInicio = TextEditingController();
  final TextEditingController _inputFieldFechaFin = TextEditingController();
  final message = ToastMessage();
  bool search = false;
  var colorBtns = Colors.white;

  void _loadMore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _page += 1; // Increase _page by 1

      try {
        final data = await documentos.getDocumentos(
            prefs.getString('token'),
            prefs.getString('idEmpresa'),
            _page,
            10,
            _inputFieldBuscador.text,
            _inputFieldFechaInicio.text == ""
                ? "vacio"
                : _inputFieldFechaInicio.text,
            _inputFieldFechaFin.text == ""
                ? "vacio"
                : _inputFieldFechaFin.text);

        final List<Documento> fetchedPosts = data;

        if (fetchedPosts.isNotEmpty) {
          setState(() {
            documentoItem.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
      _isLoading = true;
    });
    _page = 0;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = await documentos.getDocumentos(
          prefs.getString('token'),
          prefs.getString('idEmpresa'),
          _page,
          10,
          _inputFieldBuscador.text,
          _inputFieldFechaInicio.text == ""
              ? "vacio"
              : _inputFieldFechaInicio.text,
          _inputFieldFechaFin.text == "" ? "vacio" : _inputFieldFechaFin.text);

      setState(() {
        setState(() {
          documentoItem = data;
          _isLoading = false;
        });
      });
      /*final res = await http.get(Uri.parse(
          "$_baseUrl/api/documentos/consultarfacturaselec/${prefs.getString("token")}/Electronica/${prefs.getString("idEmpresa")}/vacio/vacio/$_page/10/?busqueda=${_inputFieldBuscador.text}"));
      setState(() {
        final decodedData = json.decode("[" + res.body + "]");
        print(res.body);
        _posts = decodedData[0]["documentos"];
      });*/
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  //StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog ? _internetDialog;
  //final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
   // _internetDialog = InternetDialog(context);
   // _connectivitySubscription =
  //  _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Documentos',
              style: TextStyle(fontSize: 17.0),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, 'home'),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (puedePresionarBoton == true) {
                    Navigator.pushNamed(context, 'crear-factura');
                  }
                },
                child: Row(
                  children: const [
                    Icon(Icons.add_circle_outline),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Nueva Factura'),
                    SizedBox(
                      width: 7.0,
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (puedePresionarBoton == true) {
                      _page = 0;
                      _firstLoad();
                      _inputFieldBuscador.text = '';
                    }
                  },
                  icon: const Icon(Icons.refresh))
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                    controller: _inputFieldBuscador,
                    onChanged: (value) {
                      setState(() {
                        _page = 0;
                        _firstLoad();
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: 'Buscar', border: InputBorder.none),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        _inputFieldBuscador.clear();
                        _page = 0;
                        _firstLoad();
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Checkbox(
                        value: search,
                        activeColor: color,
                        onChanged: (newValue) {
                          search = newValue!;
                          if (search) {
                            _modalFechasReporte();
                          } else {
                            _inputFieldFechaInicio.clear();
                            _inputFieldFechaFin.clear();
                            _firstLoad();
                          }
                          setState(() {});
                        }),
                    const Text('Filtrar documentos por fechas'),
                  ],
                ),
              ),
              _isFirstLoadRunning
                  ? Center(
                      child: load.loading(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: documentoItem.length,
                        controller: _controller,
                        itemBuilder: (_, index) =>
                            bandTile(documentoItem[index]),
                      ),
                    ),
              if (_isLoadMoreRunning == true)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(
                    child: load.loading(),
                  ),
                ),
            ],
          )),
    );
  }

  bandTile(Documento documento) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: Container(
          margin: const EdgeInsets.all(25.0),
          child: Row(
            children: [
              SizedBox(
                  height: 250,
                  width: 10.0,
                  child: VerticalDivider(
                    color: color,
                    width: 100.0,
                    thickness: 4,
                  )),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(border: Border.all(color: color)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        documento.tipo == 'Electronica'
                            ? Text('FACTURA. ',
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                )))
                            : Text('RECIBO. ',
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ))),
                        documento.tipo == 'Electronica'
                            ? Text(documento.secuencialFacturaE!,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                )))
                            : Text(
                                documento.secuencialFacturaF
                                    .toString()
                                    .substring(8),
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(Icons.supervised_user_circle),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text('CLIENTE. ',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ))),
                      Text(
                          documento.nombreCliente.toString().length >= 24
                              ? "${documento.nombreCliente.toString().substring(0, 20)}... "
                              : documento.nombreCliente
                                  .toString()
                                  .toUpperCase(),
                          softWrap: false,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ))),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(Icons.payment_rounded),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text('FORMA DE PAGO. ',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ))),
                      Text(
                          documento.metodoPago.toString().length >= 24
                              ? "${documento.metodoPago.toString().substring(0, 20)}... "
                              : documento.metodoPago.toString().toUpperCase(),
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ))),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(Icons.dinner_dining_rounded),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text('TOTAL. ',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ))),
                      Text(
                          "\$ ${documento.totalPagar.toString().toUpperCase()}",
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ))),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text('FECHA. ',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ))),
                      Text(documento.fechaRegistro.toString().toUpperCase(),
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ))),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  documento.tipo == 'Electronica'
                      ? Row(
                          children: [
                            const Icon(Icons.send),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text('ESTADO. ',
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ))),
                            Text(
                                documento.autorizado == "1"
                                    ? 'ENVIADO AL SRI'
                                    : "PENDIENTE DE AUTORIZAR",
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  color: documento.autorizado == "1"
                                      ? Colors.green
                                      : Colors.orange,
                                  fontSize: 12,
                                ))),
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 10.0),
                  Text('ACCIONES. ',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ))),
                  documento.autorizado != "1" && documento.tipo == 'Electronica'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(colorBtns),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    )),
                                  ),
                                  onPressed: () async {
                                    if (puedePresionarBoton == true) {
                                      Navigator.pushNamed(
                                      context, 'editar-factura',
                                      arguments: documento);
                                    }
                                    
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'EDITAR',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(colorBtns),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    )),
                                  ),
                                  onPressed: () async {
                                     if (puedePresionarBoton == true) {
                                    modalAutorizarDocumento(
                                        documento.idTransaccion);
                                     }
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.send,
                                        color: Colors.blue,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'AUTORIZAR',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              colorBtns),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        side: const BorderSide(
                                            color: Colors.white),
                                      )),
                                    ),
                                    onPressed: () async {
                                      if (puedePresionarBoton == true) {
                                        generateFactura(documento.idTransaccion); 
                                      }
                                      
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'VER RIDE',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              colorBtns),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        side: const BorderSide(
                                            color: Colors.white),
                                      )),
                                    ),
                                    onPressed: () async {
                                      if (puedePresionarBoton == true) {
                                        generateTicket(documento.idTransaccion);
                                      }
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'TICKET',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              colorBtns),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        side: const BorderSide(
                                            color: Colors.white),
                                      )),
                                    ),
                                    onPressed: () {
                                      if (puedePresionarBoton == true) {
                                        verXML(documento.idTransaccion);
                                      }
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.code,
                                          color: Colors.red,
                                          size: 15.0,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          'XML',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      : Container(),
                  documento.autorizado == "1" && documento.tipo == 'Electronica'
                      ? Column(
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    )),
                                  ),
                                  onPressed: () async {
                                    if (puedePresionarBoton == true) {
                                      generateFactura(documento.idTransaccion);
                                    }
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'VER RIDE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    )),
                                  ),
                                  onPressed: () async {
                                    if (puedePresionarBoton == true) {
                                      generateTicket(documento.idTransaccion);
                                    }
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'TICKET',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    )),
                                  ),
                                  onPressed: () {
                                    if (puedePresionarBoton == true) {
                                      verXML(documento.idTransaccion);
                                    }
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.code,
                                        color: Colors.red,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'XML',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      : Container(),
                  documento.tipo == "Fisica"
                      ? Column(
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    )),
                                  ),
                                  onPressed: () async {
                                    if (puedePresionarBoton == true) {
                                      Navigator.pushNamed(
                                        context, 'editar-factura',
                                        arguments: documento
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'EDITAR',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    )),
                                  ),
                                  onPressed: () async {
                                    if (puedePresionarBoton == true) {
                                      generateTicket(documento.idTransaccion);
                                    }
                                  },
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 15.0,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        'VER RECIBO',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      : Container(),
                
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _launchUrl(url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not open the map.';
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                            MODAL ELIMINAR ORDEN                            */
  /* -------------------------------------------------------------------------- */
  void _modalFechasReporte() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Column(
              children: [
                Text('Filtrar documentos',
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold))),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Desde:',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 10.0),
                Container(
                  child: TextField(
                    controller: _inputFieldFechaInicio,
                    showCursor: false,
                    readOnly: true,
                    onTap: () {
                      _selectDateInicio();
                    },
                    enableInteractiveSelection: false,
                    decoration: ThemeHelper()
                        .textInputDecoration('Fecha', 'Ingrese fecha'),
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Hasta:',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 10.0),
                Container(
                  child: TextField(
                    controller: _inputFieldFechaFin,
                    showCursor: false,
                    readOnly: true,
                    onTap: () {
                      _selectDateFin();
                    },
                    enableInteractiveSelection: false,
                    decoration: ThemeHelper()
                        .textInputDecoration('Fecha', 'Ingrese fecha'),
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _page = 0;
                      _firstLoad();
                    });
                  },
                  child: const Text('ACEPTAR')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                      _inputFieldFechaInicio.clear();
                      _inputFieldFechaFin.clear();
                      _page = 0;
                      _firstLoad();
                    });
                  },
                  child: const Text('SALIR')),
            ],
          );
        });
  }

  /* -------------------------------------------------------------------------- */
  /*                              SELECCIONAR FECHA                             */
  /* -------------------------------------------------------------------------- */
  _selectDateInicio() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2050),
        locale: const Locale('es', 'ES'));

    if (picked != null) {
      setState(() {
        var arr = picked.toString().split(" ");
        _inputFieldFechaInicio.text = arr[0];
      });
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                           SELECCIONAR FECHA HASTA                          */
  /* -------------------------------------------------------------------------- */
  _selectDateFin() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2050),
        locale: const Locale('es', 'ES'));

    if (picked != null) {
      setState(() {
        var arr = picked.toString().split(" ");
        _inputFieldFechaFin.text = arr[0];
      });
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                ENVIAR AL SRI                               */
  /* -------------------------------------------------------------------------- */
  void enviarSRI(idFactura) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    message.showToast('Procesando por favor espere...');
    setState(() {
      _isLoading = true;
      puedePresionarBoton = false;
      colorBtns = Colors.grey.shade200;
    });
    Future<dynamic> resp = documentos.enviarSRI(
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
            puedePresionarBoton = true;
            colorBtns = Colors.white;
          });

          Timer(const Duration(seconds: 1), () {
            _firstLoad();
            Navigator.pop(context);
          });
        } else {
          message.showToast(id);
          setState(() {
            _isLoading = false;
            puedePresionarBoton = true;
            colorBtns = Colors.white;
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
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Column(
              children: [
                SizedBox(
                    child: Image.asset('assets/img/check-correct.gif'),
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
          );
        });
  }

  Future<bool> modalAutorizarDocumento(idFactura) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Está seguro que desea autorizar este documento?',
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
                  enviarSRI(idFactura);
                  Navigator.pop(context);
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

  /* -------------------------------------------------------------------------- */
  /*                               GENERAR FACTURA                              */
  /* -------------------------------------------------------------------------- */
  void generateFactura(idFactura) async {
    setState(() {
      _isLoading = true;
    });
    message.showToast('Procesando por favor espere');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<dynamic> resp = documentos.generarRIDE(
        prefs.getString("token")!, prefs.getString("idEmpresa")!, idFactura);
    resp.then((value) {
      final List<dynamic> json = jsonDecode("[$value]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);

      for (var child in json2) {
        if (child["status"]) {
          String documento = child["rutaDocumento"];
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

  /*void descargarXML(url) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      var dir = await getApplicationDocumentsDirectory();
      if (dir != null) {
        String savename = "file.xml";
        String savePath = dir.path + "/$savename";
        //output:  /storage/emulated/0/Download/banner.png

        try {
          await Dio().download(url, savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
              //you can build progressbar feature too

            }
          });

          openFile(savePath);
          print("File is saved to download folder.");
        } on DioError catch (e) {
          print(e.message);
        }
      }
    } else {
      print("No permission to read and write.");
    }
  }

  void openFile(savePath) async {
    await rootBundle.loadString(savePath);
  }*/

  /* -------------------------------------------------------------------------- */
  /*                                   VER XML                                  */
  /* -------------------------------------------------------------------------- */
  void verXML(idFactura) async {
    setState(() {
      _isLoading = true;
    });
    message.showToast('Procesando por favor espere');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<dynamic> resp = documentos.verXML(
        prefs.getString("token")!, prefs.getString("idEmpresa")!, idFactura);
    resp.then((value) {
      final List<dynamic> json = jsonDecode("[$value]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);

      for (var child in json2) {
        if (child["status"]) {
          String documento = child["rutaXml"];

          _isLoading = false;

          _launchUrl(documento);
        }
      }
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                               GENERAR FACTURA                              */
  /* -------------------------------------------------------------------------- */
  void generateTicket(idFactura) async {
    setState(() {
      _isLoading = true;
    });
    message.showToast('Procesando por favor espere');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<dynamic> resp = documentos.generarTicket(
        prefs.getString("token")!, prefs.getString("idEmpresa")!, idFactura);
    resp.then((value) {
      final List<dynamic> json = jsonDecode("[$value]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);

      for (var child in json2) {
        if (child["status"]) {
          String documento = child["rutaTicket"];
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

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Está seguro que desea volver a la página de inicio?',
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
                onTap: () => Navigator.pushNamed(context, 'home'),
                child: roundedButton("  Si  ", color, color),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}
