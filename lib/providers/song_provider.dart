import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

enum RepeatMode { off, one, all }

class SongProvider with ChangeNotifier {
  double? playProgress = 0, maxValue = 1;
  bool _isRunning = false;
  bool get isRunning => _isRunning;
  int _time = 0;
  int get time => _time;
  final audioPlayer = AudioPlayer();
  int _currentIndex = -1;
  List<Song> _songList = [];
  bool shuffleMode = false;
  RepeatMode repeatMode = RepeatMode.off;
  final List<int> _playedIndexes = [];
  PlayerState state = PlayerState.STOPPED;

  List<Song> _allSongs = [];
  List<Song> get allSongs => _allSongs;
  set allSongs(List<Song> songs) {
    _allSongs = songs;
    ChangeNotifier();
  }

  Song getByID(String id) => _allSongs.firstWhere((song) => song.id == id);

  Song? get currentSong {
    audioPlayer.onPlayerCompletion;
    if (_currentIndex == -1) {
      return null;
    }
    return _songList[_currentIndex];
  }

  //Choose a single song
  void setSong(Song song) {
    _songList.clear();
    _playedIndexes.clear();
    _songList.add(song);
    _currentIndex = 0;
    _playSong(song);
    notifyListeners();
  }

  //Choose a random song from playlist
  void setPlaylist(List<Song> currentList, {int? index, bool shuffle = false}) {
    assert((index != null && !shuffle) || (index == null && shuffle));
    _songList.clear();
    _playedIndexes.clear();

    _songList = currentList;
    //Play all songs from Shuffle Mode or Normally
    if (shuffle == true) {
      _currentIndex = Random().nextInt(_songList.length);
    } else {
      _currentIndex = index!;
    }

    final firstSong = _songList[_currentIndex];
    shuffleMode = shuffle;
    _playSong(firstSong);
    notifyListeners();
  }

  void onChangePlayerState() {
    if (state == PlayerState.PLAYING) {
      audioPlayer.pause();
      state = PlayerState.PAUSED;
    } else if (state == PlayerState.PAUSED) {
      audioPlayer.resume();
      state = PlayerState.PLAYING;
    }
    notifyListeners();
  }

  void onChangeShuffleMode() {
    shuffleMode = !shuffleMode;
  }

  void onChangeRepeatMode() {
    if (repeatMode == RepeatMode.off) {
      repeatMode = RepeatMode.all;
    } else if (repeatMode == RepeatMode.all) {
      repeatMode = RepeatMode.one;
    } else {
      repeatMode = RepeatMode.off;
    }
  }

  void playNext([bool isTapToNext = false]) {
    _playedIndexes.add(_currentIndex);

    switch (repeatMode) {
      case RepeatMode.off:
        if (_playedIndexes.toSet().length == _songList.length && isTapToNext) {
          state = PlayerState.PAUSED;
        } else {
          _currentIndex = shuffleMode
              ? _getNextRandomIndex()
              : ((_currentIndex + 1) % _songList.length);
          _playSong(_songList[_currentIndex]);
        }
        notifyListeners();
        break;

      case RepeatMode.one:
        if (isTapToNext) {
          _playSong(_songList[_currentIndex]);
        } else {
          _currentIndex = shuffleMode
              ? _getNextRandomIndex()
              : ((_currentIndex + 1) % _songList.length);
          _playSong(_songList[_currentIndex]);
          notifyListeners();
        }
        break;
      case RepeatMode.all:
        _currentIndex = shuffleMode
            ? _getNextRandomIndex()
            : ((_currentIndex + 1) % _songList.length);
        _playSong(_songList[_currentIndex]);
        notifyListeners();
        break;
    }
  }

  void playPrevious() {
    if (_playedIndexes.isEmpty) {
      audioPlayer.seek(Duration.zero);
      if (state == PlayerState.PAUSED) {
        audioPlayer.resume();
        state = PlayerState.PLAYING;
        notifyListeners();
      }
    } else {
      _currentIndex = _playedIndexes.last;
      _playedIndexes.removeLast();
      _playSong(_songList[_currentIndex]);
      notifyListeners();
    }
  }

  set isRunning(bool isRunning) {
    _isRunning = isRunning;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isRunning) {
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

  _playSong(Song song) {
    audioPlayer.play(song.songUrl);
    state = PlayerState.PLAYING;
    audioPlayer.onPlayerStateChanged.listen((event) {
      isRunning = event == PlayerState.PLAYING;
    });
    audioPlayer.onDurationChanged.listen((event) {
      maxValue = event.inMilliseconds.toDouble();
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      playProgress = event.inMilliseconds.toDouble();
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      playNext(true);
      notifyListeners();
    });
  }

  int _getNextRandomIndex() {
    List<int> pool = [for (var i = 0; i < _songList.length; i++) i];
    for (int i = _playedIndexes.length - 1;
        i >= max(0, _playedIndexes.length - _songList.length + 1);
        i--) {
      pool.remove(_playedIndexes[i]);
    }
    return pool[Random().nextInt(pool.length)];
  }
}
