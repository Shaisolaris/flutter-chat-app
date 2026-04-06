class DemoChats {
  static final List<Map<String, dynamic>> conversations = [
    {'id': '1', 'name': 'Sarah Chen', 'lastMessage': 'The deployment looks good!', 'time': '2m ago', 'unread': 2},
    {'id': '2', 'name': 'Team Chat', 'lastMessage': 'Alex: Sprint planning at 3pm', 'time': '15m ago', 'unread': 5},
    {'id': '3', 'name': 'James Wilson', 'lastMessage': 'Can you review my PR?', 'time': '1h ago', 'unread': 0},
    {'id': '4', 'name': 'Emily Park', 'lastMessage': 'Thanks for the help!', 'time': '3h ago', 'unread': 0},
  ];
  static final List<Map<String, dynamic>> messages = [
    {'id': 'm1', 'sender': 'Sarah Chen', 'content': 'Hey, the new API endpoint is ready', 'time': '10:30 AM', 'isMe': false},
    {'id': 'm2', 'sender': 'Me', 'content': 'Great! I will test it now', 'time': '10:32 AM', 'isMe': true},
    {'id': 'm3', 'sender': 'Sarah Chen', 'content': 'The deployment looks good!', 'time': '10:45 AM', 'isMe': false},
  ];
}
