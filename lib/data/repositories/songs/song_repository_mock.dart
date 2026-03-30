// song_repository_mock.dart

import '../../../domain/model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [  ];

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    return Future.delayed(Duration(seconds: 4), () {
      throw _songs;
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

  @override
  Future<Song> likeSong(Song song) async {
    return Future.delayed(Duration(seconds: 1), () {
      final index = _songs.indexWhere((s) => s.id == song.id);
      if (index != -1) {
        final updatedSong = song.copyWith(likes: song.likes + 1);
        _songs[index] = updatedSong;
        return updatedSong;
      }
      throw Exception("Song not found");
    });
  }
}
