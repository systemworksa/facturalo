import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/colorExadecimal.dart';

class SplashScrenPage extends StatefulWidget {
  const SplashScrenPage({Key? key}) : super(key: key);

  @override
  State<SplashScrenPage> createState() => _SplashScrenPageState();
}

class _SplashScrenPageState extends State<SplashScrenPage> {
  final Color color = HexColor.fromHex('#262f69');
  String validar = '';
  String validarOnboard = '';

  @override
  void initState() {
    super.initState();
    _validarInicio();
    Timer(
        const Duration(seconds: 3),
        () => validarOnboard == ''
            ? Navigator.pushNamed(context, 'onboard')
            : validar == ''
                ? Navigator.pushNamed(context, 'login')
                : Navigator.pushNamed(context, 'accesos'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo here
            Image.asset(
              'assets/img/HORIZONTALCLARO@3x.png',
              height: 190,
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        ),
      ),
    );
  }

  _validarInicio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? p = prefs.getString('idUsuario');
    String? p1 = prefs.getString('onboard');

    //int f = p?.is;

    //print('user $f');
    //Return int
    if (p?.isEmpty ?? true) {
      validar = '';
    } else {
      //  print('datos');
      validar = 'datos';
    }

    if (p1?.isEmpty ?? true) {
      validarOnboard = '';
    } else {
      //  print('datos');
      validarOnboard = 'datos';
    }
  }
}
