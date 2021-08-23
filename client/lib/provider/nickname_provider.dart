import 'dart:math';

import 'package:flutter/material.dart';

final _nicknamePrefix = <String>[
  '행복한',
  '즐거운',
  '활발한',
  '명랑한',
  '기운찬',
  '귀여운',
  '날썐',
  '멋진',
  '늠름한',
  '사나운',
];

final _nicknameSuffix = <String>[
  '토끼',
  '고양이',
  '강아지',
  '거북이',
  '치타',
  '사자',
  '호랑이',
  '사슴',
  '뱀',
  '기린',
];

String getRandomNickname() {
  _nicknamePrefix.shuffle();
  _nicknameSuffix.shuffle();
  final randId = Random().nextInt(9999);
  return '${_nicknamePrefix.first}_${_nicknameSuffix.first}_$randId';
}

class NicknameProvider extends ChangeNotifier {
  String _nickname = getRandomNickname();

  get nickname => _nickname;

  void setNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }
}
