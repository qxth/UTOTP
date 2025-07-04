import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/servicio_modal.dart';
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
        foregroundColor: Paleta.gris_claro,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              CuentaTarjeta(
                servicio: ServicioModal(
                  idServicio: '1',
                  claveTotp: '123456',
                  tipo: EnumTipoServicio.otro,
                  correo: 'correo@gmail.com',
                  titulo: 'Titulo',
                ),
              ),
              CuentaTarjeta(
                servicio: ServicioModal(
                  idServicio: '1',
                  claveTotp: '123456',
                  tipo: EnumTipoServicio.github,
                  correo: 'correo@gmail.com',
                  titulo: 'Titulo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
