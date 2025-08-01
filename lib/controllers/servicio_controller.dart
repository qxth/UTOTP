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
import '../ui/widgets/wg.dart';

class ServicioController extends GetxController {
  final List<int> lineaTiempo = [5, 10, 15, 20, 30, 60, 75, 80, 90, 120, 150, 180, 240, 300, 360, 420, 480, 540, 600];
  final GlobalKey _keyAdvertenciaGithub = GlobalKey();
  final defaultIndiceTiempo30Sec = 4;
  final RxBool cargando = true.obs;
  final int tiempo30Sec = 30;

  late final int indiceTiempoInicial;
  late final String _idService;
  late String _claveTotp;

  ServicioModal? servicioActual;
  Timer? timer;
  // Timer? timerAdvertencia;
  String txtTiempo = "00:00";
  RxString titulo = "".obs;
  RxString correo = "user@example.com".obs;
  RxString codigo2fa = "xxxxxx".obs;
  Rx<EnumTipoServicio> tipoServicio = Rx(EnumTipoServicio.github);

  int milisegundosLimite = Duration.millisecondsPerSecond;
  RxInt segundosLimite = 0.obs;
  double progreso = 0;
  RxBool temporizadorIniciado = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    _idService = Get.arguments["id"];
    await actualizarServicio();

    try {
      debugPrint('GB: ${tipoServicio.value.name}');
      if (tipoServicio.value == EnumTipoServicio.github) {
        // # Iniciamos con 30 segundos para GITHUB siempre
        indiceTiempoInicial = defaultIndiceTiempo30Sec;
      } else {
        indiceTiempoInicial = await AlphaStorage.readInt(EnumAlphaStorage.idxTiempo.name) ?? defaultIndiceTiempo30Sec;
      }

      setMilisegundosTemporizador(sec: lineaTiempo[indiceTiempoInicial]);
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
    // timerAdvertencia?.cancel();
    super.dispose();
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

      tipoServicio.value = servicio.tipo;
      correo.value = servicio.correo;
      titulo.value = servicio.titulo;
      _claveTotp = servicio.claveTotp;
    } catch (_) {
      WG.error();
      rethrow;
    }
  }

  void setMilisegundosTemporizador({required int sec}) {
    debugPrint('Tiempo: $sec');
    if (tipoServicio.value == EnumTipoServicio.github && sec != tiempo30Sec) {
      advertenciaGitHub();
    }
    segundosLimite.value = sec;
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

    /*
    if(tipoServicio.value == EnumTipoServicio.github) {
      timerAdvertencia = Timer.periodic(Duration(seconds: 5), (timer) {
        if(tipoServicio.value == EnumTipoServicio.github && segundosLimite != 30 &&
            _keyAdvertenciaGithub.currentState?.mounted != true) {
            advertenciaGitHub();
        }
      });
    }
     */

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
    // timerAdvertencia?.cancel();
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

  void advertenciaGitHub() {
    if (_keyAdvertenciaGithub.currentContext?.mounted == true) {
      return;
    }
    showDialog(
      context: GlobalNavigator.key.currentContext!,
      builder:
          (BuildContext context) => DialogAlert(
            key: _keyAdvertenciaGithub,
            title: 'Advertencia',
            message: 'Para GitHub debe establecer el tiempo en 30 segundos, para evitar conflictos con la cuenta.',
            type: DialogType.warning,
          ),
    );
    // WG.advertencia(message: );
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
