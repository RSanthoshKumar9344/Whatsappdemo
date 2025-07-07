import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<SendTextMessage>((event, emit) {
      final newMessage = ChatMessage(
        text: event.text,
        timestamp: DateTime.now(),
      );
      emit(state.copyWith(messages: [...state.messages, newMessage]));
    });

    on<SendMediaMessage>((event, emit) {
      final newMessage = ChatMessage(
        media: event.file,
        isVideo: event.isVideo,
        timestamp: DateTime.now(),
      );
      emit(state.copyWith(messages: [...state.messages, newMessage]));
    });
  }
}
