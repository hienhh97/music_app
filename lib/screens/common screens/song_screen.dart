import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/models/song.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../../widgets/widgets.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  Song song = Get.arguments;

  // Stream<List<Song>> readSongs() => FirebaseFirestore.instance
  //     .collection('songs')
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs
  //         .map((doc) => Song.fromJson(doc.data(), doc.id))
  //         .toList());

  @override
  void initState() {
    super.initState();

    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse(
              song.songUrl,
            ),
          ),
        ],
      ),
    );
  }

  void _init() async {}

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream,
          (Duration position, Duration? duration) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: //StreamBuilder<List<Song>>(
          //   stream: readSongs(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return const Text('something went wrong!');
          //     } else if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Text('loading!');
          //     }

          //     final songs = snapshot.data!;
          //     //final song = Get.arguments ?? songs[0];

          /*return*/ Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            song.imageUrl,
            fit: BoxFit.cover,
          ),
          const _BackgroundFilter(),
          _MusicPlayer(
            song: song,
            seekBarDataStream: _seekBarDataStream,
            audioPlayer: audioPlayer,
          ),
        ],
      ),
      //},
      //),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    super.key,
    required this.song,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
  }) : _seekBarDataStream = seekBarDataStream;

  final Song song;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.songName,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            song.singer,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 40,
          ),
          StreamBuilder(
            stream: _seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: audioPlayer.seek,
              );
            },
          ),
          PlayerButton(audioPlayer: audioPlayer),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: const Icon(
                  Icons.mode_comment_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline,
                  color: Colors.white,
                ),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: const Icon(
                  Icons.downloading_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: const Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
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
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.3,
              0.7
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade200,
              Colors.grey,
            ],
          ),
        ),
      ),
    );
  }
}
