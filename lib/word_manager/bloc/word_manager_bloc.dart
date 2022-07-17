import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_storage_api/word_storage_api.dart';
import 'package:word_storage_repository/word_storage_repository.dart';

import '../models/models.dart';

part 'word_manager_event.dart';
part 'word_manager_state.dart';

class WordManagerBloc extends Bloc<WordManagerEvent, WordManagerState> {
  WordManagerBloc({required WordStorageRepository wordStorageRepository})
      : _wordStorageRepository = wordStorageRepository,
        super(const WordManagerState()) {
    on<WordManagerSubscriptionRequested>(_onSubscriptionRequested);
    on<WordManagerSelectedItem>(_onSelectRequested);
    on<WordManagerCanceledSelection>(_onCancelSelectRequested);
    on<WordManagerSelectedItemsStatusChanged>(_onSelectedItemsStatusChanged);
    on<WordManagerSelectedAllItems>(_onSelectedAllItems);
    on<WordManagerWordStatusChanged>(_onStatusChanged);
    on<WordManageDeletedItem>(_onDeletedWordEntry);
    on<WordManagerSelectedItemsDeleted>(_onSelectedItemsDeleted);
    on<WordManagerPickedFile>(_onPickedFile);
    on<WordManagerWordStatusFilterChanged>(_onWordStatusFilterChanged);
    on<WordManagerDifficultyFilterChanged>(_onDifficultyFilterChanged);
  }

  final WordStorageRepository _wordStorageRepository;

  Future<void> _onSubscriptionRequested(WordManagerSubscriptionRequested event, Emitter<WordManagerState> emit) async {
    emit(state.copyWith(status: WordManagerStatus.loading));
    await emit.forEach<WordEntries>(
      _wordStorageRepository.getWords(),
      onData: (words) => state.copyWith(status: WordManagerStatus.success, words: words),
      onError: (_, __) => state.copyWith(status: WordManagerStatus.failure),
    );
  }

  Future<void> _onSelectRequested(WordManagerSelectedItem event, Emitter<WordManagerState> emit) async {
    final Set<String> selections = Set.from(state.selections);
    if (selections.contains(event.id)) {
      selections.remove(event.id);
    } else {
      selections.add(event.id);
    }
    emit(state.copyWith(selections: selections));
  }

  FutureOr<void> _onCancelSelectRequested(WordManagerCanceledSelection event, Emitter<WordManagerState> emit) {
    emit(state.copyWith(selections: const {}));
  }

  Future<void> _onSelectedItemsStatusChanged(
      WordManagerSelectedItemsStatusChanged event, Emitter<WordManagerState> emit) async {
    emit(state.copyWith(status: WordManagerStatus.loading));
    try {
      WordEntries words =
          state.selections.map((id) => _wordStorageRepository.get(id).copyWith(wordStatus: event.wordStatus)).toList();

      await _wordStorageRepository.saveAll(words);

      emit(state.copyWith(status: WordManagerStatus.success));
    } catch (e) {
      emit(state.copyWith(status: WordManagerStatus.failure));
    }
    add(const WordManagerCanceledSelection());
  }

  FutureOr<void> _onSelectedAllItems(WordManagerSelectedAllItems event, Emitter<WordManagerState> emit) {
    emit(state.copyWith(selections: Set.unmodifiable(state.filteredWords.map((word) => word.id))));
  }

  FutureOr<void> _onWordStatusFilterChanged(WordManagerWordStatusFilterChanged event, Emitter<WordManagerState> emit) {
    emit(state.copyWith(wordStatusFilter: event.filter));
  }

  FutureOr<void> _onDifficultyFilterChanged(WordManagerDifficultyFilterChanged event, Emitter<WordManagerState> emit) {
    emit(state.copyWith(difficultyFilter: event.filter));
  }

  Future<void> _onStatusChanged(WordManagerWordStatusChanged event, Emitter<WordManagerState> emit) async {
    emit(state.copyWith(status: WordManagerStatus.loading));
    try {
      await _wordStorageRepository.save(event.word.copyWith(wordStatus: event.wordStatus));

      emit(state.copyWith(status: WordManagerStatus.success));
    } catch (e) {
      emit(state.copyWith(status: WordManagerStatus.failure));
    }
  }

  Future<void> _onDeletedWordEntry(WordManageDeletedItem event, Emitter<WordManagerState> emit) async {
    try {
      await _wordStorageRepository.remove(event.id);

      emit(state.copyWith(status: WordManagerStatus.success));
    } catch (e) {
      emit(state.copyWith(status: WordManagerStatus.failure));
    }
  }

  Future<void> _onSelectedItemsDeleted(WordManagerSelectedItemsDeleted event, Emitter<WordManagerState> emit) async {
    try {
      await _wordStorageRepository.removeAll(state.selections.toList());
      emit(state.copyWith(status: WordManagerStatus.success));
    } catch (e) {
      emit(state.copyWith(status: WordManagerStatus.failure));
    }
    add(const WordManagerCanceledSelection());
  }

  Future<void> _onPickedFile(WordManagerPickedFile event, Emitter<WordManagerState> emit) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );
      if (result == null) return;
      final file = result.files.first;
      emit(state.copyWith(status: WordManagerStatus.loading));
      await _wordStorageRepository.saveAll(await _processFile(file));

      emit(state.copyWith(status: WordManagerStatus.success));
    } catch (e) {
      emit(state.copyWith(status: WordManagerStatus.failure));
    }
  }

  Future<WordEntries> _processFile(PlatformFile file) async {
    final Set<String> uniqueFileLines = await File(file.path!)
        .openRead()
        .map((event) {
          return utf8.decode(event, allowMalformed: true);
        })
        .transform(const LineSplitter())
        .map((line) => line.trim().replaceAll("�", ""))
        .where((wordInFile) => !state.words.any((word) => word.wordData == wordInFile))
        .toSet();
    return uniqueFileLines.map((e) => WordEntry(wordData: e));
  }
}
