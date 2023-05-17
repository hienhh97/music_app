import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:music_app/screens/app%20screens/account.dart';
import 'package:music_app/screens/app%20screens/home.dart';
import 'package:music_app/screens/app%20screens/notification.dart';
import 'package:music_app/screens/app%20screens/library.dart';
import 'package:music_app/screens/common%20screens/song_screen.dart';
import 'package:music_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    SongProvider songProvider = Provider.of<SongProvider>(context);

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
                              MaterialPageRoute(
                                builder: (context) => const SongScreen(),
                              ));
                        },
                        child: const CurrentSong()) // display on
                    : Container(),

                //Bottom Navbar
                Container(
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
                      tabs: const [
                        GButton(icon: Icons.home, text: 'Home'),
                        GButton(
                            icon: Icons.my_library_music_outlined,
                            text: 'Library'),
                        GButton(
                          icon: Icons.notifications,
                          text: 'Notification',
                        ),
                        GButton(icon: Icons.person, text: 'Personal'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
