import 'dart:convert';


import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/cliente_provider.dart';
import 'package:flutter/material.dart';
import '../../common/colorExadecimal.dart';
import '../../common/custom_input.dart';
import '../../common/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
////import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
class CrearClienteVentaPage extends StatefulWidget {
  const CrearClienteVentaPage({Key? key}) : super(key: key);

  @override
  State<CrearClienteVentaPage> createState() => _CrearClienteVentaPageState();
}

class _CrearClienteVentaPageState extends State<CrearClienteVentaPage> {
  // ignore: prefer_final_fields
  bool _isLoading = false;
  final cedulaController = TextEditingController();
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final pingController = TextEditingController();
  final load = Load();
  final message = ToastMessage();
  final cliente = ClienteProvider();
  final Color color = HexColor.fromHex('#262f69');
  String tipoIdentificacion = 'CEDULA';
  int cont = 0;
  int identificacion = 10;
   // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
   InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();
   @override
  void initState() {
    super.initState();
      _internetDialog = InternetDialog(context);
    //_connectivitySubscription =
     //   _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Crear cliente'),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();

              addCliente();
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
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 15),
                _isLoading ? load.loading() : Container(),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0, bottom: 8),
                    child: Text(
                      'Tipo identificación (Obligatorio)',
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
                  child: DropdownButtonFormField(
                    value: tipoIdentificacion,
                    items: gettipoIdentificacion(),
                    onChanged: (opt) {
                      setState(() {
                        tipoIdentificacion = opt.toString();

                        if (tipoIdentificacion == 'CEDULA') {
                          identificacion = 10;

                          cedulaController.clear();
                          nombreController.clear();
                        }
                        if (tipoIdentificacion == 'RUC') {
                          identificacion = 13;

                          cedulaController.clear();
                          nombreController.clear();
                        }
                      });
                    },
                    style: const TextStyle(fontSize: 19, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Seleccione obligado',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[350],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
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
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0, bottom: 8),
                    child: Text(
                      'Cedula / RUC (Obligatorio)',
                      style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                tipoIdentificacion == 'PASAPORTE'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 30, 15),
                        child: TextField(
                          controller: cedulaController,
                          keyboardType: TextInputType.text,
                          onChanged: (opt) {
                            setState(() {});
                          },
                          style: const TextStyle(
                              fontSize: 16.5, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Ingrese Identificación',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[350],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            focusColor: const Color(0xff0962ff),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Color(0xff0962ff)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.grey[350]!,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 30, 15),
                        child: TextField(
                          controller: cedulaController,
                          maxLength: identificacion,
                          keyboardType: TextInputType.number,
                          onChanged: (opt) {
                            setState(() {
                              if (tipoIdentificacion == 'CEDULA') {
                                identificacion = 10;
                                if (cedulaController.text.length >= 10 &&
                                    cedulaController.text.length <= 10) {
                                  buscarDataCedula();
                                }

                                if (cedulaController.text.isEmpty) {
                                  nombreController.clear();
                                }
                              }
                              if (tipoIdentificacion == 'RUC') {
                                identificacion = 13;
                                if (cedulaController.text.length >= 13 &&
                                    cedulaController.text.length <= 13) {
                                  buscarDataCedula();
                                }
                                if (cedulaController.text.isEmpty) {
                                  nombreController.clear();
                                }
                              }
                            });
                          },
                          style: const TextStyle(
                              fontSize: 16.5, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Ingrese Identificación',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[350],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            focusColor: const Color(0xff0962ff),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Color(0xff0962ff)),
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
                MyCustomInputBox(
                  label: 'Nombres (Obligatorio)',
                  inputHint: 'Ingrese su nombre...',
                  inputController: nombreController,
                  textInputType: TextInputType.text,
                  formatter: true,
                  maxLength: 280,
                  allowSpaces: true,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0, bottom: 8),
                    child: Text(
                      'Teléfono (Opcional)',
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
                    controller: telefonoController,
                    maxLength: 10,
                    onChanged: (opt) {
                      setState(() {});
                    },
                    style: const TextStyle(fontSize: 16.5, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Ingrese teléfono',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[350],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
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
                MyCustomInputBox(
                  label: 'Email (Obligatorio)',
                  inputHint: 'Ingrese su email...',
                  inputController: emailController,
                  textInputType: TextInputType.emailAddress,
                  formatter: false,
                  maxLength: 100,
                ),
                MyCustomInputBox(
                  label: 'Dirección (Opcional)',
                  inputHint: 'Ingrese una dirección...',
                  inputController: direccionController,
                  textInputType: TextInputType.emailAddress,
                  formatter: false,
                  maxLength: 280,
                ),
                const Divider(thickness: 0, color: Colors.white),
                /*
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Text('Don\'t have an account yet ? ', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),),
                TextButton(
                onPressed: () {},
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              ],
            ),
              */
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          OPCIONES SELECT OBLIGADO                          */
  /* -------------------------------------------------------------------------- */
  List<DropdownMenuItem<String>> gettipoIdentificacion() {
    List<DropdownMenuItem<String>> listaCiudad = [];

    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'CEDULA',
        style: TextStyle(fontSize: 14),
      ),
      value: 'CEDULA',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'RUC',
        style: TextStyle(fontSize: 14),
      ),
      value: 'RUC',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'PASAPORTE',
        style: TextStyle(fontSize: 14),
      ),
      value: 'PASAPORTE',
    ));

    return listaCiudad;
  }

  addCliente() async {
    if (cedulaController.text.toString().trim() == "") {
      message.showToast('La cedula es un campo obligatorio');
      return;
    }

    if (cedulaController.text.toString().trim().length != 13 &&
        tipoIdentificacion == 'RUC') {
      message.showToast('El RUC consta de 13 digitos.');
      return;
    }
    if (cedulaController.text.toString().trim().length != 10 &&
        tipoIdentificacion == 'CEDULA') {
      message.showToast('La cédula consta de 10 digitos.');
      return;
    }
    if (nombreController.text.toString().trim() == "") {
      message.showToast('El nombre es un campo obligatorio');
      return;
    }

    if (emailController.text.toString().trim() == "") {
      message.showToast('El email es un campo obligatorio');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    cont++;

    if (cont == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Future<dynamic> resp = cliente.crearCliente(
          prefs.getString('idEmpresa'),
          cedulaController.text,
          nombreController.text,
          telefonoController.text,
          emailController.text,
          direccionController.text == '' ? 'SD' : direccionController.text,
          tipoIdentificacion,
          prefs.getString('token'));

      resp.then((id) {
        final List<dynamic> json = jsonDecode("[$id]");
        // Create a copy of json
        final List<dynamic> json2 = List.from(json);
        for (var child in json2) {
          if (child["status"]) {
            setState(() {
              _isLoading = false;
              Navigator.pop(context, cedulaController.text);
              cedulaController.clear();
              nombreController.clear();
              telefonoController.clear();
              emailController.clear();
              direccionController.clear();

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

  void buscarDataCedula() {
    setState(() {
      _isLoading = true;
    });
    Future<dynamic> resp = cliente.getDataPersona2(cedulaController.text);

    resp.then((id) {
      final List<dynamic> json = jsonDecode("$id");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        nombreController.text = child["razonsocial"];
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
