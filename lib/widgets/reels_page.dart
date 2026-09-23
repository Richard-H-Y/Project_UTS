import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Dummy account that can post reels.
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

/// Dummy accounts already "posting" reels in the feed below.
const List<ReelUser> dummyReelUsers = [
  ReelUser(name: 'Richard', username: '@richardo'),
  ReelUser(name: 'Elysia', username: '@elysia.k'),
  ReelUser(name: 'Andrian', username: '@andriann'),
  ReelUser(name: 'Surya', username: '@suryabs'),
];

/// Simple data model for a single reel item.
/// By default [videoUrl] points to a real (public stock/sample) video
/// played with the `video_player` package. Set [isAsset] to true and
/// pass the bundled asset path instead (e.g. `assets/videos/f1_race.mp4`)
/// to play a local video file bundled with the app.
class Reel {
  final ReelUser user;
  final String videoUrl;
  final bool isAsset;
  final String caption;
  int likeCount;
  bool isLiked;
  int commentCount;

  Reel({
    required this.user,
    required this.videoUrl,
    this.isAsset = false,
    required this.caption,
    this.likeCount = 0,
    this.isLiked = false,
    this.commentCount = 0,
  });
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
      commentCount: 7,
    ),
    Reel(
      user: dummyReelUsers[1], // Elysia
      videoUrl: 'assets/videos/Chiikawa.mp4',
      isAsset: true,
      caption: 'Chiiikawa lucu banget, gemesin 🐰',
      likeCount: 231,
      commentCount: 34,
    ),
    Reel(
      user: dummyReelUsers[2], // Andrian
      videoUrl: 'assets/videos/Dog.mp4',
      isAsset: true,
      caption: 'Relatable',
      likeCount: 59,
      commentCount: 5,
    ),
    Reel(
      user: dummyReelUsers[3], // Surya
      videoUrl: 'assets/videos/Hotpot.mp4',
      isAsset: true,
      caption: 'Makan hotpot bareng keluarga, hangat banget 🍲',
      likeCount: 312,
      commentCount: 40,
    ),
    Reel(
      user: dummyReelUsers[0], // Richard again
      videoUrl: 'assets/videos/Speed.mp4',
      isAsset: true,
      caption: 'Japan is turning footsteps into electricity! ⚡ Using piezoelectric tiles, every step you take generates a small amount of energy. Millions of steps together can power LED lights and displays in busy places like Shibuya Station. A brilliant way to create a sustainable and smart city! #Japan #RenewableEnergy #SmartCity #Innovation',
      likeCount: 145,
      commentCount: 19,
    ),
    Reel(
      user: dummyReelUsers[1], // Elysia again
      videoUrl: 'assets/videos/Hamster.mp4',
      isAsset: true,
      caption: 'Blablablablabla',
      likeCount: 176,
      commentCount: 22,
    ),
    Reel(
      user: dummyReelUsers[2], // Andrian again
      videoUrl: 'assets/videos/Bed.mp4',
      isAsset: true,
      caption: 'This so ass',
      likeCount: 102,
      commentCount: 11,
    ),
    Reel(
      user: dummyReelUsers[3], // Surya again
      videoUrl: 'assets/videos/Train.mp4',
      isAsset: true,
      caption: ' commuting to work, same old same old',
      likeCount: 97,
      commentCount: 8,
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
          // Video, cropped to fill the screen like a real reels feed.
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

          // Darken bottom for text legibility
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

          // Pause indicator (shown only while paused)
          if (initialized && !_controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white70,
                size: 72,
              ),
            ),

          // Mute/unmute toggle
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

          // Bottom-left: user info + caption
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

          // Right side: like / comment / share
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
                  label: '${reel.commentCount}',
                  onTap: () {},
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