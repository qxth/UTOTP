import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/paleta.dart';

enum DialogType { success, warning, error }

class DialogAlert extends StatefulWidget {
  final String? title;
  final String message;
  final VoidCallback? onConfirm;
  final DialogType type;
  final String titleButton;

  const DialogAlert({super.key, required this.type, required this.message, this.title, this.onConfirm, this.titleButton = "ACEPTAR"});
  @override
  DialogAlertState createState() => DialogAlertState();
}

class DialogAlertState extends State<DialogAlert> {
  Color get backgroundColor {
    switch (widget.type) {
      case DialogType.success:
        return Paleta.verde_oscuro2;
      case DialogType.warning:
        return Paleta.naranja_oscuro;
      case DialogType.error:
        return Paleta.rojo_oscuro;
    }
  }

  IconData get icon {
    switch (widget.type) {
      case DialogType.success:
        return Icons.check_rounded;
      case DialogType.warning:
        return Icons.warning_rounded;
      case DialogType.error:
        return Icons.close_rounded;
    }
  }

  Color get iconColor {
    switch (widget.type) {
      case DialogType.success:
        return Paleta.verde_claro2;
      case DialogType.warning:
        return Paleta.naranja_oscuro;
      case DialogType.error:
        return Paleta.rojo_oscuro;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Paleta.negro_claro, offset: Offset(5, 5), blurRadius: 8)],
            ),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.title != null)
                  Column(
                    children: [
                      Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                    ],
                  ),
                Text(widget.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onConfirm ?? Get.back,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor,
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.only(top: 10, bottom: 8),
                        ),
                        child: Text(
                          widget.titleButton,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white.withAlpha(200)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2), // color de la sombra
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3), // posición de la sombra
                  ),
                ],
              ),
              child: CircleAvatar(backgroundColor: Colors.white, radius: 30, child: Icon(icon, color: backgroundColor, size: 35)),
            ),
          ),
        ],
      ),
    );
  }
}

class DialogButton {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  DialogButton({required this.text, required this.onPressed, required this.color});
}
