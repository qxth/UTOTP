import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../controllers/servicio_controller.dart';
import '../core/enums/render_enum.dart';
import 'utils/paleta.dart';
import 'package:get/get.dart';

class Temporizador extends StatefulWidget {
  const Temporizador({super.key});

  @override
  State<Temporizador> createState() => _TemporizadorState();
}

class _TemporizadorState extends State<Temporizador> {
  final ServicioController servicioController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServicioController>(
      id: RenderId.servicioProgresoTemporizador,
      builder: (_) {
        // debugPrint('> Render: $this');
        return SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: false,
              showTicks: false,
              minimum: 0,
              maximum: 100,
              startAngle: 270,
              endAngle: 270,
              axisLineStyle: AxisLineStyle(thickness: 1, color: Paleta.purpuraOscuro, thicknessUnit: GaugeSizeUnit.factor),
              pointers: <GaugePointer>[
                RangePointer(
                  value: 100,
                  width: 0.06,
                  color: Paleta.blanco_015,
                  pointerOffset: 0.08,
                  cornerStyle: CornerStyle.bothCurve,
                  sizeUnit: GaugeSizeUnit.factor,
                ),

                RangePointer(
                  value: servicioController.progreso,
                  width: 0.06,
                  color: Paleta.purpuraMedio,
                  pointerOffset: 0.08,
                  cornerStyle: CornerStyle.bothCurve,
                  sizeUnit: GaugeSizeUnit.factor,
                  // gradient: const SweepGradient(
                  //   colors: <Color>[Colors.orange, Colors.purple, Colors.cyan, Colors.teal, Colors.pink],
                  //   stops: <double>[0.25, 0.35, 0.45, 0.65, 0.90],
                  // ),
                ),
                MarkerPointer(
                  value: servicioController.progreso,
                  markerType: MarkerType.circle,
                  color: Colors.white,
                  markerWidth: 25,
                  markerHeight: 25,
                  offsetUnit: GaugeSizeUnit.factor,
                  markerOffset: -0.39,
                ),
                MarkerPointer(
                  text: servicioController.txtTiempo,
                  markerOffset: 82,
                  textStyle: GaugeTextStyle(color: Paleta.grisClaro, fontSize: 40, fontWeight: FontWeight.w500),
                  markerType: MarkerType.text,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
