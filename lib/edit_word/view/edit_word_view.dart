import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_word_manager/edit_word/bloc/edit_word_bloc.dart';
import 'package:flutter_word_manager/edit_word/bloc/edit_word_event.dart';
import 'package:flutter_word_manager/extensions/extensions.dart';
import 'package:word_storage_api/word_storage_api.dart';

class EditWordView extends StatelessWidget {
  const EditWordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditWordBloc>().state;
    return AlertDialog(
      title: Row(
        children: [
          Icon(state.isNewWordEntry ? Icons.add : Icons.edit),
          const SizedBox(width: 10),
          Text(state.isNewWordEntry ? "add" : "edit"),
        ],
      ),
      content: Form(
        child: Wrap(
          spacing: 10,
          runSpacing: 15,
          children: [
            TextFormField(
              initialValue: state.id,
              readOnly: !state.isNewWordEntry,
              decoration: const InputDecoration(
                labelText: "id",
                hintText: "enter id",
              ),
              onChanged: (String id) {
                context.read<EditWordBloc>().add(EditIdChanged(id));
              },
            ),
            TextFormField(
              initialValue: state.word,
              decoration: const InputDecoration(
                labelText: "word",
                hintText: "enter word",
              ),
              onChanged: (String word) {
                context.read<EditWordBloc>().add(EditWordChanged(word));
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Difficulty: "),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(DifficultyLevel.values.length, (index) {
                    return _ButtonToggle<DifficultyLevel>(
                      groupValue: state.difficultyLevel,
                      value: DifficultyLevel.values[index],
                      text: DifficultyLevel.values[index].name,
                      backgroundColor: DifficultyLevel.values[index].color,
                      onTap: () {
                        context.read<EditWordBloc>().add(EditDifficultyLevelChanged(DifficultyLevel.values[index]));
                      },
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            context.read<EditWordBloc>().add(const EditWordSubmitted());
          },
          child: Text(state.isNewWordEntry ? "Add" : "Done"),
        ),
      ],
    );
  }
}

class _ButtonToggle<T> extends StatelessWidget {
  const _ButtonToggle({
    Key? key,
    required this.groupValue,
    required this.value,
    required this.text,
    required this.backgroundColor,
    this.onTap,
  });

  final T groupValue;
  final T value;
  final String text;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isSelected = groupValue == value;

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      splashColor: Colors.white.withOpacity(.5),
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            width: 2,
            color: isSelected ? Colors.black : Colors.transparent,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            text,
            style: TextStyle(
              color: theme.textTheme.caption!.color,
              fontSize: theme.textTheme.caption!.fontSize! + 2,
            ),
          ),
        ),
      ),
    );
  }
}
