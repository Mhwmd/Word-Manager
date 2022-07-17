import 'package:flutter/material.dart';
import 'package:word_storage_api/word_storage_api.dart';

extension DifficultyLevelX on DifficultyLevel {
  Color get color {
    switch (this) {
      case DifficultyLevel.easy:
        return Colors.greenAccent;
      case DifficultyLevel.medium:
        return Colors.blueAccent;
      case DifficultyLevel.hard:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String get name {
    switch (this) {
      case DifficultyLevel.easy:
        return "Easy";
      case DifficultyLevel.medium:
        return "Medium";
      case DifficultyLevel.hard:
        return "Hard";
      default:
        return "None";
    }
  }
}
