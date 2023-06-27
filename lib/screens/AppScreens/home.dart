import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/recent_played_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:music_app/screens/CommonScreens/song_screen.dart';
import 'package:provider/provider.dart';

import '../../models/song.dart';
import '../../widgets/widgets.dart';
import 'components/search_songs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<Song>> readSongs;
  late Stream<List<Playlist>> readPlaylist;

  Stream<List<Song>> getSongs() => FirebaseFirestore.instance
      .collection('songs')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList());

  Stream<List<Playlist>> getPlaylists() => FirebaseFirestore.instance
      .collection('playlists')
      .where('createdBy', isEqualTo: 'admin')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Playlist.fromJson(doc.data())).toList());

  @override
  void initState() {
    super.initState();
    readSongs = getSongs();
    readPlaylist = getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    SongProvider songProvider = Provider.of<SongProvider>(context);
    RecentProvider recentProvider = Provider.of<RecentProvider>(context);
    List<Song> recent = recentProvider.recent.reversed.toList();

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
        backgroundColor: const Color(0xFF1F1A30),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.elliptical(180, 10))),
          title: SizedBox(
              height: 50,
              width: 50,
              child: Image.asset('assets/login-screen-icon.png')),
          centerTitle: true,
          actions: [
            //search Icon
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    AnimatedPageRoute(
                        child: SearchSongScreen(
                          songs: songProvider.allSongs,
                          isSetSongToPlaylist: false,
                        ),
                        direction: AxisDirection.left));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              splashColor: Colors.grey[400],
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.4, 0.7, 0.9],
              colors: [
                const Color.fromARGB(0, 5, 114, 117).withOpacity(0.8),
                const Color.fromARGB(0, 114, 103, 6),
                const Color.fromARGB(0, 80, 30, 85),
                const Color.fromARGB(0, 155, 4, 168),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Column(
                    // all songs
                    children: [
                      StreamBuilder<List<Song>>(
                        stream: readSongs,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('something went wrong!');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('loading!');
                          }
                          final songs = snapshot.data!;
                          songProvider.allSongs = songs;
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 80,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: SectionHeader(
                                    title: 'All songs',
                                    action: 'View more',
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CarouselSlider(
                                    items: songs.map((index) {
                                      return SongCard(song: index);
                                    }).toList(),
                                    options: CarouselOptions(
                                        aspectRatio: 2,
                                        onPageChanged: (index, reason) {},
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.3,
                                        height: 260,
                                        autoPlay: true,
                                        autoPlayAnimationDuration:
                                            const Duration(
                                                milliseconds: 2400))),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  //recent list
                  recent.isNotEmpty
                      ? Column(
                          children: [
                            const SizedBox(height: 20),
                            const SectionHeader(
                              title: 'Recent song',
                              action: '',
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    ...List.generate(
                                        recent.length,
                                        (index) => Padding(
                                              padding: index == 0
                                                  ? const EdgeInsets.only(
                                                      left: 10, right: 10)
                                                  : const EdgeInsets.only(
                                                      right: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  songProvider
                                                      .setSong(recent[index]);

                                                  playlistsProvider
                                                      .currentPlaylist = null;
                                                  Navigator.push(
                                                      context,
                                                      AnimatedPageRoute(
                                                          child:
                                                              const SongScreen(),
                                                          direction:
                                                              AxisDirection
                                                                  .up));
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  recent[index]
                                                                      .imageUrl),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      recent[index].songName,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),

                  //Playlists preview
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        const SectionHeader(
                          title: 'Playlists',
                          action: '',
                        ),
                        StreamBuilder<List<Playlist>>(
                          stream: readPlaylist,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('loading!');
                            } else if (snapshot.hasData) {
                              var playlists = snapshot.data!;
                              return AnimatedList(
                                padding: const EdgeInsets.only(top: 20),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                initialItemCount: playlists.length,
                                itemBuilder: (context, index, animation) {
                                  return PlaylistCard(
                                    isShowDelButton: false,
                                    playlist: playlists[index],
                                    animation: animation,
                                    onClicked: () {},
                                  );
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
      ),
    );
  }
}
