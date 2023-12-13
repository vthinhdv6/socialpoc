// Trong ChatController
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../common/helpdesk/help_deshk_function.dart';
import '../../model/ChatModel.dart';
import '../../model/MessageModel.dart';
import '../../model/UserModel.dart';
import 'chatboxscreen.dart';
import 'notification.dart';

class ChatController extends GetxController {
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  RxList<MessageModel> activeChatMessages = <MessageModel>[].obs;


  Future<void> createOrNavigateToChat(String otherUserId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

      ChatModel? existingChat = chatList.firstWhereOrNull(
            (chat) => chat.userIds.contains(currentUserId) && chat.userIds.contains(otherUserId) &&
            chat.userIds.length == 2,
      );

      if (existingChat != null) {
        navigateToChat(existingChat);
      } else {
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

        // Check if the chat exists
        final chatSnapshot = await chatReference.get();
        if (chatSnapshot.exists) {
          // Update the existing chat
          await chatReference.update({
            'messages': FieldValue.arrayUnion([message.toMap()]),
          });

          // Fetch and update local messages for the chat
          await fetchMessagesForChat(ChatModel.fromMap(chatSnapshot.data()!));
        } else {
          print('Chat does not exist: $chatId');
        }

        // If the chat doesn't exist, create a new one (optional)
        // if (!chatSnapshot.exists) {
        //   await createChat([FirebaseAuth.instance.currentUser?.uid ?? '', 'otherUserId']);
        // }

        print('Message sent: $chatId, $message');
      } else {
        print('ChatId or Message is null or empty');
      }
      showNotification('tin nhắn', 'bạn có tin nhắn mới');
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

  Future<void> fetchMessagesForChat(ChatModel chat) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> chatSnapshot =
      await FirebaseFirestore.instance.collection('chats').doc(chat.chatId).get();

      if (chatSnapshot.exists) {
        List<MessageModel> messages = (chatSnapshot.data()?['messages'] as List<dynamic>?)
            ?.map((messageData) => MessageModel.fromMap(messageData))
            .toList() ??
            [];

        activeChatMessages.assignAll(messages);
      }
    } catch (error) {
      print('Error fetching messages for chat ${chat.chatId}: $error');
    }
  }
  Future<void> fetchUserInformationForChat(List<MessageModel> messages) async {
    try {
      for (MessageModel message in messages) {
        UserModel sender = await fetchUserInformation(message.userId);
        message.receiver = sender;  // Đổi tên thành receiver

        // Fetch user information for the receiver
        if (message.receiverId != null) {
          UserModel receiver = await fetchUserInformation(message.receiverId!);
          message.receiver = receiver;
        }
      }
    } catch (error) {
      print('Error fetching user information for chat: $error');
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
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }


}
