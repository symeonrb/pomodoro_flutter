import 'dart:math';

import 'package:flutter/material.dart';

int generateUid({int length = 5}) {
  final random = Random();
  var uid = 0;

  for (var i = 0; i < length; i++) {
    // Generate a random digit (0-9)
    uid = uid * 10 + random.nextInt(10);
  }

  return uid;
}

extension BuildContextExt on BuildContext {
  Future<T?> pushPage<T extends Object?>(Widget page) => Navigator.push(
        this,
        MaterialPageRoute(builder: (_) => page),
      );
}
