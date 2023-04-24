class Song {
  final String id;
  final String songName;
  final String singer;
  final String songAuthor;
  final String imageUrl;
  final String songUrl;

  Song({
    required this.id,
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

  static Song fromJson(Map<String, dynamic> json, String id) => Song(
        id: id,
        songName: json['songName'],
        singer: json['singer'],
        songAuthor: json['songAuthor'],
        imageUrl: json['imageUrl'],
        songUrl: json['songUrl'],
      );
}


// class Song {
//   final String songName;
//   final String singer;
//   final String songAuthor;
//   final String imageUrl;
//   final String songUrl;

//   Song({
//     required this.songName,
//     required this.singer,
//     required this.songAuthor,
//     required this.imageUrl,
//     required this.songUrl,
//   });

//   static List<Song> songs = [
//     Song(
//         songName: 'lac',
//         singer: 'Rhymastic',
//         songAuthor: 'Rhymastic',
//         imageUrl: 'assets/images/Lac.jpg',
//         songUrl: 'assets/music/Lac.mp3'),
//     Song(
//         songName: 'lac',
//         singer: 'Rhymastic',
//         songAuthor: 'Rhymastic',
//         imageUrl: 'assets/images/Lac.jpg',
//         songUrl: 'assets/music/Lac.mp3'),
//     Song(
//         songName: 'lac',
//         singer: 'Rhymastic',
//         songAuthor: 'Rhymastic',
//         imageUrl: 'assets/images/Lac.jpg',
//         songUrl: 'assets/music/Lac.mp3'),
//   ];
// }
