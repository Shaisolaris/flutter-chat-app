# flutter-chat-app

![CI](https://github.com/Shaisolaris/flutter-chat-app/actions/workflows/ci.yml/badge.svg)

Flutter real-time chat app with conversation list, message history, typing indicators, online presence, read receipts, file sharing indicators, auto-reply simulation, pinned conversations, search, and message grouping. Dart-only with ChangeNotifier state management.

## Stack

- **Framework:** Flutter 3.x, Dart 3.3+
- **State:** ChangeNotifier (ChatProvider)
- **Design:** Material Design 3 with WhatsApp/iMessage-inspired UI

## Features

### Conversation List
- Pinned conversations section at top
- Online status dots on avatars
- Unread count badges with accent color
- Last message preview with sender prefix ("You: ...")
- Relative timestamps (5m, 2h, 3d)
- Muted conversation icon
- Search bar with real-time filtering
- Online users horizontal scroll row

### Chat Screen
- Message bubbles with sent/delivered/read status icons
- Grouped messages by sender (sender name shown on first message)
- Typing indicator with animated dots
- Online/offline status in app bar
- File attachment indicators
- Auto-scroll on new messages
- Message input with send button and attachment icon
- Phone and video call action buttons

### Message Features
- Text messages with proper wrapping
- File message type with attachment icon
- System message type (centered, gray)
- Status tracking: sending → sent → delivered → read
- Double-check mark for delivered, blue for read
- Simulated auto-reply after 2 seconds with typing indicator

## Architecture

```
lib/
├── main.dart                              # App entry with theme and navigation
├── models/models.dart                     # User, Conversation, Message, enums
├── providers/chat_provider.dart           # State: conversations, messages, typing, search, send
├── screens/
│   ├── conversation_list_screen.dart      # Search, online users, pinned/all sections
│   └── chat_screen.dart                   # Message list, typing indicator, input bar
└── widgets/
    └── message_bubble.dart                # Bubble with alignment, status, time, sender
```

## Mock Data

- 5 users with online/offline status
- 5 conversations (4 direct, 1 group) with pinned and muted states
- 12 pre-loaded messages across 2 conversations
- Auto-reply system with 7 response variants
- Simulated typing indicator before auto-reply

## Setup

```bash
git clone https://github.com/Shaisolaris/flutter-chat-app.git
cd flutter-chat-app
flutter create .  # Generate platform directories
flutter pub get
flutter run
```

## Key Design Decisions

**Simulated real-time behavior.** Sending a message triggers a delayed typing indicator (2s), followed by an auto-reply (3s). This demonstrates the full real-time UX without requiring a backend. In production, replace with WebSocket/Firebase listeners.

**Message grouping by sender.** Consecutive messages from the same sender only show the sender name on the first message. This reduces visual noise and matches the pattern used by iMessage and WhatsApp.

**Bubble alignment and styling.** Sent messages align right with dark background. Received messages align left with gray background. The border radius changes on the tail side (bottom-left for received, bottom-right for sent) creating the classic chat bubble shape.

**Conversation pinning and muting.** Pinned conversations display in a separate section above all messages. Muted conversations show a volume-off icon. These are common chat app patterns that demonstrate non-trivial list management.

## License

MIT
