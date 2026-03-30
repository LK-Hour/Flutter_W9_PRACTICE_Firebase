import '../../../../domain/model/artist/artist.dart';
import '../../../../domain/model/songs/song.dart';

class LibraryItemData {
  final Song song;
  final Artist  artist;

  LibraryItemData({required this.song, required this.artist});
}
