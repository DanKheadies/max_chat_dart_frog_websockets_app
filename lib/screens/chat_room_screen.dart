import 'package:flutter/material.dart';
import 'package:max_chat_dart_frog_websockets_app/main.dart';
// import 'package:max_chat_dart_frog_websockets_app/repositories/repositories.dart';
import 'package:max_chat_dart_frog_websockets_app/widgets/widgets.dart';
import 'package:models/models.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatRoomScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final messageController = TextEditingController();
  final List<Message> messages = [];

  @override
  void initState() {
    _loadMessages();
    _startWebSocket();

    messageRepository.subscribeToMessageUpdates((messageData) {
      final message = Message.fromJson(messageData);
      if (message.chatRoomId == widget.chatRoom.id) {
        messages.add(message);
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  _loadMessages() async {
    final _messages = await messageRepository.fetchMessages(widget.chatRoom.id);
    _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    setState(() {
      messages.addAll(_messages);
    });
  }

  void _sendMessage() async {
    print('sending message...');
    final message = Message(
      chatRoomId: widget.chatRoom.id,
      senderUserId: userId1,
      receiverUserId: userId2,
      content: messageController.text,
      // attachment: Attachment.sampleData[0],
      createdAt: DateTime.now(),
    );

    // setState(() {
    //   messages.add(message);
    // });

    await messageRepository.createMessage(message);

    messageController.clear();
  }

  _startWebSocket() {
    webSocketClient.connect(
      'ws://localhost:8080/ws',
      {
        'Authorization': 'Bearer ....',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final currentParticipant = widget.chatRoom.participants.firstWhere(
      (user) => user.id == userId1,
    );
    final otherParticipant = widget.chatRoom.participants.firstWhere(
      (user) => user.id != userId1,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Avatar(
              imageUrl: otherParticipant.avatarUrl,
              // imageUrl: 'https://i.pravatar.cc/300',
              radius: 18,
            ),
            Text(
              otherParticipant.username,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Send a message
            },
            icon: const Icon(Icons.more_vert),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: (viewInsets.bottom > 0) ? 8 : 0,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final showImage = index + 1 == messages.length ||
                        messages[index + 1].senderUserId !=
                            message.senderUserId;

                    return Row(
                      mainAxisAlignment: (message.senderUserId != userId1)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (showImage && message.senderUserId == userId1)
                          Avatar(
                            imageUrl: otherParticipant.avatarUrl,
                            radius: 12,
                          ),
                        MessageBubble(
                          message: message,
                          width: size.width,
                        ),
                        if (showImage && message.senderUserId != userId1)
                          Avatar(
                            imageUrl: currentParticipant.avatarUrl,
                            radius: 12,
                          ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(100),
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _sendMessage();
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
