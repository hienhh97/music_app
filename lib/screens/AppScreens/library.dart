import 'package:flutter/material.dart';
import 'package:music_app/providers/fav_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FavProvider favProvider = Provider.of<FavProvider>(context);
    SongProvider songProvider = Provider.of<SongProvider>(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('My favourite songs')),
          ),
          body: Column(
            children: const [
              TabBar(tabs: [
                Tab(
                    icon: Icon(
                  Icons.queue_music_rounded,
                  color: Colors.deepPurple,
                )),
                Tab(
                    icon: Icon(
                  Icons.queue_music_rounded,
                  color: Colors.deepPurple,
                )),
              ]),
              Expanded(
                child: TabBarView(children: [
                  Center(
                    child: Text('My all songs'),
                  ),
                  Center(
                    child: Text('My playlists'),
                  )
                ]),
              )
            ],
          ),
        ));
  }
}
