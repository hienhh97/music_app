import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:provider/provider.dart';

import '../providers/playlists_provider.dart';
import '../screens/CommonScreens/playlist_screen.dart';
import 'widgets.dart';

class PlaylistCard extends StatefulWidget {
  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.animation,
    required this.onClicked,
    required this.isShowDelButton,
  });

  final Playlist playlist;
  final Animation<double> animation;
  final VoidCallback? onClicked;
  final bool isShowDelButton;

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  @override
  Widget build(BuildContext context) {
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    return SizeTransition(
      sizeFactor: widget.animation,
      child: GestureDetector(
        onTap: () {
          playlistsProvider.selectedPlaylist = widget.playlist;
          Navigator.push(
              context,
              AnimatedPageRoute(
                  child: PlaylistScreen(playlistID: widget.playlist.id),
                  direction: AxisDirection.left));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              color: Colors.indigo[300],
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(15))),
          height: 75,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: widget.playlist.imageUrl != ''
                  ? Image.network(
                      widget.playlist.imageUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/no-image-album.jpg',
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
                    widget.playlist.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  Text(
                    '${widget.playlist.songIDs.length} songs',
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 14),
                  )
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.isShowDelButton ? 75 : 0,
              height: 75,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(5))),
              child: IconButton(
                onPressed: widget.onClicked,
                icon: const Icon(Icons.clear),
                color: Colors.white,
                iconSize: 30,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
