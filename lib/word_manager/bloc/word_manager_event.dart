part of 'word_manager_bloc.dart';

abstract class WordManagerEvent extends Equatable {
  const WordManagerEvent();

  @override
  List<Object> get props => [];
}

class WordManagerSubscriptionRequested extends WordManagerEvent {
  const WordManagerSubscriptionRequested();
}

class WordManagerSelectedAllItems extends WordManagerEvent {
  const WordManagerSelectedAllItems();
}

class WordManagerCanceledSelection extends WordManagerEvent {
  const WordManagerCanceledSelection();
}

class WordManagerSelectedItemsDeleted extends WordManagerEvent {
  const WordManagerSelectedItemsDeleted();
}

class WordManagerPickedFile extends WordManagerEvent {
  const WordManagerPickedFile();
}

class WordManagerSelectedItem extends WordManagerEvent {
  const WordManagerSelectedItem(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class WordManageDeletedItem extends WordManagerEvent {
  const WordManageDeletedItem(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class WordManagerSelectedItemsStatusChanged extends WordManagerEvent {
  const WordManagerSelectedItemsStatusChanged(this.wordStatus);

  final WordStatus wordStatus;

  @override
  List<Object> get props => [wordStatus];
}

class WordManagerWordStatusChanged extends WordManagerEvent {
  const WordManagerWordStatusChanged({required this.wordStatus, required this.word});

  final WordEntry word;
  final WordStatus wordStatus;

  @override
  List<Object> get props => [word, wordStatus];
}

class WordManagerWordStatusFilterChanged extends WordManagerEvent {
  const WordManagerWordStatusFilterChanged({required this.filter});

  final WordManagerViewWordStatusFilter filter;

  @override
  List<Object> get props => [filter];
}

class WordManagerDifficultyFilterChanged extends WordManagerEvent {
  const WordManagerDifficultyFilterChanged({required this.filter});

  final WordManagerViewDifficultyFilter filter;

  @override
  List<Object> get props => [filter];
}
