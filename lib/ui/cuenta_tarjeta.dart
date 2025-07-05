import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../core/rutas.dart';
import '../models/servicio_modal.dart';
import 'utils/paleta.dart';
import 'widgets/wg.dart';
import '../controllers/inicio_controller.dart';

class CuentaTarjeta extends StatefulWidget {
  final ServicioModal servicio;

  const CuentaTarjeta({super.key, required this.servicio});

  @override
  State<CuentaTarjeta> createState() => _CuentaTarjetaState();
}

class _CuentaTarjetaState extends State<CuentaTarjeta> {
  final _estaSeleccionado = false.obs;
  final _confirmacionTexto = ''.obs;
  final _estaHoverEliminacion = false.obs;
  late final RxnString _codigoConfirmacion = RxnString(null);

  @override
  void initState() {
    super.initState();

    final partsIds = widget.servicio.idServicio.split('-');

    if (partsIds.isNotEmpty && partsIds[0].trim().isNotEmpty) {
      _codigoConfirmacion.value = partsIds[0];
    }

    if (_codigoConfirmacion.value == null) {
      WG.error(message: 'Se ha generado un error al cargar el id del servicio');
    }
  }

  @override
  void dispose() {
    _estaSeleccionado.close();
    _confirmacionTexto.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => _estaSeleccionado.value = true,
      onExit: (_) => _estaSeleccionado.value = false,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.toNamed(Rutas.servicio, arguments: {"id": widget.servicio.idServicio}),
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color:
                  _estaSeleccionado.value
                      ? (esModoOscuro ? Paleta.negro_42 : Colors.grey[50])
                      : (esModoOscuro ? Paleta.negro_medio_30 : Colors.white),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: _estaSeleccionado.value ? 20 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(WG.getIconoTipo(widget.servicio.tipo), height: 60, width: 60),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.servicio.titulo.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: esModoOscuro ? Colors.white : Colors.black87,
                                  letterSpacing: 1.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.servicio.correo,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: esModoOscuro ? Colors.grey[100] : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) => _estaHoverEliminacion.value = true,
                  onExit: (_) => _estaHoverEliminacion.value = false,
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _eliminarServicio,
                    child: Obx(
                      () => Container(
                        width: 50,
                        height: 100, // Fixed height
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _estaHoverEliminacion.value ? Paleta.granate.withValues(alpha: 0.8) : Paleta.granate,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
                        ),
                        child: Icon(Icons.delete_outline, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _mostrarDialogoConfirmacion() async {
    final confirmController = TextEditingController();
    final esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    final confirmacion = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: esModoOscuro ? Paleta.azul_noche : Colors.white,
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange[700], size: 32),
              const SizedBox(width: 12),
              Text('Eliminar Servicio', style: TextStyle(color: esModoOscuro ? Colors.white : Paleta.purpura, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Estás a punto de eliminar el servicio:',
                  style: TextStyle(color: esModoOscuro ? Colors.white70 : Colors.black87, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.asset(WG.getIconoTipo(widget.servicio.tipo), width: 70, height: 70),
                ),
                Text(widget.servicio.titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Paleta.violeta)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Paleta.violeta.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Paleta.violeta.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Text(
                    widget.servicio.correo,
                    style: TextStyle(fontSize: 14, color: esModoOscuro ? Colors.white70 : Paleta.azul_noche, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '¡PRECAUCIÓN! Esta acción no se puede deshacer.',
                        style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.qr_code, color: Colors.black, size: 24),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Paleta.violeta.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Paleta.violeta.withValues(alpha: 0.3), width: 1),
                      ),
                      child: SelectableText(
                        _codigoConfirmacion.value ?? 'None',
                        style: TextStyle(fontSize: 14, color: esModoOscuro ? Colors.white70 : Paleta.morado, fontWeight: FontWeight.w500),
                        contextMenuBuilder: (context, editableTextState) {
                          return AdaptiveTextSelectionToolbar.buttonItems(
                            anchors: editableTextState.contextMenuAnchors,
                            buttonItems: editableTextState.contextMenuButtonItems,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmController,
                  decoration: InputDecoration(
                    hintText: 'Ingresar código para confirmar',
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
                        _codigoConfirmacion.value != null && _confirmacionTexto.value.trim() == _codigoConfirmacion.value
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
                    child: const Text('Eliminar'),
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

  void _eliminarServicio() async {
    final confirmarEliminacion = await _mostrarDialogoConfirmacion();

    if (confirmarEliminacion) {
      if (!Get.isRegistered<InicioController>()) {
        WG.error(message: 'No se ha logrado eliminar el servicio. Error inesperado.');
        return;
      }
      final inicioController = Get.find<InicioController>();
      inicioController.eliminarServicio(widget.servicio.idServicio);
    }
  }
}
