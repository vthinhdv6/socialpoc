class ChatModel {
  final String chatId; // Primary Key
  final List<String> userIds; // Mảng lưu userId của những người tham gia cuộc trò chuyện
  final List<MessageModel> messages; // Mảng lưu thông tin về tin nhắn

  ChatModel({
    required this.chatId,
    required this.userIds,
    required this.messages,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory ChatModel.fromMap(Map<String, dynamic> data) {
    List<dynamic> messagesData = data['messages'] ?? [];
    List<MessageModel> messages = messagesData.map((message) => MessageModel.fromMap(message)).toList();

    return ChatModel(
      chatId: data['chatId'],
      userIds: List<String>.from(data['userIds']),
      messages: messages,
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> messagesData = messages.map((message) => message.toMap()).toList();

    return {
      'chatId': chatId,
      'userIds': userIds,
      'messages': messagesData,
    };
  }
}

class MessageModel {
  final String messageId; // Primary Key
  final String userId; // Khóa ngoại tới bảng Users
  final String content;
  final DateTime messageTime;

  MessageModel({
    required this.messageId,
    required this.userId,
    required this.content,
    required this.messageTime,
  });

  // Factory constructor để tạo đối tượng từ dữ liệu Firebase
  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      messageId: data['messageId'],
      userId: data['userId'],
      content: data['content'],
      messageTime: DateTime.parse(data['messageTime']),
    );
  }

  // Chuyển đối tượng thành Map để lưu trữ trong Firebase
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'userId': userId,
      'content': content,
      'messageTime': messageTime.toUtc().toIso8601String(),
    };
  }
}
