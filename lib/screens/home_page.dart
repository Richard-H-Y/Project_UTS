import 'package:flutter/material.dart';
import '../models/app_notification.dart';
import '../models/post.dart';
import '../widgets/fb_app_bar.dart';
import '../widgets/create_post_box.dart';
import '../widgets/stories_row.dart';
import '../widgets/post_card.dart';
import '../widgets/fb_bottom_nav.dart';
import '../widgets/reels_page.dart';
import 'friends_page.dart';
import 'marketplace_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<GlobalKey> _postKeys =
      List.generate(_posts.length, (_) => GlobalKey());

  final List<Post> _posts = [
    Post(
      name: 'Richard',
      avatarUrl: '',
      time: '2 jam lalu',
      content: 'Delicious Shawarma',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAZr_5Wqiw_u50ggAFjA2ZmJbiVRhq8BICcK6hve2BjQ&s=10',
      likeCount: 24,
      comments: ['Wih enaknyaa'],
    ),
    Post(
      name: 'Elysia',
      avatarUrl: '',
      time: '5 jam lalu',
      content: 'hi',
      likeCount: 10,
      comments: [],
    ),
    Post(
      name: 'Surya',
      avatarUrl: '',
      time: '1 hari lalu',
      content: 'Hari ini makan sarapan indomie sambal matah, mantap',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNzVUGgwnWjapUmGAy3kLeepHYG02vRXKNP9NpraAXOg&s=10',
      likeCount: 87,
      comments: ['Keren!', 'Pengen pesen juga', 'laperrrr'],
    ),
    Post(
      name: 'Andrian',
      avatarUrl: '',
      time: '2 hari lalu',
      content: 'Selamat Datang',
      likeCount: 5,
      comments: [],
    )
  ];

  void _toggleLike(Post post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likeCount += post.isLiked ? 1 : -1;
    });
  }

  void _addComment(Post post, String comment) {
    setState(() {
      post.comments.add(comment);
    });
  }

  void _handleNotificationTap(AppNotification notification) {
    if (notification.type == NotifType.friend) {
      setState(() => _currentIndex = 3);
      return;
    }

    final postIndex = notification.targetPostIndex;
    if (postIndex == null || postIndex < 0 || postIndex >= _posts.length) {
      return;
    }

    setState(() => _currentIndex = 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postContext = _postKeys[postIndex].currentContext;
      if (postContext != null) {
        Scrollable.ensureVisible(
          postContext,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
          alignment: 0.05,
        );
      }
    });
  }

  String _tabTitle(int index) {
    switch (index) {
      case 4:
        return 'Notifikasi';
      case 5:
        return 'Menu';
      default:
        return 'Beranda';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_currentIndex == 1 || _currentIndex == 2) ? null : const FbAppBar(),
      body: _buildBody(),
      bottomNavigationBar: FbBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        _buildFeed(),
        const ReelsPage(),
        const MarketplacePage(),
        const FriendsPage(),
        NotificationPage(onNotificationTap: _handleNotificationTap),
        _buildOtherTab(5),
      ],
    );
  }

  Widget _buildOtherTab(int index) {
    return Center(
      child: Text(
        'Halaman ${_tabTitle(index)}',
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildFeed() {
    return ListView(
      children: [
        const CreatePostBox(),
        const SizedBox(height: 6),
        const StoriesRow(),
        const SizedBox(height: 6),
        for (var i = 0; i < _posts.length; i++)
          PostCard(
            key: _postKeys[i],
            post: _posts[i],
            onToggleLike: () => _toggleLike(_posts[i]),
            onAddComment: (comment) => _addComment(_posts[i], comment),
          ),
      ],
    );
  }
}