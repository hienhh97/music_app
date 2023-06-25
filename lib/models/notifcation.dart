import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userID;
  final String title;
  final String body;
  final bool isChecked;
  final Timestamp? timeCreated;

  const NotificationModel({
    this.id = '',
    this.title = '',
    this.userID = '',
    this.body = '',
    this.isChecked = false,
    this.timeCreated,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userID': userID,
        'title': title,
        'isChecked': isChecked,
        'timeCreated': timeCreated,
      };

  static NotificationModel fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String? ?? '',
        userID: json['userID'] as String? ?? '',
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        isChecked: json['isChecked'] as bool,
        timeCreated: json['timeCreated'] as Timestamp?,
      );
}
