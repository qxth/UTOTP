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
        child: Obx(
          () =>
              controller.servicios.value.isEmpty
                  ? _noHayServicios(context)
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 15,
                      children: controller.servicios.value.map((sv) => CuentaTarjeta(servicio: sv)).toList(),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _noHayServicios(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: mq.size.height - kToolbarHeight - mq.padding.top - mq.padding.bottom - 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(Icons.home_repair_service, size: 100, color: Paleta.violeta.withValues(alpha: 0.6)),
            const SizedBox(height: 20),
            Text(
              'No hay servicios',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Paleta.azul_noche.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 10),
            Text(
              'Agrega un nuevo servicio para generar\ncódigos de autenticación de dos factores',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Paleta.negro_42.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => WG.mostrarModalServicio(servicioExistente: null),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Agregar Servicio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Paleta.violeta,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
