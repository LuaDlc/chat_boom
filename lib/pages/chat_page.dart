import 'package:chat/components/messages.dart';
import 'package:chat/components/new_message.dart';
import 'package:chat/core/models/services/auth/auth_service.dart';
import 'package:chat/core/models/services/notification/chat_notification_service.dart';
import 'package:chat/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boom chat'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              items: const [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Sair')
                    ],
                  ),
                )
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const NotificationPage();
                    }),
                  );
                },
                icon: const Icon(Icons.notifications),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  maxRadius: 10,
                  backgroundColor: Colors.red.shade800,
                  child: Text(
                    '${Provider.of<ChatNotificationService>(context).itemsCount}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: const SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Messages(),
          ),
          NewMessage()
        ],
      )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     //adicionando notificacao aleatoria
      //     Provider.of<ChatNotificationService>(context, listen: false).add(
      //       ChatNotification(
      //           title: 'Mais uma notificacao', body: Random().toString()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
