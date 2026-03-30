import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../domain/model/artist/artist.dart';
import '../../../domain/model/comment/comment.dart';
import '../../../domain/model/songs/song.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/comment_dto.dart';
import '../../dtos/song_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  static const String _baseHost =
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri artistsUri = Uri.https(_baseHost, '/artists.json');

  Uri _songsUri() => Uri.https(_baseHost, '/songs.json');
  Uri _commentsUri() => Uri.https(_baseHost, '/comments.json');

  // In-memory cache for artists
  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    // 1- Return cache if available and not forcing fetch
    if (_cachedArtists != null && !forceFetch) {
      return _cachedArtists!;
    }

    // 2- Fetch from API
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> artistJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in artistJson.entries) {
        if (entry.value != null) {
          result.add(ArtistDto.fromJson(entry.key, entry.value));
        }
      }

      // 3- Store in memory cache
      _cachedArtists = result;

      return result;
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final Uri artistUri = Uri.https(_baseHost, '/artists/$id.json');
    final http.Response response = await http.get(artistUri);

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      if (decoded == null) return null;
      return ArtistDto.fromJson(id, decoded);
    } else {
      throw Exception('Failed to load artist');
    }
  }

  @override
  Future<List<Song>> fetchSongsByArtist(String artistId) async {
    final http.Response response = await http.get(_songsUri());

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      if (decoded == null) return [];

      List<Song> result = [];
      for (final entry in (decoded as Map<String, dynamic>).entries) {
        if (entry.value != null) {
          Song song = SongDto.fromJson(entry.key, entry.value);
          if (song.artistId == artistId) {
            result.add(song);
          }
        }
      }
      return result;
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<List<Comment>> fetchCommentsByArtist(String artistId) async {
    final http.Response response = await http.get(_commentsUri());

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      if (decoded == null) return [];

      List<Comment> result = [];
      for (final entry in (decoded as Map<String, dynamic>).entries) {
        if (entry.value != null) {
          Comment comment = CommentDto.fromJson(entry.key, entry.value);
          if (comment.artistId == artistId) {
            result.add(comment);
          }
        }
      }
      // Sort by createdAt descending (newest first)
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return result;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Future<Comment> postComment(String artistId, String content) async {
    // Create comment data
    final commentData = {
      'artistId': artistId,
      'content': content,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };

    // POST request to add new comment
    final http.Response response = await http.post(
      _commentsUri(),
      body: json.encode(commentData),
    );

    if (response.statusCode == 200) {
      // Firebase returns the new key in response
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String newId = responseData['name'];

      return Comment(
        id: newId,
        artistId: artistId,
        content: content,
        createdAt: DateTime.now(),
      );
    } else {
      throw Exception('Failed to post comment');
    }
  }
}
