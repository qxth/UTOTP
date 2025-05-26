import 'package:flutter/material.dart';
import '../utils/paleta.dart';

enum DialogType { success, warning, error }

class DialogAlert extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onClose;
  final VoidCallback onConfirm;
  final DialogType type;

  const DialogAlert({
    super.key,
    required this.title,
    required this.message,
    required this.onClose,
    required this.onConfirm,
    required this.type,
  });
  @override
  DialogAlertState createState() => DialogAlertState();
}

class DialogAlertState extends State<DialogAlert> {
  Color get backgroundColor {
    switch (widget.type) {
      case DialogType.success:
        return Paleta.verde_claro;
      case DialogType.warning:
        return Paleta.naranja_claro;
      case DialogType.error:
        return Paleta.rosa_claro;
    }
  }

  IconData get icon {
    switch (widget.type) {
      case DialogType.success:
        return Icons.check;
      case DialogType.warning:
        return Icons.warning;
      case DialogType.error:
        return Icons.close;
    }
  }

  Color get iconColor {
    switch (widget.type) {
      case DialogType.success:
        return Paleta.verde_oscuro;
      case DialogType.warning:
        return Paleta.naranja_oscuro;
      case DialogType.error:
        return Paleta.rosa_oscuro;
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
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Paleta.negro_claro, offset: Offset(5, 5), blurRadius: 8)],
            ),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(widget.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Paleta.gris_claro,
                          foregroundColor: Paleta.negro30,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Aceptar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            child: CircleAvatar(backgroundColor: Paleta.gris_claro, radius: 30, child: Icon(icon, color: iconColor, size: 30)),
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
