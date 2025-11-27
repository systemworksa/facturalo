// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:facturaloapp2025/common/colorExadecimal.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
//import 'package:new_version/new_version.dart';
import 'package:facturaloapp2025/providers/personas/usuario_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/providers/personas/empresa_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:facturaloapp2025/common/location.dart';
import 'package:facturaloapp2025/common/mock.dart';
import 'package:facturaloapp2025/common/user.dart';
import 'package:facturaloapp2025/common/styles.dart';
import 'package:new_version_plus/new_version_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String razonSocial = '';
  final empresa = EmpresaProvider();
  String totalGastos = "0.00";
  String totalIngresos = "0.00";
  String documentosDisponibles = "0";
  String documentosUtilizados = "0";
  String imagen =
      "http://facturalo.com.ec/sistema/vistas/img/usuarios/default/empresa.png";

  String tipoPlan = '';
  String asistencia = '';
  final message = ToastMessage();
  final load = Load();
  bool _isLoading = false;
  File? imagen1;
  String logoEmpresa = 'Presione aqui para subir imagen';
  final usuarios = UsuarioProvider();
  final Color color = HexColor.fromHex('#262f69');
  String titulo = "";
  String descripcion = "";
  String numeroEmpresa = "";
  @override
  void initState() {
    super.initState();
    resumen();
    /*final newVersion = NewVersion(
      iOSId: 'com.contamatic.facturacion',
      androidId: 'com.contamatic.facturacion',
    );
    advancedStatusCheck(newVersion);
    anuncio();*/
    //final newVersion = NewVersionPlus();

    //advancedStatusCheck(newVersion);
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
      //debugPrint(status.appStoreLink);
      //debugPrint(status.localVersion);
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

/* -------------------------------------------------------------------------- */
/*                               MODAL DEPOSITO                               */
/* -------------------------------------------------------------------------- */
  void _mostrarModalImagen() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Column(
              children: [
                Text(
                    'Actualizar Logo de la empresa / Persona Natural para emisión de documentos electrónicos',
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold))),
                const SizedBox(height: 20.0),
              ],
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 150.0,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/img/logoAmarillo.png',
                            image: imagen,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/img/logoAmarillo.png');
                            },
                            width: 33.0),
                      ),
                    ),
                  ),
                  _isLoading ? load.loading() : Container(),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            logoEmpresa = 'Presione aqui para subir imagen';
                          });
                        } else {
                          imagen1 = file;
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
                ]),
              );
            }),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      //_isChecks[index] = false;
                    });
                  },
                  child: const Text('CANCELAR')),
              TextButton(
                  onPressed: () {
                    actualizarImagen();
                  },
                  child: const Text('ACEPTAR Y ACTUALIZAR')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double bannerHeight = height * 0.35;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              height: bannerHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [kPrimaryColor, Colors.indigo.shade800],
              )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                _buildTopSection(bannerHeight),
                documentosUtilizados == documentosDisponibles
                    ? const SizedBox(
                        height: 10.0,
                      )
                    : Container(),
                _isLoading ? load.loading() : Container(),
                titulo == "" ? Container() : Container() ,//setAnucio(),
                documentosUtilizados == documentosDisponibles
                    ? Container(
                        height: 65,
                        // for an exact replicate, remove the padding.
                        // pour une réplique exact, enlever le padding.
                        padding:
                            const EdgeInsets.only(top: 15, left: 70, right: 70),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.indigo.shade800),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: color),
                            )),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, 'planes');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.payment,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Comprar plan',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.zero,
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildTitleSection("Accesos rápidos"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _buildPointsOfInterest(),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildTitleSection("Acciones"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildPopularTravelers(),
                        const SizedBox(
                          height: 10,
                        ),
                        /*_proximamente('Próximamente'),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildPopularProximante(),*/
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildTopSection(double bannerHeight) {
    MediaQueryData data = MediaQuery.of(context);
    double edgePadding = 25;

    return Container(
      height: bannerHeight - data.padding.top + edgePadding * 2 + 56,
      padding: EdgeInsets.all(edgePadding),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (() {
                    Navigator.pushNamed(context, 'home2');
                  }),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'editar-empresa');
                  },
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () => _onBackPressed(),
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    resumen();
                    anuncio();
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 20.0,
                ),
                Text(
                  numeroEmpresa,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _mostrarModalImagen(),
                      child: SizedBox(
                        width: 38.0,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipOval(
                            // ignore: unnecessary_null_comparison
                            child: imagen == null
                                ? Image.asset('assets/img/logoAmarillo.png')
                                : FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: 'assets/img/logoAmarillo.png',
                                    image: imagen,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset('assets/img/logoAmarillo.png');
                                    },
                                    width: 33.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Image.asset('assets/img/logo-2.png', width: 290.0),
            razonSocial.toString().length > 23
                ? Text(
                    "EMPRESA / PN: ${razonSocial.toString().substring(0, 22)}...",
                    textAlign: TextAlign.center,
                    style: kSubtitleTextStyle,
                  )
                : Text(
                    "EMPRESA / PN: $razonSocial",
                    textAlign: TextAlign.center,
                    style: kSubtitleTextStyle,
                  ),
            Text(
              'CONTADOR / IMPRENTA: $asistencia',
              style: const TextStyle(color: Colors.white, fontSize: 12.5),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(color: kPrimaryColor, width: 0.5),
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'PLAN ${tipoPlan.toUpperCase()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        CircleAvatar(
                          minRadius: 25.0,
                          child: Text(
                            '$documentosUtilizados/$documentosDisponibles',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10.0),
                          ),
                          backgroundColor: int.parse(documentosDisponibles) >
                                      0 &&
                                  documentosUtilizados != documentosDisponibles
                              ? Colors.green
                              : Colors.red,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: kPrimaryColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "INGRESOS",
                                    style: kBoxSearchTextStyle,
                                  ),
                                  Text(
                                    "\$ $totalIngresos",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 11.5),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "GASTOS",
                                    style: kBoxSearchTextStyle,
                                  ),
                                  Text(
                                    "\$ $totalGastos",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 11.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTitleSection(String title) {
    return Container(
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: kSectionTitleTextStyle,
          ),
          const Spacer(),
          Text(
            "",
            style: kMoreDetailsTextStyle,
          )
        ],
      ),
    );
  }

 

  _buildPointsOfInterest() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 20,
          ),
          ...locations
              .map((location) => PointOfInterest(
                    location: location,
                  ))
              .toList()
        ],
      ),
    );
  }

  _buildPopularTravelers() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 20,
          ),
          ...users
              .map((user) =>
                  user.name == 'Proveedores' || user.name == 'Retención'
                      ? Container()
                      : Traveler(
                          user: user,
                        ))
              .toList()
        ],
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
          '¿Está seguro que desea cerrar sesión? tendrá que ingresar nuevamente',
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
                onTap: () => salirApp(),
                child: roundedButton("  Si  ", color, color),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  /*Widget setAnucio() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: BsAlert(
        closeButton: false,
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Text(
                textAlign: TextAlign.justify,
                titulo,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              textAlign: TextAlign.justify,
              descripcion,
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }*/

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
  /*                          SALIR APP Y BORRAR CAMPOS                         */
  /* -------------------------------------------------------------------------- */
  salirApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('token', "");
    prefs.setString('idEmpresa', "");
    prefs.setString('idUsuario', "");
    prefs.setString('nombreUsuario', "");
    prefs.setString('cedulaUsuario', "");
    prefs.setString('emailUsuario', "");
    prefs.remove('idPuntoEmision');
    Navigator.pushNamed(context, 'login');
  }

  /* -------------------------------------------------------------------------- */
  /*                                RESUMEN HOME                                */
  /* -------------------------------------------------------------------------- */
  resumen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future<dynamic> resp = empresa.obtenerResumen(prefs.getString('idEmpresa'),
        prefs.getString('idUsuario'), prefs.getString('token'));
    _isLoading = true;
    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        setState(() {
          _isLoading = false;

          razonSocial = child["informacionEmpresa"]["razonSocial"];
          totalIngresos =
              child["informacionEmpresa"]["totalIngresos"].toString();
          totalGastos = child["informacionEmpresa"]["totalGastos"].toString();
          documentosDisponibles =
              child["informacionEmpresa"]["documentosDisponibles"].toString();
          documentosUtilizados =
              child["informacionEmpresa"]["documentosUtilizados"].toString();

          prefs.setString('totalDisponible',
              child["informacionEmpresa"]["documentosDisponibles"]);

          prefs.setString('totalUsado',
              child["informacionEmpresa"]["documentosUtilizados"]);

          imagen = child["informacionEmpresa"]["imgEmpresa"].toString();

          tipoPlan = child["informacionEmpresa"]["tipoPlan"].toString();
          asistencia =
              child["informacionEmpresa"]["telefonoAsistencia"].toString();
          prefs.setString(
              'nombreUsuario', child["informacionEmpresa"]["nombreUsuario"]);
          prefs.setString(
              'cedulaUsuario', child["informacionEmpresa"]["aliasUsuario"]);
          prefs.setString(
              'emailUsuario', child["informacionEmpresa"]["emailUsuario"]);
          prefs.setString(
              'passUsuario', child["informacionEmpresa"]["password"]);
          prefs.setString(
              'pinUsuario',
              child["informacionEmpresa"]["pin"]?.isEmpty ?? true
                  ? ""
                  : child["informacionEmpresa"]["pin"]);
          prefs.setString('origen', child["informacionEmpresa"]["origenPlan"]);
          prefs.setString(
              'asistencia',
              child["informacionEmpresa"]["telefonoAsistencia"]?.isEmpty ?? true
                  ? ""
                  : child["informacionEmpresa"]["telefonoAsistencia"]);
          prefs.setString('transportista',
              child["informacionEmpresa"]["datosTransportista"]);

          numeroEmpresa =
              "${child["informacionEmpresa"]["idCreadorEmpresa"]}-${child["informacionEmpresa"]["idEmpresa"]}";
        });
      }
    });
    setState(() {});
  }

  /* -------------------------------------------------------------------------- */
  /*                                   ANUNCIO                                  */
  /* -------------------------------------------------------------------------- */
  anuncio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future<dynamic> resp = empresa.anucios(prefs.getString('token'));
    _isLoading = true;
    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["operacion"]) {
          setState(() {
            _isLoading = false;

            titulo = child["datos"][0]["TITULO"].toString();
            descripcion = child["datos"][0]["DESCRIPCION"].toString();
          });
        } else {
          _isLoading = false;
          titulo = "";
          descripcion = "";
        }
      }
    });
    setState(() {});
  }

  /* -------------------------------------------------------------------------- */
  /*                           ACTUALIZAR IMAGEN DATA                           */
  /* -------------------------------------------------------------------------- */
  actualizarImagen() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final registro = await usuarios.uploadImg(
        imagen1, prefs.getString('token'), prefs.getString('idEmpresa'));
    registro.stream.transform(utf8.decoder).listen((value) {
      final List<dynamic> json = jsonDecode("[$value]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["status"]) {
          setState(() {
            _isLoading = false;
            imagen1 = null;
            logoEmpresa = 'Presione aqui para subir imagen';
          });

          setState(() {
            message.showToast(child["msg"]);
            Navigator.pop(context);
            resumen();
          });
        } else {
          setState(() {
            _isLoading = false;
            message.showToast(value);
          });
        }
      }
    });
  }
}

// ignore: must_be_immutable
class Traveler extends StatefulWidget {
  User user;

  Traveler({Key? key, required this.user}) : super(key: key);

  @override
  State<Traveler> createState() => _TravelerState();
}

class _TravelerState extends State<Traveler> {
  final _usuario = UsuarioProvider();
  final message = ToastMessage();
  /* -------------------------------------------------------------------------- */
  /*                                ONBACK PRESED                               */
  /* -------------------------------------------------------------------------- */
  Future<bool> _modalEliminarCuenta() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          '¿Está seguro que desea eliminar su cuenta?',
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
                onTap: () => eliminarCuenta(),
                child: roundedButton("  Si  ", color, color),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  /* -------------------------------------------------------------------------- */
  /*                          SALIR APP Y BORRAR CAMPOS                         */
  /* -------------------------------------------------------------------------- */
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

  eliminarCuenta() async {
    message.showToast('Procesando por favor espere...');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Future<dynamic> resp = _usuario.eliminarCuenta(
        prefs.getString('idUsuario'), prefs.getString('token'));

    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);

      for (var child in json2) {
        if (child["status"]) {
          message.showToast(child["msg"]);
          Navigator.pop(context);
          salirApp();
        } else {
          message.showToast(child["msg"]);
        }
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.user.acction != 'eliminar'
          ? Navigator.pushNamed(context, widget.user.acction!)
          : _modalEliminarCuenta(),
      child: Container(
        height: 100,
        width: 100,
        margin: const EdgeInsets.fromLTRB(2, 5, 10, 10),
        padding: const EdgeInsets.all(5),
        decoration: kCardDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(widget.user.image!),
              backgroundColor: Colors.white,
            ),
            Text(
              widget.user.name!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PointOfInterest extends StatelessWidget {
  Location location;

  PointOfInterest({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = 130;

    List<SmallProfileAvatar> profiles = [];
    location.users!.asMap().forEach((index, user) {
      profiles.add(SmallProfileAvatar(
        left: (10 + index * 25).toDouble(),
        user: user,
      ));
    });

    return Container(
      margin: const EdgeInsets.fromLTRB(2, 5, 10, 10),
      height: 180,
      width: cardWidth,
      decoration: kCardDecoration,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: cardWidth,
            height: 80,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                location.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            location.name!,
            style: kSmallCardTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: const BorderSide(color: Colors.white),
                    )),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, location.pagina!);
                  },
                  child: Text(
                    location.accion!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SmallProfileAvatar extends StatelessWidget {
  double left;
  User user;

  SmallProfileAvatar({Key? key, required this.left, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: CircleAvatar(
          backgroundImage: AssetImage(user.image!),
        ),
      ),
    );
  }
}
