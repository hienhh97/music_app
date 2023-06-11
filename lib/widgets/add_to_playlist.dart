import 'package:flutter/material.dart';

import '../providers/playlists_provider.dart';
import '../screens/AppScreens/components/playlist_filter.dart';

Future<dynamic> addToPlaylist(
    BuildContext context,
    PlaylistsProvider playlistsProvider,
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.deepPurple[800],
      builder: (modalBottomsheetCont) => FractionallySizedBox(
            heightFactor: 0.7,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: Colors.deepPurple.shade400))),
                      child: const Center(
                        child: Text(
                          'Add song to playlist',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    PlaylistsFilter(
                      playlists: playlistsProvider.allPlaylists,
                      scaffoldMessengerKey: scaffoldMessengerKey,
                    )
                  ],
                ),
              ),
            ),
          ));
}
