import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/store.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';

class MyPlaylists extends StatefulWidget {
  const MyPlaylists({super.key});

  @override
  State<MyPlaylists> createState() => _MyPlaylistsState();
}

class _MyPlaylistsState extends State<MyPlaylists> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late Stream<List<Playlist>> readUserAllPlaylist;
  late TextEditingController _playlistController;

  Stream<List<Playlist>> getUserAllPlaylists() => FirebaseFirestore.instance
      .collection('playlists')
      .where('createdBy', isEqualTo: Store.instance.currentUser.uid)
      .snapshots()
      .map((event) =>
          event.docs.map((doc) => Playlist.fromJson(doc.data())).toList());

  @override
  void initState() {
    super.initState();
    readUserAllPlaylist = getUserAllPlaylists();
    setState(() {
      _playlistController = TextEditingController();
    });
  }

  @override
  void dispose() {
    _playlistController.dispose();
    super.dispose();
  }

  bool isShowDelButton = false;

  @override
  Widget build(BuildContext context) {
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Text(
              'My playlists',
              style: TextStyle(fontSize: 22),
            ),
            actions: [
              Switch(
                  value: isShowDelButton,
                  activeColor: Colors.deepOrange,
                  inactiveThumbColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      isShowDelButton = value;
                    });
                  })
            ],
            backgroundColor: Color.fromARGB(255, 43, 16, 99),
          ),

          //add new playlist button
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _newPlaylist(context, playlistsProvider);
            },
            backgroundColor: Colors.deepOrange[800],
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 18, 5, 47),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder<List<Playlist>>(
                stream: readUserAllPlaylist,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('loading!');
                  } else if (snapshot.hasData) {
                    var myPlaylists = snapshot.data!;
                    playlistsProvider.allPlaylists = myPlaylists;

                    return SingleChildScrollView(
                      child: AnimatedList(
                        key: _listKey,
                        padding: const EdgeInsets.only(top: 20),
                        initialItemCount: playlistsProvider.allPlaylists.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index, animation) {
                          return PlaylistCard(
                            isShowDelButton: isShowDelButton,
                            playlist: playlistsProvider.allPlaylists[index],
                            animation: animation,
                            onClicked: () {
                              _removePlaylist(
                                  playlistsProvider.allPlaylists[index],
                                  index,
                                  playlistsProvider,
                                  isShowDelButton);
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text(
                        'No topics found in Firestore. Check database');
                  }
                }),
          )),
    );
  }

  Future<dynamic> _newPlaylist(
      BuildContext context, PlaylistsProvider playlistsProvider) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.black87,
              child: SizedBox(
                height: 180,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 2, color: Colors.black45))),
                        child: const Center(
                          child: Text(
                            'New playlist',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      TextFormField(
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        controller: _playlistController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Enter playlist's name...",
                          hintStyle: const TextStyle(
                              color: Colors.white24,
                              fontStyle: FontStyle.italic),
                          label: const Text("Playlist's name"),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        cursorColor: Colors.amber[200],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () {
                          if (_playlistController.text.isNotEmpty) {
                            playlistsProvider
                                .createNewPlaylist(
                                    _playlistController.text.trim(), Song())
                                .whenComplete(() {
                              scaffoldMessengerKey.currentState!.showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Playlist created successfully!')));
                              _listKey.currentState!.insertItem(0,
                                  duration: const Duration(milliseconds: 300));
                            });
                          } else {}
                          _playlistController.clear();
                          Navigator.of(context).pop();
                        },
                        child: const Text('SUBMIT'),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  void _removePlaylist(Playlist playlist, int index,
      PlaylistsProvider playlistsProvider, bool isShowDelButton) {
    final removedPlaylist = playlistsProvider.allPlaylists[index];

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Warning!"),
              content: const Text("REMOVE this playlist?"),
              actions: [
                TextButton(
                    onPressed: () {
                      playlistsProvider.removeMyPlaylist(playlist).whenComplete(
                          () => _listKey.currentState!.removeItem(
                              index,
                              (context, animation) => PlaylistCard(
                                  isShowDelButton: isShowDelButton,
                                  playlist: removedPlaylist,
                                  animation: animation,
                                  onClicked: () {})));
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No')),
              ],
            ));
  }
}
