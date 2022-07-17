part of 'word_manager_bloc.dart';

enum WordManagerStatus { initial, loading, success, failure }

class WordManagerState extends Equatable {
  const WordManagerState({
    this.status = WordManagerStatus.initial,
    this.words = const [],
    this.selections = const {},
    this.wordStatusFilter = WordManagerViewWordStatusFilter.all,
    this.difficultyFilter = WordManagerViewDifficultyFilter.all,
  });

  final WordManagerStatus status;
  final WordEntries words;
  final Set<String> selections;

  final WordManagerViewWordStatusFilter wordStatusFilter;
  final WordManagerViewDifficultyFilter difficultyFilter;

  WordManagerState copyWith({
    WordManagerStatus? status,
    WordEntries? words,
    Set<String>? selections,
    WordManagerViewWordStatusFilter? wordStatusFilter,
    WordManagerViewDifficultyFilter? difficultyFilter,
  }) {
    return WordManagerState(
      status: status ?? this.status,
      words: words ?? this.words,
      selections: selections ?? this.selections,
      wordStatusFilter: wordStatusFilter ?? this.wordStatusFilter,
      difficultyFilter: difficultyFilter ?? this.difficultyFilter,
    );
  }

  bool get isInSelectionMode => selections.isNotEmpty;

  WordEntries get filteredWords {
    return words.where((word) => wordStatusFilter.apply(word) && difficultyFilter.apply(word));
  }

  @override
  List<Object?> get props => [status, words, selections, wordStatusFilter, difficultyFilter];
}
