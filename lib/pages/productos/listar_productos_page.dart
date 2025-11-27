import 'dart:convert';

import 'package:facturaloapp2025/common/colorExadecimal.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/models/inventario/productos_model.dart';
import 'package:facturaloapp2025/providers/inventario/productos_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';

class ListarProductosPage extends StatefulWidget {
  const ListarProductosPage({Key? key}) : super(key: key);

  @override
  State<ListarProductosPage> createState() => _ListarProductosPageState();
}

class _ListarProductosPageState extends State<ListarProductosPage> {
  final productos = ProductoProvider();
  List<Producto> productosItem = [];
  List<Producto> productosItemSearch = [];
  final TextEditingController _inputFieldBuscador = TextEditingController();
  // ignore: unused_field
  bool _isLoading = false;
  final Color color = HexColor.fromHex('#262f69');
  final load = Load();
  final message = ToastMessage();
 //  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
 // InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    super.initState();
    getProductos();
  //  _internetDialog = InternetDialog(context);
   // _connectivitySubscription =
   // _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Productos / Servicios',
            style: TextStyle(fontSize: 14.0),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'home');
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'crear-producto'),
              child: Row(
                children: const [
                  Icon(Icons.add_circle_outline),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text('Nuevo'),
                  SizedBox(
                    width: 7.0,
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  getProductos();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                  controller: _inputFieldBuscador,
                  onChanged: (value) {
                    //recargar();
                    setState(() {
                      onSearch(value);
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Buscar', border: InputBorder.none),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    _inputFieldBuscador.clear();
                    //recargar();
                  },
                ),
              ),
            ),
            _isLoading ? load.loading() : Container(),
            Expanded(
                flex: 1,
                child: productosItemSearch
                        .isNotEmpty //|| controller.text.isNotEmpty
                    ? ListView.builder(
                        itemCount: productosItemSearch.length,
                        itemBuilder: (context, i) =>
                            _band(productosItemSearch[i]))
                    : ListView.builder(
                        itemCount: productosItem.length,
                        itemBuilder: (context, i) => _band(productosItem[i]))),
          ],
        ),
      ),
    );
  }

  _band(Producto band) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 12.0),
              Column(
                children: [
                  SizedBox(
                    width: 80.0,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipOval(
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: 'assets/img/logoAmarillo.png',
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/img/logoAmarillo.png');
                          },
                          image: band.imagen!,
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text('ACCIONES',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ))),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16.0,
                        backgroundColor: Colors.red,
                        child: IconButton(
                            onPressed: () {
                              modalEliminarProducto(band.idProducto);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 15.0,
                            )),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      CircleAvatar(
                        radius: 16.0,
                        backgroundColor: Colors.orange,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'editar-producto',
                                  arguments: band);
                            },
                            icon: const Icon(
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 15.0,
                            )),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    Text('CÓDIGO',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ))),
                    Text(band.codigo!,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ))),
                    const SizedBox(height: 10.0),
                    Text('NOMBRE',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ))),
                    Text(band.nombre!.toUpperCase(),
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ))),
                    const SizedBox(height: 10.0),
                    Text('COSTO',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ))),
                    Text(band.costo == "" ? " - " : band.costo!,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ))),
                    const SizedBox(height: 10.0),
                    Text('PRECIO VENTA',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ))),
                    Text(band.precio == "" ? " - " : band.precio!,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ))),
                    const SizedBox(height: 10.0),
                    Text('FECHA REGISTRO',
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ))),
                    Text(band.fechaRegistro!,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ))),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                              OBTENER PRODUCTOS                             */
  /* -------------------------------------------------------------------------- */
  getProductos() async {
    setState(() {
      _isLoading = true;
      productosItem.clear();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await productos.getProductos(
        prefs.getString('token'), prefs.getString('idEmpresa'));
    setState(() {
      setState(() {
        productosItem = data;
        _isLoading = false;
      });
    });
  }

  onSearch(String text) async {
    productosItemSearch.clear();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      for (var servicioDetail in productosItem) {
        String codigo = '';
        String nombre = '';
        String costo = '';
        String precioP = '';
        String fechaRegistro = '';

        if (servicioDetail.codigo?.isEmpty ?? true) {
        } else {
          codigo = servicioDetail.codigo.toString();
        }

        if (servicioDetail.nombre?.isEmpty ?? true) {
        } else {
          nombre = servicioDetail.nombre.toString();
        }

        if (servicioDetail.costo?.isEmpty ?? true) {
        } else {
          costo = servicioDetail.costo.toString();
        }

        if (servicioDetail.precio?.isEmpty ?? true) {
        } else {
          precioP = servicioDetail.precio.toString();
        }

        if (servicioDetail.fechaRegistro?.isEmpty ?? true) {
        } else {
          fechaRegistro = servicioDetail.fechaRegistro.toString();
        }

        if (codigo.toUpperCase().contains(text.toUpperCase()) ||
            nombre.toUpperCase().contains(text.toUpperCase()) ||
            costo.toUpperCase().contains(text.toUpperCase()) ||
            precioP.toUpperCase().contains(text.toUpperCase()) ||
            fechaRegistro.toUpperCase().contains(text.toUpperCase())) {
          productosItemSearch.add(servicioDetail);
        }
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Está seguro que desea volver a la página de inicio?',
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

  /* -------------------------------------------------------------------------- */
  /*                           MODAL ELIMINAR PRODUCTO                          */
  /* -------------------------------------------------------------------------- */

  Future<bool> modalEliminarProducto(idProducto) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Está seguro que desea eliminar este item?',
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
                onTap: () => eliminarProducto(idProducto),
                child: roundedButton("  Si  ", color, color),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  /* -------------------------------------------------------------------------- */
  /*                        ELIMINAR PRODUCTO / SERVICIO                        */
  /* -------------------------------------------------------------------------- */
  eliminarProducto(idProducto) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Future<dynamic> resp =
        productos.eliminarProducto(idProducto, prefs.getString('token'));

    resp.then((id) {
      final List<dynamic> json = jsonDecode("[$id]");
      // Create a copy of json
      final List<dynamic> json2 = List.from(json);
      for (var child in json2) {
        if (child["status"]) {
          message.showToast('Eliminado correctamente.');

          setState(() {
            _isLoading = false;
            Navigator.pop(context);

            getProductos();
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
}
