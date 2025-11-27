import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../../common/colorExadecimal.dart';
import '../../common/loading.dart';
import 'package:facturaloapp2025/models/establecimientos/establecimientos_model.dart';
import 'package:facturaloapp2025/providers/establecimientos/establecimientos_provider.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/custom_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditarEstablecimientoPage extends StatefulWidget {
  const EditarEstablecimientoPage({Key? key}) : super(key: key);

  @override
  State<EditarEstablecimientoPage> createState() => _EditarEstablecimientoPageState();
}

class _EditarEstablecimientoPageState extends State<EditarEstablecimientoPage> {
  int conP = 0;
  Establecimiento? establecimientoConsulta;
  bool _isLoading = false;
  final nombreController = TextEditingController();
  final direccionController = TextEditingController();
  final establecimientoController = TextEditingController();
  final emisionController = TextEditingController();
  String idEstablecimiento = '';
  final load = Load();
  final message = ToastMessage();
  final establecimiento = EstablecimientoProvider();
  final Color color = HexColor.fromHex('#262f69');

  int identificacion = 10;
  int cont = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    conP++;
    if (conP == 1) {
      setState(() {
        establecimientoConsulta = ModalRoute.of(context)!.settings.arguments as Establecimiento?;
        nombreController.text = establecimientoConsulta!.nombre.toString();
        direccionController.text = establecimientoConsulta!.direccion.toString();
        establecimientoController.text = establecimientoConsulta!.secuencialEstablecimiento.toString();
        emisionController.text = establecimientoConsulta!.secuencialEmision.toString(); 
        idEstablecimiento = establecimientoConsulta!.id.toString();      
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Punto de Emisión'),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                editarEstablecimiento();
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
                  const SizedBox(height: 15),           
                  MyCustomInputBox(
                    label: 'Nombre',
                    inputHint: 'Ingrese un nombre...',
                    inputController: nombreController,
                    textInputType: TextInputType.text,
                    maxLength:280,
                    formatter: true,
                  ),
                  MyCustomInputBox(
                    label: 'Dirección (Aparecerá en la factura)',
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

  editarEstablecimiento() async {
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

    cont++;

    if (cont == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await establecimiento.editarEstablecimiento(  
          prefs.getString('idEmpresa'),
          prefs.getString('token'),
          idEstablecimiento,
          nombreController.text,
          direccionController.text,
          establecimientoController.text,
          emisionController.text
          ).then((value) {
            
          final List<dynamic> json = jsonDecode("[$value]");         
          final List<dynamic> json2 = List.from(json);
          for (var child in json2) {
            if (child["status"]) {
              message.showToast('Actualizado correctamente.');

              setState(() {
                _isLoading = false;
                Navigator.pushNamed(context, 'listar-establecimientos');
                nombreController.clear();
                direccionController.clear();
                establecimientoController.clear();
                emisionController.clear();

                cont = 0;
              });
            } else {
              message.showToast(child["msg"]);
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
    /*Future<dynamic> resp = cliente.getDataPersona2(cedulaController.text);

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
    });*/
  }
}
