import 'dart:async';

import 'package:get/get.dart';

import '../core/enums/render_enum.dart';

class ServicioController extends GetxController {
  Timer? timer;
  String txtTiempo = "00:00";
  String correo = "user@example.com";
  String codigo2fa = "xxxxxx";

  int segundosLimite = 60;
  int milisegundosLimite = Duration.millisecondsPerSecond;
  double progreso = 100;
  bool temporizadorIniciado = false;

  @override
  void onInit() {
    super.onInit();
    setMilisegundosTemporizador();
  }

  void setMilisegundosTemporizador() {
    milisegundosLimite = Duration.millisecondsPerSecond * segundosLimite;
  }

  void iniciarTemporizador() {
    temporizadorIniciado = !temporizadorIniciado;
    update([RenderId.servicioBotoOnOff]);
    if (!temporizadorIniciado) {
      cancelarTemporizador();
      return;
    }

    timer = Timer.periodic(Duration(milliseconds: 60), (_) {
      DateTime now = DateTime.now();
      // # Forma 1
      // var totalMs = now.millisecond + (now.second * Duration.millisecondsPerSecond);
      // progreso = ((totalMs * 100.0) / limiteTemporizador) % 100;

      // # Forma 2
      final totalMs = now.millisecondsSinceEpoch % milisegundosLimite;
      progreso = (totalMs * 100.0) / milisegundosLimite;

      final finalSegundos = segundosLimite - (now.second % segundosLimite);
      txtTiempo = '$finalSegundos'.padLeft(2, '0');
      // debugPrint('${now.millisecond} | ${now.second} > ${progreso}');
      // debugPrint('${now.millisecondsSinceEpoch} | ${now.millisecondsSinceEpoch % milisegundosLimite}');
      update([RenderId.servicioProgresoTemporizador]);
    });
  }

  void cancelarTemporizador() {
    timer?.cancel();
    update([RenderId.servicioProgresoTemporizador]);
  }
}
