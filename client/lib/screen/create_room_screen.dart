import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/provider/chat_room_list_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
              onPressed: () async {
                final title = _textEditingController.text;
                _textEditingController.text = '';
                await http.get(Uri.http(apiServerURL, '/room/create/$title'));
                await Provider.of<ChatRoomListProvider>(
                  Get.context!,
                  listen: false,
                ).reload();
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
