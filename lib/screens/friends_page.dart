import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../widgets/friend_request_card.dart';
import '../widgets/friend_suggestion_card.dart';
import '../widgets/friend_list_card.dart';
import 'chat_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<Friend> _requests = [
    Friend(
      name: 'Richard',
      avatarUrl: '',
      subtitle: 'Hello',
    ),
    Friend(
      name: 'Surya',
      avatarUrl: '',
      subtitle: 'Yummy',
    ),
    Friend(
      name: 'Ely',
      avatarUrl: '',
      subtitle: 'Life is life',
    )
  ];

  final List<Friend> _suggestions = [
    Friend(
      name: 'Andrian',
      avatarUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIoEKDfrPHHMhYzM8e8J7dRs_yZJ-cUEgK5qTKjrUkkA&s=10',
      subtitle: 'Beli Changee',
    ),
    Friend(
      name: 'Kevin',
      avatarUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIoEKDfrPHHMhYzM8e8J7dRs_yZJ-cUEgK5qTKjrUkkA&s=10',
      subtitle: 'Teknik Informatika',
    ),
    Friend(
      name: 'Jonathan',
      avatarUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIoEKDfrPHHMhYzM8e8J7dRs_yZJ-cUEgK5qTKjrUkkA&s=10',
      subtitle: 'Alamak',
    ),
  ];

  final List<Friend> _friends = [];

  final Set<String> _sentRequests = {};

  void _confirmRequest(Friend friend) {
    setState(() {
      _requests.remove(friend);
      _friends.add(friend);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kamu dan ${friend.name} sekarang berteman'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteRequest(Friend friend) {
    setState(() {
      _requests.remove(friend);
    });
  }

  void _addFriend(Friend friend) {
    setState(() {
      _sentRequests.add(friend.name);
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _suggestions.removeWhere((f) => f.name == friend.name);
        _friends.add(friend);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${friend.name} menerima permintaan pertemanan kamu'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _openChat(Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(friend: friend)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (_requests.isNotEmpty) ...[
          const Text(
            'Permintaan Pertemanan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          for (final friend in _requests)
            FriendRequestCard(
              friend: friend,
              onConfirm: () => _confirmRequest(friend),
              onDelete: () => _deleteRequest(friend),
            ),
          const SizedBox(height: 12),
        ],
        if (_friends.isNotEmpty) ...[
          const Text(
            'Teman',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          for (final friend in _friends)
            FriendListCard(
              friend: friend,
              onMessage: () => _openChat(friend),
            ),
          const SizedBox(height: 12),
        ],
        const Text(
          'Mungkin Anda Kenal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _suggestions.length,
          itemBuilder: (context, index) {
            final friend = _suggestions[index];
            return FriendSuggestionCard(
              friend: friend,
              isRequested: _sentRequests.contains(friend.name),
              onAdd: () => _addFriend(friend),
            );
          },
        ),
      ],
    );
  }
}