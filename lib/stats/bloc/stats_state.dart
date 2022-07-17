part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.wordsCount = 0,
    this.stats = const {},
  });

  final StatsStatus status;
  final int wordsCount;
  final JsonMap stats;

  StatsState copyWith({
    StatsStatus? status,
    int? wordsCount,
    JsonMap? stats,
  }) {
    return StatsState(
      status: status ?? this.status,
      wordsCount: wordsCount ?? this.wordsCount,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [status, wordsCount, stats];
}
