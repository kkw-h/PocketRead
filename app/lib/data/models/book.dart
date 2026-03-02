import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketread/core/utils/isar_utils.dart';

part 'book.g.dart';

@JsonSerializable()
// @Collection()
class Book {
  // @Id()
  @JsonKey(includeFromJson: false, includeToJson: false)
  int? isarId; // Internal ID for Isar

  @Index(unique: true, replace: true)
  String id; // External ID (UUID)

  String title;
  
  String? author;
  
  String? coverUrl;
  
  String fileKey;
  
  int? fileSize;
  
  String format; // epub, txt
  
  DateTime createdAt;
  
  DateTime updatedAt;

  Book({
    required this.id,
    required this.title,
    this.author,
    this.coverUrl,
    required this.fileKey,
    this.fileSize,
    required this.format,
    required this.createdAt,
    required this.updatedAt,
  }) : isarId = fastHash(id);

  factory Book.fromJson(Map<String, dynamic> json) {
    // Handle optional fields that might be null
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String?,
      coverUrl: (json['cover_url'] ?? json['coverUrl']) as String?,
      fileKey: (json['file_key'] ?? json['fileKey']) as String? ?? '', // Support both snake_case and camelCase
      fileSize: (json['file_size'] ?? json['fileSize']) as int?,
      format: (json['format'] as String?) ?? 'epub',
      createdAt: json['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int)
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
      updatedAt: json['updated_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['updated_at'] as int)
          : (json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now()),
    );
  }
  Map<String, dynamic> toJson() => _$BookToJson(this);
}
