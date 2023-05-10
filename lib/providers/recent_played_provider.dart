import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

class RecentProvider with ChangeNotifier {
  List<Song> _recent = [];
  List<Song> get recent => _recent;
  set recent(List<Song> songs) {
    _recent = songs;
    notifyListeners();
  }

  setRecent(Song song) {
    if (!isRecentPlayed(song)) {
      _recent.add(song);
    } else {
      _recent.removeWhere((element) => element.id == song.id);
      _recent.add(song);
    }
    notifyListeners();
  }

  isRecentPlayed(Song song) {
    if (_recent.indexWhere((element) => element.id == song.id) == -1) {
      return false;
    } else {
      return true;
    }
  }
}
