// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) =>
    ReadingProgress(
      bookId: json['bookId'] as String,
      chapterIndex: (json['chapterIndex'] as num).toInt(),
      cfi: json['cfi'] as String?,
      anchorText: json['anchorText'] as String?,
      percentage: (json['percentage'] as num).toDouble(),
      deviceId: json['deviceId'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ReadingProgressToJson(ReadingProgress instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'chapterIndex': instance.chapterIndex,
      'cfi': instance.cfi,
      'anchorText': instance.anchorText,
      'percentage': instance.percentage,
      'deviceId': instance.deviceId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
