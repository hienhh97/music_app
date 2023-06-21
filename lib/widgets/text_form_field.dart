import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  TextFormFieldCustom({
    super.key,
    required this.textController,
    required this.input,
    required this.preIcon,
    this.validator,
    this.keyboardType,
    this.errText,
  });

  final TextEditingController textController;
  final String input;
  final IconData preIcon;
  String? errText;
  String? Function(String?)? validator;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: textController,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          errorText: errText,
          label: Text(
            input,
            style: const TextStyle(color: Colors.white),
          ),
          prefixIcon: Icon(
            preIcon,
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white, width: 2.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),
          filled: true),
    );
  }
}
