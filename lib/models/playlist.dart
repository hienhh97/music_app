class Playlist {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> songIDs;

  Playlist({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.songIDs,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'imageUrl': imageUrl,
        'songIDs': songIDs,
      };

  static Playlist fromJson(Map<String, dynamic> json, String id) => Playlist(
        id: id,
        title: json['title'],
        imageUrl: json['imageUrl'],
        songIDs:
            (json['songIDs'] as List<dynamic>).map((e) => e as String).toList(),
      );
}
