import 'package:flutter/material.dart';

class TextFormFieldObscureTextCustom extends StatefulWidget {
  const TextFormFieldObscureTextCustom({
    super.key,
    required this.textController,
    required this.input,
  });

  final TextEditingController textController;
  final String input;

  @override
  State<TextFormFieldObscureTextCustom> createState() =>
      _TextFormFieldObscureTextCustomState();
}

class _TextFormFieldObscureTextCustomState
    extends State<TextFormFieldObscureTextCustom> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: widget.textController,
      decoration: InputDecoration(
          label: Text(
            widget.input,
            style: const TextStyle(color: Colors.white),
          ),
          prefixIcon: const Icon(
            Icons.lock_open_outlined,
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
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
          filled: true),
      obscureText: _obscureText,
    );
  }
}
