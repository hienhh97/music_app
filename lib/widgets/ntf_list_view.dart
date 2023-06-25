import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notifcation.dart';
import '../providers/notification_provider.dart';

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
                          notificationProvider.markReadNtf(ntf);
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
