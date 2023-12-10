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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: GetBuilder<ChatController>(
        builder: (chatController) {
          return chatController.chatList.isEmpty
              ? Center(
            child: Text('No chats available. Start a new chat!'),
          )
              : ListView.builder(
            itemCount: chatController.chatList.length,
            itemBuilder: (context, index) {
              final ChatModel chat = chatController.chatList[index];
              return ListTile(
                title: Text('Chat ${index + 1}'),
                onTap: () async {
                  // Gọi hàm chuyển đến màn hình chat
                  await chatController.navigateToChat(chat);
                },
              );
            },
          );
        },
      ),
    );
  }
}

