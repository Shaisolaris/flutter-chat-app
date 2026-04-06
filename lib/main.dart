import 'package:flutter/material.dart';
import 'providers/chat_provider.dart';
import 'screens/conversation_list_screen.dart';
import 'screens/chat_screen.dart';
import 'models/models.dart';

void main() => runApp(const ChatApp());

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final _chatProvider = ChatProvider();

  @override
  void initState() {
    super.initState();
    _chatProvider.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatKit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A1A2E)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Color(0xFF1A1A2E), elevation: 0, scrolledUnderElevation: 1),
      ),
      home: ConversationListScreen(
        provider: _chatProvider,
        onConversationTap: (conversation) => _openChat(context, conversation),
      ),
    );
  }

  void _openChat(BuildContext context, Conversation conversation) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChatScreen(conversation: conversation, provider: _chatProvider),
    ));
  }

  @override
  void dispose() { _chatProvider.dispose(); super.dispose(); }
}
