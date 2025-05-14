import 'package:crypto/crypto.dart';

enum TOTPAlgorithm {
  sha_1(sha1),
  sha_256(sha256),
  sha_384(sha384),
  sha_512(sha512);

  const TOTPAlgorithm(this.value);
  final Hash value;
}

enum TOTPEncoding {
  hex('hex'),
  ascii('ascii');

  const TOTPEncoding(this.value);
  final String value;
}
