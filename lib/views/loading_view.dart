import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../core/rutas.dart';
import '../ui/utils/logger.dart';
import '../ui/utils/paleta.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Timer timer;

  final Duration duracionCarga = Duration(seconds: 3);
  final Duration duracionAnimacionLottie = Duration(seconds: 3);

  int countTimer = 1;
  RxString txtCargando = RxString('Cargando');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    timer = Timer.periodic(Duration(milliseconds: 900), (timer) {
      logger('$countTimer');
      txtCargando.value = 'Cargando'.padRight(8 + countTimer, '.');
      countTimer = countTimer >= 2 ? 0 : countTimer + 1;
    });
    Future.delayed(duracionCarga, () => Get.offNamed(Rutas.inicio));
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Paleta.animacion_degradado1, Paleta.animacion_degradado2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/loading.json',
                width: 250,
                height: 250,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = duracionAnimacionLottie
                    ..repeat();
                },
              ),
              const SizedBox(height: 20),
              Obx(
                () => Text(
                  txtCargando.value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Paleta.animacion_txt, letterSpacing: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
