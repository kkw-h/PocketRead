import 'dart:convert';
import 'dart:typed_data';

import 'package:charset/charset.dart';
import 'package:pocketread/features/importer/domain/txt_book.dart';

class TxtEncodingDecoder {
  const TxtEncodingDecoder();

  TxtDecodedContent decode(Uint8List bytes) {
    if (bytes.isEmpty) {
      return const TxtDecodedContent(text: '', charsetName: 'utf-8');
    }

    final _DecodeCandidate? bomCandidate = _decodeBom(bytes);
    if (bomCandidate != null) {
      return TxtDecodedContent(
        text: bomCandidate.text,
        charsetName: bomCandidate.charsetName,
      );
    }

    final List<_DecodeCandidate> candidates = <_DecodeCandidate?>[
      _tryDecode('utf-8', () => utf8.decode(bytes, allowMalformed: false)),
      _tryDecode('gbk', () => gbk.decode(bytes, allowMalformed: true)),
      _tryDecode('latin1', () => latin1.decode(bytes, allowInvalid: true)),
    ].whereType<_DecodeCandidate>().toList();

    if (candidates.isEmpty) {
      throw const TxtDecodeException('无法识别 TXT 编码');
    }

    candidates.sort((_DecodeCandidate a, _DecodeCandidate b) {
      return b.score.compareTo(a.score);
    });
    final _DecodeCandidate best = candidates.first;
    if (best.score < -100) {
      throw const TxtDecodeException('TXT 解码结果不可用');
    }
    return TxtDecodedContent(text: best.text, charsetName: best.charsetName);
  }

  _DecodeCandidate? _decodeBom(Uint8List bytes) {
    if (_startsWith(bytes, <int>[0xEF, 0xBB, 0xBF])) {
      return _DecodeCandidate(
        charsetName: 'utf-8',
        text: utf8.decode(bytes.sublist(3), allowMalformed: false),
      );
    }
    if (_startsWith(bytes, <int>[0xFF, 0xFE])) {
      return _DecodeCandidate(
        charsetName: 'utf-16le',
        text: const Utf16Decoder().decodeUtf16Le(
          bytes.sublist(2),
          0,
          null,
          true,
        ),
      );
    }
    if (_startsWith(bytes, <int>[0xFE, 0xFF])) {
      return _DecodeCandidate(
        charsetName: 'utf-16be',
        text: const Utf16Decoder().decodeUtf16Be(
          bytes.sublist(2),
          0,
          null,
          true,
        ),
      );
    }
    return null;
  }

  bool _startsWith(Uint8List bytes, List<int> prefix) {
    if (bytes.length < prefix.length) {
      return false;
    }
    for (int index = 0; index < prefix.length; index += 1) {
      if (bytes[index] != prefix[index]) {
        return false;
      }
    }
    return true;
  }

  _DecodeCandidate? _tryDecode(String charsetName, String Function() decode) {
    try {
      return _DecodeCandidate(charsetName: charsetName, text: decode());
    } on FormatException {
      return null;
    }
  }
}

class _DecodeCandidate {
  _DecodeCandidate({required this.charsetName, required this.text})
    : score = _score(text);

  final String charsetName;
  final String text;
  final int score;

  static int _score(String text) {
    int chineseCount = 0;
    int replacementCount = 0;
    int controlCount = 0;
    int latin1MojibakeCount = 0;
    final int sampleLength = text.length > 5000 ? 5000 : text.length;

    for (int index = 0; index < sampleLength; index += 1) {
      final int codeUnit = text.codeUnitAt(index);
      if (codeUnit >= 0x4E00 && codeUnit <= 0x9FFF) {
        chineseCount += 1;
      }
      if (codeUnit == 0xFFFD) {
        replacementCount += 1;
      }
      if (codeUnit < 0x20 &&
          codeUnit != 0x09 &&
          codeUnit != 0x0A &&
          codeUnit != 0x0D) {
        controlCount += 1;
      }
      if (codeUnit >= 0x00C0 && codeUnit <= 0x00FF) {
        latin1MojibakeCount += 1;
      }
    }

    return chineseCount * 4 -
        replacementCount * 20 -
        controlCount * 10 -
        latin1MojibakeCount * 2;
  }
}
