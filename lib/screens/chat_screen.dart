import 'package:flutter/material.dart';
import '../models/models.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final Conversation conversation;
  final ChatProvider provider;

  const ChatScreen({super.key, required this.conversation, required this.provider});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.provider.markAsRead(widget.conversation.id);
    widget.provider.addListener(_onUpdate);
  }

  void _onUpdate() {
    if (mounted) setState(() {});
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.provider.sendMessage(widget.conversation.id, text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.provider.getMessages(widget.conversation.id);
    final isTyping = widget.provider.isTyping(widget.conversation.id);
    final onlineParticipant = widget.conversation.participants.isNotEmpty ? widget.conversation.participants.first : null;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.grey[100], child: Text(widget.conversation.avatarEmoji, style: const TextStyle(fontSize: 18))),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.conversation.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(
              isTyping ? 'typing...' : (onlineParticipant?.isOnline == true ? 'online' : 'offline'),
              style: TextStyle(fontSize: 12, color: isTyping || onlineParticipant?.isOnline == true ? Colors.green : Colors.grey),
            ),
          ]),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
              ? Center(child: Text('Say hi to ${widget.conversation.name}! 👋', style: TextStyle(color: Colors.grey[400], fontSize: 16)))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: messages.length + (isTyping ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == messages.length && isTyping) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 4, right: 48),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(18)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            for (var j = 0; j < 3; j++) ...[
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle)),
                              if (j < 2) const SizedBox(width: 4),
                            ],
                          ]),
                        ),
                      );
                    }
                    final msg = messages[i];
                    final isMe = msg.senderId == ChatProvider.currentUserId;
                    final showSender = i == 0 || messages[i - 1].senderId != msg.senderId;
                    return MessageBubble(message: msg, isMe: isMe, showSender: showSender);
                  },
                ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
            child: SafeArea(
              child: Row(children: [
                IconButton(icon: const Icon(Icons.attach_file, color: Colors.grey), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 4),
                CircleAvatar(
                  backgroundColor: const Color(0xFF1A1A2E),
                  child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: _send),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.provider.removeListener(_onUpdate);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
