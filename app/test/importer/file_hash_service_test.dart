import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/services/file_hash_service.dart';

void main() {
  test('calculates stable sha256 for file content', () async {
    final Directory tempDir = await Directory.systemTemp.createTemp(
      'pocketread_hash_test',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final File file = File('${tempDir.path}/book.txt');
    await file.writeAsString('PocketRead');

    const FileHashService service = FileHashService();
    final String hash = await service.sha256OfFile(file);

    expect(
      hash,
      '5d69dba64cd899cb13764aa58e01a096ad9e026458bbf9d1b65ef63b78793511',
    );
  });
}
