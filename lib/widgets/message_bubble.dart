import 'package:flutter/material.dart';
import 'package:max_chat_dart_frog_websockets_app/main.dart';
import 'package:models/models.dart';

class MessageBubble extends StatelessWidget {
  final double width;
  final Message message;

  const MessageBubble({
    super.key,
    required this.message,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = (message.senderUserId != userId1)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    final color = (message.senderUserId == userId1)
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    final textColor = (message.senderUserId == userId1)
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSecondary;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: width * 0.66,
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message.content ?? '',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: textColor,
              ),
        ),
      ),
    );
  }
}
