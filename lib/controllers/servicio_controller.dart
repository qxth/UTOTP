import 'dart:async';

import 'package:get/get.dart';

import '../core/alpha_storage.dart';
import '../core/enums/render_enum.dart';
import '../core/enums/storage_enum.dart';

class ServicioController extends GetxController {
  final List<int> lineaTiempo = [5, 10, 15, 20, 30, 60, 75, 80, 90, 120, 150, 180, 240, 300, 360, 420, 480, 540, 600];

  Timer? timer;
  String txtTiempo = "00:00";
  String correo = "user@example.com";
  String codigo2fa = "xxxxxx";

  int milisegundosLimite = Duration.millisecondsPerSecond;
  double progreso = 0;
  bool temporizadorIniciado = false;

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
    milisegundosLimite = Duration.millisecondsPerSecond * sec;
  }

  void setMilisegundosTemporizadorStore({required int sec, required int idx}) async {
    await AlphaStorage.save(key: EnumAlphaStorage.idxTiempo.name, value: idx);
    setMilisegundosTemporizador(sec: sec);
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

      final int expiracion = ((now.millisecondsSinceEpoch + 1) / milisegundosLimite).ceil() * milisegundosLimite;
      // final expiracionTime = DateTime.fromMillisecondsSinceEpoch(expiracion);
      final int intervalo = expiracion - now.millisecondsSinceEpoch;

      progreso = 100 - (intervalo * 100 / milisegundosLimite);

      mostrarTiempo(intervalo);
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
