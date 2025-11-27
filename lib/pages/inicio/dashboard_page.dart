// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/colorExadecimal.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final Color color = HexColor.fromHex('#262f69');
   //StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog ? _internetDialog;
  //final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();
   // _internetDialog = InternetDialog(context);
  //  _connectivitySubscription =
   // _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 60.0,
            ),
            LottieBuilder.asset("assets/animation/bussines.json"),
            Text(
              'Opss!',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Hemos detectado que aún no ha registrado los datos de la empresa o persona natural del ruc necesarios para la facturación electrónica.',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Container(
              height: 55,
              // for an exact replicate, remove the padding.
              // pour une réplique exact, enlever le padding.
              padding: const EdgeInsets.only(top: 5, left: 70, right: 70),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.indigo.shade800),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Colors.indigo.shade800),
                  )),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'configuracion-empresa');
                },
                child: const Text(
                  'Registrar datos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'login');
              },
              child: const Center(
                child: Text(
                  '¿Iniciar sesión? clic aquí',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
