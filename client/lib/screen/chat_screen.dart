import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/function/chat.dart';
import 'package:flutter_application_1/provider/nickname_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChatItem extends StatelessWidget {
  final MainAxisAlignment position;
  final String message;
  final String nickname;

  const ChatItem({
    Key? key,
    required this.position,
    required this.message,
    this.nickname = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: position,
      children: [
        Column(
          children: [
            Text(nickname),
            Container(
              child: Text(message),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xffdddddd),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ChatScreen extends StatefulWidget {
  final int id;

  const ChatScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Chat> _chatList = [];
  final _textEditingController = TextEditingController();

  Future _reloadChat() {
    return Chat.load(widget.id).then(
      (value) => setState(() {
        _chatList = value;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _reloadChat();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _reloadChat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final message = _textEditingController.text;
          _textEditingController.text = '';

          Chat.send(
            roomId: widget.id,
            chat: Chat(
              content: message,
              nickname: Provider.of<NicknameProvider>(
                context,
                listen: false,
              ).nickname,
            ),
          ).then((_) => _reloadChat());
        },
        child: const Icon(Icons.send),
      ),
      appBar: AppBar(
        title: const Text('채팅방?!'),
      ),
      bottomSheet: Container(
        color: Colors.blue,
        child: Container(
          child: TextField(
            controller: _textEditingController,
          ),
          padding: EdgeInsets.only(
            bottom: Get.mediaQuery.padding.bottom,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              _chatList.length,
              (index) => ChatItem(
                position: MainAxisAlignment.end,
                message: _chatList[index].content,
                nickname: _chatList[index].nickname,
              ),
            ),
            if (_chatList.isEmpty) const Text('아직 대화가 없어요.'),
          ],
        ),
      ),
    );
  }
}
