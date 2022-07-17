import 'package:word_storage_api/word_storage_api.dart';

enum WordManagerViewWordStatusFilter {
  all,
  noneOnly,
  acceptedOnly,
  rejectedOnly;

  bool apply(WordEntry word) {
    switch (this) {
      case WordManagerViewWordStatusFilter.all:
        return true;
      case WordManagerViewWordStatusFilter.noneOnly:
        return word.wordStatus == WordStatus.none;
      case WordManagerViewWordStatusFilter.acceptedOnly:
        return word.wordStatus == WordStatus.accepted;
      case WordManagerViewWordStatusFilter.rejectedOnly:
        return word.wordStatus == WordStatus.rejected;
      default:
        return false;
    }
  }
}

enum WordManagerViewDifficultyFilter {
  all,
  noneOnly,
  easyOnly,
  mediumOnly,
  hardOnly;

  bool apply(WordEntry word) {
    switch (this) {
      case WordManagerViewDifficultyFilter.all:
        return true;
      case WordManagerViewDifficultyFilter.noneOnly:
        return word.difficultyLevel == DifficultyLevel.none;

      case WordManagerViewDifficultyFilter.easyOnly:
        return word.difficultyLevel == DifficultyLevel.easy;

      case WordManagerViewDifficultyFilter.mediumOnly:
        return word.difficultyLevel == DifficultyLevel.medium;

      case WordManagerViewDifficultyFilter.hardOnly:
        return word.difficultyLevel == DifficultyLevel.hard;

      default:
        return false;
    }
  }
}
