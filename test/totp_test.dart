import 'package:flutter/cupertino.dart';
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

    void recurseTest(TotpTest ot, {bool isLog = false}) {
      final amPm = ot.hour < 12 ? 'am' : 'pm';
      test('${ot.hour}:${ot.min}:${ot.sec} $amPm (${ot.period} seg)', () async {
        final fecha = DateTime(y, m, d, ot.hour, ot.min, ot.sec);
        final r = await Totp.generate(keySecret, digits: ot.digits, period: ot.period, timestamp: fecha);

        expect(r.otp.length, ot.digits);
        expect(r.expires.year, ot.rYear ?? y);
        expect(r.expires.month, ot.rMonth ?? m);
        expect(r.expires.day, ot.rDay ?? d);

        expect(r.expires.hour, ot.rHour ?? ot.hour);
        expect(r.expires.minute, ot.rMin ?? ot.min);
        expect(r.expires.second, ot.rSec ?? ot.sec);
        if (isLog) {
          debugPrint('Hora\t: $fecha');
          debugPrint('Expira\t: ${r.expires}');
        }
      });
    }

    final List<TotpTest> dicTests = [
      TotpTest(hour: 6, min: 30, sec: 30, period: 15, rSec: 45),
      TotpTest(hour: 6, min: 30, sec: 30, period: 30, rMin: 31, rSec: 0),
      /**
       * # Nota
       * > Esta hora es importante, se define de la siguiente forma
       * period: 15 segundos
       * 6:59:59 am con 15 segundos de expiracion
       * Al dividir 60/15 = 4 lo que significa que cuando sean las 6:59:59 am el otp expira a las
       * 7:00:00 am ya que los 15 segundos de expiracion se reinician en un intervalo divisile para 60 segundos
       * Es decir que 15 segundos de expiracion se repiten 4 veces en 60 segundos y luego vuelve a reiniciarse el bucle
       * Por lo que al ser las 6:59:59 am faltaria 1 segundo para completar los 15 segundos de expiracion del cuarto ciclo (4 de 60)
       * 4 * 15 = 60
       */
      TotpTest(hour: 6, min: 59, sec: 59, period: 15, rHour: 7, rMin: 0, rSec: 0),
      TotpTest(hour: 7, min: 0, sec: 0, period: 15, rSec: 15),
      TotpTest(hour: 7, min: 0, sec: 0, period: 1, rSec: 1),
      TotpTest(hour: 11, min: 30, sec: 30, period: 30, rMin: 31, rSec: 0),
      TotpTest(hour: 11, min: 59, sec: 59, period: 1, rHour: 12, rMin: 0, rSec: 0),
      TotpTest(hour: 12, min: 0, sec: 0, period: 1, rSec: 1),
      TotpTest(hour: 18, min: 30, sec: 30, period: 30, rMin: 31, rSec: 0),
      TotpTest(hour: 18, min: 0, sec: 0, period: 300, rMin: 5),
      TotpTest(hour: 23, min: 59, sec: 59, period: 1, rYear: y + 1, rMonth: 1, rDay: 1, rHour: 0, rMin: 0, rSec: 0),
    ];

    for (var params in dicTests) {
      recurseTest(params, isLog: true);
    }
  });
}

class TotpTest {
  final int hour;
  final int min;
  final int sec;
  final int period;
  final int digits;

  final int? rYear;
  final int? rMonth;
  final int? rDay;
  final int? rHour;
  final int? rMin;
  final int? rSec;

  TotpTest({
    required this.hour,
    required this.min,
    required this.sec,
    required this.period,
    this.digits = 6,
    this.rYear,
    this.rMonth,
    this.rDay,
    this.rHour,
    this.rMin,
    this.rSec,
  });
}
