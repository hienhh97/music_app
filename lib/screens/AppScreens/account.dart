import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/providers/store.dart';
import 'package:music_app/screens/AuthScreens/change_password.dart';
import 'package:music_app/screens/CommonScreens/edit_acc_info.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';
import '../../providers/song_provider.dart';
import '../../widgets/widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Stream<UserModel> readUser;
  final currentUser = FirebaseAuth.instance.currentUser!;

  Stream<UserModel> getUser() => FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: currentUser.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).single);

  @override
  void initState() {
    readUser = getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SongProvider songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontSize: 36),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder(
                        stream: readUser,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('loading!');
                          }
                          final user = snapshot.data!;
                          Store.instance.currentUser = user;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
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
                                    fit: BoxFit.cover,
                                    image: user.image != null
                                        ? NetworkImage(user.image!)
                                        : const AssetImage(
                                                'assets/images/user-avatar.png')
                                            as ImageProvider,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          );
                        },
                      )),
                  ProfileItem(
                    icon: Icons.edit,
                    title: 'Edit profile',
                    onPress: () {
                      Navigator.push(
                          context,
                          AnimatedPageRoute(
                              child: const EditAccInfo(),
                              direction: AxisDirection.left));
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ProfileItem(
                    icon: Icons.edit,
                    title: 'Change password',
                    onPress: () {
                      Navigator.push(
                          context,
                          AnimatedPageRoute(
                              child: const ChangePassword(),
                              direction: AxisDirection.left));
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),

              const SizedBox(
                height: 40,
              ),

              //sign out button
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: const Center(child: Text('WARNING!')),
                            titleTextStyle: TextStyle(
                                color: Colors.red[700],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            content: const Text('Do you wanna sign out?'),
                            contentTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pop();
                                    songProvider.state = PlayerState.PAUSED;
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Colors.blue[200], fontSize: 16),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 16),
                                  )),
                            ],
                          ));
                },
                child: Container(
                  height: 60,
                  width: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.deepOrange[800],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        CupertinoIcons.square_arrow_up,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Log out',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[600],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[600]?.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
