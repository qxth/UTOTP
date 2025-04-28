import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../core/enums/render_enum.dart';
import 'utils/paleta.dart';
import 'package:get/get.dart';
import '../controllers/inicio_controller.dart';

class Temporizador extends StatefulWidget {
  const Temporizador({super.key});

  @override
  State<Temporizador> createState() => _TemporizadorState();
}

class _TemporizadorState extends State<Temporizador> {
  final InicioController inicioController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InicioController>(
      id: RenderId.progresoTemporizador,
      builder: (_) {
        return SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: false,
              showTicks: false,
              minimum: 0,
              maximum: 100,
              startAngle: 270,
              endAngle: 270,
              axisLineStyle: AxisLineStyle(thickness: 1, color: Paleta.turquesa, thicknessUnit: GaugeSizeUnit.factor),
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
                  value: inicioController.progreso,
                  width: 0.06,
                  color: Colors.white,
                  pointerOffset: 0.08,
                  cornerStyle: CornerStyle.bothCurve,
                  sizeUnit: GaugeSizeUnit.factor,
                  // gradient: const SweepGradient(
                  //   colors: <Color>[Color(0xFF00a9b5), Color(0xFFa4edeb)],
                  //   stops: <double>[0.25, 0.75],
                  // ),
                ),
                MarkerPointer(
                  value: inicioController.progreso,
                  markerType: MarkerType.circle,
                  color: const Color(0xffffffff),
                  markerWidth: 25,
                  markerHeight: 25,
                  offsetUnit: GaugeSizeUnit.factor,
                  markerOffset: -0.39,
                ),
                MarkerPointer(
                  text: inicioController.txtTiempo,
                  markerOffset: 82,
                  textStyle: GaugeTextStyle(color: Paleta.verdePetroleo, fontSize: 40, fontWeight: FontWeight.w500),
                  markerType: MarkerType.text,
                  color: const Color(0xffffffff),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
