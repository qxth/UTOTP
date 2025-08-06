import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/enums/servicio_enum.dart';

class Tarjeta extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final String? fontFamily;
  final EnumTipoServicio? servicio;

  const Tarjeta({super.key, this.text, this.servicio, this.fontSize, this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 3,
            children: [
              if (servicio != null) SvgPicture.asset(servicio!.icono, height: 26),
              Text(
                text ?? servicio?.name ?? 'None',
                style: TextStyle(
                  fontSize: fontSize ?? 23,
                  fontFamily: fontFamily ?? 'Courier',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
