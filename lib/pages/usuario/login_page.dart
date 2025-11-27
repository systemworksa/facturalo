// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
//import 'package:new_version/new_version.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/colorExadecimal.dart';
import '../../common/custom_input.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final message = ToastMessage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final load = Load();
  // ignore: unused_field
  bool _isLoading = false;
  bool lower = false;
  final usuarios = UsuarioProvider();
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
  //InternetDialog? _internetDialog;
 // final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    /*final newVersion = NewVersion(
      iOSId: 'com.contamatic.facturacion',
      androidId: 'com.contamatic.facturacion',
    );
    advancedStatusCheck(newVersion);*/
    //final newVersion = NewVersionPlus();

    //advancedStatusCheck(newVersion);
   // _internetDialog = InternetDialog(context);
   // _connectivitySubscription = _connectivity.onConnectivityChanged
   //     .listen(_internetDialog!.updateConnectionStatus);
  }

  basicStatusCheck(NewVersionPlus newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          allowDismissal: false,
          updateButtonText: 'Actualizar',
          dismissButtonText: "",
          dialogTitle: 'Nueva versión disponible',
          dialogText:
              'Descarga la última versión, nuevas características y corrección de errores.',
        );
      }
    }
  }

  /*advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      // debugPrint(status.releaseNotes);
      //  debugPrint(status.appStoreLink);
      // debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      //debugPrint(status.canUpdate.toString());
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
            context: context,
            versionStatus: status,
            dialogTitle: 'Nueva version disponible',
            dialogText:
                'Incluye nuevas caracteristicas y corrección de errores.',
            updateButtonText: 'Actualizar',
            allowDismissal: false);
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                'assets/img/FONDOMORADO@3x.png',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 635,
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
                        'Ingrese sus datos de acceso.',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 15),
                      MyCustomInputBox(
                        label: 'Usuario',
                        inputHint: 'Ingrese su usuario...',
                        inputController: emailController,
                        formatter: false,
                      ),
                      MyCustomInputBox(
                        label: 'Clave',
                        inputHint: 'Ingrese su clave...',
                        inputController: passwordController,
                        formatter: false,
                      ),
                      _isLoading ? load.loading() : Container(),
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
                            iniciarSession();
                            //Navigator.pushNamed(context, 'inicio');
                          },
                          child: const Text(
                            'Iniciar sesión',
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
                          Navigator.pushNamed(context, 'email-verificacion');
                        },
                        child: const Center(
                          child: Text(
                            '¿Recuperar clave? clic aquí',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            login(Icons.add, context),
                          ],
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

  iniciarSession() async {
    if (emailController.text.toString() == "") {
      message.showToast('El email es un campo obligatorio');
      return;
    }
    if (passwordController.text.toString() == "") {
      message.showToast('La clave es un campo obligatorio');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future<dynamic> resp =
        usuarios.loginUser(emailController.text, passwordController.text);

    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["status"]) {
          if (child["datos"]["estado"] == 1) {
            message.showToast('Datos de acceso correctos.');
            prefs.setString('token', child["token"]);
            prefs.setString(
                'idEmpresa', child["datos"]["idEmpresa"].toString());
            prefs.setString(
                'idUsuario', child["datos"]["idUsuario"].toString());
            prefs.setString(
                'nombreUsuario', child["datos"]["nombres"].toString());
            prefs.setString(
                'cedulaUsuario', child["datos"]["cedula"].toString());
            prefs.setString('emailUsuario', child["datos"]["email"].toString());
            prefs.setString('pin', child["datos"]["pin"].toString());
            setState(() {
              _isLoading = false;

              //cedulaController.clear();
              //nombreController.clear();
              passwordController.clear();
              emailController.clear();
              if (!child["empresaActualizada"]) {
                Navigator.pushNamed(context, 'inicio');
              } else {
                Navigator.pushNamed(context, 'home');
              }
            });
          } else {
            setState(() {
              _isLoading = false;
              message.showToast('Usuario desactivado o eliminado');
            });
          }
        } else {
          message.showToast(id);
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
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
