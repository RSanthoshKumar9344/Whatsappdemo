import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class SendTextMessage extends ChatEvent {
  final String text;

  const SendTextMessage(this.text);

  @override
  List<Object> get props => [text];
}

class SendMediaMessage extends ChatEvent {
  final File file;
  final bool isVideo;

  const SendMediaMessage({required this.file, required this.isVideo});

  @override
  List<Object> get props => [file, isVideo];
}
