import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:music_app/models/song.dart';
import '../../widgets/widgets.dart';

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
  File? imageFile, songFile;

  Future upLoadImage() async {
    final imgpath = 'images/${pickedImageFile?.name}';
    final imgFile = File(pickedImageFile!.path!);
    Reference ref = FirebaseStorage.instance.ref().child(imgpath);
    UploadTask uploadTask = ref.putFile(imgFile);
    final snapshot = await uploadTask.whenComplete(() {});
    imageUrlDownload = await snapshot.ref.getDownloadURL();
    print('Download link: ${imageUrlDownload}');
  }

  Future uploadSong() async {
    final songpath = 'songs/${pickedSongFile?.name}';
    final songFile = File(pickedSongFile!.path!);
    Reference ref = FirebaseStorage.instance.ref().child(songpath);
    UploadTask uploadTask = ref.putFile(songFile);
    final snapshot = await uploadTask.whenComplete(() {});
    songUrlDownload = await snapshot.ref.getDownloadURL();
    print('Download link: ${songUrlDownload}');
  }

  void selectImage() async {
    final img = await FilePicker.platform.pickFiles(type: FileType.image);
    if (img != null) {
      setState(() {
        imageFile = File(img.files.single.path!);
        pickedImageFile = img.files.first;
      });
    }
  }

  void selectSong() async {
    final song = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (song != null) {
      setState(() {
        songFile = File(song.files.single.path!);
        pickedSongFile = song.files.first;
      });
    } else {}
  }

  Future uploadData() async {
    await upLoadImage();
    await uploadSong();
  }

  submitData(context) async {
    if (pickedImageFile != null && pickedSongFile != null) {
      uploadData().whenComplete(() async {
        if (songName.text != '' && songAuthor.text != '' && singer.text != '') {
          final docSong = FirebaseFirestore.instance.collection('songs').doc();
          final song = Song(
            id: docSong.id,
            songName: songName.text.trim(),
            singer: singer.text.trim(),
            songAuthor: songAuthor.text.trim(),
            imageUrl: imageUrlDownload.toString(),
            songUrl: songUrlDownload.toString(),
          );
          final json = song.toJson();
          await docSong.set(json).whenComplete(() => showDialog(
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
      });
    }
  }

  _onTapButton(BuildContext context, data) {
    return AlertDialog(title: Text(data));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 26, 89),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Upload new song',
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.6, 0.9],
              colors: [
                Color.fromARGB(0, 111, 18, 119).withOpacity(0.8),
                Color.fromARGB(0, 26, 119, 156),
                Color.fromARGB(0, 170, 95, 9),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                color: Colors.blueGrey[800],
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: 600,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      //Choose song's avatar form device
                      InkWell(
                        onTap: selectImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          color: Colors.white,
                          strokeWidth: 2,
                          padding: const EdgeInsets.all(5),
                          dashPattern: const [15, 8],
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[600],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 4,
                                        color: Colors.white,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 3,
                                            blurRadius: 10,
                                            color:
                                                Colors.white.withOpacity(0.1))
                                      ],
                                    ),
                                    child: (pickedImageFile != null)
                                        ? Image.file(
                                            imageFile!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/no-image.jpg'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          pickedImageFile != null
                                              ? pickedImageFile!.name
                                              : 'No Image file :(',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          pickedImageFile != null
                                              ? '${(pickedImageFile!.size / 1024).ceil()} KB'
                                              : '',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.white38),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //Choose song file from device
                      InkWell(
                        onTap: selectSong,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          color: Colors.white,
                          strokeWidth: 2,
                          padding: const EdgeInsets.all(5),
                          dashPattern: const [15, 8],
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey[600],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      shape: BoxShape.circle,
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/music-disk.png',
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        pickedSongFile != null
                                            ? pickedSongFile!.name
                                            : 'No song file :(',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        pickedSongFile != null
                                            ? '${(pickedSongFile!.size / 1024).ceil()} KB'
                                            : '',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white38),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormFieldCustom(
                          textController: songName,
                          input: "Song's name",
                          preIcon: Icons.abc_outlined),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormFieldCustom(
                          input: "Singer's name",
                          preIcon: Icons.person_2_outlined,
                          textController: singer),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormFieldCustom(
                          textController: songAuthor,
                          input: "Musician",
                          preIcon: Icons.person_2_outlined),
                      const SizedBox(
                        height: 45,
                      ),
                      GestureDetector(
                        onTap: () => submitData(context),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.deepOrange[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Text('Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
