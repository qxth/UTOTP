import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../core/rutas.dart';
import '../models/servicio_modal.dart';
import 'utils/paleta.dart';
import 'widgets/wg.dart';

class CuentaTarjeta extends StatefulWidget {
  final ServicioModal servicio;

  const CuentaTarjeta({super.key, required this.servicio});

  @override
  State<CuentaTarjeta> createState() => _EstadoCuentaTarjeta();
}

class _EstadoCuentaTarjeta extends State<CuentaTarjeta> {
  bool _estaSeleccionado = false;

  @override
  Widget build(BuildContext context) {
    final esModoOscuro = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _estaSeleccionado = true),
      onExit: (_) => setState(() => _estaSeleccionado = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.toNamed(Rutas.servicio, arguments: {"id": "abc"}),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _estaSeleccionado ? (esModoOscuro ? Paleta.negro42 : Colors.grey[50]) : (esModoOscuro ? Paleta.negro30 : Colors.white),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: _estaSeleccionado ? 20 : 12, offset: const Offset(0, 6)),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                child: SvgPicture.asset(WG.getIconoTipo(widget.servicio.tipo), height: 60, width: 60),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.servicio.titulo.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: esModoOscuro ? Colors.white : Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.servicio.correo,
                    style: TextStyle(fontSize: 16, color: esModoOscuro ? Colors.grey[100] : Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
