import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/providers/fav_provider.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/recent_played_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:music_app/screens/CommonScreens/playlist_screen.dart';
import 'package:provider/provider.dart';

import '../../const.dart';
import '../../widgets/widgets.dart';
import 'my_fav_songs.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key, this.currentSong});
  final Song? currentSong;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> with TickerProviderStateMixin {
  late AnimationController _songImgController, _playButtonController;
  late Animation<double> animation;
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    _songImgController =
        AnimationController(vsync: this, duration: const Duration(seconds: 14));
    animation = ReverseAnimation(_songImgController);
    _songImgController.repeat();
    _playButtonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _songImgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SongProvider songProvider = Provider.of<SongProvider>(context);
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    FavProvider favProvider = Provider.of<FavProvider>(context);
    RecentProvider recentProvider = Provider.of<RecentProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
            //Action buttons
            //
            //Add song to playlist
            IconButton(
                onPressed: () {
                  addToPlaylist(
                      context, playlistsProvider, scaffoldMessengerKey);
                },
                icon: const Icon(
                  Icons.add_circle_outline,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      songProvider.currentSong!.songName,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
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
                    //Rotate song image
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
                    // seek bar
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
                        songProvider.state = PlayerState.PLAYING;
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
                                milliseconds:
                                    songProvider.playProgress!.toInt())),
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
                          onPressed: () {
                            setState(() {
                              songProvider.onChangeShuffleMode();
                            });
                          },
                          icon: Icon(Icons.shuffle_outlined,
                              color: songProvider.shuffleMode
                                  ? Colors.deepPurpleAccent
                                  : Colors.white),
                        ),
                        IconButton(
                          iconSize: 45,
                          onPressed: () {
                            songProvider.playPrevious();
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              songProvider.onChangePlayerState();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              songProvider.state == PlayerState.PLAYING
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: 75,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 45,
                          onPressed: () async {
                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              songProvider.playNext();
                            });
                            recentProvider.setRecent(songProvider.currentSong!);
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              songProvider.onChangeRepeatMode();
                            });
                          },
                          icon: Icon(
                            songProvider.repeatMode == RepeatMode.off
                                ? Icons.repeat_rounded
                                : (songProvider.repeatMode == RepeatMode.one
                                    ? Icons.repeat_one_rounded
                                    : Icons.repeat_rounded),
                          ),
                          color: songProvider.repeatMode == RepeatMode.off
                              ? Colors.white
                              : Colors.deepPurpleAccent,
                        ),
                      ],
                    ),
                    playlistsProvider.currentPlaylist != null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                playlistsProvider.currentPlaylist?.id ==
                                        'fav-songs-list'
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyFavSongs()))
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PlaylistScreen(
                                                  playlistID: playlistsProvider
                                                      .currentPlaylist!.id,
                                                )));
                                ;
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'From playlist:',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          playlistsProvider
                                              .currentPlaylist!.title,
                                          style: const TextStyle(
                                              color: Colors.yellowAccent,
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              decoration:
                                                  TextDecoration.underline),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter();

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
