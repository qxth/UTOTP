import 'package:flutter/material.dart';

class Tarjeta extends StatelessWidget {
  final String text;
  final double? fontSize;
  final String? fontFamily;

  const Tarjeta({super.key, required this.text, this.fontSize, this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 23,
                fontFamily: fontFamily ?? 'Courier',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
