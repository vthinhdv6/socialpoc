import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/ChatModel.dart';
import '../../model/MessageModel.dart';

import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreenBody(),
    );
  }
}

class ChatScreenBody extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: GetBuilder<ChatController>(
        builder: (chatController) {
          ChatModel? chat = chatController.currentChat;

          if (chat == null) {
            return Center(
              child: Text('Please select a chat to start messaging.'),
            );
          }

          return ChatBoxScreen(chat: chat, chatController: chatController, messageController: messageController);
        },
      ),
    );
  }
}

// ChatBoxScreen
// ChatBoxScreen
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

                      // Optionally, you can add logic to scroll to the latest message
                      // using a ScrollController and ScrollPosition.
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
