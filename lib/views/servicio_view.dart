import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/servicio_controller.dart';
import '../models/servicio_modal.dart';
import '../ui/linea_tiempo.dart';
import '../ui/tarjeta.dart';
import '../ui/temporizador.dart';
import '../ui/utils/paleta.dart';
import '../ui/widgets/wg.dart';

class ServicioView extends GetView<ServicioController> {
  const ServicioView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('> Render Servicio: $this');
    return Obx(() {
      if (controller.cargando.value) {
        return CircularProgressIndicator();
      }

      return _contenido();
    });
  }

  _contenido() {
    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 15, children: [Icon(Icons.stacked_bar_chart), const Text('Servicio')]),
        backgroundColor: Paleta.azul_noche,
        foregroundColor: Paleta.gris_240,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              WG.mostrarModalServicio(servicioExistente: controller.servicioActual);
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
            spacing: 15,
            children: [
              Obx(() => Tarjeta(text: controller.correo.value)),
              Obx(() => Tarjeta(text: controller.tipoServicio.value.name)),
              if (controller.tipoServicio.value == EnumTipoServicio.github && controller.segundosLimite.value != controller.tiempo30Sec)
                IntrinsicWidth(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Advertencia! Establecer el tiempo en 30 segundos',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Paleta.rojo),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),

              Temporizador(),
              Obx(() => Tarjeta(text: controller.codigo2fa.value)),
              LineaTiempo(
                callback: controller.setMilisegundosTemporizadorStore,
                idxTiempoInicial: controller.indiceTiempoInicial,
                lista: controller.lineaTiempo,
              ),
              ElevatedButton(
                onPressed: controller.iniciarTemporizador,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  alignment: Alignment.center,
                  child: Obx(() => Text(controller.temporizadorIniciado.value ? 'CANCELAR' : 'ACTIVAR')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
