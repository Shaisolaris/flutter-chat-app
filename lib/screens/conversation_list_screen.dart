import 'package:flutter/material.dart';
import '../providers/chat_provider.dart';
import '../models/models.dart';

class ConversationListScreen extends StatefulWidget {
  final ChatProvider provider;
  final void Function(Conversation) onConversationTap;

  const ConversationListScreen({super.key, required this.provider, required this.onConversationTap});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final conversations = widget.provider.search(_search);
    final pinned = conversations.where((c) => c.isPinned).toList();
    final unpinned = conversations.where((c) => !c.isPinned).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
        actions: [
          IconButton(icon: const Icon(Icons.edit_square), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          // Online users
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final user in [const User(id: 'me', name: 'You', avatarEmoji: '📸'), ..._getOnlineUsers()])
                  _OnlineAvatar(user: user, isMe: user.id == 'me'),
              ],
            ),
          ),
          const Divider(height: 1),
          // Conversations
          Expanded(
            child: ListView(
              children: [
                if (pinned.isNotEmpty) ...[
                  _sectionLabel('Pinned'),
                  ...pinned.map((c) => _ConversationTile(conversation: c, onTap: () => widget.onConversationTap(c))),
                ],
                if (unpinned.isNotEmpty) ...[
                  _sectionLabel('All Messages'),
                  ...unpinned.map((c) => _ConversationTile(conversation: c, onTap: () => widget.onConversationTap(c))),
                ],
                if (conversations.isEmpty)
                  const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No conversations found', style: TextStyle(color: Colors.grey)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<User> _getOnlineUsers() {
    final users = <User>[];
    for (final c in widget.provider.conversations) {
      for (final p in c.participants) {
        if (p.isOnline && !users.any((u) => u.id == p.id)) users.add(p);
      }
    }
    return users;
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[500])),
  );
}

class _OnlineAvatar extends StatelessWidget {
  final User user;
  final bool isMe;
  const _OnlineAvatar({required this.user, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            CircleAvatar(radius: 26, backgroundColor: Colors.grey[100], child: Text(user.avatarEmoji, style: const TextStyle(fontSize: 24))),
            if (!isMe) Positioned(bottom: 0, right: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
            if (isMe) Positioned(bottom: 0, right: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.add, size: 10, color: Colors.white))),
          ]),
          const SizedBox(height: 4),
          Text(isMe ? 'Your Story' : user.name.split(' ').first, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  const _ConversationTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final msg = conversation.lastMessage;
    final hasUnread = conversation.unreadCount > 0;
    final timeStr = msg != null ? _formatTime(msg.sentAt) : '';

    return ListTile(
      onTap: onTap,
      leading: Stack(children: [
        CircleAvatar(radius: 26, backgroundColor: Colors.grey[100], child: Text(conversation.avatarEmoji, style: const TextStyle(fontSize: 24))),
        if (conversation.participants.any((p) => p.isOnline))
          Positioned(bottom: 0, right: 0, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
      ]),
      title: Row(children: [
        Expanded(child: Text(conversation.name, style: TextStyle(fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500, fontSize: 16))),
        Text(timeStr, style: TextStyle(fontSize: 12, color: hasUnread ? Theme.of(context).primaryColor : Colors.grey[500])),
      ]),
      subtitle: Row(children: [
        if (conversation.isMuted) Padding(padding: const EdgeInsets.only(right: 4), child: Icon(Icons.volume_off, size: 14, color: Colors.grey[400])),
        Expanded(child: Text(
          msg != null ? (msg.senderId == 'me' ? 'You: ${msg.content}' : msg.content) : 'No messages yet',
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: hasUnread ? Colors.black87 : Colors.grey[500], fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400),
        )),
        if (hasUnread)
          Container(margin: const EdgeInsets.only(left: 8), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Text('${conversation.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
      ]),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dt.month}/${dt.day}';
  }
}
