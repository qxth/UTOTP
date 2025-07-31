import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/alpha_storage.dart';
import '../core/enums/storage_enum.dart';

class LineaTiempo extends StatefulWidget {
  final Function({required int sec, required int idx}) callback;
  final List<int> lista;
  const LineaTiempo({super.key, required this.callback, required this.lista});

  @override
  State<LineaTiempo> createState() => _LineaTiempoState();
}

class _LineaTiempoState extends State<LineaTiempo> {
  late final LineaTiempoController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LineaTiempoController(widget.lista));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('> Render $this');
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

  LineaTiempoController(this.listaTiempos);

  @override
  void onInit() async {
    super.onInit();

    final int? idxTiempo = await AlphaStorage.readInt(EnumAlphaStorage.idxTiempo.name);
    setTiempo(idxTiempo: idxTiempo);
  }

  String label() {
    final segundosActual = listaTiempos[indiceTiempo.value];

    if (segundosActual < 60) {
      return '${segundosActual.toInt()}s';
    }
    final int m = segundosActual ~/ 60;
    final int s = segundosActual % 60;
    if (s == 0) {
      return '${m}m';
    }
    return '${m}m ${s}s';
  }

  String labelTiempo() {
    final int m = listaTiempos[indiceTiempo.value] ~/ 60;
    final int s = listaTiempos[indiceTiempo.value] % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void setTiempo({required int? idxTiempo}) {
    if (idxTiempo != null) {
      indiceTiempo.value = idxTiempo;
    }
  }
}
