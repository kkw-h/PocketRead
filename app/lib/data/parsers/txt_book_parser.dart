import 'dart:io';
import 'dart:typed_data';

import 'package:pocketread/data/parsers/txt_chapter_splitter.dart';
import 'package:pocketread/data/parsers/txt_encoding_decoder.dart';
import 'package:pocketread/data/parsers/txt_text_normalizer.dart';
import 'package:pocketread/features/importer/domain/txt_book.dart';

class TxtBookParser {
  const TxtBookParser({
    required TxtEncodingDecoder decoder,
    required TxtTextNormalizer normalizer,
    required TxtChapterSplitter chapterSplitter,
  }) : _decoder = decoder,
       _normalizer = normalizer,
       _chapterSplitter = chapterSplitter;

  final TxtEncodingDecoder _decoder;
  final TxtTextNormalizer _normalizer;
  final TxtChapterSplitter _chapterSplitter;

  Future<TxtParsedBook> parseFile(File file) async {
    final Uint8List bytes = await file.readAsBytes();
    final TxtDecodedContent decoded = _decoder.decode(bytes);
    final String normalizedText = _normalizer.normalize(decoded.text);
    final List<TxtChapter> chapters = _chapterSplitter.split(normalizedText);

    return TxtParsedBook(
      charsetName: decoded.charsetName,
      normalizedText: normalizedText,
      chapters: chapters,
      totalWords: _normalizer.countReadableChars(normalizedText),
    );
  }
}
