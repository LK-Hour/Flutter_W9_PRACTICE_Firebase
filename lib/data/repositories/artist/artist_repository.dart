import '../../../domain/model/artist/artist.dart';
import '../../../domain/model/comment/comment.dart';
import '../../../domain/model/songs/song.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});
  
  Future<Artist?> fetchArtistById(String id);

  Future<List<Song>> fetchSongsByArtist(String artistId);

  Future<List<Comment>> fetchCommentsByArtist(String artistId);

  Future<Comment> postComment(String artistId, String content);
}
