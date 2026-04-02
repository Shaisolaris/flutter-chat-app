import 'package:flutter/material.dart';
import '../models/models.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool showSender;

  const MessageBubble({super.key, required this.message, required this.isMe, this.showSender = false});

  @override
  Widget build(BuildContext context) {
    final time = '${message.sentAt.hour.toString().padLeft(2, '0')}:${message.sentAt.minute.toString().padLeft(2, '0')}';

    if (message.type == MessageType.system) {
      return Center(child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(message.content, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      ));
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: EdgeInsets.only(top: showSender ? 12 : 2, bottom: 2, left: isMe ? 48 : 0, right: isMe ? 0 : 48),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (showSender && !isMe)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 2),
                child: Text(message.senderName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF1A1A2E) : Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (message.type == MessageType.file)
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.attach_file, size: 16, color: isMe ? Colors.white70 : Colors.grey[600]),
                      const SizedBox(width: 4),
                      Flexible(child: Text(message.content, style: TextStyle(fontSize: 15, color: isMe ? Colors.white : Colors.black87, decoration: TextDecoration.underline))),
                    ])
                  else
                    Text(message.content, style: TextStyle(fontSize: 15, color: isMe ? Colors.white : Colors.black87, height: 1.3)),
                  const SizedBox(height: 4),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(time, style: TextStyle(fontSize: 11, color: isMe ? Colors.white54 : Colors.grey[500])),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(_statusIcon(message.status), size: 14, color: message.status == MessageStatus.read ? Colors.blue[200] : Colors.white54),
                    ],
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending: return Icons.access_time;
      case MessageStatus.sent: return Icons.check;
      case MessageStatus.delivered: return Icons.done_all;
      case MessageStatus.read: return Icons.done_all;
    }
  }
}
