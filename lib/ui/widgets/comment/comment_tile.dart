import 'package:flutter/material.dart';
import '../../../domain/model/comment/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
  });

  final Comment comment;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
          title: Text(
            comment.content,
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(
            _formatDate(comment.createdAt),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
