import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../domain/model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static const String _baseHost =
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri songsUri = Uri.https(_baseHost, '/songs.json');

  Uri _songUri(String id) => Uri.https(_baseHost, '/songs/$id.json');

  // In-memory cache for songs
  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    // 1- Return cache if available and not forcing fetch
    if (_cachedSongs != null && !forceFetch) {
      return _cachedSongs!;
    }

    // 2- Fetch from API
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }

      // 3- Store in memory cache
      _cachedSongs = result;

      return result;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final http.Response response = await http.get(_songUri(id));

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      if (decoded == null) return null;
      return SongDto.fromJson(id, decoded);
    } else {
      throw Exception('Failed to load song');
    }
  }

  @override
  Future<Song> likeSong(Song song) async {
    // 1- Create the updated song with incremented likes
    final updatedSong = song.copyWith(likes: song.likes + 1);

    // 2- Send PUT request to update the song in Firebase
    final http.Response response = await http.put(
      _songUri(song.id),
      body: json.encode(SongDto.toJson(updatedSong)),
    );

    if (response.statusCode == 200) {
      // 3- Update the cache if exists
      if (_cachedSongs != null) {
        int index = _cachedSongs!.indexWhere((s) => s.id == song.id);
        if (index != -1) {
          _cachedSongs![index] = updatedSong;
        }
      }

      return updatedSong;
    } else {
      throw Exception('Failed to like song');
    }
  }
}
