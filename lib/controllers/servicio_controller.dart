import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../core/alpha_storage.dart';
import '../core/enums/render_enum.dart';
import '../core/enums/storage_enum.dart';
import '../core/totp.dart';

class ServicioController extends GetxController {
  final List<int> lineaTiempo = [5, 10, 15, 20, 30, 60, 75, 80, 90, 120, 150, 180, 240, 300, 360, 420, 480, 540, 600];

  Timer? timer;
  String txtTiempo = "00:00";
  RxString correo = "user@example.com".obs;
  RxString codigo2fa = "xxxxxx".obs;

  int milisegundosLimite = Duration.millisecondsPerSecond;
  int segundosLimite = 0;
  double progreso = 0;
  RxBool temporizadorIniciado = false.obs;

  @override
  void onInit() async {
    super.onInit();

    final int? indiceTiempo = await AlphaStorage.readInt(EnumAlphaStorage.idxTiempo.name);
    // debugPrint('Indice Store: $indiceTiempo');
    setMilisegundosTemporizador(sec: lineaTiempo[indiceTiempo ?? 0]);
  }

  @override
  void onReady() {
    super.onReady();
    iniciarTemporizador();
  }

  void setMilisegundosTemporizador({required int sec}) {
    segundosLimite = sec;
    milisegundosLimite = Duration.millisecondsPerSecond * sec;
  }

  void setMilisegundosTemporizadorStore({required int sec, required int idx}) async {
    await AlphaStorage.save(key: EnumAlphaStorage.idxTiempo.name, value: idx);
    setMilisegundosTemporizador(sec: sec);
  }

  void iniciarTemporizador() {
    temporizadorIniciado.value = !temporizadorIniciado.value;
    if (!temporizadorIniciado.value) {
      cancelarTemporizador();
      return;
    }

    int expiracionInicial = -1;
    final String secretKey = 'ABCDEFGHIJ';

    timer = Timer.periodic(Duration(milliseconds: 60), (_) async {
      DateTime now = DateTime.now();

      final int expiracion = ((now.millisecondsSinceEpoch + 1) / milisegundosLimite).ceil() * milisegundosLimite;
      // final expiracionTime = DateTime.fromMillisecondsSinceEpoch(expiracion);
      final int intervalo = expiracion - now.millisecondsSinceEpoch;

      progreso = 100 - (intervalo * 100 / milisegundosLimite);

      if (expiracionInicial != expiracion) {
        expiracionInicial = expiracion;
        final totp = await Totp.generate(secretKey, period: segundosLimite);
        codigo2fa.value = totp.otp;
        // debugPrint('> Obteniendo OTP: $expiracion');
        debugPrint('Code: ${codigo2fa.value} | Sec: $segundosLimite');
      }

      mostrarTiempo(intervalo);
      // debugPrint('$expiracion $intervalo');
      // debugPrint('${mostrarHora(now)} | ${mostrarHora(expiracionTime)} | ${now.millisecondsSinceEpoch} | ${expiracionTime.millisecondsSinceEpoch}');
      update([RenderId.servicioProgresoTemporizador]);
    });
  }

  void cancelarTemporizador() {
    timer?.cancel();
    update([RenderId.servicioProgresoTemporizador]);
  }

  void mostrarTiempo(int intervaloMs) {
    final int secActual = (intervaloMs ~/ Duration.millisecondsPerSecond);

    final int min = secActual ~/ 60;
    final int sec = secActual % 60;

    final m = min.toString().padLeft(2, '0');
    final s = sec.toString().padLeft(2, '0');

    txtTiempo = '$m:$s';
  }

  /*
  String mostrarHora(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
   */
}
