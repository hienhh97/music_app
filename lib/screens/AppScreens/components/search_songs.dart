import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:provider/provider.dart';

class SearchSongScreen extends StatefulWidget {
  const SearchSongScreen({
    super.key,
    required this.songs,
    required this.isSetSongToPlaylist,
  });

  @override
  State<SearchSongScreen> createState() => _SearchSongScreenState();
  final List<Song> songs;
  final bool isSetSongToPlaylist;
}

class _SearchSongScreenState extends State<SearchSongScreen> {
  List<Song> _foundedSongs = [];
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    setState(() {
      _foundedSongs = widget.songs;
    });
  }

  onSearch(String search) {
    setState(() {
      _foundedSongs = widget.songs
          .where((song) => song.songName.toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade900,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
          title: SizedBox(
            height: 38,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => onSearch(value),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[700],
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
                  hintText: 'Search song name...'),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(right: 20, left: 20),
          color: Colors.grey[900],
          child: _foundedSongs.isNotEmpty
              ? ListView.builder(
                  itemCount: _foundedSongs.length,
                  itemBuilder: (context, index) {
                    return songDetails(
                        song: _foundedSongs[index], key: scaffoldMessengerKey);
                  },
                )
              : const Center(
                  child: Text(
                    'Song not found!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }

  songDetails(
      {required Song song, required GlobalKey<ScaffoldMessengerState> key}) {
    SongProvider songProvider = Provider.of<SongProvider>(context);
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);

    return GestureDetector(
      onTap: widget.isSetSongToPlaylist == false
          ? () {
              songProvider.setSong(song);
              Get.toNamed('/song', arguments: song);
            }
          : () {
              playlistsProvider
                  .addSongToPlaylist(playlistsProvider.selectedPlaylist!, song)
                  .whenComplete(() => key.currentState!
                      .showSnackBar(const SnackBar(content: Text('success'))));
            },
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
                      backgroundImage: NetworkImage(song.imageUrl),
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.songName,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    song.singer,
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
