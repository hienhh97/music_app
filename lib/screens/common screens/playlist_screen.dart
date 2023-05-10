import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/recent_played_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/fav_provider.dart';
import '../../widgets/widgets.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late Future<List<Song>> readData;

  Future<List<Song>> getData() async {
    var ref = FirebaseFirestore.instance.collection('songs');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((i) => i.data());
    var songs = data.map((e) => Song.fromJson(e));
    return songs.toList();
  }

  @override
  void initState() {
    readData = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Song> songs = [];
    FavProvider favProvider = Provider.of<FavProvider>(context);
    SongProvider songProvider = Provider.of<SongProvider>(context);
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    RecentProvider recentProvider = Provider.of<RecentProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black87,
            Colors.black54,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Playlist'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _PlaylistInfor(playlist: playlistsProvider.currentPlaylist!),
                const SizedBox(
                  height: 30,
                ),
                const _PlayOrShuffle(),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder<List<Song>?>(
                  future: readData,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('somethings has wrong!!');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Text('');
                    }
                    {
                      final allSongs = snapshot.data!;
                      //get list of songs by songID
                      for (var songID
                          in playlistsProvider.currentPlaylist!.songIDs) {
                        for (var song in allSongs) {
                          if (song.id == songID) {
                            songs.add(song);
                          }
                        }
                      }
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          //list song proview
                          return MusicItem(
                            song: songs[index],
                            favProvider: favProvider,
                            songProvider: songProvider,
                            recentProvider: recentProvider,
                          );
                        },
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistSong extends StatelessWidget {
  const _PlaylistSong({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _PlayOrShuffle extends StatefulWidget {
  const _PlayOrShuffle({
    super.key,
  });

  @override
  State<_PlayOrShuffle> createState() => _PlayOrShuffleState();
}

class _PlayOrShuffleState extends State<_PlayOrShuffle> {
  bool isPlay = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          isPlay = !isPlay;
        });
      },
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: isPlay ? 0 : width * 0.45,
              child: Container(
                height: 50,
                width: width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Play',
                          style: TextStyle(
                            color: isPlay ? Colors.white : Colors.deepOrange,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Icon(
                        Icons.play_circle,
                        color: isPlay ? Colors.white : Colors.deepOrange,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Shuffle',
                          style: TextStyle(
                            color: isPlay ? Colors.deepOrange : Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.shuffle,
                        color: isPlay ? Colors.deepOrange : Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistInfor extends StatelessWidget {
  const _PlaylistInfor({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            playlist.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          playlist.title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
