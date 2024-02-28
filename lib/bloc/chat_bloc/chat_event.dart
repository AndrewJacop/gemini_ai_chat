part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {
  const ChatEvent();
}

class FetchHistory extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;

  const SendMessage({required this.message});
}
