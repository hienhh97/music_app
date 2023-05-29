import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback showLoginScreen;
  const RegisterScreen({super.key, required this.showLoginScreen});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //global key
  final formKey = GlobalKey<FormState>();

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      //create user
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim())
            .then((value) {
          FirebaseFirestore.instance.collection('users').doc().set({
            "uid": value.user!.uid,
            'firstname': _firstNameController.text.trim(),
            'lastname': _lastNameController.text.trim(),
            'email': _emailController.text.trim(),
            'age': int.parse(_ageController.text.trim()),
            'password': _passwordController.text.trim(),
            'image': null,
          });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "email-already-in-use") {
          emailInUse();
        } else {
          unexpectedError();
        }
      }
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  void emailInUse() {
    showDialog(
        context: context,
        builder: (content) {
          return const AlertDialog(
              title: Text("Email in use by a different person!"));
        });
  }

  void unexpectedError() {
    showDialog(
        context: context,
        builder: (content) {
          return const AlertDialog(title: Text("An unexpected error"));
        });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF1F1A30),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.1, 0.4, 0.7, 0.9],
                colors: [
                  const Color.fromARGB(0, 170, 95, 9).withOpacity(0.8),
                  const Color.fromARGB(0, 26, 119, 156),
                  const Color.fromARGB(0, 44, 2, 48),
                  const Color.fromARGB(0, 111, 18, 119),
                ],
              ),
            ),
            child: Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Image.asset(
                        'assets/login-screen-icon.png',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 5,
                        color: const Color.fromARGB(255, 171, 211, 250)
                            .withOpacity(0.4),
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.all(40.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Login title
                              const Text(
                                "Register",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                    color: Colors.white),
                              ),

                              const SizedBox(height: 25),

                              //first name textfiled
                              TextFormFieldCustom(
                                  textController: _firstNameController,
                                  input: 'First name',
                                  preIcon: Icons.abc),

                              const SizedBox(height: 12),
                              //last name textfiled
                              TextFormFieldCustom(
                                  textController: _lastNameController,
                                  input: 'Last name',
                                  preIcon: Icons.abc),

                              const SizedBox(height: 12),

                              //age textfiled
                              TextFormFieldCustom(
                                textController: _ageController,
                                input: 'Enter your age',
                                preIcon: Icons.numbers_outlined,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r'^[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]+$')
                                          .hasMatch(value)) {
                                    return "Enter correct age number!";
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                              const SizedBox(height: 12),

                              //email textfiled
                              TextFormFieldCustom(
                                textController: _emailController,
                                input: 'Email',
                                preIcon: Icons.email_outlined,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return "Enter correct e-mail address!";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              //password TextFormField
                              TextFormFieldObscureTextCustom(
                                  textController: _passwordController,
                                  input: 'Password'),

                              const SizedBox(
                                height: 12,
                              ),

                              //confirm password TextFormField
                              TextFormFieldObscureTextCustom(
                                  textController: _confirmPasswordController,
                                  input: 'Confirm password'),

                              const SizedBox(height: 20),

                              //Sign button
                              GestureDetector(
                                onTap: signUp,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                      child: Text('Sign up',
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
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "I'm a member! ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: widget.showLoginScreen,
                              child: const Text(
                                "Go to Login!",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
