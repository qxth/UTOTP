import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/logger.dart';
import 'utils/tiempos.dart';

class LineaTiempo extends StatefulWidget {
  final RxInt idxTiempo;
  final void Function({required int sec, required int idx}) callback;
  final List<int> lista;

  const LineaTiempo({super.key, required this.callback, required this.lista, required this.idxTiempo});

  @override
  State<LineaTiempo> createState() => _LineaTiempoState();
}

class _LineaTiempoState extends State<LineaTiempo> {
  late final LineaTiempoController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(LineaTiempoController(listaTiempos: widget.lista, idxTiempo: widget.idxTiempo.value));

    ever(widget.idxTiempo, (value) {
      logger('Cambio Indice: $value');
      controller.setTiempo(idx: value);
    });
  }

  @override
  void dispose() {
    Get.delete<LineaTiempoController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger('> Render LT $this');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => Text(controller.label(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        Obx(
          () => Slider(
            min: 0,
            max: (controller.listaTiempos.length - 1),
            value: controller.indiceTiempo.value.toDouble(),
            divisions: controller.listaTiempos.length - 1,
            label: controller.label(),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            onChanged: (double value) {
              controller.indiceTiempo.value = value.round();
            },
            onChangeEnd: (value) {
              controller.indiceTiempo.value = value.round();
              final segundosActuales = controller.listaTiempos[controller.indiceTiempo.value];
              widget.callback(sec: segundosActuales, idx: controller.indiceTiempo.value);
            },
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.deepPurple.shade100,
          ),
        ),
      ],
    );
  }
}

class LineaTiempoController extends GetxController {
  final List<int> listaTiempos;
  RxInt indiceTiempo = RxInt(0);

  LineaTiempoController({required this.listaTiempos, required int idxTiempo}) {
    setTiempo(idx: idxTiempo);
  }

  String label() {
    return labelTiempo(listaTiempos[indiceTiempo.value]);
  }

  /*
  String labelTiempo() {
    final int m = listaTiempos[indiceTiempo.value] ~/ 60;
    final int s = listaTiempos[indiceTiempo.value] % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
   */

  void setTiempo({required int idx}) {
    indiceTiempo.value = idx;
  }
}
