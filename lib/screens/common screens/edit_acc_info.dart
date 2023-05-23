import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/controller/profile_controller.dart';
import 'package:music_app/models/account.dart';

import '../../widgets/widgets.dart';

class EditAccInfo extends StatefulWidget {
  const EditAccInfo({super.key});

  @override
  State<EditAccInfo> createState() => _EditAccInfoState();
}

class _EditAccInfoState extends State<EditAccInfo> {
  late dynamic readUserData;
  bool _obscureText = true;
  final controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    readUserData = controller.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontSize: 36),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_outlined),
            iconSize: 30,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
            future: readUserData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;

                  final firstName = TextEditingController(text: user.firstName);
                  final lastName = TextEditingController(text: user.lastName);
                  final password = TextEditingController(text: user.password);
                  final confirmPassword =
                      TextEditingController(text: user.password);
                  final age = TextEditingController(text: user.age.toString());
                  final image = TextEditingController(text: user.image);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        //Image and Edit Image button
                        const SizedBox(
                          height: 40,
                        ),
                        user.image != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.image!),
                                radius: 60,
                              )
                            : const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/user-avatar.png'),
                                radius: 60,
                              ),
                        const SizedBox(
                          height: 50,
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
                              textController: age,
                              input: 'Age',
                              preIcon: Icons.numbers_outlined,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: password,
                              decoration: InputDecoration(
                                label: const Text(
                                  'Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              obscureText: _obscureText,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: confirmPassword,
                              decoration: InputDecoration(
                                label: const Text(
                                  'Confirm password',
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.password,
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              obscureText: _obscureText,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: GestureDetector(
                                onTap: () async {
                                  final userData = UserModel(
                                      id: user.id,
                                      email: user.email,
                                      age: int.parse(age.text.trim()),
                                      password: password.text.trim(),
                                      firstName: firstName.text.trim(),
                                      lastName: lastName.text.trim(),
                                      image: image.text.trim());

                                  await controller.updateRecord(userData);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                      child: Text('Submit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  );
                }
              }
              return Container(
                child: Text('Erorrrrrrrrrrrrrrrrrrr'),
              );
            },
          ),
        ),
      ),
    );
  }
}
