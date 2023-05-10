import 'package:flutter/material.dart';
import 'package:music_app/providers/fav_provider.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:music_app/screens/common%20screens/playlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:music_app/const.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 14));
    animation = ReverseAnimation(controller);
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SongProvider songProvider = Provider.of<SongProvider>(context);
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    FavProvider favProvider = Provider.of<FavProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.expand_more_outlined,
              size: 40,
            )),
        actions: [
          //Favourite action button
          IconButton(
            onPressed: () {
              favProvider.setFav(songProvider.currentSong!);
            },
            icon: favProvider.isFavorite(songProvider.currentSong!)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.pinkAccent,
                  )
                : const Icon(
                    Icons.favorite_border,
                  ),
          ),
          const SizedBox(
            width: 15,
          ),
          //More actions button
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_outlined,
              )),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            songProvider.currentSong!.imageUrl,
            fit: BoxFit.cover,
          ),
          const _BackgroundFilter(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  songProvider.currentSong!.songName,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  songProvider.currentSong!.singer,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(
                  height: 50,
                ),
                RotationTransition(
                  turns: animation,
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        NetworkImage(songProvider.currentSong!.imageUrl),
                    radius: screenWidth / 3,
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Slider.adaptive(
                  activeColor: Colors.deepOrange[400],
                  inactiveColor: Colors.blueGrey[200],
                  max: songProvider.maxValue!,
                  min: 0,
                  value: songProvider.playProgress! > songProvider.maxValue!
                      ? songProvider.maxValue!
                      : songProvider.playProgress!,
                  onChanged: (value) {
                    songProvider.playProgress = value;
                    songProvider.audioPlayer
                        .seek(Duration(milliseconds: value.toInt()));
                    songProvider.audioPlayer.resume();
                  },
                  onChangeEnd: (value) {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(Duration(
                            milliseconds: songProvider.playProgress!.toInt())),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        formatTime(Duration(
                            milliseconds: songProvider.maxValue!.toInt())),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shuffle_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      iconSize: 45,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (songProvider.isPlaying) {
                          songProvider.audioPlayer.pause();
                        } else {
                          songProvider.audioPlayer.resume();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          songProvider.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          size: 75,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 45,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.repeat,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                playlistsProvider.currentPlaylist != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PlaylistScreen()));
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      playlistsProvider
                                          .currentPlaylist!.imageUrl,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'From playlist:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      playlistsProvider.currentPlaylist!.title,
                                      style: const TextStyle(
                                          color: Colors.yellowAccent,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.arrow_right_rounded,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _MusicPlayer extends StatefulWidget {
//   const _MusicPlayer({
//     required this.song,
//     //required Stream<SeekBarData> seekBarDataStream,
//     //required this.audioPlayer,
//   }) //: _seekBarDataStream = seekBarDataStream;

//   final Song song;
//   final Stream<SeekBarData> _seekBarDataStream;
//   final AudioPlayer audioPlayer;

//   @override
//   State<_MusicPlayer> createState() => _MusicPlayerState();
// }

// class _MusicPlayerState extends State<_MusicPlayer>
//     with TickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<double> animation;

//   @override
//   void initState() {
//     super.initState();

//     controller =
//         AnimationController(vsync: this, duration: const Duration(seconds: 14));
//     animation = ReverseAnimation(controller);
//     controller.repeat();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20.0,
//         vertical: 40.0,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             widget.song.songName,
//             style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 35,
//                 ),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             widget.song.singer,
//             maxLines: 2,
//             style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontStyle: FontStyle.italic,
//                 ),
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           RotationTransition(
//             turns: animation,
//             alignment: Alignment.center,
//             child: CircleAvatar(
//               backgroundColor: Colors.transparent,
//               backgroundImage: NetworkImage(widget.song.imageUrl),
//               radius: screenWidth / 3,
//             ),
//           ),
//           const SizedBox(
//             height: 70,
//           ),
//           StreamBuilder(
//             stream: widget._seekBarDataStream,
//             builder: (context, snapshot) {
//               final positionData = snapshot.data;
//               return SeekBar(
//                 position: positionData?.position ?? Duration.zero,
//                 duration: positionData?.duration ?? Duration.zero,
//                 onChangeEnd: widget.audioPlayer.seek,
//               );
//             },
//           ),
//           PlayerButton(audioPlayer: widget.audioPlayer),
//           const SizedBox(
//             height: 30,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               IconButton(
//                 iconSize: 30,
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.mode_comment_outlined,
//                   color: Colors.white,
//                 ),
//               ),
//               IconButton(
//                 iconSize: 30,
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.favorite_outline,
//                   color: Colors.white,
//                 ),
//               ),
//               IconButton(
//                 iconSize: 30,
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.downloading_outlined,
//                   color: Colors.white,
//                 ),
//               ),
//               IconButton(
//                 iconSize: 30,
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.playlist_add,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.05),
            ],
            stops: const [
              0.0,
              0.3,
              0.7
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black87,
              Colors.black,
            ],
          ),
        ),
      ),
    );
  }
}
