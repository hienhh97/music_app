import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final songName = TextEditingController();
  final singer = TextEditingController();
  final songAuthor = TextEditingController();
  PlatformFile? pickedImageFile, pickedSongFile;
  var songUrlDownload, imageUrlDownload;

  Future upLoadImage() async {
    final imgpath = 'images/${pickedImageFile!.name}';
    final imgFile = File(pickedImageFile!.path!);
    Reference ref = FirebaseStorage.instance.ref().child(imgpath);
    UploadTask uploadTask = ref.putFile(imgFile);
    final snapshot = await uploadTask.whenComplete(() {});
    imageUrlDownload = await snapshot.ref.getDownloadURL();
    print('Download link: ${imageUrlDownload}');
  }

  Future uploadSong() async {
    final songpath = 'songs/${pickedSongFile!.name}';
    final songFile = File(pickedSongFile!.path!);
    Reference ref = FirebaseStorage.instance.ref().child(songpath);
    UploadTask uploadTask = ref.putFile(songFile);
    final snapshot = await uploadTask.whenComplete(() {});
    songUrlDownload = await snapshot.ref.getDownloadURL();
    print('Download link: ${songUrlDownload}');
  }

  void selectImage() async {
    FilePickerResult? img =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (img != null) {
      File imageFile = File(img.files.single.path!);
    } else {}

    setState(() {
      img = img;
      pickedImageFile = img!.files.first;
      upLoadImage();
    });
  }

  void selectSong() async {
    FilePickerResult? song = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (song != null) {
      File songFile = File(song.files.single.path!);
    } else {}

    setState(() {
      song = song;
      pickedSongFile = song!.files.first;
      uploadSong();
    });
  }

  submitData(context) {
    if (songName.text != '' &&
        songUrlDownload != null &&
        imageUrlDownload != null) {
      print(songName.text);
      print(singer.text);
      print(songAuthor.text);
      print(songUrlDownload.toString());
      print(imageUrlDownload.toString());

      var data = {
        "songName": songName.text,
        "singer": singer.text,
        "songAuthor": songAuthor.text,
        "songUrl": songUrlDownload.toString(),
        "imageUrl": imageUrlDownload.toString(),
      };

      FirebaseFirestore.instance
          .collection("songs")
          .doc()
          .set(data)
          .whenComplete(() => showDialog(
                context: context,
                builder: (context) =>
                    _onTapButton(context, "File uploaded successfully!"),
              ));
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            _onTapButton(context, "Please Enter All Details!"),
      );
    }
  }

  _onTapButton(BuildContext context, data) {
    return AlertDialog(title: Text(data));
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
            if (pickedImageFile != null)
              Expanded(
                child: Container(
                  color: Colors.blue[100],
                  child: Center(
                    child: Image.file(
                      File(pickedImageFile!.path!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            //upload image button
            ElevatedButton(
              onPressed: () => selectImage(),
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
              onPressed: () => selectSong(),
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
              controller: songName,
              decoration:
                  const InputDecoration(hintText: "Enter the song's name"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: singer,
              decoration:
                  const InputDecoration(hintText: "Enter the singer name"),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: songAuthor,
              decoration:
                  const InputDecoration(hintText: "Enter the song's Author"),
            ),
            const SizedBox(
              height: 15,
            ),
            FilledButton(
              onPressed: () => submitData(context),
              child: const Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}
