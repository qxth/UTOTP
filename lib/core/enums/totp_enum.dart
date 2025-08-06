import 'package:crypto/crypto.dart';

enum TOTPAlgorithm {
  sha_1(value: sha1, title: 'sha-1'),
  sha_256(value: sha256, title: 'sha-256'),
  sha_384(value: sha384, title: 'sha-384'),
  sha_512(value: sha512, title: 'sha-512');

  final Hash value;
  final String title;

  const TOTPAlgorithm({required this.value, required this.title});
}

enum TOTPEncoding {
  hex('hex'),
  ascii('ascii');

  final String value;

  const TOTPEncoding(this.value);
}
