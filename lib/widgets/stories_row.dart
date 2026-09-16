import 'package:flutter/material.dart';

class StoriesRow extends StatelessWidget {
  final int storyCount;

  const StoriesRow({super.key, this.storyCount = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storyCount,
        itemBuilder: (context, index) {
          return Container(
            width: 110,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/seed/story$index/220/360'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF1877F2),
                    child: CircleAvatar(
                      radius: 12,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Text(
                    'Pengguna ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}