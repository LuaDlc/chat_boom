import 'package:chat/core/models/services/auth/auth_service.dart';
import 'package:chat/core/models/services/auth/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = AuthService().currentUser;

    if (user != null) {
      //se usuario diferente de null e enviou a mensagem, faz o clear
      await ChatService().save(_message, user);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            //onCHanged altera o valor da mensagem
            onChanged: (msg) => setState(() => _message = msg),
            decoration: const InputDecoration(
              labelText: 'Enviar mensagem',
            ),
          ),
        ),
        IconButton(
            //trim: para verificar se ha espaco vazio, se houve o botao fica null
            //se nao houver chama o metodo sendMessage
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send))
      ],
    );
  }
}
