import 'package:flutter/material.dart';
import 'package:music_app/providers/fav_provider.dart';
import 'package:music_app/providers/player_provider.dart';
import 'package:provider/provider.dart';

class CurrentSong extends StatelessWidget {
  const CurrentSong({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PlayerProvider songProvider = Provider.of<PlayerProvider>(context);
    FavProvider favProvider = Provider.of<FavProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.blueGrey.shade700,
      child: Row(
        children: [
          const SizedBox(
            width: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage:
                  NetworkImage(songProvider.currentSong?.imageUrl ?? ''),
              radius: 23,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songProvider.currentSong?.songName ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  songProvider.currentSong?.singer ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              favProvider.setFav(songProvider.currentSong!);
            },
            icon: favProvider.isFavorite(songProvider.currentSong!)
                ? const Icon(Icons.favorite, color: Colors.pinkAccent)
                : const Icon(Icons.favorite_border_outlined),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              songProvider.isPlaying
                  ? songProvider.audioPlayer.pause()
                  : songProvider.audioPlayer.resume();
            },
            icon: songProvider.isPlaying
                ? const Icon(Icons.pause_rounded)
                : const Icon(Icons.play_arrow_rounded),
            color: Colors.white,
            iconSize: 34,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.skip_next_rounded),
            color: Colors.white,
            iconSize: 34,
          ),
        ],
      ),
    );
  }
}
