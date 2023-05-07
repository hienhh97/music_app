import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButton extends StatefulWidget {
  const PlayerButton({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  State<PlayerButton> createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<bool>(
          stream: widget.audioPlayer.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;

            return IconButton(
                onPressed: () {
                  widget.audioPlayer.setShuffleModeEnabled(
                      !widget.audioPlayer.shuffleModeEnabled);
                },
                icon: shuffleModeEnabled
                    ? const Icon(
                        Icons.shuffle_outlined,
                        color: Colors.orange,
                      )
                    : const Icon(
                        Icons.shuffle_outlined,
                        color: Colors.white,
                      ));
          },
        ),
        const SizedBox(
          width: 20,
        ),
        StreamBuilder<SequenceState?>(
          stream: widget.audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return IconButton(
              onPressed: widget.audioPlayer.hasPrevious
                  ? widget.audioPlayer.seekToPrevious
                  : null,
              iconSize: 45.0,
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
              ),
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 64.0,
                  height: 64.0,
                  margin: const EdgeInsets.all(10.0),
                  child: const CircularProgressIndicator(),
                );
              } else if (!widget.audioPlayer.playing) {
                return IconButton(
                  onPressed: widget.audioPlayer.play,
                  iconSize: 75,
                  icon: const Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  onPressed: widget.audioPlayer.pause,
                  iconSize: 75,
                  icon: const Icon(
                    Icons.pause_circle,
                    color: Colors.white,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () => widget.audioPlayer.seek(Duration.zero,
                      index: widget.audioPlayer.effectiveIndices!.first),
                  iconSize: 75,
                  icon: const Icon(
                    Icons.replay_circle_filled_outlined,
                    color: Colors.white,
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: widget.audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return IconButton(
              onPressed: widget.audioPlayer.hasNext
                  ? widget.audioPlayer.seekToNext
                  : null,
              iconSize: 45.0,
              icon: const Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
            );
          },
        ),
        const SizedBox(
          width: 20,
        ),
        StreamBuilder<LoopMode>(
          stream: widget.audioPlayer.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            const icons = [
              Icon(Icons.repeat, color: Colors.grey),
              Icon(Icons.repeat, color: Colors.orange),
              Icon(Icons.repeat_one, color: Colors.orange),
            ];
            const cycleModes = [
              LoopMode.off,
              LoopMode.all,
              LoopMode.one,
            ];
            final index = cycleModes.indexOf(loopMode);
            return IconButton(
              icon: icons[index],
              onPressed: () {
                widget.audioPlayer.setLoopMode(cycleModes[
                    (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
              },
            );
          },
        ),
      ],
    );
  }
}
