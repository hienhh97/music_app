import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:provider/provider.dart';

class PlaylistsFilter extends StatefulWidget {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();
  PlaylistsFilter(
      {super.key, required this.playlists, required this.scaffoldMessengerKey});

  @override
  State<PlaylistsFilter> createState() => _PlaylistsFilterState();
  final List<Playlist> playlists;
}

class _PlaylistsFilterState extends State<PlaylistsFilter> {
  List<Playlist> _foundedPlaylists = [];
  late TextEditingController _playlistController;

  @override
  void initState() {
    super.initState();
    setState(() {
      _foundedPlaylists = widget.playlists;
      _playlistController = TextEditingController();
    });
  }

  @override
  void dispose() {
    _playlistController.dispose();
    super.dispose();
  }

  onSearch(String search) {
    setState(() {
      _foundedPlaylists = widget.playlists
          .where((playlist) => playlist.title.toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    SongProvider songProvider = Provider.of<SongProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => onSearch(value),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white54,
                  contentPadding: const EdgeInsets.all(0),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[200],
                  ),
                  hintText: 'Search playlist name...'),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.black87,
                              child: SizedBox(
                                height: 180,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 2,
                                                    color: Colors.black45))),
                                        child: const Center(
                                          child: Text(
                                            'New playlist',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        controller: _playlistController,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          hintText: "Enter playlist's name...",
                                          hintStyle: const TextStyle(
                                              color: Colors.white24,
                                              fontStyle: FontStyle.italic),
                                          label: const Text("Playlist's name"),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                          if (_playlistController
                                              .text.isNotEmpty) {
                                            playlistsProvider
                                                .createNewPlaylist(
                                                    _playlistController.text
                                                        .trim(),
                                                    songProvider.currentSong!,
                                                    context)
                                                .whenComplete(() => widget
                                                    .scaffoldMessengerKey
                                                    .currentState!
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Playlist created successfully!'))));
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
                            )).whenComplete(() => Navigator.pop(context));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const Positioned(
                                right: 5,
                                top: 5,
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Expanded(
                            child: Text(
                          'Create a new playlist',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 320,
                  child: _foundedPlaylists.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _foundedPlaylists.length,
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        if (await playlistsProvider
                                                .addSongToPlaylist(
                                                    _foundedPlaylists[index],
                                                    songProvider
                                                        .currentSong!) ==
                                            true) {
                                          widget.scaffoldMessengerKey
                                              .currentState!
                                              .showSnackBar(const SnackBar(
                                                  content: Text('success!')));
                                        } else {
                                          widget.scaffoldMessengerKey
                                              .currentState!
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text('song exist!')));
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Image.network(
                                              _foundedPlaylists[index].imageUrl,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _foundedPlaylists[index]
                                                      .title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  '${_foundedPlaylists[index].songIDs.length} songs',
                                                  style: const TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 18),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'Playlist not found!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  playlistDetails({required Playlist playlist}) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                width: 60,
                height: 60,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(playlist.imageUrl),
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    playlist.id,
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
