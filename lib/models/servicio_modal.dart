enum EnumServicio { idServicio, titulo, correo, tipo, clave_totp }

enum EnumTipoServicio { github, otro }

class ServicioModal {
  final EnumTipoServicio tipo;
  final String correo;
  final String titulo;
  final String idServicio;
  final String claveTotp;

  ServicioModal({required this.tipo, required this.correo, required this.titulo, required this.idServicio, required this.claveTotp});

  factory ServicioModal.fromJson(Map<String, dynamic> json) {
    return ServicioModal(
      tipo: _parseTipoServicio(json[EnumServicio.tipo.name]),
      correo: json[EnumServicio.correo.name] ?? '',
      titulo: json[EnumServicio.titulo.name] ?? '',
      idServicio: json[EnumServicio.idServicio.name] ?? '',
      claveTotp: json[EnumServicio.clave_totp.name] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      EnumServicio.tipo.name: tipo.name,
      EnumServicio.correo.name: correo,
      EnumServicio.titulo.name: titulo,
      EnumServicio.idServicio.name: idServicio,
      EnumServicio.clave_totp.name: claveTotp,
    };
  }

  static EnumTipoServicio _parseTipoServicio(String? value) {
    return EnumTipoServicio.values.firstWhere((e) => e.name == value, orElse: () => EnumTipoServicio.otro);
  }

  @override
  String toString() {
    return 'Servicio(idServicio: $idServicio, tipo: $tipo, correo: $correo, titulo: $titulo)';
  }
}
