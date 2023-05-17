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
      Navigator.of(context, rootNavigator: true).pop();
    } on FirebaseAuthException catch (e) {
      //pop the loading icon
      Navigator.of(context, rootNavigator: true).pop();

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
        backgroundColor: Color(0xFF1F1A30),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color.fromARGB(0, 170, 95, 9).withOpacity(0.8),
                Color.fromARGB(0, 26, 119, 156),
                Color.fromARGB(0, 111, 18, 119),
                Color.fromARGB(0, 111, 18, 119),
              ],
            ),
          ),
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
                  SizedBox(
                    height: 25,
                  ),
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
                        children: [
                          //Login title
                          const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: Colors.white),
                          ),

                          SizedBox(height: 15),

                          //welcome
                          Text(
                            "Welcome back again!",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 28),

                          //email textfiled
                          TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple),
                                    borderRadius: BorderRadius.circular(12)),
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: "Email",
                                fillColor: Colors.white,
                                filled: true,
                              )),
                          SizedBox(height: 12),

                          //password textfield
                          TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple),
                                    borderRadius: BorderRadius.circular(12)),
                                prefixIcon: Icon(Icons.lock_open_outlined),
                                hintText: "Password",
                                fillColor: Colors.white,
                                filled: true,
                              )),

                          SizedBox(height: 25),

                          //Sign button
                          GestureDetector(
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
                          SizedBox(height: 25),
                          //navigate to sign up screen
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have a account? ",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
                ],
              ),
            ),
          ),
        ));
  }
}
