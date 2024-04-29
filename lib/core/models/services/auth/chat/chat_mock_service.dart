import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/chat/chat_service.dart';

class ChatMockService implements ChatService {
  //lista static
  static final List<ChatMessage> _msgs = [];
  //controller pra criar e salvar nova msg
  static MultiStreamController<List<ChatMessage>>? _controller;
  //stream de dados
  static final _msgStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    controller.add(_msgs);
  });

  Stream<List<ChatMessage>> messagesStream() {
    return _msgStream;
  }

  //metodo pra salvar o chat
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageUrl,
    );
    _msgs.add(newMessage);
    _controller?.add(_msgs.reversed
        .toList()); //altera a ordem das mensagens, adicionando a ultima no
    //final da lista de mensagens
    return newMessage;
  }
}
