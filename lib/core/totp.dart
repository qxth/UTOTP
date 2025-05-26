import 'dart:typed_data';
import 'enums/totp_enum.dart';
import 'package:crypto/crypto.dart';

/**
 *
 * # Referencias
 * Implementacion basada en https://github.com/bellstrand/totp-generator
 *
 */

/// La clase proporciona codigos temporales que se utilizan comunmente para autenticacion
/// de dos factores (2FA).
class Totp {
  /// Genera un codigo TOTP con una clave secreta.
  ///
  /// Parametros:
  /// - [key]: Clave secreta para generar el TOTP.
  /// - [digits]: Numero de digitos del codigo. Predeterminado es 6.
  /// - [algorithm]: Algoritmo de hash. Predeterminado es `sha_1`.
  /// - [encoding]: Codificacion de la clave. Predeterminado es `hex`.
  /// - [period]: Duracion de validez del codigo en segundos. Predeterminado es 30 seg.
  /// - [timestamp]: Fecha y hora de generacion. Si no se especifica, usa la actual.
  ///
  /// Retorna un [Future] con un [TotpResult] que contiene:
  /// - [otp]: El codigo OTP generado.
  /// - [expires]: Tiempo hasta la expiracion del codigo.
  static Future<TotpResult> generate(
    String key, {
    int digits = 6,
    TOTPAlgorithm algorithm = TOTPAlgorithm.sha_1,
    TOTPEncoding encoding = TOTPEncoding.hex,
    int period = 30,
    DateTime? timestamp,
  }) async {
    timestamp ??= DateTime.now();

    final int epochSeconds = (timestamp.millisecondsSinceEpoch / Duration.millisecondsPerSecond).floor();
    final String timeHex = _decToHex((epochSeconds / period).floor()).padLeft(16, "0");
    final Uint8List keyBuffer = encoding == TOTPEncoding.hex ? _base32To8List(key) : _asciiTo8List(key);

    final Hmac hmacKey = Hmac(algorithm.value, keyBuffer);
    final Digest signature = hmacKey.convert(_hexTo8List(timeHex));

    final String signatureHex = _bytesToHex(signature.bytes);
    final int offset = _hexToDec(signatureHex.substring(signatureHex.length - 1)) * 2;

    final int masked = _hexToDec(signatureHex.substring(offset, offset + 8)) & 0x7fffffff;
    final String maskedStr = masked.toString();
    final String otp = maskedStr.substring(maskedStr.length - digits);
    final int msLimitPeriod = period * Duration.millisecondsPerSecond;

    final expires = ((timestamp.millisecondsSinceEpoch + 1) / msLimitPeriod).ceil() * msLimitPeriod;

    return TotpResult(otp, DateTime.fromMillisecondsSinceEpoch(expires));
  }

  static String _decToHex(int dec) {
    return (dec < 15.5 ? "0" : "") + dec.round().toRadixString(16);
  }

  static int _hexToDec(String hex) {
    return int.parse(hex, radix: 16);
  }

  static Uint8List _base32To8List(String str) {
    str = str.toUpperCase();
    int length = str.length;
    while (str.codeUnitAt(length - 1) == 61) {
      // Remove pads
      length--;
    }

    // Estimate buffer size
    final int bufferSize = ((length * 5) / 8).toInt();
    final buffer = Uint8List(bufferSize);
    int value = 0, bits = 0, index = 0;

    for (var i = 0; i < length; i++) {
      final int? charCode = _base32[str.codeUnitAt(i)];
      if (charCode == null) {
        throw Exception("Invalid base32 character in key");
      }
      value = (value << 5) | charCode;
      bits += 5;
      if (bits >= 8) {
        buffer[index++] = value >>> (bits -= 8);
      }
    }

    return buffer;
  }

  static Uint8List _asciiTo8List(String str) {
    final buffer = Uint8List(str.length);
    for (var i = 0; i < str.length; i++) {
      buffer[i] = str.codeUnitAt(i);
    }
    return buffer;
  }

  static Uint8List _hexTo8List(String hex) {
    final buffer = Uint8List((hex.length / 2).toInt());
    for (var i = 0, j = 0; i < hex.length; i += 2, j++) {
      buffer[j] = _hexToDec(hex.substring(i, i + 2));
    }
    return buffer;
  }

  static String _bytesToHex(List<int> bytes) {
    return [...bytes].map((x) => x.toRadixString(16).padLeft(2, "0")).join("");
  }

  static const Map<int, int> _base32 = {
    50: 26,
    51: 27,
    52: 28,
    53: 29,
    54: 30,
    55: 31,
    65: 0,
    66: 1,
    67: 2,
    68: 3,
    69: 4,
    70: 5,
    71: 6,
    72: 7,
    73: 8,
    74: 9,
    75: 10,
    76: 11,
    77: 12,
    78: 13,
    79: 14,
    80: 15,
    81: 16,
    82: 17,
    83: 18,
    84: 19,
    85: 20,
    86: 21,
    87: 22,
    88: 23,
    89: 24,
    90: 25,
  };
}

class TotpResult {
  String otp;
  DateTime expires;

  TotpResult(this.otp, this.expires);

  @override
  String toString() {
    return 'OTP: $otp\n'
        'Expires: ${expires.toIso8601String()}';
  }
}
