import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../domain/model/artist/artist.dart';
import '../../../../domain/model/songs/song.dart';
import '../../../states/player_state.dart';
import '../../../utils/async_value.dart';
import 'library_item_data.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  final PlayerState playerState;

  AsyncValue<List<LibraryItemData>> data = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
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

  void fetchSong({bool forceFetch = false}) async {
    // 1- Loading state
    data = AsyncValue.loading();
    notifyListeners();

    try {
      // 1- Fetch songs (use forceFetch to clear cache)
      List<Song> songs = await songRepository.fetchSongs(forceFetch: forceFetch);

      // 2- Fethc artist (use forceFetch to clear cache)
      List<Artist> artists = await artistRepository.fetchArtists(forceFetch: forceFetch);

      // 3- Create the mapping artistid-> artist
      Map<String, Artist> mapArtist = {};
      for (Artist artist in artists) {
        mapArtist[artist.id] = artist;
      }

      List<LibraryItemData> data = songs
          .map(
            (song) =>
                LibraryItemData(song: song, artist: mapArtist[song.artistId]!),
          )
          .toList();

      this.data = AsyncValue.success(data);

    } catch (e) {
      // 3- Fetch is unsucessfull
      data = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> refreshData() async {
    // Force fetch to clear cache and get fresh data
    fetchSong(forceFetch: true);
  }

  Future<void> likeSong(Song song) async {
    try {
      // 1- Call repository to like song
      Song updatedSong = await songRepository.likeSong(song);

      // 2- Update the local data
      if (data.state == AsyncValueState.success) {
        List<LibraryItemData> currentData = data.data!;
        int index = currentData.indexWhere((item) => item.song.id == song.id);
        
        if (index != -1) {
          currentData[index] = LibraryItemData(
            song: updatedSong,
            artist: currentData[index].artist,
          );
          data = AsyncValue.success(List.from(currentData));
          notifyListeners();
        }
      }
    } catch (e) {
      // 3- Show error via snackbar or other method
      debugPrint('Error liking song: $e');
    }
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
