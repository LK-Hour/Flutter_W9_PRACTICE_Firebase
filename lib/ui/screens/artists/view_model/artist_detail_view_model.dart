import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../domain/model/artist/artist.dart';
import '../../../../domain/model/comment/comment.dart';
import '../../../../domain/model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artist,
  }) {
    _init();
  }

  void _init() {
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch songs
    songsValue = AsyncValue.loading();
    commentsValue = AsyncValue.loading();
    notifyListeners();

    try {
      List<Song> songs = await artistRepository.fetchSongsByArtist(artist.id);
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }

    try {
      List<Comment> comments = await artistRepository.fetchCommentsByArtist(artist.id);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }

    notifyListeners();
  }

  Future<void> addComment(String content) async {
    if (content.trim().isEmpty) {
      return;
    }

    try {
      Comment newComment = await artistRepository.postComment(artist.id, content);

      // Update local state
      if (commentsValue.state == AsyncValueState.success) {
        List<Comment> currentComments = List.from(commentsValue.data!);
        currentComments.insert(0, newComment);
        commentsValue = AsyncValue.success(currentComments);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
    }
  }
}
