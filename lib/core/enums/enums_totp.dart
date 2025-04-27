enum TOTPAlgorithm {
  sha_1('SHA-1'),
  sha_256('SHA-256'),
  sha_384('SHA-384'),
  sha_512('SHA-512');

  const TOTPAlgorithm(this.value);
  final String value;
}

enum TOTPEncoding {
  hex('hex'),
  ascii('ascii');

  const TOTPEncoding(this.value);
  final String value;
}
