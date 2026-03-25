import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/artists/artist_repository.dart';
import 'view_model/artist_view_model.dart';
import 'widgets/artist_content.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistViewModel(
        artistRepository: context.read<ArtistRepository>(),
      ),
      child: const ArtistContent(),
    );
  }
}
