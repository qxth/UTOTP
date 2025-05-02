import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineaTiempo extends StatefulWidget {
  final Function(int value) callback;
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
      spacing: 5,
      children: [
        Obx(() => Text(controller.labelTiempo(), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
        Obx(
          () => Slider(
            min: 0,
            max: (controller.listaTiempos.length - 1),
            value: controller.indiceTiempo.value.toDouble(),
            divisions: controller.listaTiempos.length - 1,
            label: controller.label(),
            onChanged: (double value) {
              controller.indiceTiempo.value = value.round();
              controller.segundosActual.value = controller.listaTiempos[controller.indiceTiempo.value];
              widget.callback(controller.segundosActual.value);
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
  late RxInt segundosActual;

  LineaTiempoController(this.listaTiempos);

  @override
  void onInit() {
    super.onInit();
    segundosActual = RxInt(listaTiempos[0]);
  }

  String label() {
    if (segundosActual.value < 60) {
      return '${listaTiempos[indiceTiempo.value].toInt()}s';
    }
    final int m = segundosActual.value ~/ 60;
    final int s = segundosActual.value % 60;
    if (s == 0) {
      return '${m}m';
    }
    return '${m}m ${s}s';
  }

  String labelTiempo() {
    final int m = segundosActual.value ~/ 60;
    final int s = segundosActual.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
