import 'dart:async';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    return const Stream<List<ChatMessage>>.empty();
  }

  //metodo pra salvar o chat
  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    // ChatMessage => Map<String, dynamic>
    store.collection('chat').add({
      'text': text,
      'createdAt': DateTime.now().toIso8601String(),
      'userId': user.id,
      'userName': user.name,
      'userImageUrl': user.imageUrl,
    });

    return null;
  }
}
