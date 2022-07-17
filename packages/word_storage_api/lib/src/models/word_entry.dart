import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:word_storage_api/src/types/types.dart';

class WordEntry extends Equatable {
  WordEntry({
    String? id,
    required this.wordData,
    this.difficultyLevel = DifficultyLevel.none,
    this.wordStatus = WordStatus.none,
  })  : assert(id == null || id.isNotEmpty),
        _id = id ?? const Uuid().v4();

  final String _id;
  final String wordData;
  final DifficultyLevel difficultyLevel;
  final WordStatus wordStatus;

  factory WordEntry.fromJson(JsonMap json) {
    return WordEntry(
      id: json["id"],
      wordData: json["word_data"],
      difficultyLevel:
          DifficultyLevel.values.firstWhere((difficultyLevel) => difficultyLevel.id == json["difficulty_level"]),
      wordStatus: WordStatus.values.firstWhere((wordStatus) => wordStatus.id == json["word_status"]),
    );
  }

  JsonMap toJson() {
    return {
      "id": _id,
      "word_data": wordData,
      "difficulty_level": difficultyLevel.id,
      "word_status": wordStatus.id,
    };
  }

  WordEntry copyWith({
    String? id,
    String? wordData,
    DifficultyLevel? difficultyLevel,
    WordStatus? wordStatus,
  }) {
    return WordEntry(
      id: id ?? _id,
      wordData: wordData ?? this.wordData,
      wordStatus: wordStatus ?? this.wordStatus,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
    );
  }

  String get id => _id;

  @override
  List<Object?> get props => [_id, wordData, wordStatus, difficultyLevel];
}
