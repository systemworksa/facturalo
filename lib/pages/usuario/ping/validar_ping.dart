import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:convert';
import 'dart:io';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/usuario_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/colorExadecimal.dart';

class ValidarPingPage extends StatefulWidget {
  const ValidarPingPage({Key? key}) : super(key: key);

  @override
  State<ValidarPingPage> createState() => _ValidarPingPageState();
}

class _ValidarPingPageState extends State<ValidarPingPage> {
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final message = ToastMessage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final load = Load();
  final Color color = HexColor.fromHex('#262f69');
  String valuePing = '';
  // ignore: unused_field
  bool _isLoading = false;
  bool lower = false;
  final usuarios = UsuarioProvider();
 
     Timer? _debounce;
      
  bool isDialogShown = false;
  //    ConnectivityResult? _connectionStatus;
 //     StreamSubscription<ConnectivityResult>? _connectivitySubscription;
 // InternetDialog ? _internetDialog;
  //final Connectivity _connectivity = Connectivity();
  Widget login(IconData icon, BuildContext context) {
    return Container(
      height: 60,
      width: 210,
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
                Navigator.pushNamed(context, 'accesos');
              },
              child: const Text('Iniciar con otro método')),
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
   //  _internetDialog = InternetDialog(context);
   // _connectivitySubscription =
   //     _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }
/*
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      if (!isDialogShown) {
        isDialogShown = true;
        _showNoInternetDialog();
      }
    } else {
      if (isDialogShown) {
        Navigator.of(context).pop();  // Cerrar el cuadro de diálogo
        isDialogShown = false;
      }
    }
  }
*/
/*
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Evitar que el cuadro de diálogo se cierre al tocar fuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('No tienes conexión a internet.'),
          actions: [
            TextButton(
              child: Text('Reintentar'),
              onPressed: _retryConnection,
            ),
          ],
        );
      },
    ).then((_) => isDialogShown = false);
  }*/
/*
  Future<void> _retryConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }
*/ 

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
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
                        'Ingrese su pin registrado.',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 15),
                      PinCodeTextField(
                          appContext: context,
                          length: 4,
                          obscureText: false,
                          animationType: AnimationType.scale,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                              activeColor: color,
                              selectedFillColor: Colors.grey[200],
                              inactiveFillColor: color,
                              inactiveColor: color),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.white,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          onCompleted: (v) {
                            setState(() {
                              valuePing = v;
                              validarPing(valuePing);
                              //currentText = value;
                            });
                          },
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          }),
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
                            validarPing(valuePing);
                            //Navigator.pushNamed(context, 'inicio');
                          },
                          child: const Text(
                            'Validar',
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
                          Navigator.pushNamed(context, 'validar-email-ping');
                        },
                        child: const Center(
                          child: Text(
                            '¿Recuperar pin? clic aquí',
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
                            login(Icons.arrow_left, context),
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

  validarPing(ping) async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future<dynamic> resp = usuarios.validarPing(
        ping, prefs.getString('token'), prefs.getString('idUsuario'));

    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["status"]) {
          message.showToast('Datos de acceso correctos.');

          prefs.setString('pin', valuePing);
          setState(() {
            _isLoading = false;

            Navigator.pushNamed(context, 'home');
          });
        } else {
          message.showToast(child["msg"]);
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
