// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'forgot_password.dart';

const List<Color> _kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class LoginScreen extends StatefulWidget {
  final VoidCallback showRegisterScreen;
  const LoginScreen({super.key, required this.showRegisterScreen});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    showDialog(
        context: context,
        builder: (content) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: LoadingIndicator(
                indicatorType: Indicator.ballSpinFadeLoader,
                colors: _kDefaultRainbowColors,
              ),
            ),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      //pop the loading icon
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      //pop the loading icon
      Navigator.of(context).pop();

      if (e.code == 'user-not-found') {
        //show error to user
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        //show error to user
        wrongPasswordMessage();
      } else {
        //show error to user
        accountBlockedMessage();
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (content) {
          return AlertDialog(title: Text("Incorrect E-mail!"));
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (content) {
          return AlertDialog(title: Text("Incorrect Password!"));
        });
  }

  void accountBlockedMessage() {
    showDialog(
        context: context,
        builder: (content) {
          return AlertDialog(
              title: Text(
                  "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later"));
        });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/login-screen-icon.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  //Login title
                  const Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),

                  SizedBox(height: 15),

                  //welcome
                  Text(
                    "Welcome back again, my friend!",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 28),

                  //email textfiled
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: "Email",
                            fillColor: Colors.white,
                            filled: true,
                          ))),
                  SizedBox(height: 12),

                  //password textfield
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: "Password",
                            fillColor: Colors.white,
                            filled: true,
                          ))),

                  SizedBox(height: 20),

                  //Sign button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text('Sign in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  //navigate to sign up screen
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        Text(
                          "Don't have a account? ",
                          style: TextStyle(fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: widget.showRegisterScreen,
                          child: Text(
                            "Register now!",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgotPassword();
                            }));
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
