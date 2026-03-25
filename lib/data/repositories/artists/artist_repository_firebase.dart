import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../model/artists/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  static const String _primaryHost =
      'flutter-project-test-lk-hour-default-rtdb.asia-southeast1.firebasedatabase.app';
  static const String _fallbackHost =
      'flutter-project-test-lk-hour-default-rtdb.firebaseio.com';

  final Uri artistsUri = Uri.https(_primaryHost, '/artists.json');
  final Uri artistsFallbackUri = Uri.https(_fallbackHost, '/artists.json');

  Future<http.Response> _getWithFallback(Uri primary, Uri fallback) async {
    try {
      return await http.get(primary);
    } on SocketException {
      return http.get(fallback);
    }
  }

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response =
        await _getWithFallback(artistsUri, artistsFallbackUri);

    if (response.statusCode == 200) {
      final dynamic decoded = json.decode(response.body);
      if (decoded == null) return [];
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Unexpected artists payload format');
      }

      final List<Artist> result = [];
      for (final entry in decoded.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value as Map<String, dynamic>));
      }

      return result;
    }

    throw Exception('Failed to load artists (status ${response.statusCode})');
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    throw UnimplementedError();
  }
}
