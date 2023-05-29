class Song {
  final String id;
  final String songName;
  final String singer;
  final String songAuthor;
  final String imageUrl;
  final String songUrl;

  Song({
    this.songName = '',
    this.singer = '',
    this.songAuthor = '',
    this.imageUrl = '',
    this.id = '',
    this.songUrl = '',
  });

  static Song fromJson(Map<String, dynamic> json) => Song(
        id: json['id'] as String? ?? '',
        songName: json['songName'] as String? ?? '',
        singer: json['singer'] as String? ?? '',
        songAuthor: json['songAuthor'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        songUrl: json['songUrl'] as String? ?? '',
      );
}
