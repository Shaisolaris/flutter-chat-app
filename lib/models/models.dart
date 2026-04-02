class User {
  final String id;
  final String name;
  final String avatarEmoji;
  final bool isOnline;
  final DateTime? lastSeen;

  const User({required this.id, required this.name, this.avatarEmoji = '👤', this.isOnline = false, this.lastSeen});
}

class Conversation {
  final String id;
  final String type; // direct, group
  final String name;
  final String avatarEmoji;
  final List<User> participants;
  final Message? lastMessage;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;

  const Conversation({required this.id, this.type = 'direct', required this.name, this.avatarEmoji = '👤', this.participants = const [], this.lastMessage, this.unreadCount = 0, this.isMuted = false, this.isPinned = false});
}

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType type;
  final DateTime sentAt;
  final MessageStatus status;
  final String? replyToId;
  final Map<String, String> reactions;

  const Message({required this.id, required this.conversationId, required this.senderId, required this.senderName, required this.content, this.type = MessageType.text, required this.sentAt, this.status = MessageStatus.sent, this.replyToId, this.reactions = const {}});
}

enum MessageType { text, image, file, audio, system }
enum MessageStatus { sending, sent, delivered, read }
