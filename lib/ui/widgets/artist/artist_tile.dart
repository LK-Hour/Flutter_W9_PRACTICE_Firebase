import 'package:flutter/material.dart';
import '../../../domain/model/artist/artist.dart';

class ArtistTile extends StatelessWidget {
  const ArtistTile({super.key, required this.artist, this.onTap});

  final Artist artist;
  final VoidCallback? onTap;

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
          leading: artist.imageUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(artist.imageUrl.toString()),
                )
              : const CircleAvatar(child: Icon(Icons.person)),
          onTap: onTap,
          title: Text(artist.name),
          subtitle: Text(
            artist.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
    );
  }
}
