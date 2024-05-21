import 'dart:async';
import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });
  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  } //sempre que mudar o estado do usuario lanca um novo dado no estado do usuario


  @override
  Future<void>newFunction() {};
  @override
  Future<void> signup(
    String name,
    String password,
    String email,
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    UserCredential credencial = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credencial.user != null) return;
    //atualiza nome do usuario apenas se estiver presente
    credencial.user?.updateDisplayName(name);
    // credencial.user?.updatePhotoURL(photoURL)
  }

  @override
  Future<void> login(
    String email,
    String password,
  ) async {}

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  static ChatUser _toChatUser(User user) {
    return ChatUser(
        id: user.uid,
        name: user.displayName ?? user.email!.split('@')[0],
        email: user.email!,
        imageUrl: user.photoURL ?? 'assets/images/avatar.png');
  }
}
