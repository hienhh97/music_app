import 'package:flutter/material.dart';

class EditAccInfo extends StatefulWidget {
  const EditAccInfo({super.key});

  @override
  State<EditAccInfo> createState() => _EditAccInfoState();
}

class _EditAccInfoState extends State<EditAccInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
