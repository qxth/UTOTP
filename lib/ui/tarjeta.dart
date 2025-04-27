import 'package:flutter/material.dart';

class Tarjeta extends StatelessWidget {
  final String text;

  const Tarjeta({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        color:
        Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
                color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
