import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LineaTiempo extends StatefulWidget {
  final Function(double value) callback;
  const LineaTiempo({super.key, required this.callback});

  @override
  State<LineaTiempo> createState() => _LineaTiempoState();
}

class _LineaTiempoState extends State<LineaTiempo> {
  final LineaTiempoController controller = Get.put(LineaTiempoController());

  @override
  Widget build(BuildContext context) {
    debugPrint('> Render $this');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Obx(() => Text(controller.formatoLineaTiempo(), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
        Obx(
          () => Slider(
            min: 0,
            max: (controller.listaTiempos.length - 1),
            value: controller.indiceTiempo.value.toDouble(),
            divisions: controller.listaTiempos.length - 1,
            label: '${controller.listaTiempos[controller.indiceTiempo.value].toInt()}s',
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
  final List<double> listaTiempos = [5, 10, 15, 20, 30, 60, 75, 80, 90, 120, 150];
  RxInt indiceTiempo = RxInt(0);
  late RxDouble segundosActual;

  @override
  void onInit() {
    super.onInit();
    segundosActual = RxDouble(listaTiempos[0]);
  }

  String formatoLineaTiempo() {
    final int minutos = segundosActual ~/ 60;
    final int segundos = segundosActual.toInt() % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }
}
