import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/chat/chat_firebase_service.dart';

abstract class ChatService {
  //comportamentos e metodos pra funcionar o chat service
//metodo que consultar os dados
  Stream<List<ChatMessage>> messagesStream();
  //metodo pra salvar o chat
  Future<ChatMessage?> save(String text, ChatUser user);

  factory ChatService() {
    return ChatFirebaseService();
  }
}
