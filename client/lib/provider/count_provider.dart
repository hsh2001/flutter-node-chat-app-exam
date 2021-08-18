import 'package:flutter/material.dart';

class CountProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void _add(int amount) {
    _count += amount;
    notifyListeners();
  }

  void up() => _add(1);
  void down() => _add(-1);
}
