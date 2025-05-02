import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

final exts = '_test.txt';
final name = 'temporizador';
File logFile = File('$name$exts');

void main() {
  group('Temporizador', () {
    List<DateTime> dateList = [];
    crearHoras(dateList);
    final desde = 0;
    final hasta = 60;
    final msMinuto = 1_000 * 60;

    group('Forma 1', () {
      for (var k = desde; k < hasta; k++) {
        final msTotal = msMinuto * k;
        test("con $k minutos", () {
          progreso(minutos: k, list: dateList, msTotal: msTotal, callProgreso: (now, msLimite) => forma1(now, msLimite));
        });
      }
    });

    /*
    group('Forma 2', () {
      for (var k = desde; k < hasta; k++) {
        final msTotal = msMinuto * k;
        test("con $k minutos", () {
          progreso(minutos: k, list: dateList, msTotal: msTotal, callProgreso: (now, msLimite) => forma2(now, msLimite));
        });
      }
    });
     // */

    group('Forma 3', () {
      for (var k = desde; k < hasta; k++) {
        final msTotal = msMinuto * k;
        test("con $k minutos", () {
          progreso(minutos: k, list: dateList, msTotal: msTotal, callProgreso: (now, msLimite) => forma3(now, msLimite));
        });
      }
    });

    /*
    test('test minutos', () {
      final minutos = 5;
      final msTotal = msMinuto * minutos;
      logFile = File('$name$minutos$exts');
      logFile.writeAsStringSync('Minutos: $minutos\n');
      progreso(
        minutos: minutos,
        list: dateList,
        msTotal: msTotal,
        callProgreso: (now, msLimite) => forma3(now, msLimite),
        loggerFile: true,
      );
    });
    // */

    /*
    test('fecha', () {
      final fechaBase = DateTime(2025, 04, 30, 0, 0, 0, 0, 0);
      final fecha = DateTime(2025, 04, 30, 0, 7, 0, 0, 0);
      debugPrint('Fecha Bs: $fechaBase');
      debugPrint('Fecha Ac: $fecha');
      debugPrint('Ms Epoch Bs: ${fechaBase.millisecondsSinceEpoch}');
      debugPrint('Ms Epoch Ac: ${fecha.millisecondsSinceEpoch}');
      debugPrint('Fecha Epoch: ${fecha.millisecondsSinceEpoch - fechaBase.millisecondsSinceEpoch}');

      debugPrint('Fecha Base desde Fecha Actual: ${DateTime(fecha.year, fecha.month, fecha.day).millisecondsSinceEpoch}');
    });
     // */

    test('division con resultado solo parte entera', () {
      var res = 70 ~/ 60;
      expect(res, 1);
    });
  });
}

void progreso({
  int minutos = 0,
  int segundos = 0,
  required List<DateTime> list,
  required int msTotal,
  required TProgreso Function(DateTime now, int msLimite) callProgreso,
  bool loggerFile = false,
}) {
  if (minutos == 0 && segundos == 0) {
    expect(minutos, 0);
    expect(segundos, 0);
    return;
  }

  expect(list.length, 86400);
  int milisegundosLimite =
      (Duration.millisecondsPerSecond * segundos) + (Duration.millisecondsPerSecond * Duration.secondsPerMinute * minutos);

  expect(milisegundosLimite, msTotal);

  late final int totalPorciento_0;
  late final int totalPorciento_99;

  final int fragmentoHora = (60 / minutos).toInt();

  if (60 % minutos == 0) {
    totalPorciento_0 = fragmentoHora * 24;
    totalPorciento_99 = totalPorciento_0;
  } else {
    totalPorciento_0 = (fragmentoHora + 1) * 24;
    totalPorciento_99 = fragmentoHora * 24;
  }

  int countPorciento_0 = 0;
  int countPorciento_99 = 0;

  for (DateTime now in list) {
    final int msDateTime =
        now.millisecond +
        (now.second * Duration.millisecondsPerSecond) +
        (now.minute * Duration.secondsPerMinute * Duration.millisecondsPerSecond);
    final double progresoDateTime = ((msDateTime * 100.0) / milisegundosLimite) % 100;

    TProgreso tp = callProgreso(now, milisegundosLimite);

    if (tp.totalMs % milisegundosLimite == 0) {
      countPorciento_0 += 1;
      expect(tp.progreso, 0);
    } else if (milisegundosLimite - (tp.totalMs % milisegundosLimite) == 1000) {
      countPorciento_99 += 1;
    }

    if (loggerFile) {
      logFile.writeAsStringSync(
        '${now.toIso8601String()} | ${tp.progreso.toStringAsFixed(2)} | ${progresoDateTime.toStringAsFixed(2)} > '
        '${tp.totalMs} % $milisegundosLimite = ${tp.totalMs % milisegundosLimite}'
        '\n',
        mode: FileMode.append,
      );
    }

    try {
      expect(tp.progreso.toStringAsPrecision(6), progresoDateTime.toStringAsPrecision(6));
      // expect(true, true);
    } catch (ex) {
      debugPrint('Minutos: $minutos');
      debugPrint('h: ${now.hour} | m: ${now.minute} | s: ${now.second} | ms: ${now.millisecond} | $msDateTime');
      debugPrint(now.toIso8601String());
      debugPrint('${tp.progreso} | $progresoDateTime');
      rethrow;
    }
  }

  expect(totalPorciento_0, countPorciento_0);
  expect(totalPorciento_99, countPorciento_99);
}

void crearHoras(List<DateTime> dateList) {
  DateTime baseDate = DateTime(2025, 4, 30, 0, 0, 0);

  int h = 0;
  int m = 0;
  int s = 0;

  while (h < 24) {
    DateTime newDate = baseDate.add(Duration(hours: h, minutes: m, seconds: s));
    dateList.add(newDate);
    s += 1;
    if (s == 60) {
      s = 0;
      m += 1;
    }
    if (m == 60) {
      m = 0;
      h += 1;
    }
  }
}

class TProgreso {
  final int totalMs;
  final double progreso;

  TProgreso({required int ms, required double pg}) : totalMs = ms, progreso = pg;
}

TProgreso forma1(DateTime now, int milisegundosLimite) {
  // # Forma 1
  var totalMs =
      now.millisecond +
      (now.second * Duration.millisecondsPerSecond) +
      (now.minute * Duration.secondsPerMinute * Duration.millisecondsPerSecond);
  final progreso = ((totalMs * 100.0) / milisegundosLimite) % 100;

  return TProgreso(ms: totalMs, pg: progreso);
}

TProgreso forma2(DateTime now, int milisegundosLimite) {
  // # Forma 2
  final totalMs = milisegundosLimite < 1 ? 0 : now.millisecondsSinceEpoch % milisegundosLimite;
  final progreso = (totalMs * 100.0) / milisegundosLimite;

  return TProgreso(ms: totalMs, pg: progreso);
}

TProgreso forma3(DateTime now, int milisegundosLimite) {
  // # Forma 3
  final totalMs = now.millisecondsSinceEpoch - DateTime(now.year, now.month, now.day, now.hour).millisecondsSinceEpoch;
  final progreso = ((totalMs * 100.0) / milisegundosLimite) % 100;

  return TProgreso(ms: totalMs, pg: progreso);
}
