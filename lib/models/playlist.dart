import 'package:music_app/models/song.dart';
import '../providers/song_provider.dart';

class Playlist {
  final String id;
  final String title;
  final String imageUrl;
  //final List<Song> songs;
  final List<String> songIDs;

  Playlist({
    this.id = '',
    this.title = '',
    this.imageUrl = '',
    this.songIDs = const [],
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'imageUrl': imageUrl,
        'songIDs': songIDs,
      };

  static Playlist fromJson(Map<String, dynamic> json) => Playlist(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        songIDs:
            (json['songIDs'] as List<dynamic>).map((e) => e as String).toList(),
        // songs: (json['songs'] as List<dynamic>?)
        //         ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
        //         .toList() ??
        //     const [],
      );
  Future<List<Song>> getListSong() async {
    List<Song> result = [];
    for (var songID in songIDs) {
      result.add(SongProvider.instance.getByID(songID));
    }
    return result;
  }

  Song getMusicAtIndex(int index) {
    final musicId = songIDs[index];
    return SongProvider.instance.getByID(musicId);
  }
}
