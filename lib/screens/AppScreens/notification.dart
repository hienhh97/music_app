import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/notifcation.dart';
import 'package:music_app/providers/notification_provider.dart';
import 'package:music_app/providers/store.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  final String? payload;

  const NotificationScreen({this.payload, super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Stream<List<NotificationModel>> readUnCheckedNtf, readCheckedNtf;
  bool isEditing = false;

  Stream<List<NotificationModel>> getUnCheckedNtf() =>
      FirebaseFirestore.instance
          .collection('notifications')
          .where('userID', isEqualTo: Store.instance.currentUser.id)
          .where('isChecked', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data()))
              .toList());

  Stream<List<NotificationModel>> getCheckedNtf() => FirebaseFirestore.instance
      .collection('notifications')
      .where('userID', isEqualTo: Store.instance.currentUser.id)
      .where('isChecked', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList());

  @override
  void initState() {
    super.initState();
    readUnCheckedNtf = getUnCheckedNtf();
    readCheckedNtf = getCheckedNtf();
  }

  @override
  Widget build(BuildContext context) {
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
              icon: Icon(
                Icons.edit_outlined,
                color: !isEditing ? Colors.white : Colors.deepOrange,
              )),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            notificationProvider.userNotifications.isEmpty
                ? const Text(
                    'You have no any new notifications!',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  )
                : TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                backgroundColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: const Text(
                                  'MARK ALL AS READ?',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        notificationProvider.markReadListNtf(
                                            notificationProvider
                                                .userNotifications);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 18),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 18),
                                      )),
                                ],
                              ));
                    },
                    child: const Text(
                      'MARK ALL AS READ!',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontStyle: FontStyle.italic),
                    )),
            StreamBuilder(
              stream: readUnCheckedNtf,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Text('loading!');
                }
                final unCheckedNtf = snapshot.data!;

                return ListView.builder(
                  itemCount: unCheckedNtf.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return NotificationsListView(
                      ntf: unCheckedNtf[index],
                      color: Colors.white,
                    );
                  },
                );
              },
            ),
            notificationProvider.userCheckedNotifications.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Older notices',
                            style: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        backgroundColor: Colors.black54,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        title: const Text(
                                          'REMOVE ALL OLD NOTIFICATIONS?',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 18),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                notificationProvider.removeListNtf(
                                                    notificationProvider
                                                        .userCheckedNotifications);
                                              },
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 18),
                                              )),
                                        ],
                                      ));
                            },
                            child: const Text(
                              'REMOVE ALL OLD NOTICES',
                              style: TextStyle(
                                  color: Colors.deepOrange, fontSize: 18),
                            ))
                      ],
                    ),
                  )
                : Container(),
            StreamBuilder(
              stream: readCheckedNtf,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Text('loading!');
                }
                final checkedNtf = snapshot.data!.reversed.toList();
                notificationProvider.userCheckedNotifications = checkedNtf;

                return ListView.builder(
                  itemCount: checkedNtf.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return NotificationsListView(
                      ntf: checkedNtf[index],
                      color: Colors.white54,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
