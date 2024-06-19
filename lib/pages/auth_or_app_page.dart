import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/auth_service.dart';
import 'package:chat/pages/auth_page.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:flutter/material.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  Future<void> init(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized(); //serve para garantir que
    //os widgets estejam inicializados antes de executar o restante do codigo??
  }

  @override
  Widget build(BuildContext context) {
    return
        //sempre que chamar o controller pra adicionar novo user ele vai ser notificado e com a stream escolher qual tela vai
        FutureBuilder(
      future: init(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return StreamBuilder<ChatUser?>(
            stream: AuthService().userChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPage();
              } else {
                return snapshot.hasData ? const ChatPage() : const AuthPage();
              }
            },
          );
        }
      },
    );
  }
}

/*
construtores factory é possivel retornar uma subclasse da classe que chama o construtor
sem que ninguem saiba. é possivel retornar as implementacoes e nao a interface
que nesse caso é de como seria a interface de como seria um servico de autenticacao
*/
