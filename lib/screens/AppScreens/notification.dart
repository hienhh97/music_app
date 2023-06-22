import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/notifcation.dart';
import 'package:music_app/providers/notification_provider.dart';
import 'package:music_app/providers/store.dart';
import 'package:provider/provider.dart';

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

                if (unCheckedNtf.isEmpty) {
                  return const Text(
                    'You have no any new notifications!',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  );
                }
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
                            child: Text(
                              'REMOVE ALL NOTICES',
                              style: TextStyle(
                                  color: Colors.red[900], fontSize: 18),
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

class NotificationsListView extends StatelessWidget {
  const NotificationsListView({
    super.key,
    required this.ntf,
    required this.color,
  });

  final NotificationModel ntf;
  final Color color;

  @override
  Widget build(BuildContext context) {
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);
    final scrHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: GestureDetector(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: const Text(
                      'Remove this notification?',
                      style: TextStyle(color: Colors.blue, fontSize: 22),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            notificationProvider.removeNtf(ntf);
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          )),
                    ],
                  ));
        },
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Colors.deepPurple[800],
            builder: (context) => FractionallySizedBox(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2, color: Colors.deepPurple.shade400)),
                      ),
                      child: Center(
                        child: Text(
                          ntf.title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${ntf.timeCreated!.toDate().hour}:${ntf.timeCreated!.toDate().minute}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 20),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          '${ntf.timeCreated!.toDate().month}/${ntf.timeCreated!.toDate().day}/${ntf.timeCreated!.toDate().year}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '    ${ntf.body}',
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          color: Colors.white),
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Container(
          height: scrHeight / 7,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        ntf.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                        '${ntf.timeCreated!.toDate().hour}:${ntf.timeCreated!.toDate().minute}'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        '${ntf.timeCreated!.toDate().month}/${ntf.timeCreated!.toDate().day}/${ntf.timeCreated!.toDate().year}'),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  ntf.body,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis, fontSize: 16),
                  maxLines: 2,
                ),
                ntf.isChecked == false
                    ? TextButton(
                        onPressed: () {
                          notificationProvider.updateNtf(ntf);
                        },
                        child: const Text(
                          'Mark as read',
                          style: TextStyle(color: Colors.red),
                        ))
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
