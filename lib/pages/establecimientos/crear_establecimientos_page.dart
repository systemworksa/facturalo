import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/models/establecimientos/establecimientos_model.dart';
import 'package:facturaloapp2025/providers/establecimientos/establecimientos_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/colorExadecimal.dart';
import '../../common/custom_input.dart';
import '../../common/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearEstablecimientoPage extends StatefulWidget {
  const CrearEstablecimientoPage({Key? key}) : super(key: key);

  @override
  State<CrearEstablecimientoPage> createState() => _CrearEstablecimientoPageState();
}

class _CrearEstablecimientoPageState extends State<CrearEstablecimientoPage> {
  // ignore: prefer_final_fields
  bool _isLoading = false;
  
  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final establecimientoController = TextEditingController();
  final emisionController = TextEditingController();
  final load = Load();
  final message = ToastMessage();
  final establecimiento = EstablecimientoProvider();
  final Color color = HexColor.fromHex('#262f69');
  

  List<Establecimiento> establecimientoItem = [];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Punto de Emisión'),          
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                addEstablecimiento();
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
                  
                  MyCustomInputBox(
                    label: 'Nombre Comercial',
                    inputHint: 'Ingrese un nombre...',
                    inputController: nombreController,
                    textInputType: TextInputType.text,
                    maxLength:280,
                    formatter: true,
                  ),
                  
                  
                  MyCustomInputBox(
                    label: 'Dirección Sucursal',
                    inputHint: 'Ingrese la dirección...',
                    inputController: direccionController,
                    textInputType: TextInputType.text,
                    maxLength:280,
                    formatter: true,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, bottom: 8),
                      child: Text(
                        'Número Establecimiento',
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
                      controller: establecimientoController,
                      maxLength: 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Esto permite solo números
                      ],
                      onChanged: (opt) {
                        setState(() {});
                      },
                      style:const TextStyle(fontSize: 16.5, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: '001',
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
                        'Número de Punto de Emisión',
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
                      controller: emisionController,
                      maxLength: 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Esto permite solo números
                      ],
                      onChanged: (opt) {
                        setState(() {});
                      },
                      style:const TextStyle(fontSize: 16.5, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: '001',
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
                  
                  const Divider(thickness: 0, color: Colors.white),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                onTap: () => Navigator.pushNamed(context, 'listar-establecimientos'),
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

  addEstablecimiento() async {
    if (nombreController.text.toString().trim() == "") {
      message.showToast('Ingrese un nombre del Punto de Emisión');
      return;
    }

    if (direccionController.text.toString().trim() == "") {
      message.showToast('Ingrese dirección del establecimiento / sucursal.');
      return;
    }
    if (establecimientoController.text.toString().length != 3) {
      message.showToast('Ingrese un secuencial correcto para el Establecimiento.');
      return;
    }
    if (emisionController.text.toString().length != 3) {
      message.showToast('Ingrese un secuencial correcto para el Punto de Emisión.');
      return;
    }

    if (establecimientoController.text.toString() == "000") {
      message.showToast('Ingrese un secuencial válido para el Establecimiento.');
      return;
    } 

    if (emisionController.text.toString() == "000") {
      message.showToast('Ingrese un secuencial válido para el Punto de Emisión.');
      return;
    }   


    setState(() {
      _isLoading = true;
    });

    //cont++;

    if (true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await establecimiento.guardarEstablecimiento(        
          nombreController.text,
          direccionController.text,
          establecimientoController.text,
          emisionController.text,
          prefs.getString('token'),
          prefs.getString('idEmpresa')
        ).then((value) {
        
      //resp.then((id) {
        final List<dynamic> json = jsonDecode("[$value]");
        for (var child in json) {
          if (child["status"]) {
            message.showToast('Guardado correctamente.');

            setState(() {
              _isLoading = false;
              Navigator.pushNamed(context, 'listar-establecimientos');
              nombreController.clear();
              direccionController.clear();
              establecimientoController.clear();
              emisionController.clear();

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
  }

  
}