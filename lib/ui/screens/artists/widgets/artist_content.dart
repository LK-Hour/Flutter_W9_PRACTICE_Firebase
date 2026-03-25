import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../model/artists/artist.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/artist/artist_tile.dart';
import '../view_model/artist_view_model.dart';

class ArtistContent extends StatelessWidget {
  const ArtistContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the view model
    ArtistViewModel mv = context.watch<ArtistViewModel>();

    AsyncValue<List<Artist>> asyncValue = mv.artistsValue;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Text(
            'Error: ${asyncValue.error}',
            style: const TextStyle(color: Colors.red),
          ),
        );
        break;
      case AsyncValueState.success:
        List<Artist> artists = asyncValue.data!;
        content = ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) => ArtistTile(
            artist: artists[index],
            onTap: () {
              // Handle tap if needed
              // debugPrint('Tapped on ${artists[index].name}');
            },
          ),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Artists",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
          Expanded(child: content),
        ],
      ),
    );
  }
}
