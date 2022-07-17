import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_word_manager/edit_word/edit_word.dart';
import 'package:flutter_word_manager/widgets/widgets.dart';
import 'package:flutter_word_manager/word_manager/bloc/word_manager_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:word_storage_api/word_storage_api.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class WordManagerView extends StatelessWidget {
  const WordManagerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WordManagerState state = context.watch<WordManagerBloc>().state;
    AppBar appBar = AppBar(
      key: const Key("word_manager_view->appbar:normal"),
      title: const Text("WordsList"),
      actions: [
        PopupMenuButton<WordManagerViewDifficultyFilter>(
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          tooltip: "more",
          icon: const Icon(Icons.filter_list_rounded),
          initialValue: state.difficultyFilter,
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                context
                    .read<WordManagerBloc>()
                    .add(const WordManagerWordStatusFilterChanged(filter: WordManagerViewWordStatusFilter.all));
              },
              value: WordManagerViewDifficultyFilter.all,
              child: const Text('All'),
            ),
            const PopupMenuItem(
              value: WordManagerViewDifficultyFilter.noneOnly,
              child: Text('None only'),
            ),
            const PopupMenuItem(
              value: WordManagerViewDifficultyFilter.easyOnly,
              child: Text('Easy only'),
            ),
            const PopupMenuItem(
              value: WordManagerViewDifficultyFilter.mediumOnly,
              child: Text('Medium only'),
            ),
            const PopupMenuItem(
              value: WordManagerViewDifficultyFilter.hardOnly,
              child: Text('Hard only'),
            ),
          ],
          onSelected: (WordManagerViewDifficultyFilter filter) {
            context.read<WordManagerBloc>().add(WordManagerDifficultyFilterChanged(filter: filter));
          },
        ),
        PopupMenuButton<WordManagerViewWordStatusFilter?>(
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          initialValue: state.wordStatusFilter,
          tooltip: "more",
          onSelected: (WordManagerViewWordStatusFilter? filter) {
            if (filter == null) return;
            context.read<WordManagerBloc>().add(WordManagerWordStatusFilterChanged(filter: filter));
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: WordManagerViewWordStatusFilter.all,
              child: Text('All'),
            ),
            const PopupMenuItem(
              value: WordManagerViewWordStatusFilter.noneOnly,
              child: Text('None only'),
            ),
            const PopupMenuItem(
              value: WordManagerViewWordStatusFilter.acceptedOnly,
              child: Text('Accepted only'),
            ),
            const PopupMenuItem(
              value: WordManagerViewWordStatusFilter.rejectedOnly,
              child: Text('Rejected only'),
            ),
            const PopupMenuDivider(
              height: 2,
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              onTap: () async {
                NavigatorState navigator = Navigator.of(context);
                WordManagerBloc bloc = BlocProvider.of<WordManagerBloc>(context);

                var statusStorage = await Permission.storage.status;
                if (!statusStorage.isGranted) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PermissionDialog(
                        title: "Storage permission",
                        content: "For import data from storage we need storage permission.",
                        onSubmitted: () async {
                          await Permission.storage.request();
                          navigator.pop();
                        },
                      );
                    },
                  );
                } else {
                  bloc.add(const WordManagerPickedFile());
                }
              },
              child: Column(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.import_contacts_rounded, color: Colors.black),
                      ),
                      Text('Import'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    if (state.isInSelectionMode) {
      appBar = AppBar(
        key: const Key("word_manager_view->appbar:selection"),
        backgroundColor: state.isInSelectionMode ? Colors.white : null,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            alignment: Alignment.centerLeft,
            child: AnimatedFlipCounter(
              textStyle: const TextStyle(color: Colors.black),
              value: state.selections.length,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.read<WordManagerBloc>().add(const WordManagerCanceledSelection());
          },
          icon: const Icon(Icons.close_rounded, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<WordManagerBloc>().add(const WordManagerSelectedAllItems());
            },
            icon: const Icon(Icons.select_all_rounded, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              context.read<WordManagerBloc>().add(const WordManagerSelectedItemsDeleted());
            },
            icon: const Icon(Icons.delete, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              context.read<WordManagerBloc>().add(const WordManagerSelectedItemsStatusChanged(WordStatus.rejected));
            },
            icon: const Icon(Icons.block_rounded, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              context.read<WordManagerBloc>().add(const WordManagerSelectedItemsStatusChanged(WordStatus.accepted));
            },
            icon: const Icon(Icons.check, color: Colors.black),
          ),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () {
        if (state.isInSelectionMode) {
          context.read<WordManagerBloc>().add(const WordManagerCanceledSelection());
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 360),
            reverseDuration: const Duration(milliseconds: 300),
            child: appBar,
          ),
        ),
        body: Builder(
          builder: (context) {
            if (state.words.isEmpty) {
              if (state.status == WordManagerStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != WordManagerStatus.success) {
                return const SizedBox();
              } else {
                return const Center(child: Text("No word:("));
              }
            }
            return ListView.builder(
              itemCount: state.filteredWords.length,
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemBuilder: (context, index) {
                final WordEntry word = state.filteredWords.elementAt(index);
                return WordListItem(
                  wordEntry: word,
                  isChecked: state.selections.contains(word.id),
                  showMoreOption: !state.isInSelectionMode,
                  onTap: () {
                    if (state.isInSelectionMode) {
                      context.read<WordManagerBloc>().add(WordManagerSelectedItem(word.id));
                      return;
                    }
                    EditWordDialog.show(context: context, word: word);
                  },
                  onLongPress: () {
                    if (state.isInSelectionMode) return;
                    context.read<WordManagerBloc>().add(WordManagerSelectedItem(word.id));
                  },
                  onOptionSelected: (String? selection) {
                    switch (selection) {
                      case "accepted":
                        return context
                            .read<WordManagerBloc>()
                            .add(WordManagerWordStatusChanged(word: word, wordStatus: WordStatus.accepted));
                      case "rejected":
                        return context
                            .read<WordManagerBloc>()
                            .add(WordManagerWordStatusChanged(word: word, wordStatus: WordStatus.rejected));
                      case "deleted":
                        return context.read<WordManagerBloc>().add(WordManageDeletedItem(word.id));
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
