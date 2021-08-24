import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/function/chat.dart';
import 'package:flutter_application_1/provider/nickname_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../constant.dart';

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
  final _channel = IOWebSocketChannel.connect(Uri.parse('ws://$apiServerURL'));
  int _lastChatId = 0;

  void _concatChatList(List<Chat> _newChatList) {
    _chatList.addAll(_newChatList);
    final ids = _chatList.map((e) => e.id).toSet();
    _chatList.retainWhere((x) => ids.remove(x.id));
    _chatList = _chatList.where((chat) => chat.id > 0).toList();
  }

  void _sendToWebSocket(int roomId) {
    _channel.sink.add(
      jsonEncode({
        'lastChatId': _lastChatId,
        'roomId': roomId,
      }),
    );
  }

  void _sendMessage(String message) {
    final roomId = widget.id;
    _sendToWebSocket(roomId);

    final chat = Chat(
      content: message,
      nickname: Provider.of<NicknameProvider>(
        context,
        listen: false,
      ).nickname,
    );

    setState(() {
      _chatList.add(chat);
    });

    Chat.send(
      roomId: roomId,
      chat: chat,
    );
  }

  @override
  void initState() {
    super.initState();

    final roomId = widget.id;
    Chat.load(roomId).then(
      (value) => setState(() {
        _chatList = value;
      }),
    );

    _channel.stream.listen((rawData) {
      final Map<String, dynamic> responseData = jsonDecode(rawData);
      final List<dynamic> chatLogs = responseData['chatLogs'];

      print(chatLogs);

      if (chatLogs.isEmpty) return;

      setState(() {
        _lastChatId = chatLogs.first['id'];
        _concatChatList(Chat.fromMapList(chatLogs));
      });
    });

    _sendToWebSocket(roomId);
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sendMessage(_textEditingController.text);
          _textEditingController.text = '';
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
                position: _chatList[index].isMine()
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
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
