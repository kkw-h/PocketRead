import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/parsers/book_file_metadata_parser.dart';
import 'package:pocketread/features/importer/domain/book_file_format.dart';

void main() {
  const BookFileMetadataParser parser = BookFileMetadataParser();

  test('detects txt format and extracts title author from filename', () {
    final BookFileMetadata metadata = parser.parse(
      '/tmp/《唐砖》（精校版全本）作者：孑与2.txt',
    );

    expect(metadata.format, BookFileFormat.txt);
    expect(metadata.fileExt, 'txt');
    expect(metadata.title, '唐砖');
    expect(metadata.author, '孑与2');
  });

  test('detects epub format from extension', () {
    final BookFileMetadata metadata = parser.parse('/tmp/电影教师_青城无忌.epub');

    expect(metadata.format, BookFileFormat.epub);
    expect(metadata.fileExt, 'epub');
    expect(metadata.title, '电影教师_青城无忌');
  });

  test('rejects unsupported formats', () {
    expect(
      () => parser.parse('/tmp/book.pdf'),
      throwsA(isA<UnsupportedBookFormatException>()),
    );
  });
}
