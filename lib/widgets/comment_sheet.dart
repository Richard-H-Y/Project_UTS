import 'package:flutter/material.dart';
import '../models/post.dart';

class CommentSheet extends StatefulWidget {
  final Post post;
  final void Function(String comment) onAddComment;

  const CommentSheet({
    super.key,
    required this.post,
    required this.onAddComment,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      widget.onAddComment(_controller.text.trim());
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Komentar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const Divider(height: 1),
            Expanded(
              child: widget.post.comments.isEmpty
                  ? const Center(child: Text('Belum ada komentar', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: widget.post.comments.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person, size: 18)),
                        title: Text(widget.post.comments[index]),
                      ),
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Tulis komentar...',
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