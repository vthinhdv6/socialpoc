import 'package:flutter/material.dart';

import '../../model/ChatModel.dart';
import '../../model/MessageModel.dart';
import 'chat_controller.dart';


class ChatBoxScreen extends StatelessWidget {
  final ChatModel chat;
  final ChatController chatController;
  final TextEditingController messageController;

  ChatBoxScreen({
    required this.chat,
    required this.chatController,
    required this.messageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: chat.messages?.length ?? 0,
            itemBuilder: (context, index) {
              if (chat.messages != null) {
                final MessageModel message = chat.messages![index];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text('From: ${message.userId} - ${message.messageTime}'),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (chat != null && chat.messages != null) {
                    if (messageController.text.isNotEmpty) {
                      final MessageModel newMessage = MessageModel(
                        messageId: 'unique_id',
                        userId: 'current_user_id',
                        content: messageController.text,
                        messageTime: DateTime.now(),
                      );
                      chatController.sendMessage(chat.chatId, newMessage);
                      messageController.clear();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}