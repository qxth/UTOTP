import 'package:flutter_test/flutter_test.dart';
import 'package:totp_unix/core/enums/totp_enum.dart';
import 'package:totp_unix/core/totp.dart';

void main() {
  group("Enums", () {
    test("TOTPAlgorithm", () {
      for (var item in TOTPAlgorithm.values) {
        String valueStr = item.value.toString();
        int index = valueStr.indexOf('_') + 1;
        String nameClassValue = valueStr.substring(index, valueStr.length - 1).toLowerCase();
        final keyValue = item.name.replaceFirst('_', '');

        expect(keyValue, nameClassValue);
      }
    });

    test("TOTPEncoding", () {
      for (var item in TOTPEncoding.values) {
        expect(item.name, item.value);
      }
    });
  });

  group("TOTP Generar", () {
    final now = DateTime.now();
    final y = now.year, m = 12, d = 31;
    final keySecret = 'ABCDEFGHIJK';

    test("6:30:30 am con 30 seg", () async {
      final hour = 6, min = 30, sec = 30;
      final fecha = DateTime(y, m, d, hour, min, sec);
      final r = await Totp.generate(keySecret, digits: 6, period: 30, timestamp: fecha);

      expect(r.otp.length, 6);
      expect(r.expires.year, y);
      expect(r.expires.month, m);
      expect(r.expires.day, d);

      expect(r.expires.hour, hour);
      expect(r.expires.minute, min + 1);
      expect(r.expires.second, 0);
    });

    test("6:30:30 am con 15 seg", () async {
      final hour = 6, min = 30, sec = 30;
      final fecha = DateTime(y, m, d, hour, min, sec);
      final r = await Totp.generate(keySecret, digits: 6, period: 15, timestamp: fecha);

      expect(r.otp.length, 6);
      expect(r.expires.year, y);
      expect(r.expires.month, m);
      expect(r.expires.day, d);

      expect(r.expires.hour, hour);
      expect(r.expires.minute, min);
      expect(r.expires.second, min + 15);
    });

    test("6:59:59 am con 15 seg", () async {
      final hour = 6, min = 59, sec = 59;
      final fecha = DateTime(y, m, d, hour, min, sec);
      final r = await Totp.generate(keySecret, digits: 6, period: 15, timestamp: fecha);

      expect(r.otp.length, 6);
      expect(r.expires.year, y);
      expect(r.expires.month, m);
      expect(r.expires.day, d);

      expect(r.expires.hour, hour + 1);
      expect(r.expires.minute, 0);
      expect(r.expires.second, 0);
    });

    test("7:00:00 am con 15 seg", () async {
      final hour = 6, min = 59, sec = 60;
      final fecha = DateTime(y, m, d, hour, min, sec);
      final r = await Totp.generate(keySecret, digits: 6, period: 15, timestamp: fecha);

      expect(r.otp.length, 6);
      expect(r.expires.year, y);
      expect(r.expires.month, m);
      expect(r.expires.day, d);

      expect(r.expires.hour, hour + 1);
      expect(r.expires.minute, 0);
      expect(r.expires.second, 15);
    });

    test("7:00:00 am con 1 seg", () async {
      final hour = 7, min = 0, sec = 0;
      final fecha = DateTime(y, m, d, hour, min, sec);
      final r = await Totp.generate(keySecret, digits: 6, period: 1, timestamp: fecha);

      expect(r.otp.length, 6);
      expect(r.expires.year, y);
      expect(r.expires.month, m);
      expect(r.expires.day, d);

      expect(r.expires.hour, hour);
      expect(r.expires.minute, 0);
      expect(r.expires.second, sec + 1);
    });

    test("18:30:30 am con 30 seg", () async {
      final hour = 18, min = 30, sec = 30;
      final fecha = DateTime(y, m, d, hour, min, sec);
      final r = await Totp.generate(keySecret, digits: 6, period: 30, timestamp: fecha);

      expect(r.otp.length, 6);
      expect(r.expires.year, y);
      expect(r.expires.month, m);
      expect(r.expires.day, d);

      expect(r.expires.hour, hour);
      expect(r.expires.minute, min + 1);
      expect(r.expires.second, 0);
    });
  });
}
