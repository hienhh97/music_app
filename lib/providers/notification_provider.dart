import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/notifcation.dart';

class NotificationProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  List<NotificationModel> _userNotifications = [];
  List<NotificationModel> get userNotifications => _userNotifications;

  set userNotifications(List<NotificationModel> list) {
    _userNotifications = list;
  }

  List<NotificationModel> _userCheckedNotifications = [];
  List<NotificationModel> get userCheckedNotifications =>
      _userCheckedNotifications;

  set userCheckedNotifications(List<NotificationModel> list) {
    _userCheckedNotifications = list;
  }

  Future<void> markReadNtf(NotificationModel ntf) async {
    await _firestore
        .collection('notifications')
        .doc(ntf.id)
        .update({"isChecked": true});
  }

  Future<void> markReadListNtf(List<NotificationModel> list) async {
    for (var ntf in list) {
      _firestore
          .collection('notifications')
          .doc(ntf.id)
          .update({"isChecked": true});
    }
  }

  Future<void> sendNtfToFirestore(
      String title, String userID, String body) async {
    final docNtf = _firestore.collection('notifications').doc();
    await docNtf.set({
      'id': docNtf.id,
      'title': title,
      'body': body,
      'userID': userID,
      'isChecked': false,
      'timeCreated': Timestamp.now(),
    });
  }

  Future<void> removeListNtf(List<NotificationModel> list) async {
    for (var ntf in list) {
      await _firestore.collection('notifications').doc(ntf.id).delete();
    }
  }

  Future<void> removeNtf(NotificationModel ntf) async {
    await _firestore.collection('notifications').doc(ntf.id).delete();
  }
}
