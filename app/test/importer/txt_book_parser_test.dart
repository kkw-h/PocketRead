import 'dart:io';
import 'dart:typed_data';

import 'package:charset/charset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/parsers/txt_book_parser.dart';
import 'package:pocketread/data/parsers/txt_chapter_splitter.dart';
import 'package:pocketread/data/parsers/txt_encoding_decoder.dart';
import 'package:pocketread/data/parsers/txt_text_normalizer.dart';
import 'package:pocketread/features/importer/domain/txt_book.dart';

void main() {
  const TxtEncodingDecoder decoder = TxtEncodingDecoder();
  const TxtTextNormalizer normalizer = TxtTextNormalizer();
  const TxtChapterSplitter splitter = TxtChapterSplitter();
  const TxtBookParser parser = TxtBookParser(
    decoder: decoder,
    normalizer: normalizer,
    chapterSplitter: splitter,
  );

  test('decodes gbk txt content', () {
    final Uint8List bytes = Uint8List.fromList(gbk.encode('唐砖\n第一章 测试'));

    final TxtDecodedContent decoded = decoder.decode(bytes);

    expect(decoded.charsetName, 'gbk');
    expect(decoded.text, contains('唐砖'));
  });

  test('normalizes line endings and extra blank lines', () {
    final String normalized = normalizer.normalize(
      '第一章 测试\r\n\r\n\r\n\r\n正文\t \r\n',
    );

    expect(normalized, '第一章 测试\n\n\n正文');
  });

  test('splits chapter headings', () {
    const String text = '简介\n\n第一章 测试\n正文1\n\n第二章 继续\n正文2';

    final List<TxtChapter> chapters = splitter.split(text);

    expect(chapters, hasLength(3));
    expect(chapters[0].title, '序章');
    expect(chapters[1].title, '第一章 测试');
    expect(chapters[2].title, '第二章 继续');
  });

  test('parses txt file end to end', () async {
    final Directory tempDir = await Directory.systemTemp.createTemp(
      'pocketread_txt_test',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final File file = File('${tempDir.path}/book.txt');
    await file.writeAsBytes(gbk.encode('第一章 测试\r\n正文\r\n\r\n第二章 继续\r\n正文2'));

    final TxtParsedBook parsed = await parser.parseFile(file);

    expect(parsed.charsetName, 'gbk');
    expect(parsed.chapters, hasLength(2));
    expect(parsed.totalWords, greaterThan(0));
    expect(parsed.normalizedText, isNot(contains('\r')));
  });
}
