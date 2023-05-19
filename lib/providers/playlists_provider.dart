import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';

class PlaylistsProvider with ChangeNotifier {
  Playlist? _currentPlaylist, _selectedPlaylist;
  Playlist? get selectedPlaylist => _selectedPlaylist;
  Playlist? get currentPlaylist => _currentPlaylist;

  set currentPlaylist(Playlist? current) {
    _currentPlaylist = current;
    notifyListeners();
  }

  set selectedPlaylist(Playlist? selected) {
    _selectedPlaylist = selected;
    notifyListeners();
  }
}
