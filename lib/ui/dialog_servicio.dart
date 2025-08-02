import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/inicio_controller.dart';
import '../controllers/servicio_controller.dart';
import '../core/rutas.dart';
import '../models/servicio_modal.dart';
import 'utils/paleta.dart';
import 'widgets/wg.dart';
import 'package:uuid/uuid.dart';
import '../core/alpha_storage.dart';
import '../core/enums/storage_enum.dart';

class ModalServicio extends StatefulWidget {
  final ServicioModal? servicioExistente;

  const ModalServicio({super.key, this.servicioExistente});

  @override
  State<ModalServicio> createState() => _ModalServicioState();
}

class _ModalServicioState extends State<ModalServicio> {
  late TextEditingController _correoController;
  late TextEditingController _tituloController;
  late TextEditingController _claveTotpController;
  late FocusNode _correoFocus;
  late FocusNode _tituloFocus;
  late FocusNode _claveTotpFocus;

  final RegExp _correoRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
  final Rx<EnumTipoServicio> _tipoSeleccionado = EnumTipoServicio.github.obs;
  final RxBool _claveVisible = false.obs;
  final RxString _confirmacionTexto = ''.obs;
  final RxBool _tieneCambios = false.obs;
  late final Rx<ServicioModal?> servicioExistente = Rx(null);

  String? _idServicio;

  @override
  void initState() {
    super.initState();
    _correoFocus = FocusNode();
    _tituloFocus = FocusNode();
    _claveTotpFocus = FocusNode();

    if (widget.servicioExistente != null) {
      servicioExistente.value = widget.servicioExistente;
    }

    _correoController = TextEditingController(text: servicioExistente.value?.correo ?? '');
    _tituloController = TextEditingController(text: servicioExistente.value?.titulo ?? 'GitHub');
    _claveTotpController = TextEditingController(text: servicioExistente.value?.claveTotp ?? '');

    _tipoSeleccionado.value = servicioExistente.value?.tipo ?? EnumTipoServicio.github;

    if (servicioExistente.value?.idServicio != null && servicioExistente.value!.idServicio.isNotEmpty) {
      _idServicio = servicioExistente.value!.idServicio;
    } else {
      _idServicio = _generarIdServicio();
    }

    _comprobarHayCambios();
  }

  @override
  void dispose() {
    _correoController.dispose();
    _tituloController.dispose();
    _claveTotpController.dispose();
    _correoFocus.dispose();
    _tituloFocus.dispose();
    _claveTotpFocus.dispose();
    super.dispose();
  }

  String _generarIdServicio() {
    return const Uuid().v1();
  }

  Future<bool> _mostrarDialogoConfirmacion(
    BuildContext context, {
    required String correoAnterior,
    required String correoNuevo,
    required String claveAnterior,
    required String claveNueva,
  }) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) {
        final confirmController = TextEditingController();
        final esModoOscuro = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: esModoOscuro ? Paleta.azul_noche : Colors.white,
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange[700], size: 32),
              const SizedBox(width: 12),
              Text('Cambios Sensibles', style: TextStyle(color: esModoOscuro ? Colors.white : Paleta.purpura, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Se van a realizar cambios críticos del servicio:',
                  style: TextStyle(color: esModoOscuro ? Colors.white70 : Colors.black87, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                if (correoAnterior != correoNuevo) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2, right: 8),
                        child: Icon(Icons.email_outlined, color: Colors.blue[300], size: 24),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Correo Electrónico',
                              style: TextStyle(color: esModoOscuro ? Colors.white70 : Colors.black87, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Text('Anterior: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600])),
                                  Expanded(
                                    child: Text(
                                      correoAnterior,
                                      style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red[100]!, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Text('Nuevo: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red[600])),
                                  Expanded(
                                    child: Text(
                                      correoNuevo,
                                      style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                if (claveAnterior != claveNueva) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2, right: 8),
                        child: Icon(Icons.vpn_key_outlined, color: Paleta.mandarina, size: 24),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Clave Secreta',
                              style: TextStyle(color: esModoOscuro ? Colors.white70 : Colors.black87, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Paleta.mandarina.withValues(alpha: 0.3), width: 1),
                              ),
                              child: Row(
                                children: [
                                  Text('Estado: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600])),
                                  Expanded(
                                    child: Text(
                                      'MODIFICADA',
                                      style: TextStyle(color: Paleta.mandarina, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '¡PRECAUCIÓN! Estos cambios pueden afectar tu acceso al servicio.',
                        style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmController,
                  decoration: InputDecoration(
                    hintText: 'Escriba SI para confirmar',
                    filled: true,
                    fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onChanged: (value) {
                    _confirmacionTexto.value = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: Get.back,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Paleta.granate,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  child: const Text('Cancelar'),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        _confirmacionTexto.value.trim().toUpperCase() == 'SI'
                            ? () {
                              Navigator.of(context).pop(true);
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Paleta.violeta,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      elevation: 2,
                    ),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    return confirmacion ?? false;
  }

  void _guardarServicio() async {
    final correo = _correoController.text.trim();
    final titulo = _tituloController.text.trim();
    final idServicio = _idServicio!;
    final claveTotp = _claveTotpController.text.trim();
    final correoValido = _correoRegExp.hasMatch(correo);

    if (idServicio.isEmpty) {
      WG.error(message: 'Se genero un error al crear el ID del servicio.');
      return;
    }
    if (correo.isEmpty) {
      FocusScope.of(context).requestFocus(_correoFocus);
      WG.error(message: 'El correo es obligatorio.');
      return;
    }
    if (!correoValido) {
      FocusScope.of(context).requestFocus(_correoFocus);
      WG.error(message: 'El correo no es válido.');
      return;
    }
    if (correo.length > 50) {
      FocusScope.of(context).requestFocus(_correoFocus);
      WG.error(message: 'El correo no puede tener más de 50 caracteres.');
      return;
    }
    if (titulo.isEmpty) {
      FocusScope.of(context).requestFocus(_tituloFocus);
      WG.error(message: 'El título es obligatorio.');
      return;
    }
    if (titulo.length < 3) {
      FocusScope.of(context).requestFocus(_tituloFocus);
      WG.error(message: 'El título debe tener al menos 3 caracteres.');
      return;
    }
    if (titulo.length > 50) {
      FocusScope.of(context).requestFocus(_tituloFocus);
      WG.error(message: 'El título no puede tener más de 50 caracteres.');
      return;
    }
    if (claveTotp.isEmpty) {
      FocusScope.of(context).requestFocus(_claveTotpFocus);
      WG.error(message: 'La clave secreta es obligatoria.');
      return;
    }

    bool hayCambiosSensibles =
        servicioExistente.value != null && (servicioExistente.value!.correo != correo || servicioExistente.value!.claveTotp != claveTotp);

    if (hayCambiosSensibles) {
      final confirmacion = await _mostrarDialogoConfirmacion(
        context,
        correoAnterior: servicioExistente.value?.correo ?? '',
        correoNuevo: correo,
        claveAnterior: servicioExistente.value?.claveTotp ?? '',
        claveNueva: claveTotp,
      );

      debugPrint('Confirmacion: $confirmacion');

      if (!confirmacion) return;
    }

    final nuevoServicio = ServicioModal(
      tipo: _tipoSeleccionado.value,
      correo: correo,
      titulo: titulo,
      idServicio: idServicio,
      claveTotp: claveTotp,
    );

    Map<String, dynamic> serviciosMap = {};
    final data = await AlphaStorage.readJson(EnumAlphaStorage.services);

    if (data != null && data is Map<String, dynamic>) {
      serviciosMap = Map<String, dynamic>.from(data);
    }

    // Añadir o actualizar el servicio
    serviciosMap[idServicio] = nuevoServicio.toJson();

    bool status = await AlphaStorage.saveJson(key: EnumAlphaStorage.services, value: serviciosMap);

    if (status) {
      // # Verificamos que la ruta este en la pantalla de inicio para actualizar los servicios
      if (Get.currentRoute == Rutas.inicio && Get.isRegistered<InicioController>()) {
        final inicioController = Get.find<InicioController>();
        inicioController.servicios.update((servicios) => servicios?.add(nuevoServicio));
      }

      if (Get.currentRoute == Rutas.servicio && Get.isRegistered<ServicioController>()) {
        final ServicioController servicioController = Get.find<ServicioController>();
        await servicioController.actualizarServicio();
      }

      Get.back();
      WG.success(title: 'Éxito', message: 'Servicio guardado correctamente.');
    } else {
      WG.error(message: 'Error al guardar el servicio.');
    }
  }

  Widget _iconoServicio(EnumTipoServicio tipo, {double size = 28}) {
    return SvgPicture.asset(WG.getIconoTipo(tipo), height: size, width: size);
  }

  @override
  Widget build(BuildContext context) {
    final esModoOscuro = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: esModoOscuro ? Paleta.azul_noche : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = MediaQuery.of(context).size.height * 0.85;
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings, color: Paleta.violeta, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          servicioExistente.value == null ? 'Crear Servicio' : 'Editar Servicio',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: esModoOscuro ? Colors.white : Paleta.purpura),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Tipo de Servicio',
                        filled: true,
                        fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton<EnumTipoServicio>(
                            value: _tipoSeleccionado.value,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down, color: Paleta.violeta),
                            selectedItemBuilder:
                                (context) => [
                                  Row(children: [_iconoServicio(EnumTipoServicio.github), const SizedBox(width: 8), const Text('GitHub')]),
                                  Row(children: [_iconoServicio(EnumTipoServicio.otro), const SizedBox(width: 8), const Text('Otro')]),
                                ],
                            items: [
                              DropdownMenuItem(
                                value: EnumTipoServicio.github,
                                child: Row(
                                  children: [_iconoServicio(EnumTipoServicio.github), const SizedBox(width: 8), const Text('GitHub')],
                                ),
                              ),
                              DropdownMenuItem(
                                value: EnumTipoServicio.otro,
                                child: Row(children: [_iconoServicio(EnumTipoServicio.otro), const SizedBox(width: 8), const Text('Otro')]),
                              ),
                            ],
                            onChanged: (value) {
                              _tipoSeleccionado.value = value!;
                              _comprobarHayCambios();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _tituloController,
                      focusNode: _tituloFocus,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        hintText: 'Nombre del servicio',
                        filled: true,
                        fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        prefixIcon: Icon(Icons.title_outlined, color: Paleta.verde_petroleo),
                      ),
                      onChanged: (value) {
                        _comprobarHayCambios();
                      },
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _correoController,
                      focusNode: _correoFocus,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        hintText: 'ejemplo@dominio.com',
                        filled: true,
                        fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        prefixIcon: Icon(Icons.email_outlined, color: Paleta.violeta),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _comprobarHayCambios();
                      },
                    ),

                    const SizedBox(height: 18),
                    Obx(
                      () => TextField(
                        controller: _claveTotpController,
                        focusNode: _claveTotpFocus,
                        decoration: InputDecoration(
                          labelText: 'Clave Secreta',
                          hintText: 'Clave secreta TOTP',
                          filled: true,
                          fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          prefixIcon: Icon(Icons.vpn_key_outlined, color: Paleta.mandarina),
                          suffixIcon: IconButton(
                            icon: Icon(_claveVisible.value ? Icons.visibility : Icons.visibility_off, color: Paleta.violeta),
                            onPressed: () {
                              _claveVisible.value = !_claveVisible.value;
                            },
                          ),
                        ),
                        obscureText: !_claveVisible.value,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          _comprobarHayCambios();
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: Get.back,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Paleta.granate,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            elevation: 2,
                          ),
                          child: const Text('Cancelar'),
                        ),
                        Obx(
                          () => ElevatedButton(
                            onPressed: _tieneCambios.value ? _guardarServicio : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Paleta.violeta,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              elevation: 2,
                            ),
                            child: const Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _comprobarHayCambios() {
    if (servicioExistente.value == null) {
      _tieneCambios.value = true;
      return;
    }

    final correo = _correoController.text.trim();
    final titulo = _tituloController.text.trim();
    final claveTotp = _claveTotpController.text.trim();

    _tieneCambios.value =
        correo != servicioExistente.value!.correo ||
        titulo != servicioExistente.value!.titulo ||
        claveTotp != servicioExistente.value!.claveTotp ||
        _tipoSeleccionado.value != servicioExistente.value!.tipo;
  }
}
