// ignore_for_file: file_names

import 'package:flutter/services.dart';

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text,
      selection: newValue.selection,
    );
  }
}
