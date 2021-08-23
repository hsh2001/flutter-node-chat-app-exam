import 'dart:convert';

import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/provider/nickname_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Room {
  int id;
  String name;

  Room({
    required this.id,
    required this.name,
  });

  static Future<List<Room>> getList() async {
    final response = await http.get(Uri.http(apiServerURL, '/room/list'));
    final List<dynamic> rawRoomList = jsonDecode(response.body);
    return List.generate(
      rawRoomList.length,
      (index) => Room(
        id: rawRoomList[index]['id'],
        name: rawRoomList[index]['name'],
      ),
    );
  }
}

class Chat {
  int id;
  String content;
  String nickname;

  Chat({
    this.id = -1,
    required this.content,
    required this.nickname,
  });

  bool isMine() {
    return nickname ==
        Provider.of<NicknameProvider>(
          Get.context!,
          listen: false,
        ).nickname;
  }

  static Future<List<Chat>> load(int roomId, {int index = 0}) async {
    final response = await http.get(
      Uri.http(
        apiServerURL,
        '/message/list/$roomId',
        {'index': index.toString()},
      ),
    );

    final List<dynamic> rawChatList = jsonDecode(response.body);
    return List.generate(
      rawChatList.length,
      (index) => Chat(
        id: rawChatList[index]['id'],
        content: rawChatList[index]['content'],
        nickname: rawChatList[index]['nickname'],
      ),
    );
  }

  static Future<void> send({
    required Chat chat,
    required int roomId,
  }) async {
    await http.get(
      Uri.http(
        apiServerURL,
        '/message/send',
        {
          'roomId': roomId.toString(),
          "nickname": chat.nickname,
          "content": chat.content,
        },
      ),
    );
  }
}
