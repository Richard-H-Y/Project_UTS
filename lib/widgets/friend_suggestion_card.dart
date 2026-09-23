import 'package:flutter/material.dart';
import '../models/friend.dart';

class FriendSuggestionCard extends StatelessWidget {
  final Friend friend;
  final bool isRequested;
  final VoidCallback onAdd;

  const FriendSuggestionCard({
    super.key,
    required this.friend,
    required this.isRequested,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              friend.avatarUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              children: [
                Text(
                  friend.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  friend.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: isRequested
                      ? OutlinedButton(
                          onPressed: null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: const Text('Terkirim', style: TextStyle(fontSize: 12)),
                        )
                      : ElevatedButton(
                          onPressed: onAdd,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: const Text('Tambah Teman', style: TextStyle(fontSize: 12)),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
