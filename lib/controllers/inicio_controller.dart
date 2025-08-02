import 'package:get/get.dart';

import '../core/alpha_storage.dart';
import '../core/enums/storage_enum.dart';
import '../models/servicio_modal.dart';
import '../ui/widgets/wg.dart';

class InicioController extends GetxController {
  Rx<List<ServicioModal>> servicios = Rx<List<ServicioModal>>([]);

  @override
  void onInit() async {
    super.onInit();

    await actualizarServicios();
  }

  Future<void> actualizarServicios() async {
    final data = await AlphaStorage.readJson(EnumAlphaStorage.services);

    if (data != null && data is Map<String, dynamic>) {
      servicios.value = data.values.map((e) => ServicioModal.fromJson(e)).toList();
    }
  }

  void eliminarServicio(String idServicio) async {
    try {
      final Map<String, dynamic> data = await AlphaStorage.readJson(EnumAlphaStorage.services) ?? {};

      // Eliminar el servicio del mapa
      data.remove(idServicio);

      await AlphaStorage.saveJson(key: EnumAlphaStorage.services, value: data);

      servicios.value = data.values.map((e) => ServicioModal.fromJson(e)).toList();

      WG.success(message: 'Servicio eliminado correctamente');
    } catch (_) {
      WG.error(message: 'No se pudo eliminar el servicio');
      rethrow;
    }
  }
}
