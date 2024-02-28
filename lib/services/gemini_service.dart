import 'package:gemini_tutorial/models/message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = "AIzaSyAC5_bNsUJ3TJNQbcclo2RGr68i1zD_qL0";

class GeminiService {
  late GenerativeModel model;
  late ChatSession chat;
  Future<void> init() async {
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<Message> chatWith(String message) async {
    final response = await chat.sendMessage(Content.text(message));
    return Message(content: response.text ?? "", isSent: false);
  }

  Stream<String> chatWithStream(String message) {
    return chat
        .sendMessageStream(Content.text(message))
        .map((event) => event.text ?? "");
  }

  Future<void> startChat() async {
    chat = model.startChat();
  }

  List<Content> history() => chat.history.toList();

  bool isSentFromModel(String role) => role == "user";
}
