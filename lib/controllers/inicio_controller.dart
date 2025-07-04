import 'package:get/get.dart';

import '../core/alpha_storage.dart';
import '../core/enums/storage_enum.dart';
import '../models/servicio_modal.dart';

class InicioController extends GetxController {
  Rx<List<ServicioModal>> servicios = Rx<List<ServicioModal>>([]);

  @override
  void onInit() async {
    super.onInit();

    final data = await AlphaStorage.readJson(EnumAlphaStorage.services.name);

    if (data != null && data is Map<String, dynamic>) {
      servicios.value = data.values.map((e) => ServicioModal.fromJson(e)).toList();
    }
  }
}
