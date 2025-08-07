import '../core/enums/servicio_enum.dart';
import '../core/enums/totp_enum.dart';
import '../core/totp.dart';

enum EnumServicio { idServicio, titulo, correo, tipo, clave, digitos, periodo, algoritmo, codificacion }

class ServicioModal {
  final EnumTipoServicio defectoServicio;
  final String correo;
  final String titulo;
  final String idServicio;

  final int digitos;
  final int periodo;
  final TOTPAlgorithm algoritmo;
  final TOTPEncoding codificacion;
  final String clave;

  ServicioModal({
    required this.defectoServicio,
    required this.correo,
    required this.titulo,
    required this.idServicio,
    required this.clave,
    required this.digitos,
    required this.periodo,
    required this.algoritmo,
    required this.codificacion,
  });

  factory ServicioModal.fromJson(Map<String, dynamic> json) {
    final defectoServicio = _parseTipoServicio(json[EnumServicio.tipo.name]);

    return ServicioModal(
      defectoServicio: defectoServicio,
      correo: json[EnumServicio.correo.name] ?? '',
      titulo: json[EnumServicio.titulo.name] ?? '',
      idServicio: json[EnumServicio.idServicio.name] ?? '',
      clave: json[EnumServicio.clave.name] ?? '',
      algoritmo: _parseAlgoritmo(json[EnumServicio.algoritmo.name], defectoServicio),
      codificacion: _parseCodificacion(json[EnumServicio.codificacion.name], defectoServicio),
      digitos: json[EnumServicio.digitos.name] ?? defectoServicio.digits ?? defaultDigits,
      periodo: json[EnumServicio.periodo.name] ?? defectoServicio.period ?? defaultPeriod,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      EnumServicio.tipo.name: defectoServicio.name,
      EnumServicio.correo.name: correo,
      EnumServicio.titulo.name: titulo,
      EnumServicio.idServicio.name: idServicio,
      EnumServicio.clave.name: clave,
    };

    if (defectoServicio.algorithm == null) {
      data[EnumServicio.algoritmo.name] = algoritmo.name;
    }

    if (defectoServicio.encoding == null) {
      data[EnumServicio.codificacion.name] = codificacion.name;
    }

    if (defectoServicio.digits == null) {
      data[EnumServicio.digitos.name] = digitos;
    }

    if (defectoServicio.period == null) {
      data[EnumServicio.periodo.name] = periodo;
    }

    return data;
  }

  static EnumTipoServicio _parseTipoServicio(String? value) {
    return EnumTipoServicio.values.firstWhere((e) => e.name == value, orElse: () => EnumTipoServicio.otro);
  }

  static TOTPAlgorithm _parseAlgoritmo(String? value, EnumTipoServicio defectoServicio) {
    return TOTPAlgorithm.values.firstWhere((e) => e.name == value, orElse: () => defectoServicio.algorithm ?? defaultAlgorithm);
  }

  static TOTPEncoding _parseCodificacion(String? value, EnumTipoServicio defectoServicio) {
    return TOTPEncoding.values.firstWhere((e) => e.name == value, orElse: () => defectoServicio.encoding ?? defaultEncoding);
  }

  @override
  String toString() {
    return {
      'defaultServicio': defectoServicio,
      'correo': correo,
      'titulo': titulo,
      'idServicio': idServicio,
      'digitos': digitos,
      'periodo': periodo,
      'algoritmo': algoritmo,
      'codificacion': codificacion,
    }.entries.map((e) => '${e.key}: ${e.value}').join(' | ');
  }
}
