import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/model/artist/artist.dart';
import '../../../../domain/model/comment/comment.dart';
import '../../../../domain/model/songs/song.dart';
import '../../../utils/async_value.dart';
import '../../../widgets/comment/comment_tile.dart';
import '../view_model/artist_detail_view_model.dart';

class ArtistDetailContent extends StatefulWidget {
  const ArtistDetailContent({
    super.key,
    required this.artist,
  });

  final Artist artist;

  @override
  State<ArtistDetailContent> createState() => _ArtistDetailContentState();
}

class _ArtistDetailContentState extends State<ArtistDetailContent> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showCommentBottomSheet(BuildContext context, ArtistDetailViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Comment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write your comment...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _commentController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String content = _commentController.text.trim();
                      if (content.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Comment cannot be empty')),
                        );
                        return;
                      }
                      vm.addComment(content);
                      _commentController.clear();
                      Navigator.pop(context);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ArtistDetailViewModel vm = context.watch<ArtistDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artist.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Artist header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.artist.imageUrl.toString()),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.artist.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.artist.genre,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Songs section
              Text(
                'Songs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildSongsSection(vm.songsValue),

              SizedBox(height: 24),

              // Comments section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_comment),
                    onPressed: () => _showCommentBottomSheet(context, vm),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildCommentsSection(vm.commentsValue),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCommentBottomSheet(context, vm),
        child: Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildSongsSection(AsyncValue<List<Song>> songsValue) {
    switch (songsValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Center(
          child: Text(
            'Error loading songs',
            style: TextStyle(color: Colors.red),
          ),
        );
      case AsyncValueState.success:
        List<Song> songs = songsValue.data!;
        if (songs.isEmpty) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'No songs available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            Song song = songs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.imageUrl.toString()),
                  ),
                  title: Text(song.title),
                  subtitle: Text('${song.duration.inMinutes} mins'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      Text('${song.likes}'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
    }
  }

  Widget _buildCommentsSection(AsyncValue<List<Comment>> commentsValue) {
    switch (commentsValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Center(
          child: Text(
            'Error loading comments',
            style: TextStyle(color: Colors.red),
          ),
        );
      case AsyncValueState.success:
        List<Comment> comments = commentsValue.data!;
        if (comments.isEmpty) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'No comments yet. Be the first to comment!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return CommentTile(comment: comments[index]);
          },
        );
    }
  }
}
