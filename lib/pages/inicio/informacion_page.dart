import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:facturaloapp2025/common/check_internert.dart';
class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  
 // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
 // InternetDialog ? _internetDialog;
 // final Connectivity _connectivity = Connectivity();
  @override
  void initState() {

    super.initState();
  //  _internetDialog = InternetDialog(context);
  //  _connectivitySubscription =
  //  _connectivity.onConnectivityChanged.listen(_internetDialog!.updateConnectionStatus);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 10), // This
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Text('BAJO LA LICENCIA DE:',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold))),
            const SizedBox(height: 20.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 21.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90.0),
                      child: Image.asset(
                        'assets/img/logoAmarillo.png',
                        width: 70.0,
                      ),
                    ),
                    const SizedBox(width: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('SYSTEMWORK S.A',
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold))),
                        Text('FACTURALO APP.',
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 10.0))),
                        const SizedBox(height: 4.0),
                        Text('TODOS LOS DERECHOS RESERVADOS 2024.',
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 10.0))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemDesarrallodores(item, subItem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 21.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                size: 40.0,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 24.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  subItem,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
