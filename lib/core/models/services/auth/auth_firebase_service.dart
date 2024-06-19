import 'dart:async';
import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
//1- fazer upload da foto do usuario
    final imageName = '${credencial.user!.uid}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);

    //atualiza nome do usuario apenas se estiver presente
    //2- tratar a atualizaco dos atributos do usuario
    await credencial.user?.updateDisplayName(name);
    await credencial.user?.updatePhotoURL(imageUrl);

    // 3. salvar usuario no banco de dados(opcional)
    await _saveChatUser(_toChatUser(credencial.user!, imageUrl));
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

  static ChatUser _toChatUser(User user, [String? imageUrl]) {
    return ChatUser(
        id: user.uid,
        name: user.displayName ?? user.email!.split('@')[0],
        email: user.email!,
        imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png');
  }
}
