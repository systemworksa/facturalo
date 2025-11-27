import 'dart:async';
import 'dart:convert';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/models/personas/clientes_model.dart';
import 'package:facturaloapp2025/providers/personas/cliente_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/colorExadecimal.dart';
import 'dart:async';
////import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
class ListarClientesVentaPage extends StatefulWidget {
  const ListarClientesVentaPage({Key? key}) : super(key: key);

  @override
  State<ListarClientesVentaPage> createState() =>
      _ListarClientesVentaPageState();
}

class _ListarClientesVentaPageState extends State<ListarClientesVentaPage> {
  // ignore: unused_field
  bool _isLoading = false;
  final TextEditingController _inputFieldBuscador = TextEditingController();
  final message = ToastMessage();
  final Color color = HexColor.fromHex('#262f69');
  final cliente = ClienteProvider();
  int cont = 0;
  int _page = 0;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;
  final clientes = ClienteProvider();
  List<Cliente> clienteItem = [];

  final load = Load();
  //StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();

    setState(() {
      _controller = ScrollController()..addListener(_loadMore);
      _firstLoad();
    });
   // _internetDialog = InternetDialog(context);
   // _connectivitySubscription =
   // _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Clientes'),
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
                  _firstLoad();
                },
                decoration: const InputDecoration(
                    hintText: 'Buscar', border: InputBorder.none),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  _inputFieldBuscador.clear();
                  _firstLoad();
                },
              ),
            ),
          ),
          _isFirstLoadRunning
              ? Center(
                  child: load.loading(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: clienteItem.length,
                    controller: _controller,
                    itemBuilder: (_, index) =>
                        _bandTile(clienteItem[index], index),
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
      ),
    );
  }

  Widget _bandTile(Cliente band, int index) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                      height: 120,
                      width: 10.0,
                      child: VerticalDivider(
                        color: color,
                        width: 100.0,
                        thickness: 4,
                      )),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    width: 300.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text("IDENTIFICACIÓN: ",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold))),
                            Text(band.cedula!,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ))),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                            Text("NOMBRE: ",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold))),
                            Flexible(
                              child: Text(
                                band.genero?.isEmpty ?? true
                                    ? band.nombreComercial!
                                    : band.nombreComercial!,
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                            Text("TELÉFONO: ",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold))),
                            Text(
                                band.telefono?.isEmpty ?? true
                                    ? '-'
                                    : band.telefono!,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ))),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                            Text("EMAIL: ",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold))),
                            Text(
                                band.email?.isEmpty ?? true
                                    ? ' - '
                                    : band.email!,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ))),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                            Text("DIRECCIÓN: ",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold))),
                            Text(
                                band.direccion?.isEmpty ?? true
                                    ? ' - '
                                    : band.direccion!,
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ))),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Row(children: [
                          SizedBox(
                            width: 150.0,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, band);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                ),
                                child: const Text(
                                  'Seleccionar',
                                  style: TextStyle(color: Colors.black),
                                )),
                          )
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
            ]),

            /*Image(
                image:      Container(
              */
          ],
        ),
      ),
    );
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

  Future<bool> modalEliminarItem(idCliente) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Está seguro que desea eliminar este cliente?',
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
                onTap: () => deleteCliente(idCliente),
                child: roundedButton("  Si  ", color, color),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

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
        final data = await clientes.getClientes(
          prefs.getString('token'),
          prefs.getString('idEmpresa'),
          _page,
          10,
          _inputFieldBuscador.text,
        );

        final List<Cliente> fetchedPosts = data;

        if (fetchedPosts.isNotEmpty) {
          setState(() {
            clienteItem.addAll(fetchedPosts);
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

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = await clientes.getClientes(
        prefs.getString('token'),
        prefs.getString('idEmpresa'),
        _page,
        10,
        _inputFieldBuscador.text,
      );

      setState(() {
        setState(() {
          clienteItem = data;
          _isLoading = false;
        });
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                              ELIMINAR CLIENTE                              */
  /* -------------------------------------------------------------------------- */
  deleteCliente(idCliente) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<dynamic> resp =
        cliente.eliminarCliente(idCliente, prefs.getString('token'));

    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["status"]) {
          message.showToast('Eliminado correctamente.');

          setState(() {
            _isLoading = false;
            Navigator.pop(context);
            _firstLoad();

            //cedulaController.clear();
            //nombreController.clear();
            //passwordController.clear();
            //emailController.clear();

            cont = 0;
          });
        } else {
          message.showToast(id);
          setState(() {
            _isLoading = false;
          });
          cont = 0;
        }
      }
    });
  }
}
