import 'package:flutter/material.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/screens/common%20screens/playlist_screen.dart';
import 'package:provider/provider.dart';

import '../models/playlist.dart';
import 'widgets.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.playlist,
  });

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    return InkWell(
      onTap: () {
        playlistsProvider.selectedPlaylist = playlist;
        Navigator.push(
            context,
            AnimatedPageRoute(
                child: const PlaylistScreen(), direction: AxisDirection.left));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.deepOrange.shade100.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15)),
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                playlist.imageUrl,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  Text(
                    '${playlist.songIDs.length} songs',
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 14),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.play_circle),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
