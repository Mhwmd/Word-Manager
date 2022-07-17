import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:word_storage_api/word_storage_api.dart';
import 'package:word_storage_repository/word_storage_repository.dart';

import 'edit_word_event.dart';
import 'edit_word_state.dart';

class EditWordBloc extends Bloc<EditWordEvent, EditWordState> {
  EditWordBloc({required WordStorageRepository wordStorageRepository, WordEntry? initialWordEntry})
      : _wordStorageRepository = wordStorageRepository,
        super(EditWordState(
          initialWordEntry: initialWordEntry,
          id: initialWordEntry?.id ?? const Uuid().v4(),
          word: initialWordEntry?.wordData ?? "",
          wordStatus: initialWordEntry?.wordStatus ?? WordStatus.accepted,
          difficultyLevel: initialWordEntry?.difficultyLevel ?? DifficultyLevel.none,
        )) {
    on<EditIdChanged>(_onIdChanged);
    on<EditWordChanged>(_onWordChanged);
    on<EditDifficultyLevelChanged>(_onDifficultyLevelChanged);
    on<EditWordSubmitted>(_onSubmitted);
  }

  final WordStorageRepository _wordStorageRepository;

  FutureOr<void> _onIdChanged(EditIdChanged event, Emitter<EditWordState> emit) {
    emit(state.copyWith(id: event.id));
  }

  FutureOr<void> _onWordChanged(EditWordChanged event, Emitter<EditWordState> emit) {
    emit(state.copyWith(word: event.word));
  }

  FutureOr<void> _onDifficultyLevelChanged(EditDifficultyLevelChanged event, Emitter<EditWordState> emit) {
    emit(state.copyWith(difficultyLevel: event.difficultyLevel));
  }

  Future<FutureOr<void>> _onSubmitted(EditWordSubmitted event, Emitter<EditWordState> emit) async {
    emit(state.copyWith(status: EditWordStatus.loading));
    final WordEntry wordEntry = (state.initialWordEntry ?? WordEntry(wordData: "")).copyWith(
      wordData: state.word,
      difficultyLevel: state.difficultyLevel,
      id: state.id,
      wordStatus: state.wordStatus,
    );
    try {
      await _wordStorageRepository.save(wordEntry);
      emit(state.copyWith(status: EditWordStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditWordStatus.failure));
    }
  }
}
