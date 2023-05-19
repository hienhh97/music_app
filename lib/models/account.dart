class User {
  final String uid;
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final List<String> userFavSongs;

  User({
    this.age = 0,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.uid = '',
    this.userFavSongs = const [],
  });

  static User fromJson(Map<String, dynamic> json) => User(
        uid: json['uid'] as String? ?? '',
        firstName: json['firstname'] as String? ?? '',
        lastName: json['lastname'] as String? ?? '',
        age: json['age'] as int? ?? 0,
        email: json['email'] as String? ?? '',
        userFavSongs: (json['userFavSongs'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );
}
