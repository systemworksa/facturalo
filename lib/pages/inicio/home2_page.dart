import 'dart:convert';
import 'dart:io';

import 'package:facturaloapp2025/common/colorExadecimal.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/providers/personas/empresa_provider.dart';
import 'package:facturaloapp2025/providers/personas/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
  // ignore: unused_field
  bool _isLoading = false;
  File? imagen1;
  String logoEmpresa = 'Presione aqui para subir imagen';
  final usuarios = UsuarioProvider();
  final Color color = HexColor.fromHex('#262f69');
  String titulo = "";
  String descripcion = "";
  String numeroEmpresa = "";
  int _currentIndex = 0;
  String nombrePlan = "";
  String mensajeLimitePlan = "";
  String fechaInicioPlan = "";
  String estadoPlan = "";
  final _usuario = UsuarioProvider();

  List<TarjetaInfo> tarjetas = [
    TarjetaInfo(
      imagen: 'ruta_imagen_1.png', // Ruta de la imagen para la tarjeta 1
      texto: 'Texto Tarjeta 1',
    ),
    TarjetaInfo(
      imagen: 'ruta_imagen_2.png', // Ruta de la imagen para la tarjeta 2
      texto: 'Texto Tarjeta 2',
    ),
    TarjetaInfo(
      imagen: 'ruta_imagen_3.png', // Ruta de la imagen para la tarjeta 3
      texto: 'Texto Tarjeta 3',
    ),
  ];
  double width = 0;
  //StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //InternetDialog? _internetDialog;
  //final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    resumen();
    anuncio();
  //  _internetDialog = InternetDialog(context);
  //  _connectivitySubscription = _connectivity.onConnectivityChanged
   //     .listen(_internetDialog!.updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false, // Elimina el botón de regresar
          title: Row(
            children: [
              // Logo en el extremo izquierdo
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(
                  'assets/img/HORIZONTALOSCURO@3x.png',
                  height: 100,
                  width: 150,
                ),
              ),
              const Spacer(), // Espaciado flexible
              // Iconos en el extremo derecho
              Row(
                children: [
                  Text(
                    numeroEmpresa,
                    style: TextStyle(
                        color: color,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    color: Colors.black,
                    onPressed: () {
                      resumen();
                      anuncio();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    color: Colors.black,
                    onPressed: () {
                      _onBackPressed();
                    },
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _mostrarModalImagen();
                        },
                        child: SizedBox(
                          width: 28,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle, // Esta es la clave para hacer que el borde sea circular
                                border: Border.all(
                                  color:
                                      color, // Cambia esto a tu color deseado
                                  width:
                                      0.5, // Cambia esto para ajustar el ancho del borde
                                ),
                              ),
                              child: ClipOval(
                                // ignore: unnecessary_null_comparison
                                child: imagen == null
                                    ? Image.asset('assets/img/logoAmarillo.png')
                                    : FadeInImage.assetNetwork(
                                        fit: BoxFit.cover,
                                        placeholder:
                                            'assets/img/logoAmarillo.png',
                                        image: imagen,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/img/logoAmarillo.png');
                                        },
                                        width: 31.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: color,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 1) {
                Navigator.pushNamed(context, 'editar-empresa');
              }
              if (_currentIndex == 2) {
                Navigator.pushNamed(context, 'perfil');
              }
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Mi Empresa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0), // Ajusta los márgenes aquí
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Cambia el color de fondo de la sección
                  borderRadius:
                      BorderRadius.circular(10.0), // Bordes redondeados
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20.0, // Altura de la franja de color azul
                      width: double.infinity, // Ocupa todo el ancho
                      decoration: BoxDecoration(
                        color: color, // Color de la franja
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                              10.0), // Borde redondeado superior izquierdo
                          topRight: Radius.circular(
                              10.0), // Borde redondeado superior derecho
                        ),
                      ),
                      child: Center(
                        child: Text(
                          titulo,
                          style: const TextStyle(
                            color: Colors.white, // Color del texto
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        textAlign: TextAlign.justify,
                        descripcion,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  color: Colors.white, // Cambia el color de fondo de la sección
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombrePlan,
                          style: TextStyle(
                              color: color,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          razonSocial,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12.5),
                        ),
                        fechaInicioPlan == ""
                            ? Container()
                            : Text(
                                "Inició el $fechaInicioPlan",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12.5),
                              ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        FractionallySizedBox(
                          widthFactor: 1.0, // Ancho fraccional del 100%
                          child: Card(
                            elevation:
                                4.0, // Elevación para el efecto de sombra
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Bordes redondeados
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Detalles del Plan.',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: estadoPlan == "Activo" ||
                                                    estadoPlan == "ACTIVO"
                                                ? Colors.green
                                                : Colors.red,
                                            size: 12.0,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            estadoPlan,
                                            style: TextStyle(
                                              color: estadoPlan == "Activo" ||
                                                      estadoPlan == "ACTIVO"
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      height:
                                          8.0), // Espaciado entre el indicador y la fecha
                                  mensajeLimitePlan == ""
                                      ? Container()
                                      : Text(
                                          mensajeLimitePlan, // Cambia la fecha según tus necesidades
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Documentos Utilizados.',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '$documentosUtilizados/$documentosDisponibles',
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'Soporte ADM / Contador.',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            asistencia,
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  )

                                  // Agrega más detalles aquí
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          '¿Que deseas realizar?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: color),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Primera tarjeta
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'crear-factura');
                              },
                              child: Card(
                                elevation:
                                    4.0, // Elevación para el efecto de sombra
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bordes redondeados
                                ),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width) /
                                      3.5, // Ancho de la tarjeta
                                  height: 120, // Altura de la tarjeta
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/img/factura-icon1.png',
                                        width: 60.0,
                                      ), // Icono para la tarjeta 1
                                      const SizedBox(
                                          height:
                                              8.0), // Espacio entre el icono y el texto
                                      const Text(
                                        'Crear Factura',
                                        style: TextStyle(
                                          color: Color(
                                              0xFF262F69), // Color del texto
                                        ),
                                      ), // Texto para la tarjeta 1
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Segunda tarjeta
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, 'listar-documentos');
                              },
                              child: Card(
                                elevation:
                                    4.0, // Elevación para el efecto de sombra
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bordes redondeados
                                ),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width) /
                                      3.5, // Ancho de la tarjeta
                                  height: 120, // Altura de la tarjeta
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/img/documento-icon1.png',
                                        width: 60.0,
                                      ), // Icono para la tarjeta 2
                                      const SizedBox(
                                          height:
                                              8.0), // Espacio entre el icono y el texto
                                      const Text(
                                        'Documentos',
                                        style: TextStyle(
                                          color: Color(
                                              0xFF262F69), // Color del texto
                                        ),
                                      ), // Texto para la tarjeta 2
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Tercera tarjeta
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'listar-clientes');
                              },
                              child: Card(
                                elevation:
                                    4.0, // Elevación para el efecto de sombra
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bordes redondeados
                                ),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width) /
                                      3.5, // Ancho de la tarjeta
                                  height: 120, // Altura de la tarjeta
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/img/clientes-icon1.png',
                                        width: 50.0,
                                      ), // Icono para la tarjeta 3
                                      const SizedBox(
                                          height:
                                              15.0), // Espacio entre el icono y el texto
                                      const Text(
                                        'Ver Clientes',
                                        style: TextStyle(
                                          color: Color(
                                              0xFF262F69), // Color del texto
                                        ),
                                      ), // Texto para la tarjeta 3
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Primera tarjeta
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, 'listar-productos');
                              },
                              child: Card(
                                elevation:
                                    4.0, // Elevación para el efecto de sombra
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bordes redondeados
                                ),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width) /
                                      3.5, // Ancho de la tarjeta
                                  height: 120, // Altura de la tarjeta
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/img/producto-icon1.png',
                                        width: 50.0,
                                      ), // Icono para la tarjeta 1
                                      const SizedBox(
                                          height:
                                              15.0), // Espacio entre el icono y el texto
                                      const Text(
                                        'Ver Productos',
                                        style: TextStyle(
                                          color: Color(
                                              0xFF262F69), // Color del texto
                                        ),
                                      ), // Texto para la tarjeta 1
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Segunda tarjeta
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, 'listar-establecimientos');
                              },
                              child: Card(
                                elevation:
                                    4.0, // Elevación para el efecto de sombra
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bordes redondeados
                                ),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width) /
                                      3.5, // Ancho de la tarjeta
                                  height: 120, // Altura de la tarjeta
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/img/emision-icon1.png',
                                        width: 50.0,
                                      ), // Icono para la tarjeta 2
                                      const SizedBox(
                                          height:
                                              15.0), // Espacio entre el icono y el texto
                                      const Text(
                                        'Puntos Emision',
                                        style: TextStyle(
                                          color: Color(
                                              0xFF262F69), // Color del texto
                                        ),
                                      ), // Texto para la tarjeta 2
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Tercera tarjeta
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'info');
                              },
                              child: Card(
                                elevation:
                                    4.0, // Elevación para el efecto de sombra
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bordes redondeados
                                ),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width) /
                                      3.5, // Ancho de la tarjeta
                                  height: 120, // Altura de la tarjeta
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/img/info-icon1.png',
                                        width: 50.0,
                                      ), // Icono para la tarjeta 3
                                      const SizedBox(
                                          height:
                                              15.0), // Espacio entre el icono y el texto
                                      const Text(
                                        'Información',
                                        style: TextStyle(
                                          color: Color(
                                              0xFF262F69), // Color del texto
                                        ),
                                      ), // Texto para la tarjeta 3
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _modalEliminarCuenta();
                              },
                              child: Card(
                                elevation:
                                    4.0, // Elevación para el efecto de sombra
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Bordes redondeados
                                ),
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width) /
                                      3.5, // Ancho de la tarjeta
                                  height: 120, // Altura de la tarjeta
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/img/eliminar-icon1.png',
                                        width: 50.0,
                                      ), // Icono para la tarjeta 2
                                      const SizedBox(
                                          height:
                                              15.0), // Espacio entre el icono y el texto
                                      const Text(
                                        'Eliminar cuenta',
                                        style: TextStyle(
                                          color: Color(
                                              0xFF262F69), // Color del texto
                                        ),
                                      ), // Texto para la tarjeta 2
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                RESUMEN HOME                                */
  /* -------------------------------------------------------------------------- */
  resumen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loadPopup(context);
    Future<dynamic> resp = empresa.obtenerResumen(prefs.getString('idEmpresa'),
        prefs.getString('idUsuario'), prefs.getString('token'));
    _isLoading = true;
    resp.then((id) {
      print(id);
      Navigator.pop(context);
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        print(child);
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

          estadoPlan =
              child["informacionEmpresa"]["estadoPlan"]?.isEmpty ?? true
                  ? 'Activo'
                  : child["informacionEmpresa"]["estadoPlan"];
          prefs.setString('totalDisponible',
              child["informacionEmpresa"]["documentosDisponibles"]);

          prefs.setString('totalUsado',
              child["informacionEmpresa"]["documentosUtilizados"]);

          imagen = child["informacionEmpresa"]["imgEmpresa"].toString();

          tipoPlan = child["informacionEmpresa"]["tipoPlan"].toString();

          nombrePlan =
              child["informacionEmpresa"]["nombrePlan"]?.isEmpty ?? true
                  ? 'PLAN NORMAL'
                  : child["informacionEmpresa"]["nombrePlan"];
          mensajeLimitePlan =
              child["informacionEmpresa"]["mensajeLimitePlan"]?.isEmpty ?? true
                  ? ''
                  : child["informacionEmpresa"]["mensajeLimitePlan"];
          fechaInicioPlan =
              child["informacionEmpresa"]["fechaInicioPlan"]?.isEmpty ?? true
                  ? ''
                  : child["informacionEmpresa"]["fechaInicioPlan"];
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

  anuncio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loadPopup(context);
    Future<dynamic> resp = empresa.anucios(prefs.getString('token'));
    _isLoading = true;
    resp.then((id) {
      print(id);
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        Navigator.pop(context);
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

  void _loadPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Para que se ajuste al contenido
            children: [
              Image.asset(
                'assets/img/load1.gif',
                width: 50.0,
                height: 50.0,
              ),
              const SizedBox(height: 7), // Espacio entre imagen y texto
              const Text(
                'Cargando...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
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
}

class TarjetaInfo {
  final String imagen;
  final String texto;

  TarjetaInfo({required this.imagen, required this.texto});
}


// ...



