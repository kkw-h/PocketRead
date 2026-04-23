import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

class FileHashService {
  const FileHashService();

  Future<String> sha256OfFile(File file) async {
    final Digest digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  String compactId(String input) {
    return sha1.convert(utf8.encode(input)).toString();
  }
}
