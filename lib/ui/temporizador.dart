import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:totp_unix/ui/utils/paleta.dart';

class Temporizador extends StatefulWidget {
  const Temporizador({super.key});

  @override
  State<Temporizador> createState() => _TemporizadorState();
}

class _TemporizadorState extends State<Temporizador> {
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          showLabels: false,
          showTicks: false,
          minimum: 0,
          maximum: 100,
          startAngle: 270,
          endAngle: 270,
          axisLineStyle: AxisLineStyle(
            thickness: 1,
            color: Paleta.turquesa,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: [
            RangePointer(
              value: 100,
              width: 0.06,
              color: Paleta.blanco_015,
              pointerOffset: 0.08,
              cornerStyle: CornerStyle.bothCurve,
              sizeUnit: GaugeSizeUnit.factor,
            ),
            RangePointer(
              value: 70,
              width: 0.06,
              color: Colors.white,
              pointerOffset: 0.08,
              cornerStyle: CornerStyle.bothCurve,
              sizeUnit: GaugeSizeUnit.factor,
            ),
            MarkerPointer(
              value: 70,
              markerType: MarkerType.circle,
              color: Colors.white,
              markerWidth: 25,
              markerHeight: 25,
              offsetUnit: GaugeSizeUnit.factor,
              markerOffset: -0.39,
            ),
            MarkerPointer(
              text: '00:00',
              markerOffset: 82,
              textStyle: GaugeTextStyle(
                color: Paleta.darkTeal,
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
              markerType: MarkerType.text,
            ),
          ],
        ),
      ],
    );
  }
}
