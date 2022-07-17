import 'package:flutter/material.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onSubmitted,
    this.submit = "Ok",
  }) : super(key: key);

  final String title;
  final String content;
  final String submit;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(15),
      title: Text(title),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onSubmitted.call,
          child: Text(submit),
        ),
      ],
    );
  }
}
