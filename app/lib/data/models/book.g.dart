// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: json['id'] as String,
  title: json['title'] as String,
  author: json['author'] as String?,
  coverUrl: json['coverUrl'] as String?,
  fileKey: json['fileKey'] as String,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  format: json['format'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'author': instance.author,
  'coverUrl': instance.coverUrl,
  'fileKey': instance.fileKey,
  'fileSize': instance.fileSize,
  'format': instance.format,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
