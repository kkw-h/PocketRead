import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketread/core/utils/isar_utils.dart';

part 'reading_progress.g.dart';

@JsonSerializable()
// @Collection()
class ReadingProgress {
  // @Id()
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? isarId; // Internal ID

  @Index(unique: true, replace: true)
  String bookId;

  int chapterIndex;

  String? cfi; // For EPUB

  String? anchorText; // For TXT

  double percentage;

  String deviceId;

  @Index()
  DateTime updatedAt;

  ReadingProgress({
    required this.bookId,
    required this.chapterIndex,
    this.cfi,
    this.anchorText,
    required this.percentage,
    required this.deviceId,
    required this.updatedAt,
  }) : isarId = fastHash(bookId);

  factory ReadingProgress.fromJson(Map<String, dynamic> json) => _$ReadingProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ReadingProgressToJson(this);
}
