import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(tab: HomeTab.home));

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}
