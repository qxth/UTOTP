import 'package:flutter/material.dart';

class DialogOption {
  final String text;
  final VoidCallback onPressed;

  DialogOption({required this.text, required this.onPressed});
}

class DialogSimple extends StatefulWidget {
  final String title;
  final List<DialogOption> options;

  const DialogSimple({super.key, required this.title, required this.options});

  @override
  DialogSimpleState createState() => DialogSimpleState();
}

class DialogSimpleState extends State<DialogSimple> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children:
          widget.options.map((option) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                option.onPressed();
              },
              child: Text(option.text),
            );
          }).toList(),
    );
  }
}
