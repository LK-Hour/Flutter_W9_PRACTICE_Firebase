import '../../domain/model/comment/comment.dart';

class CommentDto {
  static const String artistIdKey = 'artistId';
  static const String contentKey = 'content';
  static const String createdAtKey = 'createdAt';

  static Comment fromJson(String id, Map<String, dynamic> json) {
    return Comment(
      id: id,
      artistId: json[artistIdKey] ?? '',
      content: json[contentKey] ?? '',
      createdAt: json[createdAtKey] != null
          ? DateTime.fromMillisecondsSinceEpoch(json[createdAtKey])
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      artistIdKey: comment.artistId,
      contentKey: comment.content,
      createdAtKey: comment.createdAt.millisecondsSinceEpoch,
    };
  }
}
