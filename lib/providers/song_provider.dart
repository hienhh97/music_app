import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song.dart';

class SongProvider {
  static final instance = SongProvider._internal();
  SongProvider._internal();

  final List<Song> _list = [];

  List<Song> get list => [..._list];
  Song getByID(String id) => _list.firstWhere((song) => song.id == id);

  Future<void> fetchAndSetData() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('songs').get();
      final queryDocumentSnapshot = querySnapshot.docs;

      _list.clear();
      for (var qds in queryDocumentSnapshot) {
        try {
          final song = Song.fromJson(qds.data());
          _list.add(song);
        } catch (err) {
          print('<<Exception-AllMusics-fetchAndSetData-${qds.id}>>' +
              err.toString());
        }
      }
    } catch (err) {
      print('<<Exception-AllMusics-fetchAndSetData>> ' + err.toString());
    }
  }
}
