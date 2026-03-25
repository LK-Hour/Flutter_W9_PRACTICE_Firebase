import '../../model/artists/artist.dart';

class ArtistDto {
  static const String nameKey = 'name';
  static const String descriptionKey = 'description';
  static const String imageUrlKey = 'imageUrl';

  static Artist fromJson(String id, Map<String, dynamic> json) {
    // Basic validation
    // assert(json[nameKey] is String); // Might crash if missing, better to handle gracefully?
    // Following SongDTO pattern:
    
    return Artist(
      id: id,
      name: json[nameKey] ?? 'Unknown Artist',
      description: json[descriptionKey] ?? '',
      imageUrl: json[imageUrlKey] != null ? Uri.parse(json[imageUrlKey]) : null,
    );
  }

  static Map<String, dynamic> toJson(Artist artist) {
    return {
      nameKey: artist.name,
      descriptionKey: artist.description,
      imageUrlKey: artist.imageUrl?.toString(),
    };
  }
}
