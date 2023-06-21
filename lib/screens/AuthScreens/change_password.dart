import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/providers/store.dart';
import 'package:music_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../api/notification_api.dart';
import '../../providers/notification_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final password = TextEditingController();
  final newPassword = TextEditingController();
  final newPasswordConfirm = TextEditingController();
  final currUser = FirebaseAuth.instance.currentUser;

  bool correctlyPassword = false;
  String errPasswordMessage = '';
  String errNewPasswordMessage = '';

  final String ntfTitle = 'Changed password';
  final String ntfBody = 'Change password successfully!';

  Future<void> changePassword(String myPassword, String newPassword) async {
    var cred = EmailAuthProvider.credential(
        email: currUser!.email!, password: myPassword);

    await currUser!
        .reauthenticateWithCredential(cred)
        .then((value) => currUser!.updatePassword(newPassword));
  }

  void successDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text('Your password has updated!'),
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

  void failureDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text(
                  'New Password Confirm must be the same as New Password!'),
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

  enterPassword(String myPassword) async {
    var cred = EmailAuthProvider.credential(
        email: currUser!.email!, password: myPassword);

    await currUser!.reauthenticateWithCredential(cred).then((value) {
      setState(() {
        correctlyPassword = true;
      });
    }).catchError((err) {
      setState(() {
        errPasswordMessage = err.toString();
      });
    });
  }

  final currUserData = Store.instance.currentUser;

  bool newPasswordConfirmed() {
    if (newPassword.text.trim() == newPasswordConfirm.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Icon(
                    Icons.lock_open_rounded,
                    size: 120,
                    color: Colors.red[800],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'CHANGE',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  const Text(
                    'PASSWORD',
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AnimatedCrossFade(
                      firstChild: Column(
                        children: [
                          const Text(
                            'Make sure you remember your password!',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormFieldObscureTextCustom(
                              textController: password,
                              input: 'Enter your current password'),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            errPasswordMessage,
                            style: TextStyle(
                                color: Colors.red[100],
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          GestureDetector(
                            onTap: () {
                              enterPassword(password.text);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange[800],
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                  child: Text('SUBMIT',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                      secondChild: Column(
                        children: [
                          Text(
                            'Correctly password! Now enter your new password!',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.yellow[700],
                                fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormFieldObscureTextCustom(
                              textController: newPassword,
                              input: 'New password'),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormFieldObscureTextCustom(
                              textController: newPasswordConfirm,
                              input: 'Confirm new passwod'),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (newPasswordConfirmed()) {
                                changePassword(password.text, newPassword.text)
                                    .whenComplete(() {
                                  successDialog();
                                  sendNotifi();
                                  notificationProvider.sendNtfToFirestore(
                                      ntfTitle, currUserData.id!, ntfBody);
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange[800],
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                  child: Text('CHANGE PASSWORD',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      crossFadeState: correctlyPassword
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 400)),
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
                ],
              ),
            ),
          ),
        ),
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
