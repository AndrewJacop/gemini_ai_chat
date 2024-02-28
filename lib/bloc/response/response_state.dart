part of 'response_bloc.dart';

@immutable
abstract class ResponseState {
  final Stream<String>? message;

  const ResponseState({this.message});
}

class ResponseInitial extends ResponseState {
  const ResponseInitial({super.message});
}

class ResponseSuccess extends ResponseState {
  const ResponseSuccess(Stream<String> message) : super(message: message);
}
