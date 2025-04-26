import 'package:flutter/material.dart';
import 'package:totp_unix/views/temporizador_view.dart';

void main() {
  runApp(const UTOTPApp());
}

class UTOTPApp extends StatelessWidget {
  const UTOTPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: TemporizadorView(),
    );
  }
}
