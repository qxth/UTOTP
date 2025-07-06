import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/paleta.dart';

class DialogCustom extends StatefulWidget {
  final String title;
  final List<String> categories;
  final Color buttonColor;
  final Color buttonTextColor;
  final void Function(String category, String task) onSave;

  const DialogCustom({
    super.key,
    required this.title,
    required this.categories,
    required this.onSave,
    this.buttonColor = Paleta.azul_noche,
    this.buttonTextColor = Paleta.gris_240,
  });

  @override
  DialogCustomState createState() => DialogCustomState();
}

class DialogCustomState extends State<DialogCustom> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  String _task = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Paleta.gris_240,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Paleta.negro_suave_0_025, offset: Offset(6, 6), spreadRadius: 2, blurRadius: 4)],
          ),
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.topRight, child: CloseButton(onPressed: () => Get.back())),
                Center(child: Text(widget.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600))),
                const SizedBox(height: 16),

                // Label Categoria
                const Text("Categorías", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                // Dropdown Categorías
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Paleta.gris_240,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Paleta.gris_medio_189),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(border: InputBorder.none),
                    isExpanded: true,
                    items: widget.categories.map((category) => DropdownMenuItem<String>(value: category, child: Text(category))).toList(),
                    onChanged: (value) => setState(() => _category = value),
                    validator: (value) => value == null ? 'Por favor selecciona una categoría' : null,
                  ),
                ),

                const SizedBox(height: 16),

                // Label Tarea
                const Text("Tarea", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                // Input tarea
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Paleta.gris_240,
                  ),
                  onChanged: (value) => _task = value,
                  validator: (value) => value == null || value.isEmpty ? 'Por favor ingresa una tarea' : null,
                ),

                const SizedBox(height: 20),

                // Botón Guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSave(_category!, _task);
                        Get.back();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(widget.buttonColor),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    ),
                    child: Text('Listo', style: TextStyle(color: widget.buttonTextColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
