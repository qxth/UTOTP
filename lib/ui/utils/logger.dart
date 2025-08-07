import 'package:flutter/foundation.dart';

void logger(Object? data) {
  if (kDebugMode) {
    print(data);
  }
}
