import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:music_app/api/notification_api.dart';
import 'package:music_app/providers/notification_provider.dart';
import 'package:music_app/providers/store.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class EditAccInfo extends StatefulWidget {
  const EditAccInfo({super.key});

  @override
  State<EditAccInfo> createState() => _EditAccInfoState();
}

class _EditAccInfoState extends State<EditAccInfo> {
  final _db = FirebaseFirestore.instance;

  PlatformFile? pickedImageFile;
  File? imageFile;
  String? imageUrlDownload;

  final String ntfTitle = 'Account info updated';
  final String ntfBody =
      'You have successfully updated your account information!';

  void selectImage() async {
    final img = await FilePicker.platform.pickFiles(type: FileType.image);
    if (img != null) {
      setState(() {
        imageFile = File(img.files.single.path!);
        pickedImageFile = img.files.first;
      });
    }
  }

  void successMessageDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text('Your profile has updated!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            ));
    Navigator.of(context).pop();
  }

  Future upLoadImage() async {
    final imgpath = 'images/${pickedImageFile?.name}';
    final imgFile = File(pickedImageFile!.path!);
    Reference ref = FirebaseStorage.instance.ref().child(imgpath);
    UploadTask uploadTask = ref.putFile(imgFile);
    final snapshot = await uploadTask.whenComplete(() {});
    imageUrlDownload = await snapshot.ref.getDownloadURL();
  }

  @override
  void initState() {
    NotificationAPI.init();
    super.initState();
  }

  final currentUserData = Store.instance.currentUser;

  @override
  void dispose() {
    NotificationAPI.onNotifications.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = TextEditingController(text: currentUserData.firstName);
    final lastName = TextEditingController(text: currentUserData.lastName);
    final age = TextEditingController(text: currentUserData.age.toString());

    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.blueGrey[900],
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Edit account',
            style: TextStyle(color: Colors.white, fontSize: 36),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                //Image and Edit Image button
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Stack(children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Colors.white,
                      ),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 3,
                            blurRadius: 10,
                            color: Colors.white.withOpacity(0.1))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(

                          //User avatar:
                          // **init Avatar** If user has avatar yet,return user's avatar,
                          //            if not: return default avatar
                          // **current Avatar** If user choose an image in device to set Avatar, show that image
                          image: pickedImageFile != null
                              ? FileImage(imageFile!)
                              : (currentUserData.image != null
                                  ? NetworkImage(
                                      currentUserData.image!,
                                    )
                                  : const AssetImage(
                                          "assets/images/user-avatar.png")
                                      as ImageProvider),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: selectImage,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.blue[400],
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 4, color: Colors.white)),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ]),

                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormFieldCustom(
                      textController: firstName,
                      input: 'First name',
                      preIcon: Icons.abc_outlined,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormFieldCustom(
                      textController: lastName,
                      input: 'Last name',
                      preIcon: Icons.abc_outlined,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormFieldCustom(
                      keyboardType: TextInputType.number,
                      textController: age,
                      input: 'Age',
                      preIcon: Icons.numbers_outlined,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (pickedImageFile != null) {
                          upLoadImage().whenComplete(() async {
                            await _db
                                .collection('users')
                                .doc(currentUserData.id)
                                .update({
                              'firstName': firstName.text.trim(),
                              'lastName': lastName.text.trim(),
                              'age': int.parse(age.text.trim()),
                              'image': imageUrlDownload
                            }).whenComplete(() {
                              successMessageDialog();
                              sendNotifi();
                              notificationProvider.sendNtfToFirestore(
                                  ntfTitle, currentUserData.id!, ntfBody);
                            });
                          });
                        } else {
                          await _db
                              .collection('users')
                              .doc(currentUserData.id)
                              .update({
                            'firstName': firstName.text.trim(),
                            'lastName': lastName.text.trim(),
                            'age': int.parse(age.text.trim()),
                          }).whenComplete(() {
                            successMessageDialog();
                            sendNotifi();
                            notificationProvider.sendNtfToFirestore(
                                ntfTitle, currentUserData.id!, ntfBody);
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.deepOrange[800],
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                            child: Text('UPDATE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                            child: Text('CANCEL',
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ))
              ],
            ),
          ),
        )),
      ),
    );
  }

  void sendNotifi() {
    NotificationAPI.showNotification(
      title: ntfTitle,
      body: ntfBody,
    );
  }
}
