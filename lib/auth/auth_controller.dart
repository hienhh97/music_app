import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:music_app/screens/CommonScreens/playlist_screen.dart';
import 'package:music_app/screens/CommonScreens/song_screen.dart';
import '../home.dart';
import 'auth_scr.dart';

class AuthController extends StatelessWidget {
  const AuthController({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GetMaterialApp(
              home: const Home(),
              getPages: [
                GetPage(name: '/', page: () => const Home()),
                GetPage(name: '/song', page: () => const SongScreen()),
                GetPage(name: '/playlist', page: () => const PlaylistScreen()),
              ],
            );
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
