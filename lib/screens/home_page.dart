import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/fb_app_bar.dart';
import '../widgets/create_post_box.dart';
import '../widgets/stories_row.dart';
import '../widgets/post_card.dart';
import '../widgets/fb_bottom_nav.dart';
import '../widgets/reels_page.dart'; // Import dari kode teman
import 'friends_page.dart'; // Import dari kode aslimu

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

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

  String _tabTitle(int index) {
    switch (index) {
      case 1:
        return 'Video';
      case 2:
        return 'Teman';
      case 3:
        return 'Notifikasi';
      case 4:
        return 'Menu';
      default:
        return 'Beranda';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar disembunyikan (null) jika index == 1 (Halaman Reels)
      appBar: _currentIndex == 1 ? null : const FbAppBar(),
      body: _buildBody(),
      bottomNavigationBar: FbBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildFeed();
      case 1:
        return const ReelsPage(); // Render halaman Video/Reels
      case 2:
        return const FriendsPage(); // Render halaman Teman
      default:
        return _buildOtherTab();
    }
  }

  Widget _buildOtherTab() {
    return Center(
      child: Text(
        'Halaman ${_tabTitle(_currentIndex)}',
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
        for (final post in _posts)
          PostCard(
            post: post,
            onToggleLike: () => _toggleLike(post),
            onAddComment: (comment) => _addComment(post, comment),
          ),
      ],
    );
  }
}