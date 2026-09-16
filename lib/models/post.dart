class Post {
  final String name;
  final String avatarUrl;
  final String time;
  final String content;
  final String? imageUrl;
  int likeCount;
  bool isLiked;
  List<String> comments;

  Post({
    required this.name,
    required this.avatarUrl,
    required this.time,
    required this.content,
    this.imageUrl,
    this.likeCount = 0,
    this.isLiked = false,
    List<String>? comments,
  }) : comments = comments ?? [];
}