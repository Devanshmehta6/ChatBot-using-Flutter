import 'dart:convert';

// import 'package:flutter/cupertino.dart';

class ChatMessage{
  String? messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});

  factory ChatMessage.fromJson(Map<String, dynamic> jsonData) {
    return ChatMessage(
      messageContent : jsonData['messageContent'],
      messageType: jsonData['messageType']

    );
  }

    static Map<String, dynamic> toMap(ChatMessage msg) => {
        'messageContent' : msg.messageContent,
        'messageType' : msg.messageType
      };

  static String encode(List<ChatMessage> msgs) => json.encode(
        msgs
            .map<Map<String, dynamic>>((msg) => ChatMessage.toMap(msg))
            .toList(),
      );

  static List<ChatMessage> decode(String msgs) =>
      (json.decode(msgs) as List<dynamic>)
          .map<ChatMessage>((item) => ChatMessage.fromJson(item))
          .toList();
//   static List<ChatMessage> decode(String msgs) {
//   // Check if msgs is empty or null
//   if (msgs == Null || msgs.isEmpty) {
//     return []; // Return an empty list
//   }

//   try {
//     // Decode the JSON and handle potential errors
//     final decoded = json.decode(msgs) as List<dynamic>;
//     return decoded.map<ChatMessage>((item) => ChatMessage.fromJson(item)).toList();
//   } on FormatException catch (e) {
//     // Handle potential format exceptions during JSON decoding
//     print("Error decoding messages: $e");
//     return []; // Return an empty list on error
//   }
// }
}