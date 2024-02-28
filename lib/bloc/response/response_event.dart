part of 'response_bloc.dart';

@immutable
abstract class ResponseEvent {
  const ResponseEvent();
}

class SendMessageStream extends ResponseEvent {
  final String message;

  const SendMessageStream({
    required this.message,
  });
}
