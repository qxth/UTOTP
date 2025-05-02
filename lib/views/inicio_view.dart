import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inicio_controller.dart';
import '../ui/cuenta_tarjeta.dart';
import '../ui/utils/paleta.dart';

class InicioView extends GetView<InicioController> {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('> Render Inicio');

    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 15, children: [Icon(Icons.account_balance), const Text('Totp')]),
        backgroundColor: Paleta.azulNoche,
        foregroundColor: Paleta.grisClaro,
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: const Icon(Icons.add_box_rounded), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [for (var k = 0; k < 10; k++) CuentaTarjeta()],
          ),
        ),
      ),
    );
  }
}
