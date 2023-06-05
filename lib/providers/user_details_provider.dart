import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/account.dart';

class UserDetailsProvider with ChangeNotifier {
  UserModel? userData;
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future getUserDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUser.uid)
        .get();
    userData = snapshot.docs.map((e) => UserModel.fromJson(e.data())).single;
    return userData;
  }
}
