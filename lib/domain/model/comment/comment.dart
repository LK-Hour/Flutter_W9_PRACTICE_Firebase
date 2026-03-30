class Comment {
  final String id;
  final String artistId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.artistId,
    required this.content,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Comment(id: $id, artistId: $artistId, content: $content)';
  }
}
