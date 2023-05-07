import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';

import '../../models/song.dart';
import '../../widgets/widgets.dart';
import 'components/custom_search.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Stream<List<Song>> readSongs() => FirebaseFirestore.instance
      .collection('songs')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList());

  Future<List<Playlist>> getPlaylists() async {
    var ref = FirebaseFirestore.instance.collection('playlists');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((i) => i.data());
    var playlists = data.map((e) => Playlist.fromJson(e));
    return playlists.toList();
  }

  @override
  Widget build(BuildContext context) {
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
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.workspaces_filled),
          ),
          title: const Center(child: Text('Home screen')),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Column(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: SectionHeader(title: 'Trending Music'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.27,
                      child: StreamBuilder<List<Song>>(
                        stream: readSongs(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('something went wrong!');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('loading!');
                          }

                          final songs = snapshot.data!;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              return SongCard(song: songs[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      const SectionHeader(title: 'Playlist'),
                      FutureBuilder<List<Playlist>>(
                        future: getPlaylists(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('loading!');
                          } else if (snapshot.hasData) {
                            var playlists = snapshot.data!;
                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 20),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: playlists.length,
                              itemBuilder: (context, index) {
                                return PlaylistCart(playlist: playlists[index]);
                              },
                            );
                          } else {
                            return const Text(
                                'No topics found in Firestore. Check database');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
