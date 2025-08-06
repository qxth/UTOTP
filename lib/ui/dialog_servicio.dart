import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/inicio_controller.dart';
import '../controllers/servicio_controller.dart';
import '../core/enums/servicio_enum.dart';
import '../core/enums/totp_enum.dart';
import '../core/rutas.dart';
import '../core/totp.dart';
import '../models/servicio_modal.dart';
import 'utils/paleta.dart';
import 'utils/tiempos.dart';
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
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController(text: 'Desconocido');
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _digitosController = TextEditingController();

  late FocusNode _correoFocus;
  late FocusNode _tituloFocus;
  late FocusNode _claveFocus;
  late FocusNode _digitosFocus;

  final RegExp _correoRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
  final Rx<EnumTipoServicio> _selectTipoServicio = EnumTipoServicio.github.obs;
  final RxInt _selectTipoPeriodo = defaultPeriod.obs;
  final Rx<TOTPAlgorithm> _selectTipoAlgoritmo = Rx(TOTPAlgorithm.sha_1);
  final Rx<TOTPEncoding> _selectTipoCodificacion = Rx(TOTPEncoding.hex);
  final RxBool _claveVisible = false.obs;
  final RxString _confirmacionTexto = ''.obs;
  final RxBool _tieneCambios = false.obs;
  final String tagEditable = '(no editable)';

  final Rx<ServicioModal?> servicioExistente = Rx(null);
  final modificablePeriodo = false.obs;
  final modificableDigitos = false.obs;
  final modificableAlgoritmo = false.obs;
  final modificableCodificacion = false.obs;

  final RxBool isNew = RxBool(true);
  final RxBool isEdit = RxBool(false);

  late final String? _idServicio;

  @override
  void initState() {
    super.initState();
    _correoFocus = FocusNode();
    _tituloFocus = FocusNode();
    _claveFocus = FocusNode();
    _digitosFocus = FocusNode();

    isNew.value = widget.servicioExistente == null;
    isEdit.value = !isNew.value;

    if (isEdit.value) {
      servicioExistente.value = widget.servicioExistente;

      _idServicio = servicioExistente.value!.idServicio;
      _selectTipoServicio.value = servicioExistente.value!.defectoServicio;

      _correoController.text = servicioExistente.value!.correo;
      _tituloController.text = servicioExistente.value!.titulo;
      _claveController.text = servicioExistente.value!.clave;
      _digitosController.text = servicioExistente.value!.digitos.toString();

      _selectTipoPeriodo.value = servicioExistente.value!.periodo;
      _selectTipoAlgoritmo.value = servicioExistente.value!.algoritmo;
      _selectTipoCodificacion.value = servicioExistente.value!.codificacion;
    } else {
      _idServicio = _generarIdServicio();
      _selectTipoServicio.value = EnumTipoServicio.github;

      _digitosController.text = (EnumTipoServicio.github.digits ?? defaultDigits).toString();
      _selectTipoPeriodo.value = EnumTipoServicio.github.period ?? defaultPeriod;
      _selectTipoAlgoritmo.value = EnumTipoServicio.github.algorithm ?? defaultAlgorithm;
      _selectTipoCodificacion.value = EnumTipoServicio.github.encoding ?? defaultEncoding;
    }

    _updateIsEditable(_selectTipoServicio.value);

    _comprobarHayCambios();
  }

  @override
  void dispose() {
    _correoController.dispose();
    _tituloController.dispose();
    _claveController.dispose();
    _correoFocus.dispose();
    _tituloFocus.dispose();
    _claveFocus.dispose();
    super.dispose();
  }

  String _generarIdServicio() {
    return const Uuid().v1();
  }

  Widget _datoCambiado({
    required String datoAnterior,
    required String datoNuevo,
    required String titulo,
    required IconData icono,
    SvgPicture? iconoAnterior,
    SvgPicture? iconoNuevo,
    required bool esModoOscuro,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2, right: 8), child: Icon(icono, color: Colors.blue[300], size: 24)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(titulo, style: TextStyle(color: esModoOscuro ? Colors.white70 : Colors.black87, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Row(
                  children: [
                    if (iconoAnterior != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: CircleAvatar(backgroundColor: Colors.transparent, maxRadius: 15, child: iconoAnterior),
                      ),
                    Text('Anterior: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600])),
                    Expanded(
                      child: Text(
                        datoAnterior,
                        style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!, width: 1),
                ),
                child: Row(
                  children: [
                    if (iconoNuevo != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: CircleAvatar(backgroundColor: Colors.transparent, maxRadius: 15, child: iconoNuevo),
                      ),
                    Text('Nuevo: ', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[600])),
                    Expanded(
                      child: Text(
                        datoNuevo,
                        style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w500),
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
    );
  }

  Future<bool> _mostrarDialogoConfirmacion(
    BuildContext context, {
    required EnumTipoServicio servicioAnterior,
    required EnumTipoServicio servicioNuevo,
    required String correoAnterior,
    required String correoNuevo,
    required String claveAnterior,
    required String claveNueva,
    required int digitosAnterior,
    required int digitosNuevo,
    required int periodoAnterior,
    required int periodoNuevo,
    required String algoritmoAnterior,
    required String algoritmoNuevo,
    required String codificacionAnterior,
    required String codificacionNuevo,
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
              spacing: 16,
              children: [
                Text(
                  'Se van a realizar cambios críticos del servicio:',
                  style: TextStyle(color: esModoOscuro ? Colors.white70 : Colors.black87, fontWeight: FontWeight.w600),
                ),

                if (claveAnterior != claveNueva)
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

                if (correoAnterior != correoNuevo)
                  _datoCambiado(
                    datoAnterior: correoAnterior,
                    datoNuevo: correoNuevo,
                    titulo: 'Correo Electrónico',
                    icono: Icons.email_outlined,
                    esModoOscuro: esModoOscuro,
                  ),

                if (servicioAnterior != servicioNuevo)
                  _datoCambiado(
                    datoAnterior: servicioAnterior.name,
                    datoNuevo: servicioNuevo.name,
                    titulo: 'Tipo de Servicio',
                    icono: Icons.error_outline,
                    iconoAnterior: SvgPicture.asset(servicioAnterior.icono, width: 40, height: 40),
                    iconoNuevo: SvgPicture.asset(servicioNuevo.icono, width: 40, height: 40),
                    esModoOscuro: esModoOscuro,
                  ),

                if (digitosAnterior != digitosNuevo)
                  _datoCambiado(
                    datoAnterior: digitosAnterior.toString(),
                    datoNuevo: digitosNuevo.toString(),
                    titulo: 'Dígitos',
                    icono: Icons.numbers,
                    esModoOscuro: esModoOscuro,
                  ),

                if (periodoAnterior != periodoNuevo)
                  _datoCambiado(
                    datoAnterior: labelTiempo(periodoAnterior),
                    datoNuevo: labelTiempo(periodoNuevo),
                    titulo: 'Periodo',
                    icono: Icons.timer_sharp,
                    esModoOscuro: esModoOscuro,
                  ),

                if (algoritmoAnterior != algoritmoNuevo)
                  _datoCambiado(
                    datoAnterior: algoritmoAnterior,
                    datoNuevo: algoritmoNuevo,
                    titulo: 'Algoritmo',
                    icono: Icons.code,
                    esModoOscuro: esModoOscuro,
                  ),

                if (codificacionAnterior != codificacionNuevo)
                  _datoCambiado(
                    datoAnterior: codificacionAnterior,
                    datoNuevo: codificacionNuevo,
                    titulo: 'Codificación',
                    icono: Icons.qr_code,
                    esModoOscuro: esModoOscuro,
                  ),

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
    final claveTotp = _claveController.text.trim();
    final correoValido = _correoRegExp.hasMatch(correo);
    final digitos = int.tryParse(_digitosController.text.trim());

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
      FocusScope.of(context).requestFocus(_claveFocus);
      WG.error(message: 'La clave secreta es obligatoria.');
      return;
    }

    if (digitos == null || digitos < 1) {
      FocusScope.of(context).requestFocus(_digitosFocus);
      WG.error(message: 'Debe ingresar un dígito mayor a 0');
      return;
    }

    bool hayCambiosSensibles =
        servicioExistente.value != null &&
        (_selectTipoServicio.value != servicioExistente.value!.defectoServicio ||
            correo != servicioExistente.value!.correo ||
            claveTotp != servicioExistente.value!.clave ||
            digitos != servicioExistente.value!.digitos ||
            _selectTipoPeriodo.value != servicioExistente.value!.periodo ||
            _selectTipoAlgoritmo.value != servicioExistente.value!.algoritmo ||
            _selectTipoCodificacion.value != servicioExistente.value!.codificacion);

    if (hayCambiosSensibles) {
      final confirmacion = await _mostrarDialogoConfirmacion(
        context,
        servicioAnterior: servicioExistente.value?.defectoServicio ?? EnumTipoServicio.github,
        servicioNuevo: _selectTipoServicio.value,
        correoAnterior: servicioExistente.value?.correo ?? '',
        correoNuevo: correo,
        claveAnterior: servicioExistente.value?.clave ?? '',
        claveNueva: claveTotp,
        digitosAnterior: servicioExistente.value?.digitos ?? 0,
        digitosNuevo: digitos,
        periodoAnterior: servicioExistente.value?.periodo ?? 0,
        periodoNuevo: _selectTipoPeriodo.value,
        algoritmoAnterior: servicioExistente.value?.algoritmo.name ?? '',
        algoritmoNuevo: _selectTipoAlgoritmo.value.name,
        codificacionAnterior: servicioExistente.value?.codificacion.name ?? '',
        codificacionNuevo: _selectTipoCodificacion.value.name,
      );

      debugPrint('Confirmacion: $confirmacion');

      if (!confirmacion) return;
    }

    final nuevoServicio = ServicioModal(
      defectoServicio: _selectTipoServicio.value,
      titulo: titulo,
      correo: correo,
      idServicio: idServicio,
      algoritmo: _selectTipoAlgoritmo.value,
      codificacion: _selectTipoCodificacion.value,
      periodo: _selectTipoPeriodo.value,
      digitos: digitos,
      clave: claveTotp,
    );

    debugPrint('${nuevoServicio.toJson()}');

    // return;

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
    return SvgPicture.asset(tipo.icono, height: size, width: size);
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
                  spacing: 18,
                  children: [
                    Row(
                      spacing: 12,
                      children: [
                        Icon(Icons.settings, color: Paleta.violeta, size: 32),
                        Text(
                          isNew.value ? 'Crear Servicio' : 'Editar Servicio',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: esModoOscuro ? Colors.white : Paleta.purpura),
                        ),
                      ],
                    ),

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
                            value: _selectTipoServicio.value,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down, color: Paleta.violeta),
                            selectedItemBuilder:
                                (context) =>
                                    EnumTipoServicio.values
                                        .map(
                                          (it) => Row(
                                            spacing: 8,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [_iconoServicio(it), Text(it.name)],
                                          ),
                                        )
                                        .toList(),
                            items:
                                EnumTipoServicio.values
                                    .map(
                                      (it) => DropdownMenuItem(
                                        value: it,
                                        child: Row(
                                          spacing: 8,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [_iconoServicio(it), Text(it.name)],
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (servicio) {
                              _selectTipoServicio.value = servicio!;
                              _cambioServicio(servicio);
                              _updateIsEditable(servicio);
                              _comprobarHayCambios();
                            },
                          ),
                        ),
                      ),
                    ),

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

                    Obx(
                      () => InputDecorator(
                        decoration: InputDecoration(
                          enabled: modificableAlgoritmo.value,
                          labelText: 'Algoritmo${_editable(modificableAlgoritmo)}',
                          filled: true,
                          fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<TOTPAlgorithm>(
                              value: _selectTipoAlgoritmo.value,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: Paleta.violeta),
                              selectedItemBuilder:
                                  (context) =>
                                      TOTPAlgorithm.values
                                          .map(
                                            (it) => Row(
                                              spacing: 8,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [Icon(Icons.code), Text(it.title)],
                                            ),
                                          )
                                          .toList(),
                              items:
                                  TOTPAlgorithm.values
                                      .map(
                                        (it) => DropdownMenuItem(
                                          value: it,
                                          child: Row(
                                            spacing: 8,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [Icon(Icons.code), Text(it.title)],
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  modificableAlgoritmo.value
                                      ? (value) {
                                        _selectTipoAlgoritmo.value = value!;
                                        _comprobarHayCambios();
                                      }
                                      : null,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //if (_tipoCodificacion.value != null)
                    Obx(
                      () => InputDecorator(
                        decoration: InputDecoration(
                          enabled: modificableCodificacion.value,
                          labelText: 'Codificación${_editable(modificableCodificacion)}',
                          filled: true,
                          fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<TOTPEncoding>(
                              value: _selectTipoCodificacion.value,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: Paleta.violeta),
                              selectedItemBuilder:
                                  (context) =>
                                      TOTPEncoding.values
                                          .map(
                                            (it) => Row(
                                              spacing: 8,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [Icon(Icons.qr_code, size: 20), Text(it.name)],
                                            ),
                                          )
                                          .toList(),
                              items:
                                  TOTPEncoding.values
                                      .map(
                                        (it) => DropdownMenuItem(
                                          value: it,
                                          child: Row(
                                            spacing: 8,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [Icon(Icons.qr_code, size: 20), Text(it.name)],
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  modificableCodificacion.value
                                      ? (value) {
                                        _selectTipoCodificacion.value = value!;
                                        _comprobarHayCambios();
                                      }
                                      : null,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Obx(
                      () => InputDecorator(
                        decoration: InputDecoration(
                          enabled: modificablePeriodo.value,
                          labelText: 'Periodo${_editable(modificablePeriodo)}',
                          filled: true,
                          fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectTipoPeriodo.value,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: Paleta.violeta),
                              selectedItemBuilder:
                                  (context) =>
                                      lineaTiempoSlider
                                          .map(
                                            (it) => Row(
                                              spacing: 8,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [Icon(Icons.timer_sharp, size: 20, color: Paleta.morado), Text(labelTiempo(it))],
                                            ),
                                          )
                                          .toList(),
                              items:
                                  lineaTiempoSlider
                                      .map(
                                        (it) => DropdownMenuItem(
                                          value: it,
                                          child: Row(
                                            spacing: 8,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [Icon(Icons.timer_sharp, size: 20), Text(labelTiempo(it))],
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  modificablePeriodo.value
                                      ? (value) {
                                        _selectTipoPeriodo.value = value!;
                                        _comprobarHayCambios();
                                      }
                                      : null,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Obx(
                      () => TextField(
                        controller: _digitosController,
                        focusNode: _digitosFocus,
                        enabled: modificableDigitos.value,
                        decoration: InputDecoration(
                          labelText: 'Dígitos${_editable(modificableDigitos)}',
                          hintText: 'Dígitos',
                          filled: true,
                          fillColor: esModoOscuro ? Paleta.negro_medio_30 : Paleta.lavanda_claro,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          prefixIcon: Icon(Icons.numbers, color: Paleta.esmeralda),
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        maxLength: 2,
                        onChanged: (value) {
                          _comprobarHayCambios();
                        },
                      ),
                    ),

                    Obx(
                      () => TextField(
                        controller: _claveController,
                        focusNode: _claveFocus,
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
    final claveTotp = _claveController.text.trim();
    final digitos = _digitosController.text;

    _tieneCambios.value =
        correo != servicioExistente.value!.correo ||
        titulo != servicioExistente.value!.titulo ||
        claveTotp != servicioExistente.value!.clave ||
        digitos != servicioExistente.value!.digitos.toString() ||
        _selectTipoServicio.value != servicioExistente.value!.defectoServicio ||
        _selectTipoAlgoritmo.value != servicioExistente.value!.algoritmo ||
        _selectTipoCodificacion.value != servicioExistente.value!.codificacion ||
        _selectTipoPeriodo.value != servicioExistente.value!.periodo;
  }

  String _editable(RxBool mod) {
    return mod.value ? '' : ' $tagEditable';
  }

  void _cambioServicio(EnumTipoServicio? servicio) {
    debugPrint('Digits: ${servicio?.digits ?? defaultDigits}');

    _selectTipoPeriodo.value = servicio?.period ?? defaultPeriod;
    _digitosController.text = (servicio?.digits ?? defaultDigits).toString();
    _selectTipoAlgoritmo.value = servicio?.algorithm ?? defaultAlgorithm;
    _selectTipoCodificacion.value = servicio?.encoding ?? defaultEncoding;
  }

  void _updateIsEditable(EnumTipoServicio? servicio) {
    modificablePeriodo.value = servicio?.period == null;
    modificableDigitos.value = servicio?.digits == null;
    modificableAlgoritmo.value = servicio?.algorithm == null;
    modificableCodificacion.value = servicio?.encoding == null;
  }
}
