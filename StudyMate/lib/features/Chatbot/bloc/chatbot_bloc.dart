import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../data/chatbot_service.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotService chatService;

  String? _chatId;
  final List<Map<String, String>> _messages = [];

  final String apiKey = "AIzaSyCUXqnsHHtPcpbz8GabrZnClvdH53R5AZs";
  final String modelName = "gemini-2.5-flash";

  ChatbotBloc(this.chatService) : super(ChatbotInitial()) {
    on<StartNewChat>(_onStartNewChat);
    on<LoadOldChat>(_onLoadOldChat);
    on<SendChatMessage>(_onSendMessage);
  }

  Future<void> _onStartNewChat(
      StartNewChat event, Emitter<ChatbotState> emit) async {
    final id = await chatService.createNewChat(event.userId);
    _chatId = id;
    _messages.clear();

    emit(ChatbotLoaded(chatId: _chatId!, messages: List.from(_messages)));
  }

  Future<void> _onLoadOldChat(
      LoadOldChat event, Emitter<ChatbotState> emit) async {
    final msgs = await chatService.loadChatMessages(
      userId: event.userId,
      chatId: event.chatId,
    );

    _chatId = event.chatId;
    _messages
      ..clear()
      ..addAll(msgs.map((m) => {
            "role": m["role"],
            "text": m["text"],
          }));

    emit(ChatbotLoaded(chatId: _chatId!, messages: List.from(_messages)));
  }

  Future<void> _onSendMessage(
      SendChatMessage event, Emitter<ChatbotState> emit) async {
    if (_chatId == null || event.message.trim().isEmpty) return;

    _messages.add({"role": "user", "text": event.message});
    emit(ChatbotLoaded(
      chatId: _chatId!,
      messages: List.from(_messages),
      isLoading: true,
    ));

    await chatService.saveMessage(
      userId: event.userId,
      chatId: _chatId!,
      role: "user",
      text: event.message,
    );

    final history = _messages.map((msg) {
      return {
        "role": msg["role"],
        "parts": [
          {"text": msg["text"]!}
        ]
      };
    }).toList();

    try {
      final response = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$apiKey",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"contents": history}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply =
            data["candidates"][0]["content"]["parts"][0]["text"];

        await chatService.saveMessage(
          userId: event.userId,
          chatId: _chatId!,
          role: "model",
          text: botReply,
        );

        _messages.add({"role": "model", "text": botReply});
      }
    } catch (_) {}

    emit(ChatbotLoaded(
      chatId: _chatId!,
      messages: List.from(_messages),
      isLoading: false,
    ));
  }
}
