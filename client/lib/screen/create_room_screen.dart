import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새로운 채팅방?!'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: '제목을 입력하세요'),
              controller: _textEditingController,
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('생성?!'),
            ),
          ],
        ),
      ),
    );
  }
}
