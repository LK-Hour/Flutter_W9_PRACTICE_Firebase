import '../../model/songs/song.dart';

class SongDto {
  static const String titleKey = 'title';
  static const String artistIdKey = 'artistId';
  static const String durationKey = 'duration';
  static const String imageUrlKey = 'imageUrl';

  static Song fromJson(String Id, Map<String, dynamic> json) {
    assert(json[titleKey] is String);
    assert(json[artistIdKey] is String);
    assert(json[durationKey] is int);
    assert(json[imageUrlKey] is String);

    return Song(
      id: Id,
      title: json[titleKey],
      artistId: json[artistIdKey],
      duration: Duration(milliseconds: json[durationKey]),
      imageUri: Uri.parse(json[imageUrlKey]),
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      titleKey: song.title,
      artistIdKey: song.artistId,
      durationKey: song.duration.inMilliseconds,
      imageUrlKey: song.imageUri,
    };
  }
}
