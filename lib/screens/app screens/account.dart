import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/screens/common%20screens/edit_acc_info.dart';
import 'package:music_app/screens/common%20screens/upload_new_song.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/user-bakground.jpg"),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where("uid", isEqualTo: user.uid)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              final currentUser = snapshot.data!.docs[i];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.blueGrey,
                                        Colors.grey,
                                      ]),
                                      border: Border(
                                          right: BorderSide(
                                              width: 13,
                                              color: Colors.purpleAccent))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              currentUser['image']),
                                          radius: 35,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${currentUser['firstname']} ${currentUser['lastname']}",
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              currentUser['email'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    ProfileItem(
                      icon: Icons.edit,
                      title: 'Edit profile',
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditAccInfo()));
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ProfileItem(
                      icon: Icons.upload_rounded,
                      title: 'Upload new song',
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UploadNewSong()));
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ProfileItem(
                      icon: Icons.settings,
                      title: 'Action(Inprogress)',
                      onPress: () {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ProfileItem(
                      icon: Icons.settings,
                      title: 'Action(Inprogress)',
                      onPress: () {},
                    )
                  ],
                ),
              ),

              //sign out button
              GestureDetector(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    showCloseIcon: true,
                    closeIcon: const Icon(Icons.close_fullscreen_outlined),
                    title: 'Do you wanna sign out?',
                    btnOkOnPress: () {
                      FirebaseAuth.instance.signOut();
                    },
                    btnCancelOnPress: () {},
                    onDismissCallback: (type) {
                      debugPrint('Dialog Dismiss from callback $type');
                    },
                  ).show();
                  //FirebaseAuth.instance.signOut();
                },
                child: Container(
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
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey[100]?.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700),
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(.1),
        ),
        child: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.grey,
        ),
      ),
    );
  }
}
