import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/providers/store.dart';

import '../../../widgets/widgets.dart';

class AllFavPlaylist extends StatefulWidget {
  const AllFavPlaylist({super.key});

  @override
  State<AllFavPlaylist> createState() => _AllFavPlaylistState();
}

class _AllFavPlaylistState extends State<AllFavPlaylist> {
  late Future<List<Playlist>> readUserAllPlaylist;

  Future<List<Playlist>> getUserAllPlaylists() async {
    var ref = FirebaseFirestore.instance
        .collection('playlists')
        .where('createdBy', isEqualTo: Store.instance.currentUser.id);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((i) => i.data());
    var playlists = data.map((e) => Playlist.fromJson(e));
    return playlists.toList();
  }

  @override
  void initState() {
    super.initState();
    readUserAllPlaylist = getUserAllPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        FutureBuilder<List<Playlist>>(
            future: readUserAllPlaylist,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('loading!');
              } else if (snapshot.hasData) {
                var myPlaylists = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: myPlaylists.length,
                  itemBuilder: (context, index) {
                    return PlaylistCard(playlist: myPlaylists[index]);
                  },
                );
                ;
              } else {
                return const Text(
                    'No topics found in Firestore. Check database');
              }
            }),
      ],
    ));
  }
}
