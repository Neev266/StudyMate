import 'package:flutter/material.dart';
import 'package:flutter_app/features/Chatbot/data/chatbot_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/features/Chatbot/bloc/chatbot_bloc.dart';
import 'package:flutter_app/features/Chatbot/bloc/chatbot_event.dart';
import 'package:flutter_app/features/Chatbot/bloc/chatbot_state.dart';

class ChatbotPage extends StatefulWidget {
  final String? userId;
  const ChatbotPage({super.key, required this.userId});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

@override
  void initState() {
    super.initState();

    Future.microtask(() {
      final bloc = context.read<ChatbotBloc>();

      // ✅ Start chat ONLY if app just launched and no chat exists
      if (bloc.state is ChatbotInitial) {
        bloc.add(
          StartNewChat(widget.userId!),
        );
      }
    });
  }



  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("🧪 CHATBOT PAGE sees ChatbotBloc = ${context.read<ChatbotBloc>().hashCode}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (_, state) => _scrollToBottom(),
        builder: (context, state) {
          if (state is ChatbotLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: state.messages.length,
                    itemBuilder: (_, i) => _buildMessage(state.messages[i]),
                  ),
                ),
    
                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
    
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _controller,
                        onSubmitted: (v) {
                          context.read<ChatbotBloc>().add(
                            SendChatMessage(
                              userId: widget.userId!,
                              message: v,
                            ),
                          );
                          _controller.clear();
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          hintText: "Ask something...",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        context.read<ChatbotBloc>().add(
                          SendChatMessage(
                            userId: widget.userId!,
                            message: _controller.text,
                          ),
                        );
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ],
            );
          }
    
          return const Center(child: CircularProgressIndicator());
        },
      ),
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
}
