import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

class FavProvider with ChangeNotifier {
  List<Song> _favorite = [];
  List<Song> get favorite => _favorite;
  set favorite(List<Song> songs) {
    _favorite = songs;
    notifyListeners();
  }

  setFav(Song song) {
    if (!isFavorite(song)) {
      _favorite.add(song);
    } else {
      _favorite.removeWhere((element) => element.id == song.id);
    }
  }

  isFavorite(Song song) {
    if (_favorite.indexWhere((element) => element.id == song.id) == -1) {
      return false;
    } else {
      return true;
    }
  }
}
