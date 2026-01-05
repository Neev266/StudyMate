import 'package:equatable/equatable.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotLoaded extends ChatbotState {
  final String chatId;
  final List<Map<String, String>> messages;
  final bool isLoading;

  const ChatbotLoaded({
    required this.chatId,
    required this.messages,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [chatId, messages, isLoading];
}

class ChatbotError extends ChatbotState {
  final String error;
  const ChatbotError(this.error);

  @override
  List<Object?> get props => [error];
}
