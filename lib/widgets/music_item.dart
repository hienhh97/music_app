import 'package:flutter/material.dart';
import 'package:music_app/providers/fav_provider.dart';
import 'package:music_app/providers/recent_played_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import '../models/song.dart';

class MusicItem extends StatelessWidget {
  const MusicItem({
    super.key,
    required this.song,
    required this.favProvider,
    required this.songProvider,
    required this.recentProvider,
  });

  final Song song;
  final FavProvider favProvider;
  final SongProvider songProvider;
  final RecentProvider recentProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              songProvider.isPlaying
                  ? songProvider.audioPlayer.pause()
                  : songProvider.currentSong = song;

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
                  songProvider.isPlaying &&
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
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}