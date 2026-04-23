import 'package:pocketread/features/importer/domain/txt_book.dart';

class TxtChapterSplitter {
  const TxtChapterSplitter();

  static final RegExp _chapterHeadingPattern = RegExp(
    r'^\s*(第[一二三四五六七八九十百千万零〇两\d]+[章节卷集部篇回][^\n]{0,60}|序章|楔子|前言|后记|尾声)\s*$',
    multiLine: true,
  );

  List<TxtChapter> split(String text) {
    if (text.isEmpty) {
      return <TxtChapter>[
        const TxtChapter(
          index: 0,
          title: '正文',
          startOffset: 0,
          endOffset: 0,
          plainText: '',
          wordCount: 0,
        ),
      ];
    }

    final List<RegExpMatch> matches = _chapterHeadingPattern
        .allMatches(text)
        .toList();
    if (matches.isEmpty) {
      return <TxtChapter>[
        TxtChapter(
          index: 0,
          title: '正文',
          startOffset: 0,
          endOffset: text.length,
          plainText: text,
          wordCount: _countWords(text),
        ),
      ];
    }

    final List<TxtChapter> chapters = <TxtChapter>[];
    if (matches.first.start > 0) {
      final String preface = text.substring(0, matches.first.start).trim();
      if (preface.isNotEmpty) {
        chapters.add(
          TxtChapter(
            index: chapters.length,
            title: '序章',
            startOffset: 0,
            endOffset: matches.first.start,
            plainText: preface,
            wordCount: _countWords(preface),
          ),
        );
      }
    }

    for (int index = 0; index < matches.length; index += 1) {
      final RegExpMatch match = matches[index];
      final int endOffset = index + 1 < matches.length
          ? matches[index + 1].start
          : text.length;
      final String title = match.group(0)?.trim() ?? '第${chapters.length + 1}章';
      final String plainText = text.substring(match.start, endOffset).trim();
      chapters.add(
        TxtChapter(
          index: chapters.length,
          title: title,
          startOffset: match.start,
          endOffset: endOffset,
          plainText: plainText,
          wordCount: _countWords(plainText),
        ),
      );
    }

    return chapters;
  }

  int _countWords(String text) {
    return text.replaceAll(RegExp(r'\s+'), '').length;
  }
}
