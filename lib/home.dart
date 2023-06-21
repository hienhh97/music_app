import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:music_app/providers/notification_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:music_app/screens/AppScreens/account.dart';
import 'package:music_app/screens/AppScreens/home.dart';
import 'package:music_app/screens/AppScreens/notification.dart';
import 'package:music_app/screens/AppScreens/library.dart';
import 'package:music_app/screens/CommonScreens/song_screen.dart';
import 'package:music_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'models/notifcation.dart';
import 'providers/store.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Navigate around bottom navbar
  int _selectedIndex = 0;
  void _navigateBottomNavbar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Navigate to different pages
  final List<Widget> _children = const [
    HomeScreen(),
    LibraryScreen(),
    NotificationScreen(),
    AccountScreen(),
  ];
  late Stream<List<NotificationModel>> readUnCheckedNtf;
  final List<NotificationModel> unCheckedNotiList = [];
  Stream<List<NotificationModel>> getUnCheckedNtf() =>
      FirebaseFirestore.instance
          .collection('notifications')
          .where('userID', isEqualTo: Store.instance.currentUser.id)
          .where('isChecked', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data()))
              .toList());

  @override
  void initState() {
    super.initState();
    readUnCheckedNtf = getUnCheckedNtf();
  }

  @override
  Widget build(BuildContext context) {
    SongProvider songProvider = Provider.of<SongProvider>(context);
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);

    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: songProvider.currentSong != null ? 150 : 80,
        child: Stack(
          children: [
            Column(
              children: [
                //current song
                songProvider.currentSong != null
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              AnimatedPageRoute(
                                  child: const SongScreen(),
                                  direction: AxisDirection.up));

                          songProvider.audioPlayer.resume();
                          songProvider.state = PlayerState.PLAYING;
                        },
                        child: const CurrentSong()) // display on
                    : Container(),

                //Bottom Navbar
                // Container(
                //   color: Colors.blueGrey.shade900,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 10, vertical: 12),
                //     child: GNav(
                //       selectedIndex: _selectedIndex,
                //       onTabChange: _navigateBottomNavbar,
                //       color: Colors.white,
                //       rippleColor: Colors.blueGrey[400]!,
                //       hoverColor: Colors.blueGrey[100]!,
                //       tabBackgroundColor: Colors.grey.shade700,
                //       activeColor: Colors.white,
                //       gap: 7,
                //       tabBorderRadius: 20,
                //       padding: const EdgeInsets.all(16),
                //       iconSize: 24,
                //       tabs: [
                //         GButton(icon: Icons.home, text: 'Home'),
                //         GButton(
                //             icon: Icons.my_library_music_outlined,
                //             text: 'Library'),
                //         GButton(
                //           leading: Badge(
                //             label: Text(notificationProvider
                //                 .userNotifications.length
                //                 .toString()),
                //             child: Icon(
                //               Icons.notifications,
                //               color: Colors.white,
                //             ),
                //           ),
                //           icon: Icons.notifications,
                //           text: 'Notification',
                //         ),
                //         GButton(icon: Icons.person, text: 'Personal'),
                //       ],
                //     ),
                //   ),
                // ),
                StreamBuilder(
                  stream: readUnCheckedNtf,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Text('loading!');
                    }
                    final unCheckedNotiList = snapshot.data!;
                    notificationProvider.userNotifications = unCheckedNotiList;
                    return Container(
                      color: Colors.blueGrey.shade900,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        child: GNav(
                          selectedIndex: _selectedIndex,
                          onTabChange: _navigateBottomNavbar,
                          color: Colors.white,
                          rippleColor: Colors.blueGrey[400]!,
                          hoverColor: Colors.blueGrey[100]!,
                          tabBackgroundColor: Colors.grey.shade700,
                          activeColor: Colors.white,
                          gap: 7,
                          tabBorderRadius: 20,
                          padding: const EdgeInsets.all(16),
                          iconSize: 24,
                          tabs: [
                            GButton(icon: Icons.home, text: 'Home'),
                            GButton(
                                icon: Icons.my_library_music_outlined,
                                text: 'Library'),
                            GButton(
                              leading: notificationProvider
                                      .userNotifications.isNotEmpty
                                  ? Badge(
                                      label: Text(notificationProvider
                                          .userNotifications.length
                                          .toString()),
                                      child: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                              icon: Icons.notifications,
                              text: 'Notification',
                            ),
                            GButton(icon: Icons.person, text: 'Personal'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
