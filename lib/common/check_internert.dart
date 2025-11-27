//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InternetDialog {
  final BuildContext context;
  bool isDialogShown = false;
 // final _connectivity = Connectivity();

  InternetDialog(this.context);


    Future<void> updateConnectionStatus(result) async {
      if (result) {
        if (!isDialogShown) {
          isDialogShown = true;
          _showNoInternetDialog();
        }
      } else {
        if (await hasInternetAccess()) {
          if (isDialogShown) {
            Navigator.of(context).pop();  // Cerrar el cuadro de diálogo
            isDialogShown = false;
          }
        } else {
          if (!isDialogShown) {
            isDialogShown = true;
            _showNoInternetDialog();
          }
        }
      }
    }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,  // Esto previene que el cuadro de diálogo se cierre
          child: AlertDialog(
            title: const Text('Error'),
            content: const Text('No tienes conexión a internet.'),
            actions: [
              TextButton(
                child: const  Text('Reintentar'),
                onPressed: _retryConnection,
              ),
            ],
          ),
        );
      },
    ).then((_) => isDialogShown = false);
  }

  
  Future<void> _retryConnection() async {
   
  }

  Future<bool> hasInternetAccess() async {
  try {
    final response = await http.get(Uri.parse('https://www.google.com'));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (_) {
    return false;
  }
}
}