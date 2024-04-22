import 'dart:io';

import 'package:chat/core/models/chat_user.dart';

abstract class AuthService {
  ChatUser? get currentUser;

  Stream<ChatUser?>
      get userChanges; //sempre que mudar o estado do usuario lanca um novo dado no estado do usuario

  Future<void> signup(
    String name,
    String password,
    String email,
    File image,
  );
  Future<void> login(
    String email,
    String password,
  );
  Future<void> logout();
}
