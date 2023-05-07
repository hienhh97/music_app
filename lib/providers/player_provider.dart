import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

class PlayerProvider with ChangeNotifier {
  Song? _currentSong;
  Song? get currentSong => _currentSong;
  double? playProgress = 0, maxValue = 1;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  int _time = 0;
  int get time => _time;
  final audioPlayer = AudioPlayer();

  set currentSong(Song? current) {
    _currentSong = current;
    setAudio(current!.songUrl);
    notifyListeners();
  }

  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPlaying) {
        time += 1;
      } else {
        timer.cancel();
        time = 0;
      }
    });
    notifyListeners();
  }

  set time(int time) {
    _time = time;
    notifyListeners();
  }

  setAudio(String song) async {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    await audioPlayer.setUrl(song, isLocal: true);
    audioPlayer.play(song);
    audioPlayer.onPlayerStateChanged.listen((event) {
      isPlaying = event == PlayerState.PLAYING;
    });
    audioPlayer.onDurationChanged.listen((event) {
      maxValue = event.inMilliseconds.toDouble();
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      playProgress = event.inMilliseconds.toDouble();
    });
  }
}
