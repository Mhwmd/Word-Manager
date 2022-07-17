import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_word_manager/stats/bloc/stats_bloc.dart';
import 'package:word_storage_repository/word_storage_repository.dart';

import 'stats_view.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(wordStorageRepository: context.read<WordStorageRepository>())
        ..add(const StatsSubscriptionRequested()),
      child: const StatsView(),
    );
  }
}
