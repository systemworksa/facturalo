// ignore_for_file: deprecated_member_use

import 'dart:convert';
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
class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final cedulaController = TextEditingController();
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final pingController = TextEditingController();
  final load = Load();
  final message = ToastMessage();
  final usuarios = UsuarioProvider();
  int cont = 0;
  final Color color = HexColor.fromHex('#262f69');
  // ignore: prefer_final_fields
  bool _isLoading = false;
  //StreamSubscription<ConnectivityResult>? _connectivitySubscription;
 // InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();
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

  @override
  void initState() {
    super.initState();
    getUser();
   // _internetDialog = InternetDialog(context);
   // _connectivitySubscription =
   // _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
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
                  MyCustomInputBox(
                    label: 'Cédula o RUC',
                    inputHint: 'Ingrese su identificación...',
                    inputController: cedulaController,
                    textInputType: TextInputType.number,
                    formatter: true,
                  ),
                  MyCustomInputBox(
                    label: 'Nombres',
                    inputHint: 'Ingrese su nombre...',
                    inputController: nombreController,
                    textInputType: TextInputType.text,
                    formatter: true,
                  ),
                  MyCustomInputBox(
                    label:
                        'Clave (Acceder a la app posteriormente).\nPor motivos de seguridad no mostramos su clave',
                    inputHint: 'Ingrese una clave...',
                    inputController: passwordController,
                    textInputType: TextInputType.text,
                    formatter: true,
                  ),
                  MyCustomInputBox(
                    label: 'Email',
                    inputHint: 'Ingrese su email...',
                    inputController: emailController,
                    textInputType: TextInputType.emailAddress,
                    formatter: false,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30.0, bottom: 8),
                      child: Text(
                        'Ingrese un Pin de 4 digitos.\nPor motivos de seguridad no mostramos su pin',
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
                    child: TextField(
                      controller: pingController,
                      obscureText: true,
                      maxLength: 4,
                      onChanged: (opt) {},
                      style:
                          const TextStyle(fontSize: 16.5, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Ingreso pin',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[350],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        focusColor: Color.fromARGB(255, 81, 86, 190),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Color(0xFF5156BE)),
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

                  /*userInput(passwordController, 'Contraseña',
                      TextInputType.visiblePassword),
                  userInput(passwordController, 'Email',
                      TextInputType.visiblePassword),*/

                  Container(
                    height: 55,
                    // for an exact replicate, remove the padding.
                    // pour une réplique exact, enlever le padding.
                    padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigo.shade800),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.indigo.shade800),
                        )),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (prefs.getString('passUsuario') !=
                                passwordController.text &&
                            passwordController.text != '') {
                          _actualizarIniciar();
                        } else {
                          updateUser();
                        }

                        //;
                        //saveUser();
                      },
                      child: const Text(
                        'Actualizar',
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
                      Navigator.pushNamed(context, 'home');
                    },
                    child: const Center(
                      child: Text(
                        '¿Desea volver a la página principal? clic aquí',
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
          ],
        ),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                              OBTENER USUARIOS                              */
  /* -------------------------------------------------------------------------- */
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cedulaController.text = prefs.getString('cedulaUsuario')!;
      nombreController.text = prefs.getString('nombreUsuario')!;
      //passwordController.text = prefs.getString('passUsuario')!;
      emailController.text = prefs.getString('emailUsuario')!;
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                              MODIFICAR USUARIO                             */
  /* -------------------------------------------------------------------------- */
  updateUser() async {
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

    if (emailController.text.toString() == "") {
      message.showToast('El email es un campo obligatorio');
      return;
    }
    setState(() {
      _isLoading = true;
    });

    cont++;

    if (cont == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Future<dynamic> resp = usuarios.updateUser(
          prefs.getString('idUsuario'),
          cedulaController.text,
          nombreController.text,
          passwordController.text == ''
              ? prefs.getString('passUsuario')
              : passwordController.text,
          pingController.text == ''
              ? prefs.getString('pinUsuario')
              : pingController.text,
          emailController.text,
          prefs.getString('token'));

      resp.then((id) {
        final List<dynamic> json = jsonDecode("[$id]");
        // Create a copy of json
        final List<dynamic> json2 = List.from(json);
        for (var child in json2) {
          if (child["status"]) {
            message.showToast('Datos actualizados correctamente.');

            setState(() {
              _isLoading = false;

              //cedulaController.clear();
              //nombreController.clear();
              //passwordController.clear();
              //emailController.clear();

              if (prefs.getString('passUsuario') != passwordController.text &&
                  passwordController.text != '') {
                salirApp();
                Navigator.pushNamed(context, 'login');
              } else {
                Navigator.pushNamed(context, 'home');
              }

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
  Future<bool> _actualizarIniciar() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Hemos detectado que cambió su clave tendrá que iniciar sesión nuevamente, esta seguro de continuar?',
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
                onTap: () => updateUser(),
                child: roundedButton("  Si  ", color, color),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Está seguro que desea volver al inicio?',
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
