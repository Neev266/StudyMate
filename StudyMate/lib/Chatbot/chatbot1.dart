import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chatbot_service.dart';

class ChatbotPage extends StatefulWidget {
  final String? userId;

  const ChatbotPage({super.key, required this.userId});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  final ChatbotService _chatService = ChatbotService();

  String? chatId;
  bool _isLoading = false;

  // Gemini API
  final String apiKey = "AIzaSyCUXqnsHHtPcpbz8GabrZnClvdH53R5AZs";
  final String modelName = "gemini-2.5-flash";

  @override
  void initState() {
    super.initState();
    _startNewChat();
  }

  /// Auto-scroll to newest message
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  /// Start new chat
  Future<void> _startNewChat() async {
    final id = await _chatService.createNewChat(widget.userId!);
    if (!mounted) return;
    setState(() {
      chatId = id;
      _messages.clear();
    });
  }

  /// Load old chat
  Future<void> _loadOldChat(String oldChatId) async {
    final msgs = await _chatService.loadChatMessages(
      userId: widget.userId!,
      chatId: oldChatId,
    );

    if (!mounted) return;

    setState(() {
      chatId = oldChatId;
      _messages.clear();
      _messages.addAll(msgs.map((m) => {
            "role": m["role"],
            "text": m["text"],
          }));
    });

    _scrollToBottom();
  }

  /// Send message
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty || chatId == null) return;

    if (!mounted) return;

    setState(() {
      _messages.add({"role": "user", "text": message});
      _isLoading = true;
    });

    _scrollToBottom();
    _controller.clear();

    // Save user message
    await _chatService.saveMessage(
      userId: widget.userId!,
      chatId: chatId!,
      role: "user",
      text: message,
    );

    // Build full conversation history
    final history = _messages.map((msg) {
      return {
        "role": msg["role"],
        "parts": [
          {"text": msg["text"]!}
        ]
      };
    }).toList();

    String botReply = "⚠️ No response";

    try {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey",
      );

      final body = jsonEncode({"contents": history});

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        botReply =
            data["candidates"][0]["content"]["parts"][0]["text"] ?? "⚠️ No reply";
          await _chatService.saveMessage(
            userId: widget.userId!,
            chatId: chatId!,
            role: "bot",
            text: botReply,
    );
           print(response.body);
      }
    } catch (e) {
      botReply = "Error: $e";
    }

    // Save bot reply
    

    if (!mounted) return;

    setState(() {
      _messages.add({"role": "bot", "text": botReply});
      _isLoading = false;
    });

    _scrollToBottom();
  }

  /// Show chat history
  void _showHistoryMenu() async {
    final chats = await _chatService.getChatHistory(widget.userId!);
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        children: chats.map((chat) {
          return ListTile(
            title: Text(chat["lastMessage"]!.isEmpty
                ? "Untitled Chat"
                : chat["lastMessage"]!),
            subtitle: Text("Tap to open • Long press to delete"),
            onTap: () {
              Navigator.pop(context);
              _loadOldChat(chat["id"]);
            },
            onLongPress: () async {
              await _chatService.deleteChat(
                userId: widget.userId!,
                chatId: chat["id"],
              );

              Navigator.pop(context);
              _showHistoryMenu();
            },
          );
        }).toList(),
      ),
    );
  }

  /// Build three-dots menu
  Widget _buildMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == "new") _startNewChat();
        if (value == "history") _showHistoryMenu();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: "new", child: Text("🆕 New Chat")),
        const PopupMenuItem(value: "history", child: Text("📜 History")),
      ],
    );
  }

  Widget _buildMessage(Map<String, String> m) {
    final isUser = m["role"] == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          m["text"]!,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Chatbot",
        style: TextStyle(color: Colors.black),
        ),
        actions: [_buildMenuButton()],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildMessage(_messages[i]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: sendMessage,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Ask something...",
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => sendMessage(_controller.text),
              )
            ],
          )
        ],
      ),
    );
  }
}
