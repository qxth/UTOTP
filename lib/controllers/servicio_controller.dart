import 'dart:async';

import 'package:get/get.dart';

import '../core/enums/render_enum.dart';

class ServicioController extends GetxController {
  Timer? timer;
  String txtTiempo = "00:00";
  String correo = "user@example.com";
  String codigo2fa = "xxxxxx";

  int segundosLimite = 0;
  int minutosLimite = 0;
  int milisegundosLimite = Duration.millisecondsPerSecond;
  double progreso = 100;
  bool temporizadorIniciado = false;

  @override
  void onInit() {
    super.onInit();
    setMilisegundosTemporizador(sec: 15);
  }

  void setMilisegundosTemporizador({required int sec}) {
    minutosLimite = sec ~/ Duration.secondsPerMinute;
    segundosLimite = sec;
    milisegundosLimite = Duration.millisecondsPerSecond * sec;
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
      /*
      var totalMs =
          now.millisecond +
              (now.second * Duration.millisecondsPerSecond) +
              (now.minute * Duration.secondsPerMinute * Duration.millisecondsPerSecond);
      progreso = ((totalMs * 100.0) / milisegundosLimite) % 100;
       */

      // # Forma 2 : no funciona > probado en test
      // final totalMs = now.millisecondsSinceEpoch % milisegundosLimite;
      // progreso = (totalMs * 100.0) / milisegundosLimite;

      // # Forma 3
      final totalMs = now.millisecondsSinceEpoch - DateTime(now.year, now.month, now.day, now.hour).millisecondsSinceEpoch;
      progreso = ((totalMs * 100.0) / milisegundosLimite) % 100;

      mostrarTiempo(now);

      // debugPrint('${now.toIso8601String()} ${progreso.toStringAsFixed(2)}');
      // debugPrint('${now.millisecondsSinceEpoch} | ${now.millisecondsSinceEpoch % milisegundosLimite}');
      update([RenderId.servicioProgresoTemporizador]);
    });
  }

  void cancelarTemporizador() {
    timer?.cancel();
    update([RenderId.servicioProgresoTemporizador]);
  }

  void mostrarTiempo(DateTime now) {
    final totalSegundos = segundosLimite > 0 ? segundosLimite - (now.second % segundosLimite) : 0;
    final totalMinutos = minutosLimite > 0 ? minutosLimite - (now.minute % minutosLimite) - 1 : 0;

    final min = totalMinutos.toString().padLeft(2, '0');
    final sec = (totalSegundos % 60).toString().padLeft(2, '0');
    txtTiempo = '$min:$sec';
  }
}
