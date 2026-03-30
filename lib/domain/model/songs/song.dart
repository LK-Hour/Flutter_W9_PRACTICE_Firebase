class Song {
  final String id;
  final String title;
  final String artistId;
  final Duration duration;
  final Uri imageUrl;
  final int likes;
  final bool isLiked;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.duration,
    required this.imageUrl,
    this.likes = 0,
    this.isLiked = false,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artistId,
    Duration? duration,
    Uri? imageUrl,
    int? likes,
    bool? isLiked,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artistId: artistId ?? this.artistId,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist id: $artistId, duration: $duration, likes: $likes, isLiked: $isLiked)';
  }
}
