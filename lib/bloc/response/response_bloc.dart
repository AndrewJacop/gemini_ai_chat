import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gemini_tutorial/main.dart';
import 'package:meta/meta.dart';

part 'response_event.dart';
part 'response_state.dart';

class ResponseBloc extends Bloc<ResponseEvent, ResponseState> {
  ResponseBloc() : super(const ResponseInitial()) {
    on<SendMessageStream>(_sendMessageStream);
  }

  void _sendMessageStream(
      SendMessageStream event, Emitter<ResponseState> emit) {
    final data = service.chatWithStream(event.message);

    emit(ResponseSuccess(data));
  }
}
