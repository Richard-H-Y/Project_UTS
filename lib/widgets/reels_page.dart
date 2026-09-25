import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelUser {
  final String name;
  final String username;
  final String avatarUrl;

  const ReelUser({
    required this.name,
    required this.username,
    this.avatarUrl = '',
  });
}

const List<ReelUser> dummyReelUsers = [
  ReelUser(name: 'Richard', username: '@richardo'),
  ReelUser(name: 'Elysia', username: '@elysia.k'),
  ReelUser(name: 'Andrian', username: '@andriann'),
  ReelUser(name: 'Surya', username: '@suryabs'),
];

const ReelUser currentUser = ReelUser(name: 'Kamu', username: '@kamu');

class ReelComment {
  final ReelUser author;
  final String text;
  int likeCount;
  bool isLiked;
  List<ReelComment> replies;

  ReelComment({
    required this.author,
    required this.text,
    this.likeCount = 0,
    this.isLiked = false,
    List<ReelComment>? replies,
  }) : replies = replies ?? [];
}

class Reel {
  final ReelUser user;
  final String videoUrl;
  final bool isAsset;
  final String caption;
  int likeCount;
  bool isLiked;
  List<ReelComment> comments;

  Reel({
    required this.user,
    required this.videoUrl,
    this.isAsset = false,
    required this.caption,
    this.likeCount = 0,
    this.isLiked = false,
    List<ReelComment>? comments,
  }) : comments = comments ?? [];
}

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<Reel> _reels = [
    Reel(
      user: dummyReelUsers[0], // Richard
      videoUrl: 'assets/videos/f1_race.mp4',
      isAsset: true,
      caption: 'Ngebut ala F1, jantung deg-degan 🏎️🔥',
      likeCount: 88,
      comments: [
        ReelComment(author: dummyReelUsers[2], text: 'Gilaa ngebut banget', likeCount: 3),
        ReelComment(author: dummyReelUsers[1], text: 'Pengen nyoba juga'),
      ],
    ),
    Reel(
      user: dummyReelUsers[1], // Elysia
      videoUrl: 'assets/videos/Chiikawa.mp4',
      isAsset: true,
      caption: 'Chiiikawa lucu banget, gemesin 🐰',
      likeCount: 231,
      comments: [
        ReelComment(
          author: dummyReelUsers[3],
          text: 'Gemesin bangettt',
          likeCount: 5,
          replies: [
            ReelComment(author: dummyReelUsers[0], text: 'Iya lucu parah 😭'),
          ],
        ),
        ReelComment(author: dummyReelUsers[0], text: 'Aku juga suka Chiikawa'),
        ReelComment(author: dummyReelUsers[2], text: 'Lucu ihh'),
        ReelComment(author: dummyReelUsers[3], text: 'Mana bisa kuat liat ini'),
      ],
    ),
    Reel(
      user: dummyReelUsers[2], // Andrian
      videoUrl: 'assets/videos/Dog.mp4',
      isAsset: true,
      caption: 'Relatable',
      likeCount: 59,
      comments: [
        ReelComment(
          author: dummyReelUsers[3],
          text: 'Wkwkwk relate banget',
          likeCount: 2,
          replies: [
            ReelComment(author: dummyReelUsers[1], text: 'hahahhha'),
          ],
        ),
      ],
    ),
    Reel(
      user: dummyReelUsers[3], // Surya
      videoUrl: 'assets/videos/Hotpot.mp4',
      isAsset: true,
      caption: 'Makan hotpot bareng keluarga, hangat banget 🍲',
      likeCount: 312,
      comments: [
        ReelComment(author: dummyReelUsers[0], text: 'Jadi laper'),
        ReelComment(author: dummyReelUsers[1], text: 'Enak banget kayaknya', likeCount: 4),
        ReelComment(author: dummyReelUsers[2], text: 'Ajak-ajak dong'),
        ReelComment(author: dummyReelUsers[0], text: 'Hotpot emang the best'),
      ],
    ),
    Reel(
      user: dummyReelUsers[0], // Richard again
      videoUrl: 'assets/videos/Speed.mp4',
      isAsset: true,
      caption: 'Japan is turning footsteps into electricity! ⚡ Using piezoelectric tiles, every step you take generates a small amount of energy. Millions of steps together can power LED lights and displays in busy places like Shibuya Station. A brilliant way to create a sustainable and smart city! #Japan #RenewableEnergy #SmartCity #Innovation',
      likeCount: 145,
      comments: [
        ReelComment(author: dummyReelUsers[2], text: 'Keren banget teknologinya', likeCount: 6),
        ReelComment(author: dummyReelUsers[1], text: 'Wah baru tau'),
        ReelComment(author: dummyReelUsers[3], text: 'Indonesia kapan nih'),
      ],
    ),
    Reel(
      user: dummyReelUsers[1], // Elysia again
      videoUrl: 'assets/videos/Hamster.mp4',
      isAsset: true,
      caption: 'Blablablablabla',
      likeCount: 176,
      comments: [
        ReelComment(author: dummyReelUsers[0], text: 'Wkwkwk'),
        ReelComment(author: dummyReelUsers[2], text: 'Ngakak liat ini'),
      ],
    ),
    Reel(
      user: dummyReelUsers[2], // Andrian again
      videoUrl: 'assets/videos/Bed.mp4',
      isAsset: true,
      caption: 'This so ass',
      likeCount: 102,
      comments: [
        ReelComment(author: dummyReelUsers[3], text: 'LMAO'),
      ],
    ),
    Reel(
      user: dummyReelUsers[3], // Surya again
      videoUrl: 'assets/videos/Train.mp4',
      isAsset: true,
      caption: ' commuting to work, same old same old',
      likeCount: 97,
      comments: [
        ReelComment(author: dummyReelUsers[1], text: 'Semangat kerjanya'),
        ReelComment(author: dummyReelUsers[0], text: 'Same here bro'),
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleLike(Reel reel) {
    setState(() {
      reel.isLiked = !reel.isLiked;
      reel.likeCount += reel.isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          return _ReelItem(
            key: ValueKey(index),
            reel: _reels[index],
            isActive: index == _currentPage,
            onToggleLike: () => _toggleLike(_reels[index]),
          );
        },
      ),
    );
  }
}

class _ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isActive;
  final VoidCallback onToggleLike;

  const _ReelItem({
    super.key,
    required this.reel,
    required this.isActive,
    required this.onToggleLike,
  });

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem> {
  late final VideoPlayerController _controller;
  bool _isMuted = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = widget.reel.isAsset
        ? VideoPlayerController.asset(widget.reel.videoUrl)
        : VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl));
    _controller
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        if (widget.isActive) _controller.play();
      }).catchError((Object e) {
        // Surface load failures (e.g. asset not bundled, bad URL) instead
        // of leaving the spinner running forever.
        debugPrint('Reel video failed to load: ${widget.reel.videoUrl} -> $e');
        if (!mounted) return;
        setState(() => _error = e.toString());
      });
  }

  @override
  void didUpdateWidget(covariant _ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive && _controller.value.isInitialized) {
      if (widget.isActive) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_controller.value.isInitialized) return;
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  int get _totalCommentCount {
    return widget.reel.comments.fold<int>(
      0,
      (sum, c) => sum + 1 + c.replies.length,
    );
  }

  void _showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _ReelCommentSheet(
        reel: widget.reel,
        onChanged: () => setState(() {}),
      ),
    ).then((_) => setState(() {}));
  }

  Widget _sideAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reel = widget.reel;
    final initialized = _controller.value.isInitialized;

    return GestureDetector(
      onTap: _togglePlay,
      child: Stack(
        fit: StackFit.expand,
        children: [

          if (initialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const ColoredBox(color: Colors.black),

          if (!initialized && _error == null)
            const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            ),

          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white54, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Video gagal dimuat',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
                stops: [0.6, 1.0],
              ),
            ),
          ),

          if (initialized && !_controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white70,
                size: 72,
              ),
            ),

          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: _toggleMute,
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                radius: 18,
                child: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          Positioned(
            left: 12,
            right: 80,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF1877F2),
                      backgroundImage: reel.user.avatarUrl.isNotEmpty
                          ? NetworkImage(reel.user.avatarUrl)
                          : null,
                      child: reel.user.avatarUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.white, size: 18)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reel.user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          reel.user.username,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  reel.caption,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),

          Positioned(
            right: 8,
            bottom: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _sideAction(
                  icon: reel.isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '${reel.likeCount}',
                  color: reel.isLiked ? const Color(0xFF1877F2) : Colors.white,
                  onTap: widget.onToggleLike,
                ),
                _sideAction(
                  icon: Icons.comment,
                  label: '$_totalCommentCount',
                  onTap: () => _showCommentSheet(context),
                ),
                _sideAction(
                  icon: Icons.share,
                  label: 'Bagikan',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReelCommentSheet extends StatefulWidget {
  final Reel reel;
  final VoidCallback onChanged;

  const _ReelCommentSheet({
    required this.reel,
    required this.onChanged,
  });

  @override
  State<_ReelCommentSheet> createState() => _ReelCommentSheetState();
}

class _ReelCommentSheetState extends State<_ReelCommentSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ReelComment? _replyTarget;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      if (_replyTarget != null) {
        _replyTarget!.replies.add(ReelComment(author: currentUser, text: text));
      } else {
        widget.reel.comments.add(ReelComment(author: currentUser, text: text));
      }
      _replyTarget = null;
    });
    _controller.clear();
    widget.onChanged();
  }

  void _startReply(ReelComment comment) {
    setState(() {
      _replyTarget = comment;
      _controller.text = '${comment.author.username} ';
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyTarget = null;
      _controller.clear();
    });
  }

  void _toggleCommentLike(ReelComment comment) {
    setState(() {
      comment.isLiked = !comment.isLiked;
      comment.likeCount += comment.isLiked ? 1 : -1;
    });
  }

  Widget _commentTile(ReelComment comment, {required ReelComment replyTarget, bool isReply = false}) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 40 : 0, right: 12, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: isReply ? 14 : 16,
            backgroundColor: const Color(0xFF1877F2),
            child: Icon(Icons.person, size: isReply ? 14 : 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(
                        text: comment.author.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '  ${comment.author.username}',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(comment.text, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleCommentLike(comment),
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 15,
                            color: comment.isLiked ? const Color(0xFF1877F2) : Colors.grey,
                          ),
                          if (comment.likeCount > 0) ...[
                            const SizedBox(width: 3),
                            Text(
                              '${comment.likeCount}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _startReply(replyTarget),
                      child: const Text(
                        'Balas',
                        style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 480,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Komentar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const Divider(height: 1),
            Expanded(
              child: widget.reel.comments.isEmpty
                  ? const Center(child: Text('Belum ada komentar', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: widget.reel.comments.length,
                      itemBuilder: (context, index) {
                        final comment = widget.reel.comments[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _commentTile(comment, replyTarget: comment),
                            for (final reply in comment.replies)
                              _commentTile(reply, replyTarget: comment, isReply: true),
                          ],
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            if (_replyTarget != null)
              Container(
                width: double.infinity,
                color: const Color(0xFFF0F2F5),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Membalas ke ${_replyTarget!.author.username}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    GestureDetector(
                      onTap: _cancelReply,
                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const CircleAvatar(radius: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: _replyTarget == null ? 'Tulis komentar...' : 'Tulis balasan...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF0F2F5),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF1877F2)),
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}