import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/servicio_controller.dart';
import '../core/enums/render_enum.dart';
import '../ui/linea_tiempo.dart';
import '../ui/tarjeta.dart';
import '../ui/temporizador.dart';
import '../ui/utils/paleta.dart';

class ServicioView extends GetView<ServicioController> {
  const ServicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 15, children: [Icon(Icons.stacked_bar_chart), const Text('Servicio')]),
        backgroundColor: Paleta.azulNoche,
        foregroundColor: Paleta.grisClaro,
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              Tarjeta(text: controller.correo),
              Temporizador(),
              Tarjeta(text: controller.codigo2fa),
              LineaTiempo(callback: (value) => controller.setMilisegundosTemporizador(sec: value.toInt())),
              ElevatedButton(
                onPressed: controller.iniciarTemporizador,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  alignment: Alignment.center,
                  child: GetBuilder<ServicioController>(
                    id: RenderId.servicioBotoOnOff,
                    builder: (_) {
                      debugPrint('> Render Text: $this');
                      return Text(controller.temporizadorIniciado ? 'CANCELAR' : 'ACTIVAR');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
