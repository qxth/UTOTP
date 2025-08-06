String labelTiempo(int segundosActual) {
  if (segundosActual < 60) {
    return '${segundosActual.toInt()}s';
  }
  final int m = segundosActual ~/ 60;
  final int s = segundosActual % 60;
  if (s == 0) {
    return '${m}m';
  }
  return '${m}m ${s}s';
}
