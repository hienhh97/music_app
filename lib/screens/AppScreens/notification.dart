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
  final List<NotificationModel> checkedNotiList = [], unCheckedNotiList = [];

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
    final scrHeight = MediaQuery.of(context).size.height;
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Notifications'),
        centerTitle: true,
        actions: const [Icon(Icons.mark_email_unread)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
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
                return NotificationListView(
                  myNotises: unCheckedNtf,
                  scrHeight: scrHeight,
                  color: Colors.white,
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Older notices',
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  fontStyle: FontStyle.italic),
            ),
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
                return NotificationListView(
                  myNotises: checkedNtf,
                  scrHeight: scrHeight,
                  color: Colors.white54,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationListView extends StatelessWidget {
  const NotificationListView({
    super.key,
    required this.myNotises,
    required this.scrHeight,
    required this.color,
  });

  final List<NotificationModel> myNotises;
  final double scrHeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);
    return ListView.builder(
      itemCount: myNotises.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.deepPurple[800],
                builder: (context) => FractionallySizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 2,
                                    color: Colors.deepPurple.shade400)),
                          ),
                          child: Center(
                            child: Text(
                              myNotises[index].title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
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
                              '${myNotises[index].timeCreated!.toDate().hour}:${myNotises[index].timeCreated!.toDate().minute}',
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 20),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${myNotises[index].timeCreated!.toDate().month}/${myNotises[index].timeCreated!.toDate().day}/${myNotises[index].timeCreated!.toDate().year}',
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '    ${myNotises[index].body}',
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
                padding: EdgeInsets.symmetric(
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
                            myNotises[index].title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                            '${myNotises[index].timeCreated!.toDate().hour}:${myNotises[index].timeCreated!.toDate().minute}'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            '${myNotises[index].timeCreated!.toDate().month}/${myNotises[index].timeCreated!.toDate().day}/${myNotises[index].timeCreated!.toDate().year}'),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      myNotises[index].body,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: 16),
                      maxLines: 2,
                    ),
                    myNotises[index].isChecked == false
                        ? TextButton(
                            onPressed: () {
                              notificationProvider.updateNtf(myNotises[index]);
                            },
                            child: const Text(
                              'Mark as read',
                              style: TextStyle(color: Colors.red),
                            ))
                        : IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete_forever_outlined))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
