import 'dart:async';
import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

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
  Future<void> signup(
      String name, String email, String password, File? image) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      // 1. Upload da foto do usuário
      final imageName = '${credential.user!.uid}.jpg';
      final imageUrl = await _uploadUserImage(image, imageName);

      // 2. atualizar os atributos do usuário
      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(imageUrl);

      // 2.5 fazer o login do usuário
      await login(email, password);

      // 3. salvar usuário no banco de dados (opcional)
      _currentUser = _toChatUser(credential.user!, imageUrl, name);
      await _saveChatUser(_currentUser!);
    }

    await signup.delete();
  }

  @override
  Future<void> login(
    String email,
    String password,
  ) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  //metodo privado que retorna o url da imagem q recebe o file
  //metodo ser';a usado dentro do contexto do cadastro
  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    //metodo child uso o nome de uma pasta que quero criar e o nome da imagem q quero persistir no firebaseStorage, com a referencia pra imagem
    final imageRef = storage.ref().child('user_image').child(
        imageName); //ref recebe um path q é opcional, usa um bucket padrao

    //upload do arquivo a partir da referencia da imagem
    //when fazer o upload aguarda um future pra completar o upload
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageUrl,
    });
  }

  static ChatUser _toChatUser(User user, [String? imageUrl, String? name]) {
    return ChatUser(
        id: user.uid,
        name: name ?? user.displayName ?? user.email!.split('@')[0],
        email: user.email!,
        imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png');
  }
}
