import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

import '../models/account.dart';

class FavProvider with ChangeNotifier {
  List<Song> songs = [];

  List<String> _favoriteListSongIDs = [];
  List<String> get favoriteListSongIDs => _favoriteListSongIDs;

  set favoriteListSongIDs(List<String> songs) {
    // _favorite.clear();
    _favoriteListSongIDs = songs;
  }

  UserModel? userData;
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future getUserDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUser.uid)
        .get();
    userData = snapshot.docs.map((e) => UserModel.fromJson(e.data())).single;
    return userData;
  }

  Future<void> updateList() async {
    await getUserDetails().whenComplete(() => FirebaseFirestore.instance
        .collection("users")
        .doc(userData!.id)
        .update({"favSongs": _favoriteListSongIDs}));
  }

  setFav(Song song) {
    if (!isFavorite(song)) {
      _favoriteListSongIDs.add(song.id);
      songs.add(song);
    } else {
      _favoriteListSongIDs.removeWhere((element) => element == song.id);
      songs.removeWhere((element) => element.id == song.id);
    }

    updateList();
  }

  isFavorite(Song song) {
    if (_favoriteListSongIDs.indexWhere((element) => element == song.id) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }
}
