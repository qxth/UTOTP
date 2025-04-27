import 'package:flutter/material.dart';
import 'package:totp_unix/ui/tarjeta.dart';
import 'package:totp_unix/ui/temporizador.dart';
import 'package:totp_unix/ui/utils/paleta.dart';
import 'package:totp_unix/ui/cuenta_tarjeta.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UTOTP'),
        backgroundColor: Paleta.darkPurple,
        foregroundColor: Paleta.lightGray,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Tarjeta(text: 'user@hotmail.com'),
          Temporizador(),
          Tarjeta(text: '123456'),
        ],
      ),
    );
  }
}
