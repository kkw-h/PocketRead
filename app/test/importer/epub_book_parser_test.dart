import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/parsers/epub_book_parser.dart';
import 'package:pocketread/features/importer/domain/epub_book.dart';

void main() {
  test('parses root epub sample metadata cover and chapters', () async {
    final File sample = File('../电影教师_青城无忌.epub');
    expect(await sample.exists(), isTrue);

    const EpubBookParser parser = EpubBookParser();
    final EpubParsedBook parsed = await parser.parseFile(sample);

    expect(parsed.title, '电影教师');
    expect(parsed.author, '青城无忌');
    expect(parsed.language, 'zh');
    expect(parsed.cover, isNotNull);
    expect(parsed.cover!.bytes.length, greaterThan(10000));
    expect(parsed.chapters.length, greaterThan(100));
    expect(parsed.chapters.first.title, '制作信息');
    expect(
      parsed.chapters.any(
        (EpubChapter chapter) => chapter.title == '第1章 我成老师了',
      ),
      isTrue,
    );
    expect(
      parsed.chapters
          .firstWhere((EpubChapter chapter) => chapter.title == '第1章 我成老师了')
          .htmlContent,
      contains('<h3>'),
    );
  });
}
