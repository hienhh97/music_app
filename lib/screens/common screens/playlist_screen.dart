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
          body: FutureBuilder<List<Song>?>(
            future: readData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('somethings has wrong!!');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('');
              }
              {
                final allSongs = snapshot.data!;
                //get list of songs by songID
                for (var songID
                    in playlistsProvider.selectedPlaylist!.songIDs) {
                  for (var song in allSongs) {
                    if (song.id == songID) {
                      songs.add(song);
                    }
                  }
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _PlaylistInfor(
                            playlist: playlistsProvider.selectedPlaylist!),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                songProvider.setPlaylist(songs, index: 0);
                                playlistsProvider.currentPlaylist =
                                    playlistsProvider.selectedPlaylist;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: Row(
                                  children: const [
                                    Text('Play',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Icon(
                                      Icons.play_arrow_rounded,
                                      size: 38,
                                    )
                                  ],
                                )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                songProvider.setPlaylist(songs, shuffle: true);
                                playlistsProvider.currentPlaylist =
                                    playlistsProvider.selectedPlaylist;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(25)),
                                child: const Center(
                                    child: Text('Shuffle',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            //list song proview
                            return MusicItem(
                              song: songs[index],
                              songs: songs,
                              playlist: playlistsProvider.selectedPlaylist!,
                              playlistsProvider: playlistsProvider,
                              index: index,
                              favProvider: favProvider,
                              songProvider: songProvider,
                              recentProvider: recentProvider,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          )),
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
