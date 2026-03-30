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

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
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
      // 3- Return the updated song
      return updatedSong;
    } else {
      throw Exception('Failed to like song');
    }
  }
}
