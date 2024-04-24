import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  static final _defaultUser = ChatUser(
    id: '456',
    name: 'Ana',
    email: 'ana@ana.com',
    imageUrl: 'assets/images/avatar.png',
  );
  static final Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
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
  Future<void> signup(
    String name,
    String password,
    String email,
    File? image,
  ) async {
    //crio um novo usuario
    final newUser = ChatUser(
        id: Random().nextDouble().toString(),
        name: name,
        email: email,
        imageUrl: image?.path ?? 'assets/images/avatar.png');
    //adiciona mais um usuario no map
    _users.putIfAbsent(email, () => newUser);
    //e agr pode fazer o update e o login chamando o update user passando o newUser
    _updateUser(newUser);
  }

  @override
  Future<void> login(
    String email,
    String password,
  ) async {
    _updateUser(_users[email]);
  }

  @override
  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
