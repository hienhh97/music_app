class Song {
  final String songName;
  final String singer;
  final String songAuthor;
  final String imageUrl;
  final String songUrl;

  Song({
    required this.songName,
    required this.singer,
    required this.songAuthor,
    required this.imageUrl,
    required this.songUrl,
  });

  Map<String, dynamic> toJson() => {
        songName: 'songName',
        singer: 'singer',
        songAuthor: 'songAuthor',
        imageUrl: 'imageUrl',
        songUrl: 'songUrl',
      };

  static Song fromJson(Map<String, dynamic> json) => Song(
        songName: json['songName'],
        singer: json['singer'],
        songAuthor: json['songAuthor'],
        imageUrl: json['imageUrl'],
        songUrl: json['songUrl'],
      );
}
