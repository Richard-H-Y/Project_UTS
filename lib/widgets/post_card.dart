import 'package:flutter/material.dart';
import '../models/post.dart';
import 'comment_sheet.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onToggleLike;
  final void Function(String comment) onAddComment;

  const PostCard({
    super.key,
    required this.post,
    required this.onToggleLike,
    required this.onAddComment,
  });

  void _showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => CommentSheet(
        post: post,
        onAddComment: onAddComment,
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: color, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(post.avatarUrl)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(post.time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(post.content),
          ),
          const SizedBox(height: 8),
          if (post.imageUrl != null)
            Image.network(post.imageUrl!, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              '${post.likeCount} suka · ${post.comments.length} komentar',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              _actionButton(
                icon: post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: 'Suka',
                color: post.isLiked ? const Color(0xFF1877F2) : Colors.grey[700]!,
                onTap: onToggleLike,
              ),
              _actionButton(
                icon: Icons.comment_outlined,
                label: 'Komentar',
                color: Colors.grey[700]!,
                onTap: () => _showCommentSheet(context),
              ),
              _actionButton(
                icon: Icons.share_outlined,
                label: 'Bagikan',
                color: Colors.grey[700]!,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}