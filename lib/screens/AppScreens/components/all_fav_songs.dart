import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/account.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/providers/fav_provider.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/recent_played_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:music_app/providers/store.dart';
import 'package:provider/provider.dart';
import '../../../widgets/widgets.dart';

class AllFavSongs extends StatefulWidget {
  const AllFavSongs({super.key});

  @override
  State<AllFavSongs> createState() => _AllFavSongsState();
}

class _AllFavSongsState extends State<AllFavSongs> {
  late Stream<UserModel> readUser;
  final currentUser = FirebaseAuth.instance.currentUser!;
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Stream<UserModel> getUser() => FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: currentUser.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).single);

  @override
  void initState() {
    super.initState();
    readUser = getUser();
  }

  @override
  Widget build(BuildContext context) {
    SongProvider songProvider = Provider.of<SongProvider>(context);
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    RecentProvider recentProvider = Provider.of<RecentProvider>(context);
    FavProvider favProvider = Provider.of<FavProvider>(context);

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: StreamBuilder<UserModel>(
          stream: readUser,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('loading!');
            }
            final currUser = snapshot.data!;
            Store.instance.currentUser = currUser;
            favProvider.favoriteListSongIDs = currUser.favSongs;
            for (var songID in favProvider.favoriteListSongIDs) {
              if (favProvider.songs.length <
                  favProvider.favoriteListSongIDs.length) {
                favProvider.songs.add(songProvider.getByID(songID));
              }
            }

            final allSongsPlaylist = Playlist(
                id: 'library',
                imageUrl:
                    'https://icon-library.com/images/music-icon-transparent/music-icon-transparent-8.jpg',
                songIDs: currUser.favSongs,
                title: 'MY FAVOURITE SONGS');

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      songProvider.setPlaylist(favProvider.songs,
                          shuffle: true);
                      playlistsProvider.currentPlaylist = allSongsPlaylist;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 50),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Shuffle',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.shuffle_rounded,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: favProvider.songs.length,
                    itemBuilder: (context, index) {
                      //list song proview
                      return MusicItem(
                        song: favProvider.songs[index],
                        songs: favProvider.songs,
                        playlist: allSongsPlaylist,
                        playlistsProvider: playlistsProvider,
                        index: index,
                        favProvider: favProvider,
                        songProvider: songProvider,
                        recentProvider: recentProvider,
                        scaffoldMessengerKey: scaffoldMessengerKey,
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
