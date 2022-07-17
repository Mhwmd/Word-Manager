import 'package:equatable/equatable.dart';
import 'package:word_storage_api/word_storage_api.dart';

abstract class EditWordEvent extends Equatable {
  const EditWordEvent();

  @override
  List<Object> get props => [];
}

class EditIdChanged extends EditWordEvent {
  const EditIdChanged(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class EditWordChanged extends EditWordEvent {
  const EditWordChanged(this.word);

  final String word;

  @override
  List<Object> get props => [word];
}

class EditDifficultyLevelChanged extends EditWordEvent {
  const EditDifficultyLevelChanged(this.difficultyLevel);

  final DifficultyLevel difficultyLevel;

  @override
  List<Object> get props => [difficultyLevel];
}

class EditWordSubmitted extends EditWordEvent {
  const EditWordSubmitted();
}
