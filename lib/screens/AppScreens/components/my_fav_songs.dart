import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/account.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/providers/fav_provider.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/recent_played_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:provider/provider.dart';
import '../../../models/song.dart';
import '../../../widgets/widgets.dart';

class MyFavSongs extends StatefulWidget {
  const MyFavSongs({super.key});

  @override
  State<MyFavSongs> createState() => _MyFavSongsState();
}

class _MyFavSongsState extends State<MyFavSongs> {
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
    FavProvider favProvider = Provider.of<FavProvider>(context);

    return StreamBuilder<UserModel>(
      stream: readUser,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading!');
        }
        final currUser = snapshot.data!;
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

        return MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: Scaffold(
            backgroundColor: Colors.deepPurple,
            appBar: AppBar(
              backgroundColor: Colors.deepPurple[800],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text('MY FAVOURITE SONGS'),
            ),
            body: SingleChildScrollView(
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favProvider.songs.length,
                    itemBuilder: (context, index) {
                      //list song proview
                      return FavSongCard(
                        index: index,
                        song: favProvider.songs[index],
                        songs: favProvider.songs,
                        playlist: allSongsPlaylist,
                        scaffoldMessengerKey: scaffoldMessengerKey,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

@immutable
class FavSongCard extends StatelessWidget {
  FavSongCard({
    super.key,
    required this.song,
    required this.index,
    required this.playlist,
    required this.songs,
    required this.scaffoldMessengerKey,
  });

  final int index;
  final Song song;
  final Playlist playlist;
  final List<Song> songs;
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    SongProvider songProvider = Provider.of<SongProvider>(context);
    RecentProvider recentProvider = Provider.of<RecentProvider>(context);
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    FavProvider favProvider = Provider.of<FavProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              songProvider.state == PlayerState.PLAYING
                  ? {
                      songProvider.audioPlayer.pause(),
                      songProvider.state = PlayerState.STOPPED
                    }
                  : {
                      songProvider.setPlaylist(songs, index: index),
                      songProvider.state = PlayerState.PLAYING,
                      playlistsProvider.currentPlaylist = playlist,
                    };

              recentProvider.setRecent(song);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      image: DecorationImage(
                          image: NetworkImage(song.imageUrl),
                          fit: BoxFit.cover)),
                ),
                Icon(
                  songProvider.state == PlayerState.PLAYING &&
                          songProvider.currentSong!.id == song.id
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 40,
                )
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  song.songName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  song.singer,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                favProvider.setFav(song);
              },
              icon: favProvider.isFavorite(song)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                    )
                  : const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                    )),
          IconButton(
              onPressed: () {
                addToPlaylist(context, playlistsProvider, scaffoldMessengerKey);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
