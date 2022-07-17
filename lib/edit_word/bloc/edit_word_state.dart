import 'package:equatable/equatable.dart';
import 'package:word_storage_api/word_storage_api.dart';

enum EditWordStatus { initial, loading, success, failure }

class EditWordState extends Equatable {
  const EditWordState({
    this.status = EditWordStatus.initial,
    this.initialWordEntry,
    this.id = '',
    this.word = '',
    this.difficultyLevel = DifficultyLevel.none,
    this.wordStatus = WordStatus.accepted,
  });

  final EditWordStatus status;
  final WordEntry? initialWordEntry;
  final String id;
  final String word;
  final DifficultyLevel difficultyLevel;
  final WordStatus wordStatus;

  bool get isNewWordEntry => initialWordEntry == null;

  EditWordState copyWith({
    EditWordStatus? status,
    WordEntry? initialWordEntry,
    String? id,
    String? word,
    DifficultyLevel? difficultyLevel,
    WordStatus? wordStatus,
  }) {
    return EditWordState(
      status: status ?? this.status,
      initialWordEntry: initialWordEntry ?? this.initialWordEntry,
      id: id ?? this.id,
      word: word ?? this.word,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      wordStatus: wordStatus ?? this.wordStatus,
    );
  }

  @override
  List<Object?> get props => [status, initialWordEntry, id, word, difficultyLevel, wordStatus];
}
