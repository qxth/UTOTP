import 'package:get/get.dart';
import '../controllers/servicio_controller.dart';

class ServicioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServicioController());
  }
}
