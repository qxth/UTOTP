import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inicio_controller.dart';
import '../ui/cuenta_tarjeta.dart';
import '../ui/utils/paleta.dart';
import '../ui/widgets/wg.dart';

class InicioView extends GetView<InicioController> {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('> Render Inicio');

    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 15, children: [Icon(Icons.account_balance), const Text('Totp')]),
        backgroundColor: Paleta.azul_noche,
        foregroundColor: Paleta.gris_240,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              WG.mostrarModalServicio(servicioExistente: null);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Obx(
            () =>
                controller.servicios.value.isEmpty
                    ? const Center(child: Text('No hay servicios'))
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: controller.servicios.value.map((sv) => CuentaTarjeta(servicio: sv)).toList(),
                    ),
          ),
        ),
      ),
    );
  }
}
