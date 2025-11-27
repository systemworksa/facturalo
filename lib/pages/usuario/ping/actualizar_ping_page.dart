// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/colorExadecimal.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
class ActualizarPingPage extends StatefulWidget {
  const ActualizarPingPage({Key? key}) : super(key: key);

  @override
  State<ActualizarPingPage> createState() => _ActualizarPingPageState();
}

class _ActualizarPingPageState extends State<ActualizarPingPage> {
  final message = ToastMessage();
  final pinController = TextEditingController();
  final repetirPingController = TextEditingController();
  final Color color = HexColor.fromHex('#262f69');
  final load = Load();
  // ignore: unused_field
  bool _isLoading = false;
  bool lower = false;
  final usuarios = UsuarioProvider();
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


 // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
 // InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();
    @override
  void initState() {
    super.initState();
 //   _internetDialog = InternetDialog(context);
  //  _connectivitySubscription =
  //  _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
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
                      const SizedBox(height: 15),
                      Text(
                        'Ingrese su nuevo pin de acceso.',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30.0, bottom: 8),
                          child: Text(
                            'Ingrese un Pin de 4 digitos',
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
                          controller: pinController,
                          obscureText: true,
                          maxLength: 4,
                          onChanged: (opt) {},
                          style: const TextStyle(
                              fontSize: 16.5, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Ingreso ping',
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
                          padding: EdgeInsets.only(left: 30.0, bottom: 8),
                          child: Text(
                            'Repetir pin',
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
                          controller: repetirPingController,
                          obscureText: true,
                          maxLength: 4,
                          onChanged: (opt) {},
                          style: const TextStyle(
                              fontSize: 16.5, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Ingrese nuevamente el pin',
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
                            validarCodigo();
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
                          Navigator.pushNamed(context, 'accesos');
                        },
                        child: const Center(
                          child: Text(
                            '¿Desea acceder con otro método? clic aquí',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

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

  validarCodigo() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future<dynamic> resp = usuarios.nuevoPing(pinController.text,
        prefs.getString('token'), prefs.getString('idUsuario'));

    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["status"]) {
          setState(() {
            _isLoading = false;
            pinController.clear();
            repetirPingController.clear();
            Navigator.pushNamed(context, 'validar-ping');
            message.showToast(child["msg"]);
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
