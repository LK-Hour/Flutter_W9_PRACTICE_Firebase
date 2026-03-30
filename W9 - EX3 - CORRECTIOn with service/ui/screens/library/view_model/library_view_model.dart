import 'package:flutter/material.dart';

import '../../../../domain/model/songs/song_details.dart';
import '../../../../domain/services/music_service.dart';
import '../../../states/player_state.dart';
import '../../../../domain/model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final MusicService musicService;
  final PlayerState playerState;

  AsyncValue<List<SongDetails>> songsValue = AsyncValue.loading();

  LibraryViewModel({required this.musicService, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<SongDetails> songs = await musicService.fetchSongDetails();
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
     notifyListeners();

  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
