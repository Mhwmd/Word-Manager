import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_word_manager/word_manager/view/word_manager_view.dart';
import 'package:word_storage_repository/word_storage_repository.dart';

import '../bloc/word_manager_bloc.dart';

class WordManagerPage extends StatelessWidget {
  const WordManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WordManagerBloc(
        wordStorageRepository: context.read<WordStorageRepository>(),
      )..add(const WordManagerSubscriptionRequested()),
      child: const WordManagerView(),
    );
  }
}
