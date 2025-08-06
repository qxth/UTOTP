import '../totp.dart';
import 'totp_enum.dart';

/// Servicios por defecto que tienen los mismos datos:
/// 6 digitos, 30 segundos, algorithm sha_1, encoding hex
/// + github
/// + google
///
/// Nota: Cada valor que se establece explicitamente no se puede editar en la UI.
enum EnumTipoServicio {
  // period: 120, encoding: TOTPEncoding.ascii, digits: 8, algorithm: TOTPAlgorithm.sha_512
  github(name: 'github', isDefaultAll: true),
  google(name: 'google', isDefaultAll: true),
  otro(name: 'otro', iconName: 'default_account');

  final String name;
  final String icono;

  final int? digits;
  final int? period;
  final TOTPAlgorithm? algorithm;
  final TOTPEncoding? encoding;
  final bool isDefaultAll;

  const EnumTipoServicio({
    required this.name,
    String? iconName,
    this.isDefaultAll = false,
    int? digits,
    int? period,
    TOTPAlgorithm? algorithm,
    TOTPEncoding? encoding,
  }) : icono = 'assets/svg/${iconName ?? name}.svg',
       digits = isDefaultAll ? defaultDigits : digits,
       period = isDefaultAll ? defaultPeriod : period,
       algorithm = isDefaultAll ? defaultAlgorithm : algorithm,
       encoding = isDefaultAll ? defaultEncoding : encoding;

  @override
  toString() {
    return {
      'name': name,
      'icono': icono,
      'digits': digits,
      'period': period,
      'algorithm': algorithm,
      'encoding': encoding,
      'isDefaultAll': isDefaultAll,
    }.toString();
  }
}
