import 'package:facturaloapp2025/providers/personas/cliente_provider.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/personas/clientes_model.dart';

class DataState extends ChangeNotifier {
  bool isLoading = false;
  bool isFetching = false;
  int totalPages = 0;
  int currentPage = 0;
  List<Cliente> items = [];
  List<Cliente> paginado = [];
  final _clientes = ClienteProvider();

  DataState() {
    loadFirstPage('');
  }

  void loadFirstPage(busqueda) async {
    items.clear();
    paginado.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token')?.isEmpty ?? true) {
      items = [];
      return;
    }

    final totalP = await _clientes.getPaginado(
        prefs.getString('token'), prefs.getString("idEmpresa"), 10, busqueda);

    if (totalP != null) {
      paginado = totalP;
      final holidays = await _clientes.getClientes(prefs.getString('token'),
          prefs.getString("idEmpresa"), currentPage, 10, busqueda);

      items = holidays;
    }

    if (paginado.isEmpty) {
      totalPages = 0;
      currentPage = 0;
      isLoading = currentPage < totalPages;

      notifyListeners();
    } else {
      totalPages = int.parse(paginado[0].pagina.toString());

      currentPage = 0;

      isLoading = currentPage < totalPages;

      notifyListeners();
    }
  }

  Future _delay() {
    return Future.delayed(const Duration(seconds: 5));
  }

  void loadNextPage(busqueda) async {
    if (isFetching) {
      return;
    }

    if (currentPage >= totalPages) {
      return;
    }

    isFetching = true;
    currentPage++;
    if (currentPage <= totalPages) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final holidays = await _clientes.getClientes(prefs.getString('token'),
          prefs.getString("idEmpresa"), currentPage, 10, busqueda);

      items.addAll(holidays);
    }
    isLoading = currentPage < totalPages;

    await _delay();

    //print("new page loaded $currentPage");

    isFetching = false;
    notifyListeners();
  }
}
