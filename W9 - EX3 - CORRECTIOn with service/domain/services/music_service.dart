import '../../data/repositories/artist/artist_repository.dart';
import '../../data/repositories/songs/song_repository.dart';
import '../model/artist/artist.dart';
import '../model/songs/song.dart';
import '../model/songs/song_details.dart';

class MusicService {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  MusicService({required this.songRepository, required this.artistRepository});

  Future<List<SongDetails>> fetchSongDetails() async {
    // 1- Fetch  all song
    List<Song> songs = await songRepository.fetchSongs();

    // 2- Fethc artist
    List<Artist> artists = await artistRepository.fetchArtists();

    // 3- Create the mapping artistid-> artist
    Map<String, Artist> mapArtist = {};
    for (Artist artist in artists) {
      mapArtist[artist.id] = artist;
    }

    // 4 - Return  the mapped data
    return songs
        .map(
          (song) =>
              SongDetails(song: song, artist: mapArtist[song.artistId]!),
        )
        .toList();
  }
}
