import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/alpha_storage.dart';
import '../core/enums/render_enum.dart';
import '../core/enums/storage_enum.dart';
import '../core/navigator.dart';
import '../core/totp.dart';
import '../models/servicio_modal.dart';
import '../ui/dialogs/dialog_alert.dart';
import '../ui/utils/logger.dart';
import '../ui/widgets/wg.dart';

final List<int> lineaTiempoSlider = [5, 10, 15, 20, 30, 60, 90, 120, 150, 180, 240, 300];

class ServicioController extends GetxController {
  final RxInt indiceTiempo = RxInt(0);
  late final String _idService;
  late String _claveTotp;

  final GlobalKey _keyAdvertenciaNoCumpleTipoServicio = GlobalKey();
  late final int defaultIndiceTiempo30Sec;
  final int tm30Sec = 30;

  final RxBool cargando = true.obs;
  final RxString titulo = "".obs;
  final RxString correo = "user@example.com".obs;
  final RxString codigo2fa = "xxxxxx".obs;

  final RxInt segundosLimite = 0.obs;
  final RxBool temporizadorIniciado = false.obs;

  ServicioModal? servicioActual;
  Timer? timer;
  String txtTiempo = "00:00";

  int milisegundosLimite = Duration.millisecondsPerSecond;
  double progreso = 0;

  @override
  Future<void> onInit() async {
    super.onInit();

    defaultIndiceTiempo30Sec = lineaTiempoSlider.indexWhere((element) => element == tm30Sec);
    _idService = Get.arguments["id"];
    await actualizarServicio();

    try {
      iniciarTemporizador();
    } catch (_) {
      WG.error();
      rethrow;
    }

    cargando.value = false;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> actualizarServicio() async {
    try {
      final servicesData = await AlphaStorage.readJson(EnumAlphaStorage.services);

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

      // defaultServicio.value = servicio.defaultServicio;
      titulo.value = servicio.titulo;
      correo.value = servicio.correo;
      _claveTotp = servicio.clave;

      logger('Raw: ${servicesData[_idService]}');
      logger('Servicio Actual Local: ${servicioActual?.periodo}');
      logger('Servicio Actual Defec: ${servicioActual?.defectoServicio.period}');
      logger('Tiene Periodo: ${tienePeriodoDefecto()} ${tienePeriodoLocal()}');

      //if (tienePeriodoDefecto() || tienePeriodoLocal()) {
      // # Tiene periodo entonces buscamos si existe en la linea de tiempo
      final idxTiempo = lineaTiempoSlider.indexWhere((element) => element == servicio.periodo);
      indiceTiempo.value = idxTiempo != -1 ? idxTiempo : defaultIndiceTiempo30Sec;
      // logger('IdxTiempo: ${indiceTiempo.value} ${labelTiempo(lineaTiempoSlider[indiceTiempo.value])}');

      if (idxTiempo == -1) {
        WG.error(message: 'No se ha encontrado el indice para el periodo de tiempo');
      }

      setMilisegundosTemporizador(sec: lineaTiempoSlider[indiceTiempo.value]);
    } catch (_) {
      WG.error();
      rethrow;
    }
  }

  bool tienePeriodoDefecto() {
    return servicioActual?.defectoServicio.period != null;
  }

  bool tienePeriodoLocal() {
    return servicioActual?.periodo != null;
  }

  /*
  bool tieneCualquierPeriodo() {
    return tienePeriodoDefecto() || tienePeriodoLocal();
  }
   */

  bool noTienePeriodoDefecto() {
    return servicioActual?.defectoServicio.period == null;
  }

  bool tienePeriodoDefectoNoEsIgualAlPeriodoActual(int sec) {
    return tienePeriodoDefecto() && sec != servicioActual?.defectoServicio.period;
  }

  void setMilisegundosTemporizador({required int sec}) {
    if (tienePeriodoDefectoNoEsIgualAlPeriodoActual(sec)) {
      advertenciaPeriodoDefectoNoEsIgual();
    }
    segundosLimite.value = sec;
    milisegundosLimite = Duration.millisecondsPerSecond * sec;
  }

  void setMilisegundosTemporizadorStore({required int sec, required int idx}) async {
    // if (noTienePeriodoDefecto()) {
    // await AlphaStorage.save(key: EnumAlphaStorage.idxTiempo, value: idx);
    // }
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
          final totp = await Totp.generate(_claveTotp, period: segundosLimite.value);
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
        // logger('> Obteniendo OTP: $expiracion');
        logger('Code: ${codigo2fa.value} | Sec: $segundosLimite');
      }

      mostrarTiempo(intervalo);
      // logger('$expiracion $intervalo');
      // logger('${mostrarHora(now)} | ${mostrarHora(expiracionTime)} | ${now.millisecondsSinceEpoch} | ${expiracionTime.millisecondsSinceEpoch}');
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

  void advertenciaPeriodoDefectoNoEsIgual() {
    if (_keyAdvertenciaNoCumpleTipoServicio.currentContext?.mounted == true) {
      return;
    }
    showDialog(
      context: GlobalNavigator.key.currentContext!,
      builder:
          (BuildContext context) => DialogAlert(
            key: _keyAdvertenciaNoCumpleTipoServicio,
            title: 'Advertencia',
            message:
                'Debe establecer el tiempo (${servicioActual?.defectoServicio.period} segundos) recomendado para evitar conflictos con la cuenta.',
            type: DialogType.warning,
          ),
    );
    // WG.advertencia(message: );
  }
}
