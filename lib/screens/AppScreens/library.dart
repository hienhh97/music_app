import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/providers/fav_provider.dart';
import 'package:music_app/providers/store.dart';
import 'package:music_app/screens/CommonScreens/my_playlists.dart';
import 'package:provider/provider.dart';
import '../../models/account.dart';
import '../../models/song.dart';
import '../../providers/playlists_provider.dart';
import '../../providers/recent_played_provider.dart';
import '../../providers/song_provider.dart';
import '../../widgets/widgets.dart';
import '../CommonScreens/song_screen.dart';
import '../CommonScreens/upload_new_song.dart';
import '../CommonScreens/my_fav_songs.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Stream<UserModel> readUser;
  final currentUser = FirebaseAuth.instance.currentUser!;

  Stream<UserModel> getUser() => FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: currentUser.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).single);

  @override
  void initState() {
    readUser = getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width / 2 - 20;
    final screenHeight = MediaQuery.of(context).size.height / 5;
    RecentProvider recentProvider = Provider.of<RecentProvider>(context);
    List<Song> recent = recentProvider.recent.reversed.toList();
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    SongProvider songProvider = Provider.of<SongProvider>(context);

    return StreamBuilder<UserModel>(
        stream: readUser,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading!');
          }
          final user = snapshot.data!;
          Store.instance.currentUser = user;
          return MaterialApp(
            theme: ThemeData.dark(useMaterial3: true),
            home: Scaffold(
              appBar: AppBar(
                title: const Center(
                    child: Text(
                  'LIBRARY',
                  style: TextStyle(),
                )),
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    AnimatedPageRoute(
                                        child: const MyFavSongs(),
                                        direction: AxisDirection.left));
                              },
                              child: Container(
                                height: screenHeight,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 20),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/icons/fav-icon.png'),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                    const Text(
                                      'My favourite songs',
                                      style: TextStyle(
                                          color: Colors.amber, fontSize: 22),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      '${user.favSongs.length} songs',
                                      style: TextStyle(
                                          color: Colors.amber[200],
                                          fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    AnimatedPageRoute(
                                        child: const MyPlaylists(),
                                        direction: AxisDirection.left));
                              },
                              child: Container(
                                height: screenHeight,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 20),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/icons/playlist-icon.jpg'),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                    const Text(
                                      'My playlists',
                                      style: TextStyle(
                                          color: Colors.amber, fontSize: 22),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    AnimatedPageRoute(
                                        child: const UploadNewSong(),
                                        direction: AxisDirection.left));
                              },
                              child: Container(
                                height: screenHeight,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 20),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/icons/upload-cloud.png'),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                    const Text(
                                      'Upload song',
                                      style: TextStyle(
                                          color: Colors.amber, fontSize: 22),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    recent.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const SectionHeader(
                                title: 'Recent song',
                                action: '',
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    recent[index]
                                                                        .imageUrl),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
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
                  ],
                ),
              ),
            ),
          );
        });
  }
}
