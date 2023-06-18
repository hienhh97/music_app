import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/models/song.dart';

class PlaylistsProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

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

  //All playlists
  List<Playlist> _allPlaylists = [];
  List<Playlist> get allPlaylists => _allPlaylists;

  set allPlaylists(List<Playlist> all) {
    _allPlaylists = all;
  }

  //All playlist of current user
  List<Playlist> _userAllPlaylists = [];
  List<Playlist> get userAllPlaylists => _userAllPlaylists;

  set userAllPlaylists(List<Playlist> all) {
    _userAllPlaylists = all;
  }

  Future<bool> addSongToPlaylist(Playlist playlist, Song song) async {
    final listIDs = playlist.songIDs;

    if (!isSongofPlaylist(playlist, song)) {
      listIDs.add(song.id);
      _firestore
          .collection('playlists')
          .doc(playlist.id)
          .update({"songIDs": listIDs});
      return true;
    } else {
      return false;
    }
  }

  Future<void> removeSongFromPlaylist(Playlist playlist, Song song) async {
    final listIDs = playlist.songIDs;
    if (isSongofPlaylist(playlist, song)) {
      listIDs.remove(song.id);

      _firestore
          .collection('playlists')
          .doc(playlist.id)
          .update({"songIDs": listIDs});
    }
  }

  Future<void> createNewPlaylist(String playlistName, Song? firstSong) async {
    final docPlaylist = _firestore.collection('playlists').doc();
    final currentUser = FirebaseAuth.instance.currentUser;
    final playlist = Playlist(
      id: docPlaylist.id,
      imageUrl: firstSong!.imageUrl,
      songIDs: firstSong.id != '' ? [firstSong.id] : [],
      title: playlistName,
      createdBy: currentUser!.uid,
    );
    final json = playlist.toJson();
    await docPlaylist.set(json);
  }

  Future<void> removeMyPlaylist(Playlist playlist) async {
    final selectedPlaylist =
        _firestore.collection('playlists').doc(playlist.id);
    selectedPlaylist.delete();
  }

  isSongofPlaylist(Playlist playlist, Song song) {
    if (playlist.songIDs.indexWhere((element) => element == song.id) == -1) {
      return false;
    } else {
      return true;
    }
  }
}
