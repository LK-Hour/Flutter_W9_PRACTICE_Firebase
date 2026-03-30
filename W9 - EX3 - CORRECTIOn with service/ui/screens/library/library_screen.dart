import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/services/music_service.dart';
import 'view_model/library_view_model.dart';
import '../../states/player_state.dart';
import 'widgets/library_content.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LibraryViewModel(
        playerState: context.read<PlayerState>(),
        musicService: context.read<MusicService>(),
      ),
      child: LibraryContent(),
    );
  }
}
