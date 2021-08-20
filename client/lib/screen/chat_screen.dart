import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatItem extends StatelessWidget {
  final MainAxisAlignment position;
  final String message;

  const ChatItem({
    Key? key,
    required this.position,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: position,
      children: [
        Container(
          child: Text(message),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xffdddddd),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        )
      ],
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(_textEditingController.text);
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
          children: const [
            ChatItem(
              position: MainAxisAlignment.end,
              message: '안녕하세요',
            ),
            ChatItem(
              position: MainAxisAlignment.start,
              message: '네 안녕합니다',
            ),
            ChatItem(
              position: MainAxisAlignment.end,
              message: '반갑습니다.',
            ),
            ChatItem(
              position: MainAxisAlignment.end,
              message: '이름이 뭔가요?',
            ),
            ChatItem(
              position: MainAxisAlignment.center,
              message: '상대방이 채팅방을 떠났습니다.',
            ),
          ],
        ),
      ),
    );
  }
}
