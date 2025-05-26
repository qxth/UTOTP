import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/dialogs/dialog_custom.dart';
import '../ui/dialogs/dialog_simple.dart';
import '../ui/dialogs/dialog_alert.dart';
import '../controllers/inicio_controller.dart';
import '../ui/cuenta_tarjeta.dart';
import '../ui/utils/paleta.dart';

class InicioView extends GetView<InicioController> {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('> Render Inicio');

    return Scaffold(
      appBar: AppBar(
        title: Row(spacing: 15, children: [Icon(Icons.account_balance), const Text('Totp')]),
        backgroundColor: Paleta.azul_noche,
        foregroundColor: Paleta.gris_claro,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => DialogCustom(
                      title: 'Añadir tarea',
                      categories: ['Personal', 'Trabajo', 'Otro'],
                      buttonColor: Paleta.turquesa,
                      buttonTextColor: Paleta.gris_claro,
                      onSave: (category, task) {},
                    ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (BuildContext context) => DialogAlert(
                      title: 'Excelente',
                      message: 'Se ha procesado tu solicitud.',
                      type: DialogType.success,
                      onClose: () => Navigator.of(context).pop(),
                      onConfirm: () => Navigator.of(context).pop(),
                    ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.ac_unit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogSimple(
                    title: 'Escoja su opción',
                    options: [
                      DialogOption(
                        text: 'Opción X',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opción 1 seleccionada')));
                        },
                      ),
                      DialogOption(
                        text: 'Opción 2',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opción 2 seleccionada')));
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [for (var k = 0; k < 10; k++) CuentaTarjeta()],
          ),
        ),
      ),
    );
  }
}
