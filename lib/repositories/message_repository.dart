import 'dart:async';
import 'dart:convert';

import 'package:max_chat_dart_frog_websockets_app/services/services.dart';
import 'package:models/models.dart';

class MessageRepository {
  final ApiClient apiClient;
  final WebSocketClient webSocketClient;
  StreamSubscription? _messageSubscription;

  MessageRepository({
    required this.apiClient,
    required this.webSocketClient,
  });

  Future<void> createMessage(Message message) async {
    // final payload = "{ 'message.create': ${message.toJson()} }";
    // webSocketClient.send(payload);
    final payload = {
      'event': 'message.create',
      'data': message.toJson(),
    };
    webSocketClient.send(jsonEncode(payload));
  }

  Future<List<Message>> fetchMessages(String chatRoomId) async {
    final response = await apiClient.fetchMessages(chatRoomId);
    final messages = (response['messages'] as List)
        .map((message) => Message.fromJson(message))
        .toList();
    return messages;
  }

  // TODO: Subscribe only to the current chat room.
  void subscribeToMessageUpdates(
    void Function(Map<String, dynamic>) onMessageReceived,
  ) {
    _messageSubscription = webSocketClient.messageUpdates().listen(
      (message) {
        onMessageReceived(message);
      },
    );
  }

  void unsubscribeFromMessageUpdates() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }
}
