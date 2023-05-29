import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? id;
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final String? image;
  final List<String>? favSongs;

  const UserModel({
    this.uid,
    this.id,
    required this.age,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    this.favSongs,
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
      firstName: data["firstname"],
      lastName: data["lastname"],
      age: data["age"],
      email: data["email"],
      image: data['image'],
    );
  }
}
