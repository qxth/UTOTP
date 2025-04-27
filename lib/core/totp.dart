//export type TOTPAlgorithm = "SHA-1" | "SHA-256" | "SHA-384" | "SHA-512"
//export type TOTPEncoding = "hex" | "ascii"
import 'package:flutter/material.dart';

enum TOTPAlgorithm {
  value(
    sha_1: 'SHA-1',
    sha_256: 'SHA-256',
    sha_384: 'SHA-384',
    sha_512: 'SHA-512',
  );

  final String sha_1;
  final String sha_256;
  final String sha_384;
  final String sha_512;
  const TOTPAlgorithm({
    required this.sha_1,
    required this.sha_256,
    required this.sha_384,
    required this.sha_512,
  });
}

enum TOTPEncoding {
  value(hex: 'hex', ascii: 'ascii');

  final String hex;
  final String ascii;
  const TOTPEncoding({required this.hex, required this.ascii});
}

enum Ejemplo { a, b, c, d, e }

void main() {
  for (var x in Ejemplo.values) {
    debugPrint('Key: ${x.name}');
  }

  return;