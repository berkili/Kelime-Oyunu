import 'dart:ffi';

import 'package:flutter/foundation.dart';

class LeaderBoardItem {
  final String userId;
  final String name;
  final String email;
  final String point;

  LeaderBoardItem({
    required this.userId,
    required this.name,
    required this.email,
    required this.point,
  });

}