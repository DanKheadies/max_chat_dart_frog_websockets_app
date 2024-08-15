import 'package:flutter/material.dart';
import 'package:max_chat_dart_frog_websockets_app/repositories/message_repository.dart';
import 'package:max_chat_dart_frog_websockets_app/screens/screens.dart';
import 'package:max_chat_dart_frog_websockets_app/services/api_client.dart';
import 'package:max_chat_dart_frog_websockets_app/services/websocket_client.dart';
import 'package:models/models.dart';

final ApiClient apiClient = ApiClient(
  tokenProvider: () async {
    // TODO: Get the bearer token of the current user.
    return '';
  },
);

final webSocketClient = WebSocketClient();
final messageRepository = MessageRepository(
  apiClient: apiClient,
  webSocketClient: webSocketClient,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChatRoomScreen(chatRoom: chatRoom),
    );
  }
}

const userId1 = '0db9987d-ef95-41f8-9c8f-efd499769bab';
const userId2 = 'c926f70e-2085-4991-b8a0-b43236cc77a8';

final chatRoom = ChatRoom(
  id: '8d162274-6cb8-4776-815a-8e721ebfb76d',
  participants: const [
    User(
      id: userId1,
      username: 'User 1',
      phone: '1234512345',
      email: 'user1@email.com',
      avatarUrl: 'https://i.pravatar.cc/300',
      status: 'online',
    ),
    User(
      id: userId2,
      username: 'User 2',
      phone: '5432154321',
      email: 'user2@email.com',
      avatarUrl: 'https://i.pravatar.cc/300',
      status: 'online',
    ),
  ],
  lastMessage: Message(
    id: 'de120f3a-dbca-4330-9e2e-18b55a2fb9e5',
    chatRoomId: '8d162274-6cb8-4776-815a-8e721ebfb76d',
    senderUserId: userId1,
    receiverUserId: userId2,
    content: 'Hey! I am good, thanks.',
    createdAt: DateTime(2023, 12, 1, 1, 0, 0),
  ),
  unreadCount: 0,
);

// final messages = [
//   Message(
//     id: 'de120f3a-dbca-4330-9e2e-18b55a2fb9e5',
//     chatRoomId: '8d162274-6cb8-4776-815a-8e721ebfb76d',
//     senderUserId: userId1,
//     receiverUserId: userId2,
//     content: 'Hey! I am good, thanks.',
//     createdAt: DateTime(2023, 12, 1, 1, 0, 10),
//   ),
//   Message(
//     id: '18b55a2fb9e5-de120f3a-dbca-4330-9e2e',
//     chatRoomId: '8d162274-6cb8-4776-815a-8e721ebfb76d',
//     senderUserId: userId2,
//     receiverUserId: userId1,
//     content: 'Hi, how are you?',
//     createdAt: DateTime(2023, 12, 1, 1, 0, 0),
//   ),
// ];
