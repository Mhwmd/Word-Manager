import 'package:flutter/material.dart';
import 'package:flutter_word_manager/extensions/extensions.dart';
import 'package:word_storage_api/word_storage_api.dart';

class WordListItem extends StatelessWidget {
  const WordListItem({
    super.key,
    required this.wordEntry,
    this.onLongPress,
    this.onTap,
    this.onOptionSelected,
    required this.showMoreOption,
    required this.isChecked,
  });

  final WordEntry wordEntry;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final ValueChanged<String>? onOptionSelected;
  final bool showMoreOption;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    Widget trailing = Checkbox(value: isChecked, onChanged: (_) => onTap?.call());
    if (showMoreOption) {
      trailing = PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        tooltip: "more",
        itemBuilder: (context) => [
          PopupMenuItem(
            padding: EdgeInsets.zero,
            value: "accepted",
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check, color: Colors.green),
                ),
                Text('Accept'),
              ],
            ),
          ),
          PopupMenuItem(
            padding: EdgeInsets.zero,
            value: "rejected",
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.block_rounded, color: Colors.red),
                ),
                Text('Reject'),
              ],
            ),
          ),
          const PopupMenuDivider(
            height: 2,
          ),
          PopupMenuItem(
            padding: EdgeInsets.zero,
            value: "deleted",
            child: Column(
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                    Text('Delete'),
                  ],
                ),
              ],
            ),
          ),
        ],
        onSelected: onOptionSelected?.call,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        selected: isChecked,
        selectedTileColor: Colors.white,
        selectedColor: Colors.black,
        onLongPress: onLongPress?.call,
        onTap: onTap?.call,
        tileColor: Colors.white,
        title: Text(wordEntry.wordData),
        isThreeLine: true,
        subtitle: Column(
          children: [
            Row(
              children: [
                const Text("difficulty: "),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: wordEntry.difficultyLevel.color,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(wordEntry.difficultyLevel.name),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text("status: "),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: wordEntry.wordStatus.color,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(wordEntry.wordStatus.name),
                ),
              ],
            ),
          ],
        ),
        trailing: trailing,
        dense: true,
      ),
    );
  }
}
