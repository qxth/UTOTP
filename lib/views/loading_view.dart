import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'inicio_view.dart'; // Asegúrate de importar correctamente
import '../ui/utils/paleta.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(debugShowCheckedModeBanner: false, home: LoadingView());
  }
}

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    // Timer de 5 segundos para cambiar de vista
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(() => const InicioView());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Paleta.lavandaClaro, Paleta.lavanda], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/loading.json',
                width: 200,
                height: 200,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..repeat();
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Cargando...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Paleta.purpuraClaro, letterSpacing: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
