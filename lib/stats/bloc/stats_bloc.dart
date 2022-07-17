import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_storage_api/word_storage_api.dart';
import 'package:word_storage_repository/word_storage_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

var wordStatusCount = {
  "none": 0,
  "accepted": 1,
  "rejected": 1,
};

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({required WordStorageRepository wordStorageRepository})
      : _wordStorageRepository = wordStorageRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  final WordStorageRepository _wordStorageRepository;

  Future<void> _onSubscriptionRequested(StatsSubscriptionRequested event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));
    await emit.forEach<WordEntries>(
      _wordStorageRepository.stream,
      onData: (words) => state.copyWith(
        status: StatsStatus.success,
        wordsCount: words.length,
        stats: analysisWords(words),
      ),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }

  Map<T, Map<S, int>> prepareForAnalysis<T, S>(List<T> a, List<S> b) {
    Map<S, int> sub = Map.fromIterables(b, List.filled(b.length, 0));
    return Map.fromEntries(a.map((element) => MapEntry(element, {...sub})));
  }

  JsonMap analysisWords(WordEntries words) {
    const String countKey = "count";
    var difficultyAnalysis = prepareForAnalysis(DifficultyLevel.values, [countKey, ...WordStatus.values]);
    var statusAnalysis = prepareForAnalysis(WordStatus.values, [countKey, ...DifficultyLevel.values]);

    for (final WordEntry word in words) {
      difficultyAnalysis[word.difficultyLevel]![countKey] = difficultyAnalysis[word.difficultyLevel]![countKey]! + 1;
      difficultyAnalysis[word.difficultyLevel]![word.wordStatus] =
          difficultyAnalysis[word.difficultyLevel]![word.wordStatus]! + 1;
      statusAnalysis[word.wordStatus]![countKey] = statusAnalysis[word.wordStatus]![countKey]! + 1;
      statusAnalysis[word.wordStatus]![word.difficultyLevel] =
          statusAnalysis[word.wordStatus]![word.difficultyLevel]! + 1;
    }

    Map<DifficultyLevel, Map<dynamic, double>> difficultyPercentage = difficultyAnalysis.map((key, value) {
      final int count = difficultyAnalysis[key]![countKey]!;
      if (count == 0) return MapEntry(key, value.map((key, value) => MapEntry(key, value.toDouble())));
      return MapEntry(key, value.map((key, value) {
        return MapEntry(key, key == countKey ? value / words.length : value / count);
      }));
    });

    Map<WordStatus, Map<dynamic, double>> statusPercentage = statusAnalysis.map((key, value) {
      final int count = statusAnalysis[key]![countKey]!;
      if (count == 0) return MapEntry(key, value.map((key, value) => MapEntry(key, value.toDouble())));
      return MapEntry(key, value.map((key, value) {
        return MapEntry(key, key == countKey ? value / words.length : value / count);
      }));
    });

    return {
      "difficultyPercentage": difficultyPercentage,
      "statusPercentage": statusPercentage,
    };
  }
}
