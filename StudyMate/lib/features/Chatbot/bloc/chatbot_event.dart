import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class StartNewChat extends ChatbotEvent {
  final String userId;
  const StartNewChat(this.userId);
}

class LoadOldChat extends ChatbotEvent {
  final String userId;
  final String chatId;

  const LoadOldChat({required this.userId, required this.chatId});
}

class SendChatMessage extends ChatbotEvent {
  final String userId;
  final String message;

  const SendChatMessage({
    required this.userId,
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
