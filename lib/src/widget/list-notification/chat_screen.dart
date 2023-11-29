import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/ChatModel.dart';
import 'chat_controller.dart';
import 'chatboxscreen.dart';



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

          // Provide a default value for chat when it is null
          chat ??= ChatModel(
            chatId: 'default_chat_id',
            userIds: [], // Provide default values as needed
            messages: [],
          );

          return chatController.chatList.isEmpty
              ? Center(
            child: Text('No chats available. Start a new chat!'),
          )
              : ChatBoxScreen(
            chat: chat,
            chatController: chatController,
            messageController: messageController,
          );
        },
      ),
    );
  }
}
