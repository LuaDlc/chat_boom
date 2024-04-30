import 'package:chat/core/models/services/notification/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    //generics é o chatService com os items da notificacao
    final service = Provider.of<ChatNotificationService>(context);
    final items = service.items;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Notifições'),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, i) => ListTile(
            title: Text(items[i].title),
            subtitle: Text(items[i].body),
            //com o ontap, ao clicar remove o item das notificacoes
            onTap: () => service.remove(i),
          ),
          itemCount: service.itemsCount,
        ));
  }
}
