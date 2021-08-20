import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/chat_screen.dart';
import 'package:flutter_application_1/screen/create_room_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              ...List.generate(
                30,
                (index) => InkWell(
                  onTap: () => Get.to(() => const ChatScreen()),
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
                    child: const Text("1"),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
