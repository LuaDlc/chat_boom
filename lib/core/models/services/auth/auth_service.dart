import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/auth_firebase_service.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?>
      get userChanges; //sempre que mudar o estado do usuario lanca um novo dado no estado do usuario

  Future<void> signup(
    String name,
    String password,
    String email,
    File? image,
  );
  Future<void> login(
    String email,
    String password,
  );
  Future<void> logout();

//vantagem do factory: nao precisa retornar uma instancia da classe, por ser abstrata, mas pode instanciar implementacoes
  factory AuthService() {
    //classe generica
    return AuthFirebaseService(); //implementacao
  }
}
