import 'package:flutter/material.dart';
import 'package:word_storage_api/word_storage_api.dart';

extension WordStatusX on WordStatus {
  Color get color {
    switch (this) {
      case WordStatus.accepted:
        return Colors.greenAccent;
      case WordStatus.rejected:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String get name {
    switch (this) {
      case WordStatus.accepted:
        return "Accepted";
      case WordStatus.rejected:
        return "Rejected";
      default:
        return "None";
    }
  }
}
