// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:facturaloapp2025/providers/personas/empresa_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../common/colorExadecimal.dart';
import '../../common/custom_input.dart';
import '../../common/loading.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
class ConfiguracionEmpresaPage extends StatefulWidget {
  const ConfiguracionEmpresaPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracionEmpresaPage> createState() =>
      _ConfiguracionEmpresaPageState();
}

class _ConfiguracionEmpresaPageState extends State<ConfiguracionEmpresaPage> {
  final emailController = TextEditingController();
  final cedulaController = TextEditingController();
  final razonSocialController = TextEditingController();
  final nombreComercialController = TextEditingController();
  final ciudadController = TextEditingController();
  final direccionController = TextEditingController();
  final celularController = TextEditingController();
  final codigoArtesanalController = TextEditingController();
  final claveFirmaController = TextEditingController();
  final impuestoController = TextEditingController();
  final message = ToastMessage();
  final usuarios = UsuarioProvider();
  bool enable = true;
  String opcionObligado = '';
  String opcionTipoContribuyente = '';
  String opcionAgenteRetencion = '';
  String archivoP12 = 'Presione aquí para subir firma';
  String logoEmpresa = 'Presione aquí para subir imagen';
  final empresa = EmpresaProvider();
  File? firma;
  File? imagen;
  final Color color = HexColor.fromHex('#262f69');
  // ignore: prefer_final_fields
  bool _isLoading = false;
  final load = Load();
  //StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog ? _internetDialog;
  //final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();
  //  _internetDialog = InternetDialog(context);
  //  _connectivitySubscription =
  //  _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }
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

  Widget dataInput(TextEditingController dataInput, String hintTitle,
      TextInputType keyboardType) {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 15, right: 25),
        child: TextField(
          controller: dataInput,
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

  /* -------------------------------------------------------------------------- */
  /*                          OPCIONES SELECT OBLIGADO                          */
  /* -------------------------------------------------------------------------- */
  List<DropdownMenuItem<String>> getObligado() {
    List<DropdownMenuItem<String>> listaCiudad = [];
    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'Seleccione...',
        style: TextStyle(fontSize: 14),
      ),
      value: '',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'SI',
        style: TextStyle(fontSize: 14),
      ),
      value: 'SI',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'NO',
        style: TextStyle(fontSize: 14),
      ),
      value: 'NO',
    ));

    return listaCiudad;
  }

  /* -------------------------------------------------------------------------- */
  /*                        SELECT TIPO DE CONTRIBUYENTE                        */
  /* -------------------------------------------------------------------------- */
  List<DropdownMenuItem<String>> getContribuyente() {
    List<DropdownMenuItem<String>> listaCiudad = [];
    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'Seleccione...',
        style: TextStyle(fontSize: 14),
      ),
      value: '',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220,
        child: Text(
          'CONTRIBUYENTE RÉGIMEN GENERAL',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: 'CONTRIBUYENTE RÉGIMEN GENERAL',
    ));

    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220.0,
        child: Text(
          'CONTRIBUYENTE RÉGIMEN RIMPE EMPREDEDOR',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: 'CONTRIBUYENTE RÉGIMEN RIMPE EMPRENDEDOR',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220.0,
        child: Text(
          'CONTRIBUYENTE RÉGIMEN RIMPE EMPREDEDOR JNDA',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: 'CONTRIBUYENTE RÉGIMEN RIMPE EMPREDEDOR JNDA',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220.0,
        child: Text(
          'CONTRIBUYENTE RÉGIMEN RIMPE NEGOCIO POPULAR',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: 'CONTRIBUYENTE RÉGIMEN RIMPE NEGOCIO POPULAR',
    ));

    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220.0,
        child: Text(
          'CONTRIBUYENTE RÉGIMEN RIMPE',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: 'CONTRIBUYENTE RÉGIMEN RIMPE',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220.0,
        child: Text(
          'CONTRIBUYENTE SIMPLIFICADO SOCIEDADES',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: 'CONTRIBUYENTE SIMPLIFICADO SOCIEDADES',
    ));

    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220.0,
        child: Text(
          'CONTRIBUYENTE RÉGIMEN MICROEMPRESAS',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: 'CONTRIBUYENTE RÉGIMEN MICROEMPRESAS',
    ));
    return listaCiudad;
  }

  /* -------------------------------------------------------------------------- */
  /*                              OPCION RESOLUCION                             */
  /* -------------------------------------------------------------------------- */
  List<DropdownMenuItem<String>> getResolucion() {
    List<DropdownMenuItem<String>> listaCiudad = [];
    listaCiudad.add(const DropdownMenuItem(
      child: Text(
        'No soy agente de retención',
        style: TextStyle(fontSize: 14),
      ),
      value: '',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220.0,
        child: Text(
          'Agente resolución No. 1 (NAC-DNCRASC20-0000001)',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: '1',
    ));
    listaCiudad.add(const DropdownMenuItem(
      child: SizedBox(
        width: 220.0,
        child: Text(
          'Agente resolución No. 2 (NAC-DNCRASC21-0000001, NAC-DNCRASC22-0000001)',
          style: TextStyle(fontSize: 11),
        ),
      ),
      value: '2',
    ));

    return listaCiudad;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: ListView(
          children: [
            Container(
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
                    Row(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 5.0,
                            ),
                            Image.asset('assets/img/sri.png', width: 30.0),
                          ],
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Ingrese los datos del RUC.',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, bottom: 8),
                        child: Text(
                          'RUC (Obligatorio)',
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
                        controller: cedulaController,
                        enabled: enable,
                        maxLength: 13,
                        onChanged: (opt) {
                          setState(() {
                            //print(opt.length);
                            if (opt.length == 13) {
                              enable = false;
                              consultarData();
                            }
                          });
                        },
                        style: const TextStyle(
                            fontSize: 16.5, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'RUC (Obligatorio)',
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
                    _isLoading ? const SizedBox(height: 20.0) : Container(),
                    MyCustomInputBox(
                      label: 'Razón social (Obligatorio)',
                      inputHint: 'Ingrese la razón social...',
                      inputController: razonSocialController,
                      formatter: true,
                      textInputType: TextInputType.text,
                    ),
                    MyCustomInputBox(
                      label: 'Nombre comercial (Obligatorio)',
                      inputHint: 'Ingrese el nombre comercial...',
                      formatter: true,
                      inputController: nombreComercialController,
                      textInputType: TextInputType.text,
                    ),
                    MyCustomInputBox(
                      label: 'Ciudad (Obligatorio)',
                      inputHint: 'Ingrese la ciudad...',
                      inputController: ciudadController,
                      formatter: true,
                      textInputType: TextInputType.text,
                    ),
                    MyCustomInputBox(
                      label: 'Dirección (Obligatorio)',
                      inputHint: 'Ingrese la dirección...',
                      inputController: direccionController,
                      textInputType: TextInputType.text,
                      formatter: true,
                    ),
                    MyCustomInputBox(
                      label: 'Celular contacto (Obligatorio)',
                      inputHint: 'Ingrese celular contacto...',
                      inputController: celularController,
                      textInputType: TextInputType.number,
                      formatter: true,
                    ),
                    MyCustomInputBox(
                      label: 'Código artesanal (Opcional)',
                      inputHint: 'Ingrese código artesanal...',
                      inputController: codigoArtesanalController,
                      textInputType: TextInputType.text,
                      formatter: true,
                    ),
                    MyCustomInputBox(
                      label: 'Email (Obligatorio)',
                      inputHint: 'Ingrese email...',
                      inputController: emailController,
                      textInputType: TextInputType.emailAddress,
                      formatter: false,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, bottom: 8),
                        child: Text(
                          'Obligado a llevar contabilidad (Obligatorio)',
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
                      child: DropdownButtonFormField(
                        value: opcionObligado,
                        items: getObligado(),
                        onChanged: (opt) {
                          setState(() {
                            opcionObligado = opt.toString();
                          });
                        },
                        style:
                            const TextStyle(fontSize: 19, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Seleccione obligado',
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
                          'Tipo contribuyente (Obligatorio)',
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
                      child: DropdownButtonFormField(
                        value: opcionTipoContribuyente,
                        items: getContribuyente(),
                        onChanged: (opt) {
                          setState(() {
                            opcionTipoContribuyente = opt.toString();
                          });
                        },
                        style:
                            const TextStyle(fontSize: 19, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Seleccione obligado',
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
                          'Agente de retención resolución N.',
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
                      child: DropdownButtonFormField(
                        value: opcionAgenteRetencion,
                        items: getResolucion(),
                        onChanged: (opt) {
                          setState(() {
                            opcionAgenteRetencion = opt.toString();
                          });
                        },
                        style:
                            const TextStyle(fontSize: 19, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Seleccione obligado',
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
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, bottom: 8),
                        child: Text(
                          'Subir Firma .p12 (Opcional)',
                          style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      // for an exact replicate, remove the padding.
                      // pour une réplique exact, enlever le padding.
                      padding:
                          const EdgeInsets.only(top: 5, left: 30, right: 100),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: const BorderSide(color: Colors.white),
                          )),
                        ),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            firma = file;
                            setState(() {
                              archivoP12 = result.files.single.name;
                            });
                          } else {}
                        },
                        child: Text(
                          archivoP12,
                          style: TextStyle(
                            fontSize:
                                archivoP12 == 'Presione aquí para subir firma'
                                    ? 13
                                    : 11.5,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyCustomInputBox(
                      label: 'Clave firma (Opcional)',
                      inputHint: 'Ingrese clave Firma...',
                      inputController: claveFirmaController,
                      textInputType: TextInputType.visiblePassword,
                      formatter: false,
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, bottom: 8),
                        child: Text(
                          'Logo PNG O JPG (Opcional)',
                          style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      // for an exact replicate, remove the padding.
                      // pour une réplique exact, enlever le padding.
                      padding:
                          const EdgeInsets.only(top: 5, left: 30, right: 100),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: const BorderSide(color: Colors.white),
                          )),
                        ),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png'],
                          );

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            if (result.files.single.extension.toString().toLowerCase() != "jpg" &&
                                result.files.single.extension
                                        .toString()
                                        .toLowerCase() !=
                                    "png" &&
                                result.files.single.extension
                                        .toString()
                                        .toLowerCase() !=
                                    "jpeg") {
                              message.showToast(
                                  'El archivo subido no tiene un formato permitido');
                              setState(() {
                                logoEmpresa = 'Presione aquí para subir imagen';
                              });
                            } else {
                              imagen = file;
                              setState(() {
                                logoEmpresa = result.files.single.name;
                              });
                            }
                          } else {}
                        },
                        child: Text(
                          logoEmpresa,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoading ? load.loading() : Container(),
                    Container(
                      height: 55,
                      // for an exact replicate, remove the padding.
                      // pour une réplique exact, enlever le padding.
                      padding:
                          const EdgeInsets.only(top: 5, left: 70, right: 70),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.indigo[800]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.indigo[800]!),
                          )),
                        ),
                        onPressed: () {
                          guardarEmpresa();
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
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      child: const Center(
                        child: Text(
                          '¿Deseas iniciar sesión? clic aquí',
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

  /* -------------------------------------------------------------------------- */
  /*                               GUARDAR EMPRESA                              */
  /* -------------------------------------------------------------------------- */
  guardarEmpresa() async {
    if (cedulaController.text == '') {
      message.showToast('El ruc es un campo obligatorio');
      return;
    }

    if (cedulaController.text.length != 13) {
      message.showToast(
          'El ruc consta de 13 dígitos, verifique y vuelva a intentar.');
      return;
    }

    if (razonSocialController.text == '') {
      message.showToast('La razón social es un campo obligatorio');
      return;
    }

    if (nombreComercialController.text == '') {
      message.showToast('El nombre comercial es un campo obligatorio');
      return;
    }

    if (ciudadController.text == '') {
      message.showToast('La ciudad es un campo obligatorio');
      return;
    }

    if (ciudadController.text == '') {
      message.showToast('La dirección es un campo obligatorio');
      return;
    }

    if (ciudadController.text == '') {
      message.showToast('Celular de contacto es un campo obligatorio');
      return;
    }

    if (emailController.text == '') {
      message.showToast('El email es un campo obligatorio');
      return;
    }

    if (opcionObligado == '') {
      message.showToast('Seleccione si es obligado o no a llevar contabilidad');
      return;
    }

    if (opcionObligado == '') {
      message.showToast('Seleccione el tipo de contribuyente al que pertenece');
      return;
    }
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final registro = await usuarios.upload(
        cedulaController.text,
        razonSocialController.text,
        nombreComercialController.text,
        ciudadController.text,
        direccionController.text,
        celularController.text,
        codigoArtesanalController.text,
        emailController.text,
        opcionObligado,
        opcionTipoContribuyente,
        opcionAgenteRetencion,
        firma,
        claveFirmaController.text,
        impuestoController.text,
        imagen,
        prefs.getString('token'),
        prefs.getString('idEmpresa'));
    registro.stream.transform(utf8.decoder).listen((value) {
      final List<dynamic> json = jsonDecode("[$value]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["status"]) {
          setState(() {
            message.showToast(child["msg"]);
            prefs.setString('razonsocial', razonSocialController.text);
            prefs.setString('nombrecomercial', nombreComercialController.text);
            prefs.setString('ruc', cedulaController.text);
            prefs.setString('ciudad', ciudadController.text);
            prefs.setString('pin', '');
            _isLoading = false;
            cedulaController.clear();
            razonSocialController.clear();
            nombreComercialController.clear();
            ciudadController.clear();
            direccionController.clear();
            celularController.clear();
            codigoArtesanalController.clear();
            emailController.clear();
            opcionObligado = '';
            opcionTipoContribuyente = '';
            opcionAgenteRetencion = '';
            firma = null;
            claveFirmaController.clear();
            imagen = null;
            message.showToast(child["msg"]);
            Navigator.pushNamed(context, 'home');
          });
        } else {
          message.showToast(child["msg"]);
          _isLoading = false;
        }
      }
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                               CONSULTAR DATOS                              */
  /* -------------------------------------------------------------------------- */
  consultarData() async {
    setState(() {
      _isLoading = true;
    });

    Future<dynamic> resp = usuarios.consultarData(cedulaController.text);

    resp.then((id) {
      setState(() {
        _isLoading = false;
        enable = true;
      });

      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        razonSocialController.text = child["nombreCompleto"]?.isEmpty ?? true
            ? ''
            : child["nombreCompleto"];
        nombreComercialController.text =
            child["nombreCompleto"]?.isEmpty ?? true
                ? ''
                : child["nombreCompleto"];
        var dir = child['direccion']?.isEmpty ?? true
            ? ' /  /  /  / '.split(' / ')
            : child['direccion'].toString().split(" / ");
        ciudadController.text = dir[0];
        direccionController.text = dir[3];
        opcionObligado = child["obligadoContabilidad"]?.isEmpty ?? true
            ? ''
            : child["obligadoContabilidad"];
        opcionAgenteRetencion = child["agenteRetencion"]?.isEmpty ?? true
            ? ''
            : child["agenteRetencion"];
        setState(() {
          _isLoading = true;
        });
        Future<dynamic> resp = usuarios.consultaRimpe(cedulaController.text);

        resp.then((id) {
          setState(() {
            _isLoading = false;
            enable = true;
            opcionTipoContribuyente = id.toString().trim();
          });
        });
      }
    });
  }
}
