import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screens/AppScreens/components/all_fav_playlists.dart';
import 'components/all_fav_songs.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final currUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.indigo,
          appBar: AppBar(
            title: Text('Library'),
            backgroundColor: Colors.deepPurple,
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.deepPurple.shade400),
                child: TabBar(
                    indicator: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10)),
                    tabs: const [
                      Tab(
                        child: Text(
                          'FAVOURITE SONGS',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'PLAYLISTS',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ]),
              ),
              const Expanded(
                child: TabBarView(children: [
                  AllFavSongs(),
                  AllFavPlaylist(),
                ]),
              )
            ],
          ),
        ));
  }
}
