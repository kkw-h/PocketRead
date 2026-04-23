class TxtTextNormalizer {
  const TxtTextNormalizer();

  String normalize(String input) {
    return input
        .replaceAll('\uFEFF', '')
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F]'), '')
        .replaceAll(RegExp(r'[ \t]+\n'), '\n')
        .replaceAll(RegExp(r'\n{4,}'), '\n\n\n')
        .trim();
  }

  int countReadableChars(String input) {
    return input.replaceAll(RegExp(r'\s+'), '').length;
  }
}
