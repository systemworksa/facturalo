import 'dart:convert';
import 'package:facturaloapp2025/common/colorExadecimal.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/models/establecimientos/establecimientos_model.dart';
import 'package:facturaloapp2025/providers/establecimientos/establecimientos_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListarEstablecimientosPage extends StatefulWidget {
  const ListarEstablecimientosPage({Key? key}) : super(key: key);

  @override
  State<ListarEstablecimientosPage> createState() => _ListarEstablecimientosPageState();
}

class _ListarEstablecimientosPageState extends State<ListarEstablecimientosPage> {
  final establecimientos = EstablecimientoProvider();
  List<Establecimiento> establecimientosItem = [];
  List<Establecimiento> establecimientosItemSearch = [];
  final TextEditingController _inputFieldBuscador = TextEditingController();
  // ignore: unused_field
  bool _isLoading = false;
  final Color color = HexColor.fromHex('#262f69');
  final load = Load();
  final message = ToastMessage();

  @override
  void initState() {
    super.initState();
    getEstablecimientos();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Establecimientos'),
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'home');
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'crear-establecimientos'),
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
                  getEstablecimientos();
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
                child: establecimientosItemSearch
                        .isNotEmpty //|| controller.text.isNotEmpty
                    ? ListView.builder(
                        itemCount: establecimientosItemSearch.length,
                        itemBuilder: (context, i) =>
                            _band(establecimientosItemSearch[i]))
                    : ListView.builder(
                        itemCount: establecimientosItem.length,
                        itemBuilder: (context, i) => _band(establecimientosItem[i]))),
          ],
        ),
      ),
    );
  }

  _band(Establecimiento band) {
  
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: ListTile(
          leading: 

         CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(band.imagen!)..resolve(ImageConfiguration.empty).addListener(
              ImageStreamListener(
                (info, call) {
                  // La imagen se cargó correctamente
                },
                onError: (exception, stackTrace) {
                  // Ocurrió un error al cargar la imagen, muestra una imagen predeterminada
                  setState(() {
                    band.imagen = 'https://facturalo.com.ec/sistema/vistas/img/usuarios/default/empresa.png';
                  });
                },
              ),
            ),
          ),


          title: Text(
            band.nombre ?? '',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Text(
                'DIRECCIÓN:',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    color: Colors.grey, 
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Text(
                band.direccion ?? '',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    color: Colors.black, 
                    fontSize: 14.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'SIGUIENTE FACTURA:',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Text(
                band.secuencialComprobante ?? '',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              IconButton(                
                onPressed: () {
                      Navigator.pushNamed(context, 'editar-establecimientos',
                      arguments: band);
                    },
                icon: const Icon(
                  Icons.edit_rounded,
                  color: Colors.orange,
                  size: 30.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  modalEliminarEstablecimiento(band.id);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  /* -------------------------------------------------------------------------- */
  /*                              OBTENER PRODUCTOS                             */
  /* -------------------------------------------------------------------------- */
  getEstablecimientos() async {
    setState(() {
      _isLoading = true;
      establecimientosItem.clear();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final puntoemision = prefs.getString('idPuntoEmision')??0;
    
    final data = await establecimientos.getEstablecimientos(prefs.getString('token'), prefs.getString('idEmpresa'), puntoemision);
          
    setState(() {
      setState(() {
        establecimientosItem = data;
        _isLoading = false;
      });
    });
  }

  onSearch(String text) async {
    establecimientosItemSearch.clear();
    if (text.isEmpty) {
      return;
    }

    setState(() {

      for (var servicioDetail in establecimientosItem) {
        String codigo = servicioDetail.id?.toString() ?? '';
        String nombre = servicioDetail.nombre?.toString() ?? '';
        String direccion = servicioDetail.direccion?.toString() ?? '';
        String secuencialElectronico = servicioDetail.secuencialElectronico?.toString() ?? '';
        String secuencialFisico = servicioDetail.secuencialFisico?.toString() ?? '';
        String estado = servicioDetail.estado?.toString() ?? '';
        String limiteFactura = servicioDetail.limiteFactura?.toString() ?? '';

        if (codigo.toUpperCase().contains(text.toUpperCase()) ||
            nombre.toUpperCase().contains(text.toUpperCase()) ||
            direccion.toUpperCase().contains(text.toUpperCase()) ||
            secuencialElectronico.toUpperCase().contains(text.toUpperCase()) ||
            secuencialFisico.toUpperCase().contains(text.toUpperCase()) ||
            estado.toUpperCase().contains(text.toUpperCase()) ||
            limiteFactura.toUpperCase().contains(text.toUpperCase())) {
          establecimientosItemSearch.add(servicioDetail);
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
  /*                           MODAL ELIMINAR ESTABLECIMIENTO                   */
  /* -------------------------------------------------------------------------- */

  Future<bool> modalEliminarEstablecimiento(idEstablecimiento) {
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
                
                onTap: () => eliminarEstablecimiento(idEstablecimiento),
                child: roundedButton("  Si  ", color, color),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  eliminarEstablecimiento(idEstablecimiento) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    establecimientos.eliminarEstablecimiento(idEstablecimiento,prefs.getString('idEmpresa'), prefs.getString('token'))
    .then((value) {

      final List<dynamic> json = jsonDecode("[$value]");         
          final List<dynamic> json2 = List.from(json);
          for (var child in json2) {
            if (child["status"]) {
              message.showToast('Actualizado correctamente.');

              setState(() {
                _isLoading = false;
                Navigator.pop(context);
                getEstablecimientos();
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
