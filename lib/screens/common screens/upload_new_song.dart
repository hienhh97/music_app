import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadNewSong extends StatefulWidget {
  const UploadNewSong({super.key});

  @override
  State<UploadNewSong> createState() => _UploadNewSongState();
}

class _UploadNewSongState extends State<UploadNewSong> {
  //text controller
  final songname = TextEditingController();
  final singer = TextEditingController();
  final songartist = TextEditingController();
  String? imgPath;

  void uploadImage() async {
    FilePickerResult? img = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (img != null) {
      File file = File(img.files.single.path!);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload new song'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //upload image button
            ElevatedButton(
              onPressed: () => uploadImage(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Icon(Icons.image),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Select Image'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? musicFile =
                    await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Icon(Icons.music_note),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Select Song from your device'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: songname,
              decoration:
                  const InputDecoration(hintText: "Enter the song's name"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: songname,
              decoration:
                  const InputDecoration(hintText: "Enter the singer name"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: songartist,
              decoration:
                  const InputDecoration(hintText: "Enter the song's artist"),
            ),
            const SizedBox(
              height: 15,
            ),
            FilledButton(
              onPressed: () {},
              child: const Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}
