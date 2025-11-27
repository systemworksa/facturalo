// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/colorExadecimal.dart';
import '../../common/custom_input.dart';
import '../../common/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';

class RegistrarUsuarioPago extends StatefulWidget {
  const RegistrarUsuarioPago({Key? key}) : super(key: key);

  @override
  State<RegistrarUsuarioPago> createState() => _RegistrarUsuarioPagoState();
}

class _RegistrarUsuarioPagoState extends State<RegistrarUsuarioPago> {
  final cedulaController = TextEditingController();
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final telefonoController = TextEditingController();
  final load = Load();
  final message = ToastMessage();
  final usuarios = UsuarioProvider();
  int cont = 0;
  // ignore: prefer_final_fields
  bool _isLoading = false;
  final Color color = HexColor.fromHex('#262f69');
  Widget login(IconData icon, BuildContext context) {
    return Container(
      height: 60,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'registrar');
              },
              child: const Text('Registrase')),
        ],
      ),
    );
  }

  Widget userInput(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType) {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 15, right: 25),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          decoration: InputDecoration.collapsed(
            hintText: hintTitle,
            hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  //StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog ? _internetDialog;
  //final Connectivity _connectivity = Connectivity();
  @override
  void initState() {

    super.initState();
   // _internetDialog = InternetDialog(context);
   // _connectivitySubscription =
   // _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                'assets/img/FONDOMORADO@3x.png',
              ),
            ),
          ),
          child: ListView(
            children: [
              Container(
                height: 848,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        'Ingrese los datos requeridos.',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 15),
                      MyCustomInputBox(
                        label: 'Cédula o RUC (Obligatorio)',
                        inputHint: 'Ingrese su identificación...',
                        inputController: cedulaController,
                        textInputType: TextInputType.number,
                        formatter: true,
                      ),
                      MyCustomInputBox(
                        label: 'Nombres (Obligatorio)',
                        inputHint: 'Ingrese su nombre...',
                        inputController: nombreController,
                        textInputType: TextInputType.text,
                        formatter: true,
                      ),
                      MyCustomInputBox(
                        label: 'Clave (Acceder a la app posteriormente)',
                        inputHint: 'Ingrese una clave...',
                        inputController: passwordController,
                        textInputType: TextInputType.text,
                        formatter: true,
                      ),
                      MyCustomInputBox(
                        label: 'Email (Obligatorio)',
                        inputHint: 'Ingrese su email...',
                        inputController: emailController,
                        textInputType: TextInputType.emailAddress,
                        formatter: false,
                      ),
                      MyCustomInputBox(
                        label: 'Teléfono (Obligatorio)',
                        inputHint: 'Ingrese su número de teléfono...',
                        inputController: telefonoController,
                        textInputType: TextInputType.number,
                        formatter: false,
                      ),
                      _isLoading ? load.loading() : Container(),

                      /*userInput(passwordController, 'Contraseña',
                          TextInputType.visiblePassword),
                      userInput(passwordController, 'Email',
                          TextInputType.visiblePassword),*/

                      Container(
                        height: 55,
                        // for an exact replicate, remove the padding.
                        // pour une réplique exact, enlever le padding.
                        padding:
                            const EdgeInsets.only(top: 5, left: 70, right: 70),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.indigo.shade800),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.indigo.shade800),
                            )),
                          ),
                          onPressed: () {
                            saveUser();
                            //saveUser();
                          },
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: const Center(
                          child: Text(
                            '¿Iniciar sesión? clic aquí',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blueAccent),
                          ),
                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  saveUser() async {
    if (cedulaController.text.toString() == "") {
      message.showToast('La cedula es un campo obligatorio');
      return;
    }

    if (cedulaController.text.toString().length != 13 &&
        cedulaController.text.toString().length != 10) {
      message.showToast(
          'La identificación no tiene 10 digitos de una cedula ni 13 digitos de un RUC');
      return;
    }
    if (nombreController.text.toString() == "") {
      message.showToast('El nombre es un campo obligatorio');
      return;
    }
    if (passwordController.text.toString() == "") {
      message.showToast('La clave es un campo obligatorio');
      return;
    }
    if (emailController.text.toString() == "") {
      message.showToast('El email es un campo obligatorio');
      return;
    }

    if (telefonoController.text.toString() == "") {
      message.showToast(
          'El teléfono es un campo obligatorio, digitar correctamente para que sus documentos gratis sean activados correctamente');
      return;
    }
    setState(() {
      _isLoading = true;
    });

    cont++;

    if (cont == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Future<dynamic> resp = usuarios.saveUser(
          cedulaController.text,
          nombreController.text,
          passwordController.text,
          emailController.text,
          telefonoController.text);

      resp.then((id) {
        final List<dynamic> json = jsonDecode("[$id]");
        // Create a copy of json
        final List<dynamic> json2 = List.from(json);
        for (var child in json2) {
          if (child["status"]) {
            message.showToast('Registrado correctamente.');
            prefs.setString('token', child["token"]);
            prefs.setString(
                'idEmpresa', child["datos"]["idEmpresa"].toString());
            prefs.setString(
                'idUsuario', child["datos"]["idUsuario"].toString());
            prefs.setString('nombreUsuario', nombreController.text);
            prefs.setString('cedulaUsuario', cedulaController.text);
            prefs.setString('emailUsuario', emailController.text);
            setState(() {
              _isLoading = false;

              //cedulaController.clear();
              //nombreController.clear();
              //passwordController.clear();
              //emailController.clear();
              if (!child["empresaActualizada"]) {
                Navigator.pushNamed(context, 'inicio');
                cont = 0;
              }
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

  /* -------------------------------------------------------------------------- */
  /*                                ONBACK PRESED                               */
  /* -------------------------------------------------------------------------- */
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          '¿Está seguro que desea salir de la App?',
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
                onTap: () => exit(0),
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
}
