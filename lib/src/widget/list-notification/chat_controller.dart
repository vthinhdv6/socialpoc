// ChatController.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/ChatModel.dart';
import '../../model/MessageModel.dart';

class ChatController extends GetxController {
  RxList<ChatModel> chatList = <ChatModel>[].obs;
  ChatModel? _currentChat;

  ChatModel? get currentChat => _currentChat;

  set currentChat(ChatModel? chat) {
    _currentChat = chat;
    update();
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

  Future<void> createChat(List<String> userIds) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> existingChat =
      await FirebaseFirestore.instance.collection('chats').where('userIds', isEqualTo: userIds).get();

      if (existingChat.docs.isNotEmpty) {
        print('Chat already exists');
        return;
      }

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
      if (chatId.isNotEmpty && message != null) {
        final DocumentReference<Map<String, dynamic>> chatReference =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

        await chatReference.update({
          'messages': FieldValue.arrayUnion([message.toMap()]),
        });
      } else {
        print('ChatId or Message is null or empty');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }
}
