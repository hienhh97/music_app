import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/widgets.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final password = TextEditingController();
  final newPassword = TextEditingController();
  final newPasswordConfirm = TextEditingController();

  final currUser = FirebaseAuth.instance.currentUser;

  changePassword({email, password, newPassword}) async {
    if (newPasswordConfirmed()) {
      var cred = EmailAuthProvider.credential(email: email, password: password);

      await currUser!
          .reauthenticateWithCredential(cred)
          .then((value) => currUser!.updatePassword(newPassword))
          .catchError((err) {
        print(err.toString());
      });
    } else {
      print('New Password Confirm must be the same as New Password!');
    }
  }

  bool newPasswordConfirmed() {
    if (newPassword.text.trim() == newPasswordConfirm.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 45,
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
                Text(
                  'Make sure you remember your password!',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.shade100,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormFieldObscureTextCustom(
                    textController: password,
                    input: 'Enter your correct password'),
                const SizedBox(
                  height: 15,
                ),
                TextFormFieldObscureTextCustom(
                    textController: newPassword, input: 'New password'),
                const SizedBox(
                  height: 15,
                ),
                TextFormFieldObscureTextCustom(
                    textController: newPasswordConfirm,
                    input: 'Confirm your new passwod'),
                const SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: () async {
                    await changePassword(
                        email: currUser?.email,
                        password: password.text,
                        newPassword: newPassword.text);
                    print('Password changed');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange[400],
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                        child: Text('CHANGE PASSWORD',
                            style: TextStyle(
                                color: Colors.deepPurple,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
