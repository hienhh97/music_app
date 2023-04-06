import 'package:flutter/material.dart';
import 'package:music_app/screens/app%20screens/account.dart';
import 'package:music_app/screens/app%20screens/home.dart';
import 'package:music_app/screens/app%20screens/notification.dart';
import 'package:music_app/screens/app%20screens/trending.dart';

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
    TrendingScreen(),
    NotificationScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomNavbar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up), label: 'trending'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'account'),
        ],
      ),
    );
  }
}
