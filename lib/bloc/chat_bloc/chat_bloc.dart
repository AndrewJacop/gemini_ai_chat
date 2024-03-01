import 'package:bloc/bloc.dart';
import 'package:gemini_tutorial/main.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';

import '../../models/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatInitial(messages: [])) {
    on<FetchHistory>(_fetchHistory);
    on<SendMessage>(_sendMessage);
  }

  Future<void> _fetchHistory(
      FetchHistory event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState(messages: state.messages));
    final messages = service.history().map((e) {
      return Message(
          content: e.parts.map((e) => (e as TextPart).text).join(""),
          isSent: service.isSentFromModel(e.role ?? ""));
    }).toList();

    emit(ChatSuccessState(messages: messages));
  }

  Future<void> _sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState(messages: [
      ...state.messages,
      Message(content: event.message, isSent: true)
    ]));

    await service.chatWith(event.message);
    final messages = service.history().map((e) {
      return Message(
          content: e.parts.fold<String>(
              "",
              (previousValue, element) =>
                  previousValue + (element as TextPart).text),
          isSent: service.isSentFromModel(e.role ?? ""));
    }).toList();
    emit(ChatSuccessState(messages: messages));
  }
}
