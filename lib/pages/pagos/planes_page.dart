import 'package:facturaloapp2025/common/colorExadecimal.dart';
import 'package:facturaloapp2025/common/loading.dart';
import 'package:facturaloapp2025/common/toast_message.dart';
import 'package:facturaloapp2025/models/transacciones/planes_model.dart';
import 'package:facturaloapp2025/providers/transacciones/planes_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:bs_flutter_alert/bs_flutter_alert.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanesPage extends StatefulWidget {
  const PlanesPage({Key? key}) : super(key: key);

  @override
  State<PlanesPage> createState() => _PlanesPageState();
}

class _PlanesPageState extends State<PlanesPage> {
  List<Plan> planesItem = [];
  final Color color = HexColor.fromHex('#262f69');
  // ignore: unused_field
  bool _isLoading = false;
  final planesProvider = PlanesProvider();
  final load = Load();
  final message = ToastMessage();

  @override
  void initState() {
    super.initState();
    getPlanes();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Planes Facturación E.'),
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'home');
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Column(
          children: [
            /*const BsAlert(
              closeButton: false,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                  textAlign: TextAlign.justify,
                  'No olvides que al comprar un block de Facturas electrónicas recibes el doble de documentos por la compra de uno de estos planes con promoción temporal.'),
            ),*/
            _isLoading ? Center(child: load.loading()) : Container(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: planesItem.length,
                itemBuilder: (_, index) => _bandTile(planesItem[index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bandTile(Plan band, int index) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      width: 312.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: 'assets/img/load1.gif',
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/img/logoAmarillo.png');
            },
            image: band.imagen!,
            width: 312,
            height: 400.0,
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.getString('totalDisponible') !=
                  prefs.getString('totalUsado')) {
                message.showToast(
                    'Estimado usuario aún tiene documentos disponibles para usar cuando haya consumidos todos sus documentos podrá recargar nuevamente.');
              } else {
                message.showToast('Procesando un momento...');
                if (prefs.getString('origen') == "movil") {
                  Navigator.pushNamed(context, 'recargar', arguments: band);
                } else {
                  _mensajeWhatsapp(prefs.getString('asistencia')!, band.nombre!,
                      band.descripcion!);
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.payment, color: Colors.green, size: 20.0),
                const SizedBox(
                  width: 10.0,
                ),
                Text('COMPRAR PLAN ${band.nombre}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                              OBTENER PRODUCTOS                             */
  /* -------------------------------------------------------------------------- */
  getPlanes() async {
    setState(() {
      _isLoading = true;
      planesItem.clear();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = await planesProvider.getPlanes(prefs.getString('token')!);

    setState(() {
      planesItem = data;
      _isLoading = false;
    });
  }

  void _mensajeWhatsapp(
      String telefono, String plan, String descripcion) async {
    // add the [https]

    String text =
        "Buen día necesito estimado(a) me comunico para informarle que necesito adquirir un plan *$plan* de *$descripcion*, gracias de antemano.\nPedido realizado de la App Factúralo App.";

    final link = WhatsAppUnilink(
      phoneNumber: "+593${telefono.substring(1)}",
      text: text,
    );

    // ignore: deprecated_member_use
    await launch('$link');
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
}
