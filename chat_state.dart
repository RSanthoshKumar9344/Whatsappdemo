import 'dart:io';
import 'package:equatable/equatable.dart';

class ChatMessage {
  final String? text;
  final File? media;
  final bool isVideo;
  final DateTime timestamp;

  ChatMessage(
      {this.text, this.media, this.isVideo = false, required this.timestamp});
}

class ChatState extends Equatable {
  final List<ChatMessage> messages;

  const ChatState({this.messages = const []});

  ChatState copyWith({List<ChatMessage>? messages}) {
    return ChatState(messages: messages ?? this.messages);
  }

  @override
  List<Object?> get props => [messages];
}
