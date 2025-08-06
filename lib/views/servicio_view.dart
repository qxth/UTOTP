import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/servicio_controller.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              Tarjeta(text: controller.correo.value),
              Tarjeta(servicio: controller.servicioActual?.defectoServicio, fontSize: 19),
              if (controller.tienePeriodoDefectoNoEsIgualAlPeriodoActual(controller.segundosLimite.value))
                IntrinsicWidth(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Advertencia! Establecer el tiempo en ${controller.servicioActual?.defectoServicio.period} segundos',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Paleta.rojo),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              Temporizador(),
              Tarjeta(text: controller.codigo2fa.value),
              if (controller.noTienePeriodoDefecto())
                LineaTiempo(
                  idxTiempo: controller.indiceTiempo,
                  callback: controller.setMilisegundosTemporizadorStore,
                  lista: lineaTiempoSlider,
                ),
              ElevatedButton(
                onPressed: controller.iniciarTemporizador,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  alignment: Alignment.center,
                  child: Text(controller.temporizadorIniciado.value ? 'CANCELAR' : 'ACTIVAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
