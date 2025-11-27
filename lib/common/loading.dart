import 'package:flutter/material.dart';

class Load {
  Widget loading() {
    return Column(
      children: [
        Image.asset(
          'assets/img/load1.gif',
          width: 20.0,
          height: 20.0,
        ),
        const Text(
          'Cargando....',
          style: TextStyle(fontSize: 12.0),
        )
      ],
    );
  }
}
