import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemporizadorView extends StatefulWidget {
  const TemporizadorView({super.key});

  @override
  State<TemporizadorView> createState() => _TemporizadorViewState();
}

class _TemporizadorViewState extends State<TemporizadorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TOTP')),
      body: Center(
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 150,
              ranges: <GaugeRange>[
                GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
                GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
                GaugeRange(startValue: 100, endValue: 150, color: Colors.red),
              ],
              pointers: <GaugePointer>[NeedlePointer(value: 90)],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text(
                    '90.0',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  angle: 90,
                  positionFactor: 0.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
