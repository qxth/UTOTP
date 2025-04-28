import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inicio_controller.dart';
import '../ui/tarjeta.dart';
import '../ui/temporizador.dart';
import '../ui/utils/paleta.dart';

class InicioView extends GetView<InicioController> {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('> Render Inicio');
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOTP'),
        backgroundColor: Paleta.azulNoche,
        foregroundColor: Paleta.grisClaro,
        automaticallyImplyLeading: false,
        leading: IconButton(icon: const Icon(Icons.ac_unit), onPressed: () {}),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Tarjeta(text: 'user@hotmail.com'),
              const SizedBox(height: 16),
              Temporizador(),
              const SizedBox(height: 16),
              Tarjeta(text: '123456'),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: controller.iniciarTemporizador, child: const Text('Activar')),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: controller.cancelarTemporizador, child: const Text('Cancelar')),
            ],
          ),
        ),
      ),
    );
  }
}
