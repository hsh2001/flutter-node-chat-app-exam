import 'package:flutter/material.dart';
import 'package:flutter_application_1/function/chat.dart';

class ChatRoomListProvider extends ChangeNotifier {
  List<Room> _list = [];

  List<Room> get list => _list;

  Future reload() async {
    _list = await Room.getList();
    notifyListeners();
  }
}
