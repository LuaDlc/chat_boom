import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/chat/chat_service.dart';

class ChatMockService implements ChatService {
  //lista static
  static final List<ChatMessage> _msgs = [
    ChatMessage(
      id: '1',
      text: 'Bom dia',
      createdAt: DateTime.now(),
      userId: '123',
      userName: 'Bia',
      userImageURL: "assets/images/avatar.png",
    ),
    ChatMessage(
      id: '2',
      text: 'Bom dia, teremos reuniao hoje?',
      createdAt: DateTime.now(),
      userId: '456',
      userName: 'Ana',
      userImageURL: "assets/images/avatar.png",
    ),
    ChatMessage(
      id: '1',
      text: 'Sim. Pode ser agora.',
      createdAt: DateTime.now(),
      userId: '123',
      userName: 'Bia',
      userImageURL: "assets/images/avatar.png",
    )
  ];
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
    _controller?.add(_msgs);
    return newMessage;
  }
}
