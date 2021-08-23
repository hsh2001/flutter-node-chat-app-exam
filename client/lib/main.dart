import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/chat_room_list_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'screen/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatRoomListProvider>(
            create: (_) => ChatRoomListProvider()),
      ],
      child: GetMaterialApp(
        title: 'Hello flutter',
        theme: ThemeData(primaryColor: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
