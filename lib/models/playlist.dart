import 'package:music_app/models/song.dart';

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
}
