import 'package:facturaloapp2025/common/TextInputFormatter.dart';
import 'package:facturaloapp2025/common/normalFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class MyCustomInputBox extends StatefulWidget {
  String? label;
  String? inputHint;
  TextEditingController? inputController;
  bool? formatter = true;
  TextInputType? textInputType;
  int? maxLength;
  bool? allowSpaces;
  MyCustomInputBox(
      {Key? key,
      this.label,
      this.inputHint,
      this.inputController,
      this.formatter,
      this.textInputType,
      this.maxLength,
      this.allowSpaces})
      : super(key: key);
  @override
  _MyCustomInputBoxState createState() => _MyCustomInputBoxState();
}

class _MyCustomInputBoxState extends State<MyCustomInputBox> {
  bool isSubmitted = false;
  final checkBoxIcon = 'assets/svg/checkbox.svg';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, bottom: 8),
            child: Text(
              widget.label!,
              style: const TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        //
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 30, 22),
          child: TextFormField(
            controller: widget.inputController,
            obscureText: widget.label == 'Clave' ||
                    widget.label == 'Ingrese su nueva clave' ||
                    widget.label == 'Clave (Acceder a la app posteriormente)' ||
                    widget.label ==
                        'Clave (Acceder a la app posteriormente).\nPor motivos de seguridad no mostramos la clave' ||
                    widget.label ==
                        'Ingrese un Pin de 4 digitos.\nPor motivos de seguridad no mostramos su pin' ||
                    widget.label == 'Repita su nueva clave'
                ? true
                : false,
            keyboardType: widget.textInputType,

            // this can be changed based on usage -
            // such as - onChanged or onFieldSubmitted
            onChanged: (value) {
              setState(() {
                isSubmitted = true;
              });
            },
            style: const TextStyle(fontSize: 14, color: Colors.black),
            inputFormatters: [
              widget.formatter!
                  ? UpperCaseTextFormatter()
                  : LowerCaseTextFormatter(),
            ],
            decoration: InputDecoration(
              hintText: widget.inputHint,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[350],
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              focusColor: const Color(0xff0962ff),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xff0962ff)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.grey[350]!,
                ),
              ),
              suffixIcon: widget.inputController!.text != ""
                  // will turn the visibility of the 'checkbox' icon
                  // ON or OFF based on the condition we set before
                  ? Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: SvgPicture.asset(
                          checkBoxIcon,
                          height: 0.2,
                        ),
                      ),
                    )
                  : Visibility(
                      visible: false,
                      child: SvgPicture.asset(
                        checkBoxIcon,
                        color: Colors.green,
                      ),
                    ),
            ),
            maxLength: widget.maxLength,
            validator: (value) {
              if (value!.contains(' ') && widget.allowSpaces == false) {
                return 'No se permiten espacios';
              }
              return null;
            },// Agrega el parámetro maxLength
          ),
        ),
        //
      ],
    );
  }
}
