import 'package:max_chat_dart_frog_websockets_app/services/api_client.dart';
import 'package:models/models.dart';

class MessageRepository {
  final ApiClient apiClient;
  // final WebSocketClient webSocketClient;

  MessageRepository({
    required this.apiClient,
  });

  createMessage() {
    throw UnimplementedError();
  }

  Future<List<Message>> fetchMessages(String chatRoomId) async {
    final response = await apiClient.fetchMessages(chatRoomId);
    final messages = (response['messages'] as List)
        .map((message) => Message.fromJson(message))
        .toList();
    return messages;
  }
}
