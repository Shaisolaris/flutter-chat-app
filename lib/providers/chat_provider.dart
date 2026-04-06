import '../data/demo_data.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

final _users = [
  const User(id: 'u1', name: 'Sarah Chen', avatarEmoji: '👩‍🎨', isOnline: true),
  const User(id: 'u2', name: 'Mike Johnson', avatarEmoji: '📷', isOnline: true),
  const User(id: 'u3', name: 'Emma Wilson', avatarEmoji: '✈️', isOnline: false, lastSeen: null),
  const User(id: 'u4', name: 'James Lee', avatarEmoji: '💻', isOnline: true),
  const User(id: 'u5', name: 'Ana Garcia', avatarEmoji: '🍳', isOnline: false),
];

final _now = DateTime.now();
DateTime _ago(int minutes) => _now.subtract(Duration(minutes: minutes));

final _conversations = [
  Conversation(id: 'c1', name: 'Sarah Chen', avatarEmoji: '👩‍🎨', participants: [_users[0]], unreadCount: 3, isPinned: true,
    lastMessage: Message(id: 'm1', conversationId: 'c1', senderId: 'u1', senderName: 'Sarah', content: 'Check out this new design!', sentAt: _ago(5), status: MessageStatus.delivered)),
  Conversation(id: 'c2', name: 'Mike Johnson', avatarEmoji: '📷', participants: [_users[1]], unreadCount: 0,
    lastMessage: Message(id: 'm2', conversationId: 'c2', senderId: 'me', senderName: 'You', content: 'Thanks for the photos!', sentAt: _ago(30), status: MessageStatus.read)),
  Conversation(id: 'c3', name: 'Design Team', avatarEmoji: '🎨', type: 'group', participants: [_users[0], _users[1], _users[3]], unreadCount: 12,
    lastMessage: Message(id: 'm3', conversationId: 'c3', senderId: 'u4', senderName: 'James', content: 'Meeting at 3pm today', sentAt: _ago(15), status: MessageStatus.delivered)),
  Conversation(id: 'c4', name: 'Emma Wilson', avatarEmoji: '✈️', participants: [_users[2]], unreadCount: 1,
    lastMessage: Message(id: 'm4', conversationId: 'c4', senderId: 'u3', senderName: 'Emma', content: 'Just landed in Tokyo! 🇯🇵', sentAt: _ago(120), status: MessageStatus.delivered)),
  Conversation(id: 'c5', name: 'Ana Garcia', avatarEmoji: '🍳', participants: [_users[4]], unreadCount: 0, isMuted: true,
    lastMessage: Message(id: 'm5', conversationId: 'c5', senderId: 'u5', senderName: 'Ana', content: 'New recipe is live on the blog', sentAt: _ago(360), status: MessageStatus.read)),
];

final Map<String, List<Message>> _messageHistory = {
  'c1': [
    Message(id: 'h1', conversationId: 'c1', senderId: 'me', senderName: 'You', content: 'Hey Sarah! How is the dashboard redesign going?', sentAt: _ago(60), status: MessageStatus.read),
    Message(id: 'h2', conversationId: 'c1', senderId: 'u1', senderName: 'Sarah', content: 'Really well! Just finished the dark mode variant', sentAt: _ago(55), status: MessageStatus.read),
    Message(id: 'h3', conversationId: 'c1', senderId: 'u1', senderName: 'Sarah', content: 'The client loved the mobile responsive version too', sentAt: _ago(50), status: MessageStatus.read),
    Message(id: 'h4', conversationId: 'c1', senderId: 'me', senderName: 'You', content: 'That is awesome! Can you share the Figma link?', sentAt: _ago(45), status: MessageStatus.read),
    Message(id: 'h5', conversationId: 'c1', senderId: 'u1', senderName: 'Sarah', content: 'Sure, sending it over now', sentAt: _ago(40), status: MessageStatus.read),
    Message(id: 'h6', conversationId: 'c1', senderId: 'u1', senderName: 'Sarah', content: '📎 dashboard-v2.fig', type: MessageType.file, sentAt: _ago(38), status: MessageStatus.delivered),
    Message(id: 'h7', conversationId: 'c1', senderId: 'me', senderName: 'You', content: 'Perfect, thanks! I will review it this afternoon', sentAt: _ago(35), status: MessageStatus.read),
    Message(id: 'h8', conversationId: 'c1', senderId: 'u1', senderName: 'Sarah', content: 'Check out this new design!', sentAt: _ago(5), status: MessageStatus.delivered),
  ],
  'c2': [
    Message(id: 'h9', conversationId: 'c2', senderId: 'u2', senderName: 'Mike', content: 'Here are the product shots from yesterday', sentAt: _ago(120), status: MessageStatus.read),
    Message(id: 'h10', conversationId: 'c2', senderId: 'u2', senderName: 'Mike', content: '📸 product-photos.zip', type: MessageType.file, sentAt: _ago(118), status: MessageStatus.read),
    Message(id: 'h11', conversationId: 'c2', senderId: 'me', senderName: 'You', content: 'These look incredible! Great lighting', sentAt: _ago(60), status: MessageStatus.read),
    Message(id: 'h12', conversationId: 'c2', senderId: 'me', senderName: 'You', content: 'Thanks for the photos!', sentAt: _ago(30), status: MessageStatus.read),
  ],
};

class ChatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> get conversations => DemoChats.conversations;
  List<Map<String, dynamic>> get currentMessages => DemoChats.messages;
  static const currentUserId = 'me';

  List<Conversation> get conversations => List.unmodifiable(_conversations);
  int get totalUnread => _conversations.fold(0, (sum, c) => sum + c.unreadCount);

  List<Message> getMessages(String conversationId) {
    return _messageHistory[conversationId] ?? [];
  }

  final Map<String, bool> _typingStatus = {};
  bool isTyping(String conversationId) => _typingStatus[conversationId] ?? false;

  void sendMessage(String conversationId, String content, {MessageType type = MessageType.text}) {
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: currentUserId,
      senderName: 'You',
      content: content,
      type: type,
      sentAt: DateTime.now(),
      status: MessageStatus.sent,
    );

    _messageHistory.putIfAbsent(conversationId, () => []);
    _messageHistory[conversationId]!.add(message);

    // Simulate delivery after 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      final msgs = _messageHistory[conversationId];
      if (msgs != null && msgs.isNotEmpty) {
        notifyListeners();
      }
    });

    // Simulate reply after 2s
    Future.delayed(const Duration(seconds: 2), () {
      _typingStatus[conversationId] = true;
      notifyListeners();

      Future.delayed(const Duration(seconds: 1), () {
        _typingStatus[conversationId] = false;
        final reply = Message(
          id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
          conversationId: conversationId,
          senderId: 'u1',
          senderName: 'Sarah',
          content: _autoReplies[DateTime.now().second % _autoReplies.length],
          sentAt: DateTime.now(),
          status: MessageStatus.sent,
        );
        _messageHistory[conversationId]?.add(reply);
        notifyListeners();
      });
    });

    notifyListeners();
  }

  void markAsRead(String conversationId) {
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx >= 0 && _conversations[idx].unreadCount > 0) {
      _conversations[idx] = Conversation(
        id: _conversations[idx].id, name: _conversations[idx].name,
        avatarEmoji: _conversations[idx].avatarEmoji, type: _conversations[idx].type,
        participants: _conversations[idx].participants,
        lastMessage: _conversations[idx].lastMessage, unreadCount: 0,
        isMuted: _conversations[idx].isMuted, isPinned: _conversations[idx].isPinned,
      );
      notifyListeners();
    }
  }

  List<Conversation> search(String query) {
    if (query.isEmpty) return conversations;
    final q = query.toLowerCase();
    return _conversations.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  static const _autoReplies = [
    'Sounds great! 👍', 'I will look into that', 'Let me check and get back to you',
    'Good idea!', 'Sure thing!', 'Thanks for letting me know', 'On it! 🚀',
  ];
}
