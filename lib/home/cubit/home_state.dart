part of 'home_cubit.dart';

enum HomeTab { home, stats }

class HomeState extends Equatable {
  const HomeState({required this.tab});

  final HomeTab tab;

  @override
  List<Object?> get props => [tab];
}
