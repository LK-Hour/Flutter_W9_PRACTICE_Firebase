import 'package:flutter/material.dart';

import '../../../domain/model/songs/song_details.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.songDetails,
    required this.isPlaying,
    required this.onTap,
  });

  final SongDetails songDetails;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(songDetails.song.title),
          subtitle: Row(
            children: [
              Text("${songDetails.song.duration.inMinutes} mins"),
              SizedBox(width: 20),
              Text(songDetails.artist.name),
              SizedBox(width: 20),
              Text(songDetails.artist.genre),
            ],
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(songDetails.song.imageUrl.toString()),
          ),
          trailing: Text(
            isPlaying ? "Playing" : "",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ),
    );
  }
}
