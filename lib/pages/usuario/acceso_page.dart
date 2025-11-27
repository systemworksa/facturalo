// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
//import 'package:new_version/new_version.dart';
import '../../common/colorExadecimal.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
class AccesosPage extends StatefulWidget {
  const AccesosPage({Key? key}) : super(key: key);

  @override
  State<AccesosPage> createState() => _AccesosPageState();
}

class _AccesosPageState extends State<AccesosPage> {
  final message = ToastMessage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final load = Load();
  final LocalAuthentication auth = LocalAuthentication();
  // ignore: unused_field
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  // ignore: unused_field
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  // ignore: unused_field
  bool _isLoading = false;
  bool lower = false;
  final usuarios = UsuarioProvider();
  String nombre = '';
  String pin = '';
  final Color color = HexColor.fromHex('#262f69');
  
  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );

    obtenerData();

    /* final newVersion = NewVersion(
      iOSId: 'com.contamatic.facturacion',
      androidId: 'com.contamatic.facturacion',
    );
    advancedStatusCheck(newVersion);*/
    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersionPlus();

    advancedStatusCheck(newVersion);
  }

  basicStatusCheck(NewVersionPlus newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    debugPrint(status!.storeVersion);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);

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

  /*advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      //debugPrint(status.releaseNotes);
      // debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      //debugPrint(status.storeVersion);
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

  obtenerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString("nombreUsuario")!;
      pin = prefs.getString('pin')!;
    });
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;

      if (_canCheckBiometrics == null) {
        _checkBiometrics();
      }
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Escanee su huella digital (o cara) para autenticar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
      if (_authorized == 'Authorized') {
        Navigator.pushNamed(context, 'home');
      } else {}
    });
  }

  // ignore: unused_element
  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  Widget login(IconData icon, texto, BuildContext context) {
    return Container(
      height: 50,
      width: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              TextButton(
                  onPressed: () async {
                    if (texto == 'PIN') {
                      if (pin == '') {
                        Navigator.pushNamed(context, 'crear-ping');
                      } else {
                        Navigator.pushNamed(context, 'validar-ping');
                      }
                    } else {
                      await _getAvailableBiometrics();
                      await _checkBiometrics();

                      if (_canCheckBiometrics == true) {
                        if (_isAuthenticating) {
                          _authenticate();
                        } else {
                          _authenticateWithBiometrics();
                        }
                      } else {
                        message.showToast(
                            'Huella / Face ID no configurado o no disponible configurelo en preferencias del sistema de su dispositivo y vuelva a interntar.');
                      }
                    }
                  },
                  child: Text(texto)),
            ],
          ),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body:
            /* if (_supportState == _SupportState.unknown)
                  const CircularProgressIndicator()
                else if (_supportState == _SupportState.supported)
                  const Text('This device is supported')
                else
                  const Text('This device is not supported'),
                const Divider(height: 100),
                Text('Can check biometrics: $_canCheckBiometrics\n'),
                ElevatedButton(
                  onPressed: _checkBiometrics,
                  child: const Text('Check biometrics'),
                ),
                const Divider(height: 100),
                Text('Available biometrics: $_availableBiometrics\n'),
                ElevatedButton(
                  onPressed: _getAvailableBiometrics,
                  child: const Text('Get available biometrics'),
                ),
                const Divider(height: 100),
                Text('Current State: $_authorized\n'),
                if (_isAuthenticating)
                  ElevatedButton(
                    onPressed: _cancelAuthentication,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Text('Cancel Authentication'),
                        Icon(Icons.cancel),
                      ],
                    ),
                  )
                else
                  Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _authenticate,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            Text('Authenticate'),
                            Icon(Icons.perm_device_information),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _authenticateWithBiometrics,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(_isAuthenticating
                                ? 'Cancel'
                                : 'Authenticate: biometrics only'),
                            const Icon(Icons.fingerprint),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        )*/
            Container(
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
                height: 605,
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
                      _isLoading ? load.loading() : Container(),
                      Text(
                        'Bienvenido de nuevo $nombre\nIngreso rápido.',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                login(Icons.password, 'PIN', context),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                login(Icons.fingerprint, 'Huella / Face ID',
                                    context),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '¿Desea acceder nuevamente o  con otra cuenta?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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
                            salirApp();
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
                      const Divider(thickness: 0, color: Colors.white),
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
          message.showToast('Datos de acceso correctos.');
          prefs.setString('token', child["token"]);
          prefs.setString('idEmpresa', child["datos"]["idEmpresa"].toString());
          prefs.setString('idUsuario', child["datos"]["idUsuario"].toString());
          prefs.setString('nombreUsuario', child["datos"]["nombres"].toString());
          prefs.setString('cedulaUsuario', child["datos"]["cedula"].toString());
          prefs.setString('emailUsuario', child["datos"]["email"].toString());
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
          message.showToast(id);
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  salirApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('token', "");
    prefs.setString('idEmpresa', "");
    prefs.setString('idUsuario', "");
    prefs.setString('nombreUsuario', "");
    prefs.setString('cedulaUsuario', "");
    prefs.setString('emailUsuario', "");
    Navigator.pushNamed(context, 'login');
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

enum _SupportState {
  unknown,
  // ignore: unused_field
  supported,
  // ignore: unused_field
  unsupported,
}
