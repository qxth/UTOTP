import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/servicio_modal.dart';
import 'utils/paleta.dart';
import 'widgets/wg.dart';
import 'dart:math';

class ModalServicio extends StatefulWidget {
  final ServicioModal? servicioExistente;

  const ModalServicio({super.key, this.servicioExistente});

  @override
  State<ModalServicio> createState() => _ModalServicioState();
}

class _ModalServicioState extends State<ModalServicio> {
  late TextEditingController _correoController;
  late TextEditingController _tituloController;
  late TextEditingController _idServicioController;
  late FocusNode _correoFocus;
  late FocusNode _tituloFocus;
  EnumTipoServicio _tipoSeleccionado = EnumTipoServicio.github;
  final RegExp _correoRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');

  @override
  void initState() {
    super.initState();
    _correoController = TextEditingController(text: widget.servicioExistente?.correo ?? '');
    _tituloController = TextEditingController(text: widget.servicioExistente?.titulo ?? '');
    _idServicioController = TextEditingController(text: widget.servicioExistente?.idServicio ?? '');
    _correoFocus = FocusNode();
    _tituloFocus = FocusNode();
    _tipoSeleccionado = widget.servicioExistente?.tipo ?? EnumTipoServicio.otro;
  }

  @override
  void dispose() {
    _correoController.dispose();
    _tituloController.dispose();
    _idServicioController.dispose();
    _correoFocus.dispose();
    _tituloFocus.dispose();
    super.dispose();
  }

  String _generarIdServicio({int longitud = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(longitud, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  void _guardarServicio() {
    final correo = _correoController.text.trim();
    final titulo = _tituloController.text.trim();
    final idServicio = widget.servicioExistente?.idServicio ?? _generarIdServicio();

    if (correo.isEmpty) {
      FocusScope.of(context).requestFocus(_correoFocus);
      WG.error(title: 'Error', message: 'El correo es obligatorio.');
      return;
    }
    if (!_correoRegExp.hasMatch(correo)) {
      FocusScope.of(context).requestFocus(_correoFocus);
      WG.error(title: 'Error', message: 'El correo no es válido.');
      return;
    }
    if (correo.length > 50) {
      FocusScope.of(context).requestFocus(_correoFocus);
      WG.error(title: 'Error', message: 'El correo no puede tener más de 50 caracteres.');
      return;
    }
    if (titulo.isEmpty) {
      FocusScope.of(context).requestFocus(_tituloFocus);
      WG.error(title: 'Error', message: 'El título es obligatorio.');
      return;
    }
    if (titulo.length > 50) {
      FocusScope.of(context).requestFocus(_tituloFocus);
      WG.error(title: 'Error', message: 'El título no puede tener más de 50 caracteres.');
      return;
    }

    final nuevoServicio = ServicioModal(tipo: _tipoSeleccionado, correo: correo, titulo: titulo, idServicio: idServicio, claveTotp: '');
    Navigator.of(context).pop(nuevoServicio);
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
                        Icon(Icons.settings, color: Paleta.purpura_medio, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          widget.servicioExistente == null ? 'Crear Servicio' : 'Editar Servicio',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: esModoOscuro ? Colors.white : Paleta.purpura_oscuro,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Tipo de Servicio',
                        filled: true,
                        fillColor: esModoOscuro ? Paleta.negro30 : Paleta.lavanda_claro,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<EnumTipoServicio>(
                          value: _tipoSeleccionado,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Paleta.purpura_medio),
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
                            setState(() {
                              _tipoSeleccionado = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _correoController,
                      focusNode: _correoFocus,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        hintText: 'ejemplo@dominio.com',
                        filled: true,
                        fillColor: esModoOscuro ? Paleta.negro30 : Paleta.lavanda_claro,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        prefixIcon: Icon(Icons.email_outlined, color: Paleta.purpura_medio),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _tituloController,
                      focusNode: _tituloFocus,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        hintText: 'Nombre del servicio',
                        filled: true,
                        fillColor: esModoOscuro ? Paleta.negro30 : Paleta.lavanda_claro,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        prefixIcon: Icon(Icons.title_outlined, color: Paleta.verde_petroleo),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _idServicioController,
                      decoration: InputDecoration(
                        labelText: 'ID de Servicio',
                        hintText: 'Identificador único',
                        filled: true,
                        fillColor: esModoOscuro ? Paleta.negro30 : Paleta.lavanda_claro,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        prefixIcon: Icon(Icons.vpn_key_outlined, color: Paleta.naranja_oscuro),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Paleta.purpura_oscuro,
                            textStyle: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _guardarServicio,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Paleta.purpura_medio,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            elevation: 2,
                          ),
                          child: const Text('Guardar'),
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
}
