import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/ChatModel.dart';
import '../../model/MessageModel.dart';
import 'chatboxscreen.dart';

class ChatController extends GetxController {
  RxList<ChatModel> chatList = <ChatModel>[].obs;

  Future<void> createOrNavigateToChat(String otherUserId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Check if a chat already exists
      ChatModel? existingChat = chatList.firstWhereOrNull(
            (chat) => chat.userIds.contains(currentUserId) && chat.userIds.contains(otherUserId) &&
                chat.userIds.length == 2,
      );

      if (existingChat != null) {
        // Chat already exists, navigate to the chat screen
        navigateToChat(existingChat);
      } else {
        // Chat doesn't exist, create a new one
        await createChat([currentUserId, otherUserId]);
      }
    } catch (error) {
      print('Error creating/navigating to chat: $error');
    }
  }

  Future<void> createChat(List<String> userIds) async {
    try {
      final DocumentReference<Map<String, dynamic>> chatReference =
      FirebaseFirestore.instance.collection('chats').doc();

      await chatReference.set({
        'chatId': chatReference.id,
        'userIds': userIds,
        'messages': [],
      });
      print('New chat created: $userIds');


      fetchChatsFromFirebase();
    } catch (error) {
      print('Error creating chat: $error');
    }
  }

  Future<void> sendMessage(String chatId, MessageModel? message) async {
    try {
      if (chatId.isNotEmpty && message != null && message.content.isNotEmpty) {
        final DocumentReference<Map<String, dynamic>> chatReference =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

        await chatReference.update({
          'messages': FieldValue.arrayUnion([message.toMap()]),
        });
        print('Message sent: $chatId, $message');

      } else {
        print('ChatId or Message is null or empty');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  Future<void> fetchChatsFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('chats').get();

      if (querySnapshot.docs.isNotEmpty) {
        chatList.assignAll(querySnapshot.docs.map((doc) {
          return ChatModel.fromMap(doc.data());
        }).toList());
      }
    } catch (error) {
      print('Error fetching chats from Firebase: $error');
    }
  }

  Future<void> navigateToChat(ChatModel chat) async {
    print('Navigating to chat: $chat');
    await Get.to(() => ChatBoxScreen(
      chat: chat,
      chatController: this,
      messageController: TextEditingController(),
    ));
  }

}
