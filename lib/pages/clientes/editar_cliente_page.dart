import 'dart:convert';

import 'package:flutter/material.dart';

import '../../common/colorExadecimal.dart';
import '../../common/loading.dart';
import '../../models/personas/clientes_model.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/cliente_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/custom_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
////import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';

class EditarClientePage extends StatefulWidget {
  const EditarClientePage({Key? key}) : super(key: key);

  @override
  State<EditarClientePage> createState() => _EditarClientePageState();
}

class _EditarClientePageState extends State<EditarClientePage> {
  int conP = 0;
  Cliente? clienteConsulta;
  bool _isLoading = false;
  final cedulaController = TextEditingController();
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final pingController = TextEditingController();
  String idCliente = '';
  final load = Load();
  final message = ToastMessage();
  final cliente = ClienteProvider();
  final Color color = HexColor.fromHex('#262f69');
  String tipoIdentificacion = 'CEDULA';

  int identificacion = 10;
  int cont = 0;
  // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog ? _internetDialog;
  //final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();
    //  _internetDialog = InternetDialog(context);
    // _connectivitySubscription =
    //    _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    conP++;
    if (conP == 1) {
      setState(() {
        clienteConsulta =
            ModalRoute.of(context)!.settings.arguments as Cliente?;
        cedulaController.text = clienteConsulta!.cedula.toString();
        nombreController.text = clienteConsulta!.nombre.toString();
        telefonoController.text = clienteConsulta!.telefono.toString();
        emailController.text = clienteConsulta!.email.toString();
        direccionController.text = clienteConsulta!.direccion.toString();
        idCliente = clienteConsulta!.idCliente.toString();
        tipoIdentificacion = clienteConsulta!.tipoIdentificacion.toString();
        if (tipoIdentificacion == 'CEDULA') {
          identificacion = 10;
        }
        if (tipoIdentificacion == 'RUC') {
          identificacion = 13;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar cliente'),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();

                editarCliente();
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, bottom: 8),
                      child: Text(
                        'Cédula / RUC (Obligatorio)',
                        style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  tipoIdentificacion == 'PASAPORTE' || tipoIdentificacion == 'IDENTIFICACION EXTERIOR'
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
                    label: 'Nombres',
                    inputHint: 'Ingrese su nombre...',
                    inputController: nombreController,
                    textInputType: TextInputType.text,
                    formatter: true,
                    maxLength: 280,
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
                      style:
                          const TextStyle(fontSize: 16.5, color: Colors.black),
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
                    label: 'Email',
                    inputHint: 'Ingrese su email...',
                    inputController: emailController,
                    textInputType: TextInputType.emailAddress,
                    formatter: false,
                    maxLength: 100,
                  ),
                  MyCustomInputBox(
                    label: 'Dirección',
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
        'CÉDULA',
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
    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'IDENTIFICACION EXTERIOR',
        style: TextStyle(fontSize: 14),
      ),
      value: 'IDENTIFICACION EXTERIOR',
    ));
    return listaCiudad;
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
                onTap: () => Navigator.pushNamed(context, 'listar-clientes'),
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

  editarCliente() async {
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
    setState(() {
      _isLoading = true;
    });

    cont++;

    if (cont == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Future<dynamic> resp = cliente.editarCliente(
          prefs.getString('idEmpresa'),
          idCliente,
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
            message.showToast('Guardado correctamente.');

            setState(() {
              _isLoading = false;
              Navigator.pushNamed(context, 'listar-clientes');
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
