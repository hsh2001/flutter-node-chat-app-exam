import 'dart:convert';

import 'package:flutter_application_1/constant.dart';
import 'package:http/http.dart' as http;

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
