import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/providers/playlists_provider.dart';
import 'package:music_app/providers/recent_played_provider.dart';
import 'package:music_app/providers/song_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';
import '../AppScreens/components/search_songs.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key, this.playlistID});

  final String? playlistID;

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  bool isShowDelButton = false;

  @override
  Widget build(BuildContext context) {
    SongProvider songProvider = Provider.of<SongProvider>(context);
    PlaylistsProvider playlistsProvider =
        Provider.of<PlaylistsProvider>(context);
    RecentProvider recentProvider = Provider.of<RecentProvider>(context);

    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: ThemeData.dark(useMaterial3: true),
        home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: screenHeight / 3,
                  backgroundColor: Colors.black87,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 2,
                    background: playlistsProvider.selectedPlaylist!.imageUrl !=
                            ''
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                playlistsProvider.selectedPlaylist!.imageUrl,
                                fit: BoxFit.cover,
                              ),
                              const _BackgroundFilter(),
                            ],
                          )
                        : Stack(fit: StackFit.expand, children: [
                            Image.asset(
                              'assets/images/no-image-album.jpg',
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    border:
                                        Border.all(color: Colors.deepPurple)),
                              ),
                            ),
                          ]),
                    title: Text(
                      playlistsProvider.selectedPlaylist!.title,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    centerTitle: true,
                    titlePadding: const EdgeInsets.all(10),
                  ),
                  actions: [
                    playlistsProvider.selectedPlaylist!.createdBy != 'admin'
                        ? Switch(
                            value: isShowDelButton,
                            activeColor: Colors.deepOrange,
                            inactiveThumbColor: Colors.white,
                            onChanged: (bool value) {
                              setState(() {
                                isShowDelButton = value;
                              });
                            })
                        : Container(),
                  ],
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
                buildItems(playlistsProvider, songProvider),
              ],
            ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              buttonSize: const Size(65, 65),
              childrenButtonSize: const Size(65, 65),
              gradientBoxShape: BoxShape.circle,
              spaceBetweenChildren: 10,
              backgroundColor: Colors.deepPurple[400],
              children: [
                SpeedDialChild(
                  child: const Icon(
                    Icons.shuffle_rounded,
                  ),
                  backgroundColor: Colors.deepOrange,
                  onTap: () {
                    final firstSong = songProvider.setPlaylist(
                        songProvider.getListSongByID(
                            playlistsProvider.selectedPlaylist!),
                        shuffle: true);
                    playlistsProvider.currentPlaylist =
                        playlistsProvider.selectedPlaylist;

                    recentProvider.setRecent(firstSong);
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                        context,
                        AnimatedPageRoute(
                            child: SearchSongScreen(
                                songs: songProvider.allSongs,
                                isSetSongToPlaylist: true),
                            direction: AxisDirection.left));
                  },
                )
              ],
            )));
  }

  SliverToBoxAdapter buildItems(
      PlaylistsProvider playlistsProvider, SongProvider songProvider) {
    final listSongSelected =
        songProvider.getListSongByID(playlistsProvider.selectedPlaylist!);
    return SliverToBoxAdapter(
      child: AnimatedList(
        key: _listKey,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        initialItemCount: listSongSelected.length,
        itemBuilder: (context, index, animation) {
          //list song proview
          return MusicItem(
              isShowDelButton: isShowDelButton,
              song: listSongSelected[index],
              songs: listSongSelected,
              playlist: playlistsProvider.selectedPlaylist!,
              index: index,
              animation: animation,
              scaffoldMessengerKey: scaffoldMessengerKey,
              onClicked: () {
                _removeSong(
                    songProvider
                        .getListSongByID(playlistsProvider.selectedPlaylist!),
                    songProvider.getByID(
                        playlistsProvider.selectedPlaylist!.songIDs[index]),
                    index,
                    playlistsProvider);
              });
        },
      ),
    );
  }

  void _removeSong(List<Song> songs, Song song, int index,
      PlaylistsProvider playlistsProvider) {
    final removedSong = song;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Warning!"),
              content: const Text("REMOVE this song from playlist?"),
              actions: [
                TextButton(
                    onPressed: () {
                      playlistsProvider
                          .removeSongFromPlaylist(
                              playlistsProvider.selectedPlaylist!, song)
                          .whenComplete(() => _listKey.currentState!.removeItem(
                              index,
                              (context, animation) => MusicItem(
                                  isShowDelButton: isShowDelButton,
                                  song: removedSong,
                                  index: index,
                                  songs: songs,
                                  animation: animation,
                                  playlist: playlistsProvider.selectedPlaylist!,
                                  scaffoldMessengerKey: scaffoldMessengerKey,
                                  onClicked: () {}),
                              duration: const Duration(milliseconds: 700)));
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
              Colors.white.withOpacity(1),
              Colors.white.withOpacity(.8),
              Colors.white.withOpacity(.05),
            ],
            stops: const [
              0.0,
              0.4,
              0.8
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
