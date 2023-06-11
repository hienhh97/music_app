class Playlist {
  final String id;
  final String title;
  final String imageUrl;
  final String createdBy;
  final List<String> songIDs;

  Playlist({
    this.id = '',
    this.title = '',
    this.imageUrl = '',
    this.createdBy = '',
    this.songIDs = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'songIDs': songIDs,
        'createdBy': createdBy,
      };

  static Playlist fromJson(Map<String, dynamic> json) => Playlist(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        createdBy: json['createdBy'] as String? ?? '',
        songIDs: ((json['songIDs'] ?? []) as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );
}
