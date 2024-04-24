// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chat/core/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  static const _defatultImage = 'assets/images/avatar.png';
  final ChatMessage message;
  final bool belongsToCurrentUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.belongsToCurrentUser,
  }) : super(key: key);

  Widget _showUserImage(String imageURL) {
    ImageProvider? provider;

    final uri = Uri.parse(imageURL);
    /*
  scheme é  protocolo, neste caso é o file
  'file://...' protocolo local
  'http://' rprotocolo rede
  'https...'
  */
    if (uri.path.contains(_defatultImage)) {
      provider = const AssetImage(_defatultImage);
    }
    if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }
    return CircleAvatar(
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongsToCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: belongsToCurrentUser
                        ? Colors.grey.shade300
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: belongsToCurrentUser
                            ? const Radius.circular(12)
                            : const Radius.circular(0),
                        bottomRight: belongsToCurrentUser
                            ? const Radius.circular(0)
                            : const Radius.circular(12))),
                width: 180,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                          color: belongsToCurrentUser
                              ? Colors.black
                              : Colors.white),
                    ),
                    Text(
                      message.userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: belongsToCurrentUser
                              ? Colors.black
                              : Colors.white),
                    ),
                  ],
                )),
          ],
        ),
        Positioned(
            top: 0,
            left: belongsToCurrentUser ? null : 165,
            right: belongsToCurrentUser ? 165 : null,
            child: _showUserImage(message.userImageURL)),
      ],
    );
  }
}
