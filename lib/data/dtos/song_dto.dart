import '../../domain/model/songs/song.dart';

class SongDto {
  static const String titleKey = 'title';
  static const String durationKey = 'duration'; // in ms
  static const String artistIdKey = 'artistId';
  static const String imageUrlKey = 'imageUrl';
  static const String likesKey = 'likes';
  static const String isLikedKey = 'isLiked';

  static Song fromJson(String id, Map<String, dynamic> json) {
    return Song(
      id: id,
      title: json[titleKey] ?? '',
      artistId: json[artistIdKey] ?? '',
      duration: Duration(milliseconds: json[durationKey] ?? 0),
      imageUrl: Uri.parse(json[imageUrlKey] ?? ''),
      likes: json[likesKey] is int ? json[likesKey] : 0,
      isLiked: json[isLikedKey] is bool ? json[isLikedKey] : false,
    );
  }

  /// Convert Song to JSON
  static Map<String, dynamic> toJson(Song song) {
    return {
      titleKey: song.title,
      artistIdKey: song.artistId,
      durationKey: song.duration.inMilliseconds,
      imageUrlKey: song.imageUrl.toString(),
      likesKey: song.likes,
      isLikedKey: song.isLiked,
    };
  }
}
