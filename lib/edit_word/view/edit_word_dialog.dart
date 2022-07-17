import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_word_manager/edit_word/bloc/edit_word_state.dart';
import 'package:word_storage_api/word_storage_api.dart';
import 'package:word_storage_repository/word_storage_repository.dart';

import '../bloc/edit_word_bloc.dart';
import 'edit_word_view.dart';

class EditWordDialog extends StatelessWidget {
  const EditWordDialog({Key? key, WordEntry? word}) : super(key: key);

  static show({required BuildContext context, WordEntry? word}) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => EditWordBloc(
            wordStorageRepository: context.read<WordStorageRepository>(),
            initialWordEntry: word,
          ),
          child: const EditWordDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditWordBloc, EditWordState>(
      listenWhen: (previous, current) => previous.status != current.status && current.status == EditWordStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditWordView(),
    );
  }
}
