import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? id;
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final String? image;
  final List<String> favSongs;

  const UserModel({
    this.uid = '',
    this.id,
    this.age = 0,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.image,
    this.favSongs = const [],
  });

  toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'age': age,
      'email': email,
      'image': image,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      uid: data["uid"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      age: data["age"],
      email: data["email"],
      image: data['image'],
    );
  }

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String? ?? '',
        uid: json['uid'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        image: json['image'] as String? ?? '',
        age: json['age'] as int? ?? 0,
        favSongs: ((json['favSongs'] ?? []) as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );
}
