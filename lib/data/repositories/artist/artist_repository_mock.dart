import '../../../domain/model/artist/artist.dart';
import '../../../domain/model/comment/comment.dart';
import '../../../domain/model/songs/song.dart';
import 'artist_repository.dart';

class ArtistRepositoryMock implements ArtistRepository {
  final List<Artist> _artists = [];
  final List<Comment> _comments = [];

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    return Future.delayed(Duration(seconds: 4), () {
      throw _artists;
    });
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _artists.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception("No artist with id $id in the database"),
      );
    });
  }

  @override
  Future<List<Song>> fetchSongsByArtist(String artistId) async {
    return Future.delayed(Duration(seconds: 1), () => []);
  }

  @override
  Future<List<Comment>> fetchCommentsByArtist(String artistId) async {
    return Future.delayed(Duration(seconds: 1), () {
      return _comments.where((c) => c.artistId == artistId).toList();
    });
  }

  @override
  Future<Comment> postComment(String artistId, String content) async {
    return Future.delayed(Duration(seconds: 1), () {
      final comment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        artistId: artistId,
        content: content,
        createdAt: DateTime.now(),
      );
      _comments.add(comment);
      return comment;
    });
  }
}
