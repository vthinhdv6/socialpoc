// Trong ChatBoxScreen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
        // Trong ChatBoxScreen
        Obx(() {
          List<MessageModel> messages = chatController.activeChatMessages;

          return Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final MessageModel message = messages[index];
                bool isMyMessage = message.userId == FirebaseAuth.instance.currentUser?.uid;

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd/MM HH:mm').format(message.messageTime),
                        style: TextStyle(
                          color: isMyMessage ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 13.0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: isMyMessage ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
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
                        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
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
