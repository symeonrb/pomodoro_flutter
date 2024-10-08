import 'dart:math';

import 'package:flutter/material.dart';

// 20 chars is the default length of Firebase uids
String generateUid({int length = 20}) {
  final random = Random();

  const chars = '0123456789'
      'abcdefghijklmnopqrstuvwxyz'
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  return List<String>.generate(
    length,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
}

extension BuildContextExt on BuildContext {
  Future<T?> pushPage<T extends Object?>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute(builder: (_) => page),
      );
}
