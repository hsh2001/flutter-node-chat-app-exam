import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/chat_room_list_provider.dart';
import 'package:flutter_application_1/provider/nickname_provider.dart';
import 'package:flutter_application_1/screen/chat_screen.dart';
import 'package:flutter_application_1/screen/create_room_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RoomListLoader extends StatefulWidget {
  const RoomListLoader({Key? key}) : super(key: key);

  @override
  _RoomListLoaderState createState() => _RoomListLoaderState();
}

class _RoomListLoaderState extends State<RoomListLoader> {
  late ChatRoomListProvider _chatRoomProvider;

  @override
  void initState() {
    super.initState();
    _chatRoomProvider = Provider.of<ChatRoomListProvider>(Get.context!);
    _chatRoomProvider.reload();
    Provider.of<NicknameProvider>(Get.context!).init();
  }

  @override
  Widget build(BuildContext context) {
    _chatRoomProvider = Provider.of<ChatRoomListProvider>(context);

    return Column(
      children: [
        ...List.generate(
          _chatRoomProvider.list.length,
          (index) => InkWell(
            onTap: () => Get.to(
              () => ChatScreen(id: _chatRoomProvider.list[index].id),
            ),
            child: Container(
              width: Get.width - 24,
              margin: const EdgeInsets.only(left: 12, bottom: 6),
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xffeeeeee),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Text(_chatRoomProvider.list[index].name),
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nickname = Provider.of<NicknameProvider>(context).nickname;

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅앱?!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateRoomScreen()),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Text('Hi $nickname\n'),
              const RoomListLoader(),
            ],
          ),
        ),
      ),
    );
  }
}
