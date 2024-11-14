import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'fallback_responses.dart'; // Import fallback responses

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: "Hari",
    lastName: "Ram",
  );
  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: "Legal",
    lastName: "Assist",
  );
  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  void initState() {
    super.initState();
    // Adding initial message to prompt user to enter a legal prompt
    _messages.insert(
      0,
      ChatMessage(
        user: _gptChatUser,
        createdAt: DateTime.now(),
        text:
            "Please enter a legal-related prompt (e.g., 'Can you tell me what happens if someone is caught driving drunk?')",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(
          0,
          166,
          126,
          1,
        ),
        title: Text(
          "LegalAssist",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromRGBO(
            0,
            166,
            126,
            1,
          ),
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
        typingUsers: _typingUsers,
      ),
    );
  }

  void getChatResponse(ChatMessage m) {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    String? response = fallbackResponses.entries
        .firstWhere(
          (entry) => m.text.toLowerCase().contains(entry.key),
          orElse: () => MapEntry(
              "default", "Sorry, I couldn't find relevant legal information."),
        )
        .value;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _gptChatUser,
            createdAt: DateTime.now(),
            text: response,
          ),
        );
        _typingUsers.remove(_gptChatUser);
      });
    });
  }
}
