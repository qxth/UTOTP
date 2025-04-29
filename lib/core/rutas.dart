import 'package:get/get.dart';
import '../bindings/inicio_binding.dart';
import '../bindings/servicio_binding.dart';
import '../views/inicio_view.dart';
import '../views/servicio_view.dart';

class Rutas {
  static const inicio = '/dashboard';
  static const servicio = '/service';
}

class WGRutas {
  static List<GetPage<dynamic>> routers = [
    GetPage(name: Rutas.inicio, page: () => InicioView(), binding: InicioBinding()),
    GetPage(name: Rutas.servicio, page: () => ServicioView(), binding: ServicioBinding()),
  ];
}
