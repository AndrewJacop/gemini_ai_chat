part of 'chat_bloc.dart';

@immutable
abstract class ChatState {
  final List<Message> messages;

  const ChatState({
    required this.messages,
  });
}

class ChatInitial extends ChatState {
  const ChatInitial({required super.messages});
}

class ChatFetchSuccessState extends ChatState {
  const ChatFetchSuccessState({required super.messages});
}

class ChatSuccessState extends ChatState {
  const ChatSuccessState({required super.messages});
}

class ChatErrorState extends ChatState {
  final String message;
  const ChatErrorState({
    required super.messages,
    required this.message,
  });
}

class ChatSuccessSent extends ChatState {
  const ChatSuccessSent({required super.messages});
}

class ChatLoadingState extends ChatState {
  const ChatLoadingState({required super.messages});
}
