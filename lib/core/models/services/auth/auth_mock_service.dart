import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  @override
  ChatUser? get currentUser {
    return null;
  }

  @override
  Stream<ChatUser?>
      get userChanges {} //sempre que mudar o estado do usuario lanca um novo dado no estado do usuario

  @override
  Future<void> signup(
    String name,
    String password,
    String email,
    File image,
  ) async {}
  @override
  Future<void> login(
    String email,
    String password,
  ) async {}
  @override
  Future<void> logout() async {}
}
