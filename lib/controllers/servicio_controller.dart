import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../core/alpha_storage.dart';
import '../core/enums/render_enum.dart';
import '../core/enums/storage_enum.dart';
import '../core/totp.dart';
import '../models/servicio_modal.dart';
import '../ui/widgets/wg.dart';

class ServicioController extends GetxController {
  final List<int> lineaTiempo = [5, 10, 15, 20, 30, 60, 75, 80, 90, 120, 150, 180, 240, 300, 360, 420, 480, 540, 600];

  late final String _idService;
  late String _claveTotp;

  ServicioModal? servicioActual;
  Timer? timer;
  String txtTiempo = "00:00";
  RxString titulo = "".obs;
  RxString correo = "user@example.com".obs;
  RxString codigo2fa = "xxxxxx".obs;

  int milisegundosLimite = Duration.millisecondsPerSecond;
  int segundosLimite = 0;
  double progreso = 0;
  RxBool temporizadorIniciado = false.obs;

  @override
  void onReady() async {
    super.onReady();

    _idService = Get.arguments["id"];
    await actualizarServicio();

    try {
      final int? indiceTiempo = await AlphaStorage.readInt(EnumAlphaStorage.idxTiempo.name);
      setMilisegundosTemporizador(sec: lineaTiempo[indiceTiempo ?? 0]);
      iniciarTemporizador();
    } catch (_) {
      WG.error();
      rethrow;
    }
  }

  Future<void> actualizarServicio() async {
    try {
      final servicesData = await AlphaStorage.readJson(EnumAlphaStorage.services.name);

      if (servicesData == null || servicesData is! Map<String, dynamic>) {
        WG.error(message: "No se encontraron servicios.");
        return;
      }

      if (servicesData[_idService] == null) {
        WG.error(message: "El servicio que intenta cargar no existe.");
        return;
      }

      final ServicioModal servicio = ServicioModal.fromJson(servicesData[_idService] as Map<String, dynamic>);

      if (_idService != servicio.idServicio) {
        WG.error(message: "El servicio que intenta cargar no es identico al esperado.");
        return;
      }

      servicioActual = servicio;

      correo.value = servicio.correo;
      titulo.value = servicio.titulo;
      _claveTotp = servicio.claveTotp;
    } catch (_) {
      WG.error();
      rethrow;
    }
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

    timer = Timer.periodic(Duration(milliseconds: 60), (_) async {
      DateTime now = DateTime.now();

      final int expiracion = ((now.millisecondsSinceEpoch + 1) / milisegundosLimite).ceil() * milisegundosLimite;
      // final expiracionTime = DateTime.fromMillisecondsSinceEpoch(expiracion);
      final int intervalo = expiracion - now.millisecondsSinceEpoch;

      progreso = 100 - (intervalo * 100 / milisegundosLimite);

      if (expiracionInicial != expiracion) {
        expiracionInicial = expiracion;
        try {
          final totp = await Totp.generate(_claveTotp, period: segundosLimite);
          codigo2fa.value = totp.otp;
        } catch (ex) {
          if (ex.toString() == TOTPError.invalidBase32) {
            WG.error(message: "La clave totp no es válida.");
            temporizadorIniciado.value = false;
            cancelarTemporizador();
          } else {
            WG.error(message: "Error al generar el OTP.");
          }
          rethrow;
        }
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
