import 'package:chat/core/models/chat_notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [];

//retorna a quantidade de itens
  int get itemsCount {
    return _items.length;
  }

  List<ChatNotification> get items {
    return [..._items];
  }

  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int i) async {
    _items.removeAt(i);
    notifyListeners();
  }

  Future<void> init() async {
    await _configureForeground();
  }

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _configureForeground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessage.listen((msg) {
        if (msg.notification == null) return;

        add(ChatNotification(
            title: msg.notification!.title ?? "Nao informado",
            body: msg.notification!.body ?? 'nao informado'));
      });
    }
  }
}
