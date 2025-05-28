import 'package:flutter/material.dart';

import '../../core/navigator.dart';
import '../dialogs/dialog_alert.dart';

class WG {
  static void success({bool nt = false, String? title = 'Informativo', String message = 'Proceso exitoso.'}) {
    showDialog(
      context: GlobalNavigator.key.currentContext!,
      builder: (BuildContext context) => DialogAlert(title: nt ? null : title, message: message, type: DialogType.success),
    );
  }

  static void advertencia({bool nt = false, String? title = 'Advertencia', String message = 'Algo no salio bien.'}) {
    showDialog(
      context: GlobalNavigator.key.currentContext!,
      builder: (BuildContext context) => DialogAlert(title: nt ? null : title, message: message, type: DialogType.warning),
    );
  }

  static void error({bool nt = false, String? title = 'Advertencia', message = 'Se ha generado un error inesperado.'}) {
    showDialog(
      context: GlobalNavigator.key.currentContext!,
      builder: (BuildContext context) => DialogAlert(title: nt ? null : title, message: message, type: DialogType.error),
    );
  }
}
