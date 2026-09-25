import 'chat_message.dart';

class Friend {
  final String name;
  final String avatarUrl;
  final String subtitle;
  List<ChatMessage> messages;

  Friend({
    required this.name,
    required this.avatarUrl,
    required this.subtitle,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];
}