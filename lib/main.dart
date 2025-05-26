import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/navigator.dart';
import 'core/rutas.dart';

void main() {
  runApp(const UTOTPApp());
}

class UTOTPApp extends StatelessWidget {
  const UTOTPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTOTP',
      navigatorKey: GlobalNavigator.key,
      initialRoute: Rutas.animacion,
      getPages: WGRutas.routers,
    );
  }
}
