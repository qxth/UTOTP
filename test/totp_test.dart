import 'package:flutter_test/flutter_test.dart';
import 'package:totp_unix/core/enums/totp_enum.dart';

void main() async {
  group("Enums", () {
    test("TOTPAlgorithm", () {
      for (var item in TOTPAlgorithm.values) {
        var keyValue = item.name.toUpperCase().replaceFirst('_', '-');
        expect(keyValue, item.value);
      }
    });

    test("TOTPEncoding", () {
      for (var item in TOTPEncoding.values) {
        expect(item.name, item.value);
      }
    });
  });
}
