import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/parsers/txt_book_parser.dart';
import 'package:pocketread/data/parsers/txt_chapter_splitter.dart';
import 'package:pocketread/data/parsers/txt_encoding_decoder.dart';
import 'package:pocketread/data/parsers/txt_text_normalizer.dart';
import 'package:pocketread/features/importer/domain/txt_book.dart';

void main() {
  test('decodes and splits root Tang Zhuan txt sample', () async {
    final File sample = File('../《唐砖》（精校版全本）作者：孑与2.txt');
    expect(await sample.exists(), isTrue);

    const TxtBookParser parser = TxtBookParser(
      decoder: TxtEncodingDecoder(),
      normalizer: TxtTextNormalizer(),
      chapterSplitter: TxtChapterSplitter(),
    );
    final TxtParsedBook parsed = await parser.parseFile(sample);

    expect(parsed.charsetName, 'gbk');
    expect(parsed.normalizedText, contains('唐砖'));
    expect(parsed.chapters.length, greaterThan(100));
    expect(parsed.totalWords, greaterThan(1000000));
  });
}
