// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceFilePathMeta = const VerificationMeta(
    'sourceFilePath',
  );
  @override
  late final GeneratedColumn<String> sourceFilePath = GeneratedColumn<String>(
    'source_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileExtMeta = const VerificationMeta(
    'fileExt',
  );
  @override
  late final GeneratedColumn<String> fileExt = GeneratedColumn<String>(
    'file_ext',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverImagePathMeta = const VerificationMeta(
    'coverImagePath',
  );
  @override
  late final GeneratedColumn<String> coverImagePath = GeneratedColumn<String>(
    'cover_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverSourceTypeMeta = const VerificationMeta(
    'coverSourceType',
  );
  @override
  late final GeneratedColumn<String> coverSourceType = GeneratedColumn<String>(
    'cover_source_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _charsetNameMeta = const VerificationMeta(
    'charsetName',
  );
  @override
  late final GeneratedColumn<String> charsetName = GeneratedColumn<String>(
    'charset_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalChaptersMeta = const VerificationMeta(
    'totalChapters',
  );
  @override
  late final GeneratedColumn<int> totalChapters = GeneratedColumn<int>(
    'total_chapters',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalWordsMeta = const VerificationMeta(
    'totalWords',
  );
  @override
  late final GeneratedColumn<int> totalWords = GeneratedColumn<int>(
    'total_words',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pinnedAtMeta = const VerificationMeta(
    'pinnedAt',
  );
  @override
  late final GeneratedColumn<int> pinnedAt = GeneratedColumn<int>(
    'pinned_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importStatusMeta = const VerificationMeta(
    'importStatus',
  );
  @override
  late final GeneratedColumn<String> importStatus = GeneratedColumn<String>(
    'import_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _parseVersionMeta = const VerificationMeta(
    'parseVersion',
  );
  @override
  late final GeneratedColumn<int> parseVersion = GeneratedColumn<int>(
    'parse_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<int> lastReadAt = GeneratedColumn<int>(
    'last_read_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    format,
    title,
    author,
    description,
    sourceFilePath,
    localFilePath,
    fileName,
    fileExt,
    fileSize,
    fileHash,
    mimeType,
    coverImagePath,
    coverSourceType,
    charsetName,
    language,
    totalChapters,
    totalWords,
    isFavorite,
    pinnedAt,
    importStatus,
    parseVersion,
    createdAt,
    updatedAt,
    lastReadAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('source_file_path')) {
      context.handle(
        _sourceFilePathMeta,
        sourceFilePath.isAcceptableOrUnknown(
          data['source_file_path']!,
          _sourceFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceFilePathMeta);
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localFilePathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_ext')) {
      context.handle(
        _fileExtMeta,
        fileExt.isAcceptableOrUnknown(data['file_ext']!, _fileExtMeta),
      );
    } else if (isInserting) {
      context.missing(_fileExtMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('cover_image_path')) {
      context.handle(
        _coverImagePathMeta,
        coverImagePath.isAcceptableOrUnknown(
          data['cover_image_path']!,
          _coverImagePathMeta,
        ),
      );
    }
    if (data.containsKey('cover_source_type')) {
      context.handle(
        _coverSourceTypeMeta,
        coverSourceType.isAcceptableOrUnknown(
          data['cover_source_type']!,
          _coverSourceTypeMeta,
        ),
      );
    }
    if (data.containsKey('charset_name')) {
      context.handle(
        _charsetNameMeta,
        charsetName.isAcceptableOrUnknown(
          data['charset_name']!,
          _charsetNameMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('total_chapters')) {
      context.handle(
        _totalChaptersMeta,
        totalChapters.isAcceptableOrUnknown(
          data['total_chapters']!,
          _totalChaptersMeta,
        ),
      );
    }
    if (data.containsKey('total_words')) {
      context.handle(
        _totalWordsMeta,
        totalWords.isAcceptableOrUnknown(data['total_words']!, _totalWordsMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('pinned_at')) {
      context.handle(
        _pinnedAtMeta,
        pinnedAt.isAcceptableOrUnknown(data['pinned_at']!, _pinnedAtMeta),
      );
    }
    if (data.containsKey('import_status')) {
      context.handle(
        _importStatusMeta,
        importStatus.isAcceptableOrUnknown(
          data['import_status']!,
          _importStatusMeta,
        ),
      );
    }
    if (data.containsKey('parse_version')) {
      context.handle(
        _parseVersionMeta,
        parseVersion.isAcceptableOrUnknown(
          data['parse_version']!,
          _parseVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sourceFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_file_path'],
      )!,
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      fileExt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_ext'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      coverImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image_path'],
      ),
      coverSourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_source_type'],
      ),
      charsetName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}charset_name'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      totalChapters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_chapters'],
      )!,
      totalWords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_words'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      pinnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pinned_at'],
      ),
      importStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_status'],
      )!,
      parseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parse_version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_read_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final String id;
  final String format;
  final String title;
  final String author;
  final String? description;
  final String sourceFilePath;
  final String localFilePath;
  final String fileName;
  final String fileExt;
  final int fileSize;
  final String fileHash;
  final String? mimeType;
  final String? coverImagePath;
  final String? coverSourceType;
  final String? charsetName;
  final String? language;
  final int totalChapters;
  final int? totalWords;
  final bool isFavorite;
  final int? pinnedAt;
  final String importStatus;
  final int parseVersion;
  final int createdAt;
  final int updatedAt;
  final int? lastReadAt;
  final int? deletedAt;
  const Book({
    required this.id,
    required this.format,
    required this.title,
    required this.author,
    this.description,
    required this.sourceFilePath,
    required this.localFilePath,
    required this.fileName,
    required this.fileExt,
    required this.fileSize,
    required this.fileHash,
    this.mimeType,
    this.coverImagePath,
    this.coverSourceType,
    this.charsetName,
    this.language,
    required this.totalChapters,
    this.totalWords,
    required this.isFavorite,
    this.pinnedAt,
    required this.importStatus,
    required this.parseVersion,
    required this.createdAt,
    required this.updatedAt,
    this.lastReadAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['format'] = Variable<String>(format);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['source_file_path'] = Variable<String>(sourceFilePath);
    map['local_file_path'] = Variable<String>(localFilePath);
    map['file_name'] = Variable<String>(fileName);
    map['file_ext'] = Variable<String>(fileExt);
    map['file_size'] = Variable<int>(fileSize);
    map['file_hash'] = Variable<String>(fileHash);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || coverImagePath != null) {
      map['cover_image_path'] = Variable<String>(coverImagePath);
    }
    if (!nullToAbsent || coverSourceType != null) {
      map['cover_source_type'] = Variable<String>(coverSourceType);
    }
    if (!nullToAbsent || charsetName != null) {
      map['charset_name'] = Variable<String>(charsetName);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    map['total_chapters'] = Variable<int>(totalChapters);
    if (!nullToAbsent || totalWords != null) {
      map['total_words'] = Variable<int>(totalWords);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || pinnedAt != null) {
      map['pinned_at'] = Variable<int>(pinnedAt);
    }
    map['import_status'] = Variable<String>(importStatus);
    map['parse_version'] = Variable<int>(parseVersion);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || lastReadAt != null) {
      map['last_read_at'] = Variable<int>(lastReadAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      format: Value(format),
      title: Value(title),
      author: Value(author),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sourceFilePath: Value(sourceFilePath),
      localFilePath: Value(localFilePath),
      fileName: Value(fileName),
      fileExt: Value(fileExt),
      fileSize: Value(fileSize),
      fileHash: Value(fileHash),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      coverImagePath: coverImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImagePath),
      coverSourceType: coverSourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(coverSourceType),
      charsetName: charsetName == null && nullToAbsent
          ? const Value.absent()
          : Value(charsetName),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      totalChapters: Value(totalChapters),
      totalWords: totalWords == null && nullToAbsent
          ? const Value.absent()
          : Value(totalWords),
      isFavorite: Value(isFavorite),
      pinnedAt: pinnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinnedAt),
      importStatus: Value(importStatus),
      parseVersion: Value(parseVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastReadAt: lastReadAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReadAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<String>(json['id']),
      format: serializer.fromJson<String>(json['format']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      description: serializer.fromJson<String?>(json['description']),
      sourceFilePath: serializer.fromJson<String>(json['sourceFilePath']),
      localFilePath: serializer.fromJson<String>(json['localFilePath']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileExt: serializer.fromJson<String>(json['fileExt']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      coverImagePath: serializer.fromJson<String?>(json['coverImagePath']),
      coverSourceType: serializer.fromJson<String?>(json['coverSourceType']),
      charsetName: serializer.fromJson<String?>(json['charsetName']),
      language: serializer.fromJson<String?>(json['language']),
      totalChapters: serializer.fromJson<int>(json['totalChapters']),
      totalWords: serializer.fromJson<int?>(json['totalWords']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      pinnedAt: serializer.fromJson<int?>(json['pinnedAt']),
      importStatus: serializer.fromJson<String>(json['importStatus']),
      parseVersion: serializer.fromJson<int>(json['parseVersion']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      lastReadAt: serializer.fromJson<int?>(json['lastReadAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'format': serializer.toJson<String>(format),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'description': serializer.toJson<String?>(description),
      'sourceFilePath': serializer.toJson<String>(sourceFilePath),
      'localFilePath': serializer.toJson<String>(localFilePath),
      'fileName': serializer.toJson<String>(fileName),
      'fileExt': serializer.toJson<String>(fileExt),
      'fileSize': serializer.toJson<int>(fileSize),
      'fileHash': serializer.toJson<String>(fileHash),
      'mimeType': serializer.toJson<String?>(mimeType),
      'coverImagePath': serializer.toJson<String?>(coverImagePath),
      'coverSourceType': serializer.toJson<String?>(coverSourceType),
      'charsetName': serializer.toJson<String?>(charsetName),
      'language': serializer.toJson<String?>(language),
      'totalChapters': serializer.toJson<int>(totalChapters),
      'totalWords': serializer.toJson<int?>(totalWords),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'pinnedAt': serializer.toJson<int?>(pinnedAt),
      'importStatus': serializer.toJson<String>(importStatus),
      'parseVersion': serializer.toJson<int>(parseVersion),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'lastReadAt': serializer.toJson<int?>(lastReadAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  Book copyWith({
    String? id,
    String? format,
    String? title,
    String? author,
    Value<String?> description = const Value.absent(),
    String? sourceFilePath,
    String? localFilePath,
    String? fileName,
    String? fileExt,
    int? fileSize,
    String? fileHash,
    Value<String?> mimeType = const Value.absent(),
    Value<String?> coverImagePath = const Value.absent(),
    Value<String?> coverSourceType = const Value.absent(),
    Value<String?> charsetName = const Value.absent(),
    Value<String?> language = const Value.absent(),
    int? totalChapters,
    Value<int?> totalWords = const Value.absent(),
    bool? isFavorite,
    Value<int?> pinnedAt = const Value.absent(),
    String? importStatus,
    int? parseVersion,
    int? createdAt,
    int? updatedAt,
    Value<int?> lastReadAt = const Value.absent(),
    Value<int?> deletedAt = const Value.absent(),
  }) => Book(
    id: id ?? this.id,
    format: format ?? this.format,
    title: title ?? this.title,
    author: author ?? this.author,
    description: description.present ? description.value : this.description,
    sourceFilePath: sourceFilePath ?? this.sourceFilePath,
    localFilePath: localFilePath ?? this.localFilePath,
    fileName: fileName ?? this.fileName,
    fileExt: fileExt ?? this.fileExt,
    fileSize: fileSize ?? this.fileSize,
    fileHash: fileHash ?? this.fileHash,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    coverImagePath: coverImagePath.present
        ? coverImagePath.value
        : this.coverImagePath,
    coverSourceType: coverSourceType.present
        ? coverSourceType.value
        : this.coverSourceType,
    charsetName: charsetName.present ? charsetName.value : this.charsetName,
    language: language.present ? language.value : this.language,
    totalChapters: totalChapters ?? this.totalChapters,
    totalWords: totalWords.present ? totalWords.value : this.totalWords,
    isFavorite: isFavorite ?? this.isFavorite,
    pinnedAt: pinnedAt.present ? pinnedAt.value : this.pinnedAt,
    importStatus: importStatus ?? this.importStatus,
    parseVersion: parseVersion ?? this.parseVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastReadAt: lastReadAt.present ? lastReadAt.value : this.lastReadAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      format: data.format.present ? data.format.value : this.format,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      description: data.description.present
          ? data.description.value
          : this.description,
      sourceFilePath: data.sourceFilePath.present
          ? data.sourceFilePath.value
          : this.sourceFilePath,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileExt: data.fileExt.present ? data.fileExt.value : this.fileExt,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      coverImagePath: data.coverImagePath.present
          ? data.coverImagePath.value
          : this.coverImagePath,
      coverSourceType: data.coverSourceType.present
          ? data.coverSourceType.value
          : this.coverSourceType,
      charsetName: data.charsetName.present
          ? data.charsetName.value
          : this.charsetName,
      language: data.language.present ? data.language.value : this.language,
      totalChapters: data.totalChapters.present
          ? data.totalChapters.value
          : this.totalChapters,
      totalWords: data.totalWords.present
          ? data.totalWords.value
          : this.totalWords,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      pinnedAt: data.pinnedAt.present ? data.pinnedAt.value : this.pinnedAt,
      importStatus: data.importStatus.present
          ? data.importStatus.value
          : this.importStatus,
      parseVersion: data.parseVersion.present
          ? data.parseVersion.value
          : this.parseVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('format: $format, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('description: $description, ')
          ..write('sourceFilePath: $sourceFilePath, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('fileName: $fileName, ')
          ..write('fileExt: $fileExt, ')
          ..write('fileSize: $fileSize, ')
          ..write('fileHash: $fileHash, ')
          ..write('mimeType: $mimeType, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('coverSourceType: $coverSourceType, ')
          ..write('charsetName: $charsetName, ')
          ..write('language: $language, ')
          ..write('totalChapters: $totalChapters, ')
          ..write('totalWords: $totalWords, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('importStatus: $importStatus, ')
          ..write('parseVersion: $parseVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    format,
    title,
    author,
    description,
    sourceFilePath,
    localFilePath,
    fileName,
    fileExt,
    fileSize,
    fileHash,
    mimeType,
    coverImagePath,
    coverSourceType,
    charsetName,
    language,
    totalChapters,
    totalWords,
    isFavorite,
    pinnedAt,
    importStatus,
    parseVersion,
    createdAt,
    updatedAt,
    lastReadAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.format == this.format &&
          other.title == this.title &&
          other.author == this.author &&
          other.description == this.description &&
          other.sourceFilePath == this.sourceFilePath &&
          other.localFilePath == this.localFilePath &&
          other.fileName == this.fileName &&
          other.fileExt == this.fileExt &&
          other.fileSize == this.fileSize &&
          other.fileHash == this.fileHash &&
          other.mimeType == this.mimeType &&
          other.coverImagePath == this.coverImagePath &&
          other.coverSourceType == this.coverSourceType &&
          other.charsetName == this.charsetName &&
          other.language == this.language &&
          other.totalChapters == this.totalChapters &&
          other.totalWords == this.totalWords &&
          other.isFavorite == this.isFavorite &&
          other.pinnedAt == this.pinnedAt &&
          other.importStatus == this.importStatus &&
          other.parseVersion == this.parseVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastReadAt == this.lastReadAt &&
          other.deletedAt == this.deletedAt);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<String> id;
  final Value<String> format;
  final Value<String> title;
  final Value<String> author;
  final Value<String?> description;
  final Value<String> sourceFilePath;
  final Value<String> localFilePath;
  final Value<String> fileName;
  final Value<String> fileExt;
  final Value<int> fileSize;
  final Value<String> fileHash;
  final Value<String?> mimeType;
  final Value<String?> coverImagePath;
  final Value<String?> coverSourceType;
  final Value<String?> charsetName;
  final Value<String?> language;
  final Value<int> totalChapters;
  final Value<int?> totalWords;
  final Value<bool> isFavorite;
  final Value<int?> pinnedAt;
  final Value<String> importStatus;
  final Value<int> parseVersion;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> lastReadAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.format = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.description = const Value.absent(),
    this.sourceFilePath = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileExt = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    this.coverSourceType = const Value.absent(),
    this.charsetName = const Value.absent(),
    this.language = const Value.absent(),
    this.totalChapters = const Value.absent(),
    this.totalWords = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.importStatus = const Value.absent(),
    this.parseVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String format,
    required String title,
    this.author = const Value.absent(),
    this.description = const Value.absent(),
    required String sourceFilePath,
    required String localFilePath,
    required String fileName,
    required String fileExt,
    required int fileSize,
    required String fileHash,
    this.mimeType = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    this.coverSourceType = const Value.absent(),
    this.charsetName = const Value.absent(),
    this.language = const Value.absent(),
    this.totalChapters = const Value.absent(),
    this.totalWords = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.importStatus = const Value.absent(),
    this.parseVersion = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.lastReadAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       format = Value(format),
       title = Value(title),
       sourceFilePath = Value(sourceFilePath),
       localFilePath = Value(localFilePath),
       fileName = Value(fileName),
       fileExt = Value(fileExt),
       fileSize = Value(fileSize),
       fileHash = Value(fileHash),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Book> custom({
    Expression<String>? id,
    Expression<String>? format,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? description,
    Expression<String>? sourceFilePath,
    Expression<String>? localFilePath,
    Expression<String>? fileName,
    Expression<String>? fileExt,
    Expression<int>? fileSize,
    Expression<String>? fileHash,
    Expression<String>? mimeType,
    Expression<String>? coverImagePath,
    Expression<String>? coverSourceType,
    Expression<String>? charsetName,
    Expression<String>? language,
    Expression<int>? totalChapters,
    Expression<int>? totalWords,
    Expression<bool>? isFavorite,
    Expression<int>? pinnedAt,
    Expression<String>? importStatus,
    Expression<int>? parseVersion,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? lastReadAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (format != null) 'format': format,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (description != null) 'description': description,
      if (sourceFilePath != null) 'source_file_path': sourceFilePath,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (fileName != null) 'file_name': fileName,
      if (fileExt != null) 'file_ext': fileExt,
      if (fileSize != null) 'file_size': fileSize,
      if (fileHash != null) 'file_hash': fileHash,
      if (mimeType != null) 'mime_type': mimeType,
      if (coverImagePath != null) 'cover_image_path': coverImagePath,
      if (coverSourceType != null) 'cover_source_type': coverSourceType,
      if (charsetName != null) 'charset_name': charsetName,
      if (language != null) 'language': language,
      if (totalChapters != null) 'total_chapters': totalChapters,
      if (totalWords != null) 'total_words': totalWords,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (importStatus != null) 'import_status': importStatus,
      if (parseVersion != null) 'parse_version': parseVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksCompanion copyWith({
    Value<String>? id,
    Value<String>? format,
    Value<String>? title,
    Value<String>? author,
    Value<String?>? description,
    Value<String>? sourceFilePath,
    Value<String>? localFilePath,
    Value<String>? fileName,
    Value<String>? fileExt,
    Value<int>? fileSize,
    Value<String>? fileHash,
    Value<String?>? mimeType,
    Value<String?>? coverImagePath,
    Value<String?>? coverSourceType,
    Value<String?>? charsetName,
    Value<String?>? language,
    Value<int>? totalChapters,
    Value<int?>? totalWords,
    Value<bool>? isFavorite,
    Value<int?>? pinnedAt,
    Value<String>? importStatus,
    Value<int>? parseVersion,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? lastReadAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      format: format ?? this.format,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      sourceFilePath: sourceFilePath ?? this.sourceFilePath,
      localFilePath: localFilePath ?? this.localFilePath,
      fileName: fileName ?? this.fileName,
      fileExt: fileExt ?? this.fileExt,
      fileSize: fileSize ?? this.fileSize,
      fileHash: fileHash ?? this.fileHash,
      mimeType: mimeType ?? this.mimeType,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      coverSourceType: coverSourceType ?? this.coverSourceType,
      charsetName: charsetName ?? this.charsetName,
      language: language ?? this.language,
      totalChapters: totalChapters ?? this.totalChapters,
      totalWords: totalWords ?? this.totalWords,
      isFavorite: isFavorite ?? this.isFavorite,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      importStatus: importStatus ?? this.importStatus,
      parseVersion: parseVersion ?? this.parseVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sourceFilePath.present) {
      map['source_file_path'] = Variable<String>(sourceFilePath.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileExt.present) {
      map['file_ext'] = Variable<String>(fileExt.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (coverImagePath.present) {
      map['cover_image_path'] = Variable<String>(coverImagePath.value);
    }
    if (coverSourceType.present) {
      map['cover_source_type'] = Variable<String>(coverSourceType.value);
    }
    if (charsetName.present) {
      map['charset_name'] = Variable<String>(charsetName.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (totalChapters.present) {
      map['total_chapters'] = Variable<int>(totalChapters.value);
    }
    if (totalWords.present) {
      map['total_words'] = Variable<int>(totalWords.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<int>(pinnedAt.value);
    }
    if (importStatus.present) {
      map['import_status'] = Variable<String>(importStatus.value);
    }
    if (parseVersion.present) {
      map['parse_version'] = Variable<int>(parseVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<int>(lastReadAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('format: $format, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('description: $description, ')
          ..write('sourceFilePath: $sourceFilePath, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('fileName: $fileName, ')
          ..write('fileExt: $fileExt, ')
          ..write('fileSize: $fileSize, ')
          ..write('fileHash: $fileHash, ')
          ..write('mimeType: $mimeType, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('coverSourceType: $coverSourceType, ')
          ..write('charsetName: $charsetName, ')
          ..write('language: $language, ')
          ..write('totalChapters: $totalChapters, ')
          ..write('totalWords: $totalWords, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('importStatus: $importStatus, ')
          ..write('parseVersion: $parseVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookChaptersTable extends BookChapters
    with TableInfo<$BookChaptersTable, BookChapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _chapterIndexMeta = const VerificationMeta(
    'chapterIndex',
  );
  @override
  late final GeneratedColumn<int> chapterIndex = GeneratedColumn<int>(
    'chapter_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hrefMeta = const VerificationMeta('href');
  @override
  late final GeneratedColumn<String> href = GeneratedColumn<String>(
    'href',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anchorMeta = const VerificationMeta('anchor');
  @override
  late final GeneratedColumn<String> anchor = GeneratedColumn<String>(
    'anchor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startOffsetMeta = const VerificationMeta(
    'startOffset',
  );
  @override
  late final GeneratedColumn<int> startOffset = GeneratedColumn<int>(
    'start_offset',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endOffsetMeta = const VerificationMeta(
    'endOffset',
  );
  @override
  late final GeneratedColumn<int> endOffset = GeneratedColumn<int>(
    'end_offset',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plainTextMeta = const VerificationMeta(
    'plainText',
  );
  @override
  late final GeneratedColumn<String> plainText = GeneratedColumn<String>(
    'plain_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _htmlContentMeta = const VerificationMeta(
    'htmlContent',
  );
  @override
  late final GeneratedColumn<String> htmlContent = GeneratedColumn<String>(
    'html_content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    chapterIndex,
    title,
    sourceType,
    href,
    anchor,
    startOffset,
    endOffset,
    plainText,
    htmlContent,
    wordCount,
    level,
    parentId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookChapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_index')) {
      context.handle(
        _chapterIndexMeta,
        chapterIndex.isAcceptableOrUnknown(
          data['chapter_index']!,
          _chapterIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chapterIndexMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('href')) {
      context.handle(
        _hrefMeta,
        href.isAcceptableOrUnknown(data['href']!, _hrefMeta),
      );
    }
    if (data.containsKey('anchor')) {
      context.handle(
        _anchorMeta,
        anchor.isAcceptableOrUnknown(data['anchor']!, _anchorMeta),
      );
    }
    if (data.containsKey('start_offset')) {
      context.handle(
        _startOffsetMeta,
        startOffset.isAcceptableOrUnknown(
          data['start_offset']!,
          _startOffsetMeta,
        ),
      );
    }
    if (data.containsKey('end_offset')) {
      context.handle(
        _endOffsetMeta,
        endOffset.isAcceptableOrUnknown(data['end_offset']!, _endOffsetMeta),
      );
    }
    if (data.containsKey('plain_text')) {
      context.handle(
        _plainTextMeta,
        plainText.isAcceptableOrUnknown(data['plain_text']!, _plainTextMeta),
      );
    }
    if (data.containsKey('html_content')) {
      context.handle(
        _htmlContentMeta,
        htmlContent.isAcceptableOrUnknown(
          data['html_content']!,
          _htmlContentMeta,
        ),
      );
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {bookId, chapterIndex},
  ];
  @override
  BookChapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookChapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      chapterIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_index'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      href: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}href'],
      ),
      anchor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor'],
      ),
      startOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_offset'],
      ),
      endOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_offset'],
      ),
      plainText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plain_text'],
      ),
      htmlContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}html_content'],
      ),
      wordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_count'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BookChaptersTable createAlias(String alias) {
    return $BookChaptersTable(attachedDatabase, alias);
  }
}

class BookChapter extends DataClass implements Insertable<BookChapter> {
  final String id;
  final String bookId;
  final int chapterIndex;
  final String title;
  final String sourceType;
  final String? href;
  final String? anchor;
  final int? startOffset;
  final int? endOffset;
  final String? plainText;
  final String? htmlContent;
  final int? wordCount;
  final int level;
  final String? parentId;
  final int createdAt;
  final int updatedAt;
  const BookChapter({
    required this.id,
    required this.bookId,
    required this.chapterIndex,
    required this.title,
    required this.sourceType,
    this.href,
    this.anchor,
    this.startOffset,
    this.endOffset,
    this.plainText,
    this.htmlContent,
    this.wordCount,
    required this.level,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['chapter_index'] = Variable<int>(chapterIndex);
    map['title'] = Variable<String>(title);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || href != null) {
      map['href'] = Variable<String>(href);
    }
    if (!nullToAbsent || anchor != null) {
      map['anchor'] = Variable<String>(anchor);
    }
    if (!nullToAbsent || startOffset != null) {
      map['start_offset'] = Variable<int>(startOffset);
    }
    if (!nullToAbsent || endOffset != null) {
      map['end_offset'] = Variable<int>(endOffset);
    }
    if (!nullToAbsent || plainText != null) {
      map['plain_text'] = Variable<String>(plainText);
    }
    if (!nullToAbsent || htmlContent != null) {
      map['html_content'] = Variable<String>(htmlContent);
    }
    if (!nullToAbsent || wordCount != null) {
      map['word_count'] = Variable<int>(wordCount);
    }
    map['level'] = Variable<int>(level);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BookChaptersCompanion toCompanion(bool nullToAbsent) {
    return BookChaptersCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterIndex: Value(chapterIndex),
      title: Value(title),
      sourceType: Value(sourceType),
      href: href == null && nullToAbsent ? const Value.absent() : Value(href),
      anchor: anchor == null && nullToAbsent
          ? const Value.absent()
          : Value(anchor),
      startOffset: startOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(startOffset),
      endOffset: endOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(endOffset),
      plainText: plainText == null && nullToAbsent
          ? const Value.absent()
          : Value(plainText),
      htmlContent: htmlContent == null && nullToAbsent
          ? const Value.absent()
          : Value(htmlContent),
      wordCount: wordCount == null && nullToAbsent
          ? const Value.absent()
          : Value(wordCount),
      level: Value(level),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BookChapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookChapter(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterIndex: serializer.fromJson<int>(json['chapterIndex']),
      title: serializer.fromJson<String>(json['title']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      href: serializer.fromJson<String?>(json['href']),
      anchor: serializer.fromJson<String?>(json['anchor']),
      startOffset: serializer.fromJson<int?>(json['startOffset']),
      endOffset: serializer.fromJson<int?>(json['endOffset']),
      plainText: serializer.fromJson<String?>(json['plainText']),
      htmlContent: serializer.fromJson<String?>(json['htmlContent']),
      wordCount: serializer.fromJson<int?>(json['wordCount']),
      level: serializer.fromJson<int>(json['level']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'chapterIndex': serializer.toJson<int>(chapterIndex),
      'title': serializer.toJson<String>(title),
      'sourceType': serializer.toJson<String>(sourceType),
      'href': serializer.toJson<String?>(href),
      'anchor': serializer.toJson<String?>(anchor),
      'startOffset': serializer.toJson<int?>(startOffset),
      'endOffset': serializer.toJson<int?>(endOffset),
      'plainText': serializer.toJson<String?>(plainText),
      'htmlContent': serializer.toJson<String?>(htmlContent),
      'wordCount': serializer.toJson<int?>(wordCount),
      'level': serializer.toJson<int>(level),
      'parentId': serializer.toJson<String?>(parentId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BookChapter copyWith({
    String? id,
    String? bookId,
    int? chapterIndex,
    String? title,
    String? sourceType,
    Value<String?> href = const Value.absent(),
    Value<String?> anchor = const Value.absent(),
    Value<int?> startOffset = const Value.absent(),
    Value<int?> endOffset = const Value.absent(),
    Value<String?> plainText = const Value.absent(),
    Value<String?> htmlContent = const Value.absent(),
    Value<int?> wordCount = const Value.absent(),
    int? level,
    Value<String?> parentId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => BookChapter(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    chapterIndex: chapterIndex ?? this.chapterIndex,
    title: title ?? this.title,
    sourceType: sourceType ?? this.sourceType,
    href: href.present ? href.value : this.href,
    anchor: anchor.present ? anchor.value : this.anchor,
    startOffset: startOffset.present ? startOffset.value : this.startOffset,
    endOffset: endOffset.present ? endOffset.value : this.endOffset,
    plainText: plainText.present ? plainText.value : this.plainText,
    htmlContent: htmlContent.present ? htmlContent.value : this.htmlContent,
    wordCount: wordCount.present ? wordCount.value : this.wordCount,
    level: level ?? this.level,
    parentId: parentId.present ? parentId.value : this.parentId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BookChapter copyWithCompanion(BookChaptersCompanion data) {
    return BookChapter(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterIndex: data.chapterIndex.present
          ? data.chapterIndex.value
          : this.chapterIndex,
      title: data.title.present ? data.title.value : this.title,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      href: data.href.present ? data.href.value : this.href,
      anchor: data.anchor.present ? data.anchor.value : this.anchor,
      startOffset: data.startOffset.present
          ? data.startOffset.value
          : this.startOffset,
      endOffset: data.endOffset.present ? data.endOffset.value : this.endOffset,
      plainText: data.plainText.present ? data.plainText.value : this.plainText,
      htmlContent: data.htmlContent.present
          ? data.htmlContent.value
          : this.htmlContent,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      level: data.level.present ? data.level.value : this.level,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookChapter(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('title: $title, ')
          ..write('sourceType: $sourceType, ')
          ..write('href: $href, ')
          ..write('anchor: $anchor, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('plainText: $plainText, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('wordCount: $wordCount, ')
          ..write('level: $level, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    chapterIndex,
    title,
    sourceType,
    href,
    anchor,
    startOffset,
    endOffset,
    plainText,
    htmlContent,
    wordCount,
    level,
    parentId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookChapter &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterIndex == this.chapterIndex &&
          other.title == this.title &&
          other.sourceType == this.sourceType &&
          other.href == this.href &&
          other.anchor == this.anchor &&
          other.startOffset == this.startOffset &&
          other.endOffset == this.endOffset &&
          other.plainText == this.plainText &&
          other.htmlContent == this.htmlContent &&
          other.wordCount == this.wordCount &&
          other.level == this.level &&
          other.parentId == this.parentId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BookChaptersCompanion extends UpdateCompanion<BookChapter> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<int> chapterIndex;
  final Value<String> title;
  final Value<String> sourceType;
  final Value<String?> href;
  final Value<String?> anchor;
  final Value<int?> startOffset;
  final Value<int?> endOffset;
  final Value<String?> plainText;
  final Value<String?> htmlContent;
  final Value<int?> wordCount;
  final Value<int> level;
  final Value<String?> parentId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const BookChaptersCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterIndex = const Value.absent(),
    this.title = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.href = const Value.absent(),
    this.anchor = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.plainText = const Value.absent(),
    this.htmlContent = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.level = const Value.absent(),
    this.parentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookChaptersCompanion.insert({
    required String id,
    required String bookId,
    required int chapterIndex,
    required String title,
    required String sourceType,
    this.href = const Value.absent(),
    this.anchor = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.plainText = const Value.absent(),
    this.htmlContent = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.level = const Value.absent(),
    this.parentId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       chapterIndex = Value(chapterIndex),
       title = Value(title),
       sourceType = Value(sourceType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BookChapter> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<int>? chapterIndex,
    Expression<String>? title,
    Expression<String>? sourceType,
    Expression<String>? href,
    Expression<String>? anchor,
    Expression<int>? startOffset,
    Expression<int>? endOffset,
    Expression<String>? plainText,
    Expression<String>? htmlContent,
    Expression<int>? wordCount,
    Expression<int>? level,
    Expression<String>? parentId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterIndex != null) 'chapter_index': chapterIndex,
      if (title != null) 'title': title,
      if (sourceType != null) 'source_type': sourceType,
      if (href != null) 'href': href,
      if (anchor != null) 'anchor': anchor,
      if (startOffset != null) 'start_offset': startOffset,
      if (endOffset != null) 'end_offset': endOffset,
      if (plainText != null) 'plain_text': plainText,
      if (htmlContent != null) 'html_content': htmlContent,
      if (wordCount != null) 'word_count': wordCount,
      if (level != null) 'level': level,
      if (parentId != null) 'parent_id': parentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookChaptersCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<int>? chapterIndex,
    Value<String>? title,
    Value<String>? sourceType,
    Value<String?>? href,
    Value<String?>? anchor,
    Value<int?>? startOffset,
    Value<int?>? endOffset,
    Value<String?>? plainText,
    Value<String?>? htmlContent,
    Value<int?>? wordCount,
    Value<int>? level,
    Value<String?>? parentId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return BookChaptersCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      title: title ?? this.title,
      sourceType: sourceType ?? this.sourceType,
      href: href ?? this.href,
      anchor: anchor ?? this.anchor,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      plainText: plainText ?? this.plainText,
      htmlContent: htmlContent ?? this.htmlContent,
      wordCount: wordCount ?? this.wordCount,
      level: level ?? this.level,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterIndex.present) {
      map['chapter_index'] = Variable<int>(chapterIndex.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (href.present) {
      map['href'] = Variable<String>(href.value);
    }
    if (anchor.present) {
      map['anchor'] = Variable<String>(anchor.value);
    }
    if (startOffset.present) {
      map['start_offset'] = Variable<int>(startOffset.value);
    }
    if (endOffset.present) {
      map['end_offset'] = Variable<int>(endOffset.value);
    }
    if (plainText.present) {
      map['plain_text'] = Variable<String>(plainText.value);
    }
    if (htmlContent.present) {
      map['html_content'] = Variable<String>(htmlContent.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookChaptersCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterIndex: $chapterIndex, ')
          ..write('title: $title, ')
          ..write('sourceType: $sourceType, ')
          ..write('href: $href, ')
          ..write('anchor: $anchor, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('plainText: $plainText, ')
          ..write('htmlContent: $htmlContent, ')
          ..write('wordCount: $wordCount, ')
          ..write('level: $level, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressTable extends ReadingProgress
    with TableInfo<$ReadingProgressTable, ReadingProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _currentChapterIndexMeta =
      const VerificationMeta('currentChapterIndex');
  @override
  late final GeneratedColumn<int> currentChapterIndex = GeneratedColumn<int>(
    'current_chapter_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _chapterOffsetMeta = const VerificationMeta(
    'chapterOffset',
  );
  @override
  late final GeneratedColumn<int> chapterOffset = GeneratedColumn<int>(
    'chapter_offset',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scrollOffsetMeta = const VerificationMeta(
    'scrollOffset',
  );
  @override
  late final GeneratedColumn<double> scrollOffset = GeneratedColumn<double>(
    'scroll_offset',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressPercentMeta = const VerificationMeta(
    'progressPercent',
  );
  @override
  late final GeneratedColumn<double> progressPercent = GeneratedColumn<double>(
    'progress_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _locatorTypeMeta = const VerificationMeta(
    'locatorType',
  );
  @override
  late final GeneratedColumn<String> locatorType = GeneratedColumn<String>(
    'locator_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('txt_offset'),
  );
  static const VerificationMeta _locatorValueMeta = const VerificationMeta(
    'locatorValue',
  );
  @override
  late final GeneratedColumn<String> locatorValue = GeneratedColumn<String>(
    'locator_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<int> lastReadAt = GeneratedColumn<int>(
    'last_read_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalReadingMinutesMeta =
      const VerificationMeta('totalReadingMinutes');
  @override
  late final GeneratedColumn<int> totalReadingMinutes = GeneratedColumn<int>(
    'total_reading_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    currentChapterIndex,
    chapterOffset,
    scrollOffset,
    progressPercent,
    locatorType,
    locatorValue,
    startedAt,
    lastReadAt,
    totalReadingMinutes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('current_chapter_index')) {
      context.handle(
        _currentChapterIndexMeta,
        currentChapterIndex.isAcceptableOrUnknown(
          data['current_chapter_index']!,
          _currentChapterIndexMeta,
        ),
      );
    }
    if (data.containsKey('chapter_offset')) {
      context.handle(
        _chapterOffsetMeta,
        chapterOffset.isAcceptableOrUnknown(
          data['chapter_offset']!,
          _chapterOffsetMeta,
        ),
      );
    }
    if (data.containsKey('scroll_offset')) {
      context.handle(
        _scrollOffsetMeta,
        scrollOffset.isAcceptableOrUnknown(
          data['scroll_offset']!,
          _scrollOffsetMeta,
        ),
      );
    }
    if (data.containsKey('progress_percent')) {
      context.handle(
        _progressPercentMeta,
        progressPercent.isAcceptableOrUnknown(
          data['progress_percent']!,
          _progressPercentMeta,
        ),
      );
    }
    if (data.containsKey('locator_type')) {
      context.handle(
        _locatorTypeMeta,
        locatorType.isAcceptableOrUnknown(
          data['locator_type']!,
          _locatorTypeMeta,
        ),
      );
    }
    if (data.containsKey('locator_value')) {
      context.handle(
        _locatorValueMeta,
        locatorValue.isAcceptableOrUnknown(
          data['locator_value']!,
          _locatorValueMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastReadAtMeta);
    }
    if (data.containsKey('total_reading_minutes')) {
      context.handle(
        _totalReadingMinutesMeta,
        totalReadingMinutes.isAcceptableOrUnknown(
          data['total_reading_minutes']!,
          _totalReadingMinutesMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      currentChapterIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_chapter_index'],
      )!,
      chapterOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_offset'],
      ),
      scrollOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_offset'],
      ),
      progressPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress_percent'],
      )!,
      locatorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locator_type'],
      )!,
      locatorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locator_value'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      ),
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_read_at'],
      )!,
      totalReadingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reading_minutes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingProgressTable createAlias(String alias) {
    return $ReadingProgressTable(attachedDatabase, alias);
  }
}

class ReadingProgressData extends DataClass
    implements Insertable<ReadingProgressData> {
  final String id;
  final String bookId;
  final int currentChapterIndex;
  final int? chapterOffset;
  final double? scrollOffset;
  final double progressPercent;
  final String locatorType;
  final String? locatorValue;
  final int? startedAt;
  final int lastReadAt;
  final int totalReadingMinutes;
  final int updatedAt;
  const ReadingProgressData({
    required this.id,
    required this.bookId,
    required this.currentChapterIndex,
    this.chapterOffset,
    this.scrollOffset,
    required this.progressPercent,
    required this.locatorType,
    this.locatorValue,
    this.startedAt,
    required this.lastReadAt,
    required this.totalReadingMinutes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['current_chapter_index'] = Variable<int>(currentChapterIndex);
    if (!nullToAbsent || chapterOffset != null) {
      map['chapter_offset'] = Variable<int>(chapterOffset);
    }
    if (!nullToAbsent || scrollOffset != null) {
      map['scroll_offset'] = Variable<double>(scrollOffset);
    }
    map['progress_percent'] = Variable<double>(progressPercent);
    map['locator_type'] = Variable<String>(locatorType);
    if (!nullToAbsent || locatorValue != null) {
      map['locator_value'] = Variable<String>(locatorValue);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<int>(startedAt);
    }
    map['last_read_at'] = Variable<int>(lastReadAt);
    map['total_reading_minutes'] = Variable<int>(totalReadingMinutes);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ReadingProgressCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressCompanion(
      id: Value(id),
      bookId: Value(bookId),
      currentChapterIndex: Value(currentChapterIndex),
      chapterOffset: chapterOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterOffset),
      scrollOffset: scrollOffset == null && nullToAbsent
          ? const Value.absent()
          : Value(scrollOffset),
      progressPercent: Value(progressPercent),
      locatorType: Value(locatorType),
      locatorValue: locatorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(locatorValue),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      lastReadAt: Value(lastReadAt),
      totalReadingMinutes: Value(totalReadingMinutes),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      currentChapterIndex: serializer.fromJson<int>(
        json['currentChapterIndex'],
      ),
      chapterOffset: serializer.fromJson<int?>(json['chapterOffset']),
      scrollOffset: serializer.fromJson<double?>(json['scrollOffset']),
      progressPercent: serializer.fromJson<double>(json['progressPercent']),
      locatorType: serializer.fromJson<String>(json['locatorType']),
      locatorValue: serializer.fromJson<String?>(json['locatorValue']),
      startedAt: serializer.fromJson<int?>(json['startedAt']),
      lastReadAt: serializer.fromJson<int>(json['lastReadAt']),
      totalReadingMinutes: serializer.fromJson<int>(
        json['totalReadingMinutes'],
      ),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'currentChapterIndex': serializer.toJson<int>(currentChapterIndex),
      'chapterOffset': serializer.toJson<int?>(chapterOffset),
      'scrollOffset': serializer.toJson<double?>(scrollOffset),
      'progressPercent': serializer.toJson<double>(progressPercent),
      'locatorType': serializer.toJson<String>(locatorType),
      'locatorValue': serializer.toJson<String?>(locatorValue),
      'startedAt': serializer.toJson<int?>(startedAt),
      'lastReadAt': serializer.toJson<int>(lastReadAt),
      'totalReadingMinutes': serializer.toJson<int>(totalReadingMinutes),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReadingProgressData copyWith({
    String? id,
    String? bookId,
    int? currentChapterIndex,
    Value<int?> chapterOffset = const Value.absent(),
    Value<double?> scrollOffset = const Value.absent(),
    double? progressPercent,
    String? locatorType,
    Value<String?> locatorValue = const Value.absent(),
    Value<int?> startedAt = const Value.absent(),
    int? lastReadAt,
    int? totalReadingMinutes,
    int? updatedAt,
  }) => ReadingProgressData(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
    chapterOffset: chapterOffset.present
        ? chapterOffset.value
        : this.chapterOffset,
    scrollOffset: scrollOffset.present ? scrollOffset.value : this.scrollOffset,
    progressPercent: progressPercent ?? this.progressPercent,
    locatorType: locatorType ?? this.locatorType,
    locatorValue: locatorValue.present ? locatorValue.value : this.locatorValue,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    lastReadAt: lastReadAt ?? this.lastReadAt,
    totalReadingMinutes: totalReadingMinutes ?? this.totalReadingMinutes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingProgressData copyWithCompanion(ReadingProgressCompanion data) {
    return ReadingProgressData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      currentChapterIndex: data.currentChapterIndex.present
          ? data.currentChapterIndex.value
          : this.currentChapterIndex,
      chapterOffset: data.chapterOffset.present
          ? data.chapterOffset.value
          : this.chapterOffset,
      scrollOffset: data.scrollOffset.present
          ? data.scrollOffset.value
          : this.scrollOffset,
      progressPercent: data.progressPercent.present
          ? data.progressPercent.value
          : this.progressPercent,
      locatorType: data.locatorType.present
          ? data.locatorType.value
          : this.locatorType,
      locatorValue: data.locatorValue.present
          ? data.locatorValue.value
          : this.locatorValue,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      totalReadingMinutes: data.totalReadingMinutes.present
          ? data.totalReadingMinutes.value
          : this.totalReadingMinutes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('currentChapterIndex: $currentChapterIndex, ')
          ..write('chapterOffset: $chapterOffset, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('locatorType: $locatorType, ')
          ..write('locatorValue: $locatorValue, ')
          ..write('startedAt: $startedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('totalReadingMinutes: $totalReadingMinutes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    currentChapterIndex,
    chapterOffset,
    scrollOffset,
    progressPercent,
    locatorType,
    locatorValue,
    startedAt,
    lastReadAt,
    totalReadingMinutes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.currentChapterIndex == this.currentChapterIndex &&
          other.chapterOffset == this.chapterOffset &&
          other.scrollOffset == this.scrollOffset &&
          other.progressPercent == this.progressPercent &&
          other.locatorType == this.locatorType &&
          other.locatorValue == this.locatorValue &&
          other.startedAt == this.startedAt &&
          other.lastReadAt == this.lastReadAt &&
          other.totalReadingMinutes == this.totalReadingMinutes &&
          other.updatedAt == this.updatedAt);
}

class ReadingProgressCompanion extends UpdateCompanion<ReadingProgressData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<int> currentChapterIndex;
  final Value<int?> chapterOffset;
  final Value<double?> scrollOffset;
  final Value<double> progressPercent;
  final Value<String> locatorType;
  final Value<String?> locatorValue;
  final Value<int?> startedAt;
  final Value<int> lastReadAt;
  final Value<int> totalReadingMinutes;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ReadingProgressCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.currentChapterIndex = const Value.absent(),
    this.chapterOffset = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.locatorType = const Value.absent(),
    this.locatorValue = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.totalReadingMinutes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingProgressCompanion.insert({
    required String id,
    required String bookId,
    this.currentChapterIndex = const Value.absent(),
    this.chapterOffset = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.locatorType = const Value.absent(),
    this.locatorValue = const Value.absent(),
    this.startedAt = const Value.absent(),
    required int lastReadAt,
    this.totalReadingMinutes = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       lastReadAt = Value(lastReadAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingProgressData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<int>? currentChapterIndex,
    Expression<int>? chapterOffset,
    Expression<double>? scrollOffset,
    Expression<double>? progressPercent,
    Expression<String>? locatorType,
    Expression<String>? locatorValue,
    Expression<int>? startedAt,
    Expression<int>? lastReadAt,
    Expression<int>? totalReadingMinutes,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (currentChapterIndex != null)
        'current_chapter_index': currentChapterIndex,
      if (chapterOffset != null) 'chapter_offset': chapterOffset,
      if (scrollOffset != null) 'scroll_offset': scrollOffset,
      if (progressPercent != null) 'progress_percent': progressPercent,
      if (locatorType != null) 'locator_type': locatorType,
      if (locatorValue != null) 'locator_value': locatorValue,
      if (startedAt != null) 'started_at': startedAt,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (totalReadingMinutes != null)
        'total_reading_minutes': totalReadingMinutes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingProgressCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<int>? currentChapterIndex,
    Value<int?>? chapterOffset,
    Value<double?>? scrollOffset,
    Value<double>? progressPercent,
    Value<String>? locatorType,
    Value<String?>? locatorValue,
    Value<int?>? startedAt,
    Value<int>? lastReadAt,
    Value<int>? totalReadingMinutes,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReadingProgressCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      chapterOffset: chapterOffset ?? this.chapterOffset,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      progressPercent: progressPercent ?? this.progressPercent,
      locatorType: locatorType ?? this.locatorType,
      locatorValue: locatorValue ?? this.locatorValue,
      startedAt: startedAt ?? this.startedAt,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      totalReadingMinutes: totalReadingMinutes ?? this.totalReadingMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (currentChapterIndex.present) {
      map['current_chapter_index'] = Variable<int>(currentChapterIndex.value);
    }
    if (chapterOffset.present) {
      map['chapter_offset'] = Variable<int>(chapterOffset.value);
    }
    if (scrollOffset.present) {
      map['scroll_offset'] = Variable<double>(scrollOffset.value);
    }
    if (progressPercent.present) {
      map['progress_percent'] = Variable<double>(progressPercent.value);
    }
    if (locatorType.present) {
      map['locator_type'] = Variable<String>(locatorType.value);
    }
    if (locatorValue.present) {
      map['locator_value'] = Variable<String>(locatorValue.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<int>(lastReadAt.value);
    }
    if (totalReadingMinutes.present) {
      map['total_reading_minutes'] = Variable<int>(totalReadingMinutes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('currentChapterIndex: $currentChapterIndex, ')
          ..write('chapterOffset: $chapterOffset, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('locatorType: $locatorType, ')
          ..write('locatorValue: $locatorValue, ')
          ..write('startedAt: $startedAt, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('totalReadingMinutes: $totalReadingMinutes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReaderPreferencesTable extends ReaderPreferences
    with TableInfo<$ReaderPreferencesTable, ReaderPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReaderPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _backgroundColorMeta = const VerificationMeta(
    'backgroundColor',
  );
  @override
  late final GeneratedColumn<String> backgroundColor = GeneratedColumn<String>(
    'background_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#F6F1E9'),
  );
  static const VerificationMeta _fontFamilyMeta = const VerificationMeta(
    'fontFamily',
  );
  @override
  late final GeneratedColumn<String> fontFamily = GeneratedColumn<String>(
    'font_family',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(18),
  );
  static const VerificationMeta _lineHeightMeta = const VerificationMeta(
    'lineHeight',
  );
  @override
  late final GeneratedColumn<double> lineHeight = GeneratedColumn<double>(
    'line_height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.6),
  );
  static const VerificationMeta _horizontalPaddingMeta = const VerificationMeta(
    'horizontalPadding',
  );
  @override
  late final GeneratedColumn<double> horizontalPadding =
      GeneratedColumn<double>(
        'horizontal_padding',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(20),
      );
  static const VerificationMeta _paragraphSpacingMeta = const VerificationMeta(
    'paragraphSpacing',
  );
  @override
  late final GeneratedColumn<double> paragraphSpacing = GeneratedColumn<double>(
    'paragraph_spacing',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _textAlignMeta = const VerificationMeta(
    'textAlign',
  );
  @override
  late final GeneratedColumn<String> textAlign = GeneratedColumn<String>(
    'text_align',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('left'),
  );
  static const VerificationMeta _brightnessLockMeta = const VerificationMeta(
    'brightnessLock',
  );
  @override
  late final GeneratedColumn<String> brightnessLock = GeneratedColumn<String>(
    'brightness_lock',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    backgroundColor,
    fontFamily,
    fontSize,
    lineHeight,
    horizontalPadding,
    paragraphSpacing,
    textAlign,
    brightnessLock,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reader_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReaderPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('background_color')) {
      context.handle(
        _backgroundColorMeta,
        backgroundColor.isAcceptableOrUnknown(
          data['background_color']!,
          _backgroundColorMeta,
        ),
      );
    }
    if (data.containsKey('font_family')) {
      context.handle(
        _fontFamilyMeta,
        fontFamily.isAcceptableOrUnknown(data['font_family']!, _fontFamilyMeta),
      );
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    if (data.containsKey('line_height')) {
      context.handle(
        _lineHeightMeta,
        lineHeight.isAcceptableOrUnknown(data['line_height']!, _lineHeightMeta),
      );
    }
    if (data.containsKey('horizontal_padding')) {
      context.handle(
        _horizontalPaddingMeta,
        horizontalPadding.isAcceptableOrUnknown(
          data['horizontal_padding']!,
          _horizontalPaddingMeta,
        ),
      );
    }
    if (data.containsKey('paragraph_spacing')) {
      context.handle(
        _paragraphSpacingMeta,
        paragraphSpacing.isAcceptableOrUnknown(
          data['paragraph_spacing']!,
          _paragraphSpacingMeta,
        ),
      );
    }
    if (data.containsKey('text_align')) {
      context.handle(
        _textAlignMeta,
        textAlign.isAcceptableOrUnknown(data['text_align']!, _textAlignMeta),
      );
    }
    if (data.containsKey('brightness_lock')) {
      context.handle(
        _brightnessLockMeta,
        brightnessLock.isAcceptableOrUnknown(
          data['brightness_lock']!,
          _brightnessLockMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReaderPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReaderPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      backgroundColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_color'],
      )!,
      fontFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_family'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_size'],
      )!,
      lineHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_height'],
      )!,
      horizontalPadding: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}horizontal_padding'],
      )!,
      paragraphSpacing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paragraph_spacing'],
      )!,
      textAlign: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_align'],
      )!,
      brightnessLock: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brightness_lock'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReaderPreferencesTable createAlias(String alias) {
    return $ReaderPreferencesTable(attachedDatabase, alias);
  }
}

class ReaderPreference extends DataClass
    implements Insertable<ReaderPreference> {
  final int id;
  final String themeMode;
  final String backgroundColor;
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final double horizontalPadding;
  final double paragraphSpacing;
  final String textAlign;
  final String? brightnessLock;
  final int updatedAt;
  const ReaderPreference({
    required this.id,
    required this.themeMode,
    required this.backgroundColor,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.horizontalPadding,
    required this.paragraphSpacing,
    required this.textAlign,
    this.brightnessLock,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['background_color'] = Variable<String>(backgroundColor);
    map['font_family'] = Variable<String>(fontFamily);
    map['font_size'] = Variable<double>(fontSize);
    map['line_height'] = Variable<double>(lineHeight);
    map['horizontal_padding'] = Variable<double>(horizontalPadding);
    map['paragraph_spacing'] = Variable<double>(paragraphSpacing);
    map['text_align'] = Variable<String>(textAlign);
    if (!nullToAbsent || brightnessLock != null) {
      map['brightness_lock'] = Variable<String>(brightnessLock);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ReaderPreferencesCompanion toCompanion(bool nullToAbsent) {
    return ReaderPreferencesCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      backgroundColor: Value(backgroundColor),
      fontFamily: Value(fontFamily),
      fontSize: Value(fontSize),
      lineHeight: Value(lineHeight),
      horizontalPadding: Value(horizontalPadding),
      paragraphSpacing: Value(paragraphSpacing),
      textAlign: Value(textAlign),
      brightnessLock: brightnessLock == null && nullToAbsent
          ? const Value.absent()
          : Value(brightnessLock),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReaderPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReaderPreference(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      backgroundColor: serializer.fromJson<String>(json['backgroundColor']),
      fontFamily: serializer.fromJson<String>(json['fontFamily']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
      lineHeight: serializer.fromJson<double>(json['lineHeight']),
      horizontalPadding: serializer.fromJson<double>(json['horizontalPadding']),
      paragraphSpacing: serializer.fromJson<double>(json['paragraphSpacing']),
      textAlign: serializer.fromJson<String>(json['textAlign']),
      brightnessLock: serializer.fromJson<String?>(json['brightnessLock']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'backgroundColor': serializer.toJson<String>(backgroundColor),
      'fontFamily': serializer.toJson<String>(fontFamily),
      'fontSize': serializer.toJson<double>(fontSize),
      'lineHeight': serializer.toJson<double>(lineHeight),
      'horizontalPadding': serializer.toJson<double>(horizontalPadding),
      'paragraphSpacing': serializer.toJson<double>(paragraphSpacing),
      'textAlign': serializer.toJson<String>(textAlign),
      'brightnessLock': serializer.toJson<String?>(brightnessLock),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReaderPreference copyWith({
    int? id,
    String? themeMode,
    String? backgroundColor,
    String? fontFamily,
    double? fontSize,
    double? lineHeight,
    double? horizontalPadding,
    double? paragraphSpacing,
    String? textAlign,
    Value<String?> brightnessLock = const Value.absent(),
    int? updatedAt,
  }) => ReaderPreference(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    fontFamily: fontFamily ?? this.fontFamily,
    fontSize: fontSize ?? this.fontSize,
    lineHeight: lineHeight ?? this.lineHeight,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
    textAlign: textAlign ?? this.textAlign,
    brightnessLock: brightnessLock.present
        ? brightnessLock.value
        : this.brightnessLock,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReaderPreference copyWithCompanion(ReaderPreferencesCompanion data) {
    return ReaderPreference(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
      fontFamily: data.fontFamily.present
          ? data.fontFamily.value
          : this.fontFamily,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      lineHeight: data.lineHeight.present
          ? data.lineHeight.value
          : this.lineHeight,
      horizontalPadding: data.horizontalPadding.present
          ? data.horizontalPadding.value
          : this.horizontalPadding,
      paragraphSpacing: data.paragraphSpacing.present
          ? data.paragraphSpacing.value
          : this.paragraphSpacing,
      textAlign: data.textAlign.present ? data.textAlign.value : this.textAlign,
      brightnessLock: data.brightnessLock.present
          ? data.brightnessLock.value
          : this.brightnessLock,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReaderPreference(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('fontSize: $fontSize, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('horizontalPadding: $horizontalPadding, ')
          ..write('paragraphSpacing: $paragraphSpacing, ')
          ..write('textAlign: $textAlign, ')
          ..write('brightnessLock: $brightnessLock, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    backgroundColor,
    fontFamily,
    fontSize,
    lineHeight,
    horizontalPadding,
    paragraphSpacing,
    textAlign,
    brightnessLock,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReaderPreference &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.backgroundColor == this.backgroundColor &&
          other.fontFamily == this.fontFamily &&
          other.fontSize == this.fontSize &&
          other.lineHeight == this.lineHeight &&
          other.horizontalPadding == this.horizontalPadding &&
          other.paragraphSpacing == this.paragraphSpacing &&
          other.textAlign == this.textAlign &&
          other.brightnessLock == this.brightnessLock &&
          other.updatedAt == this.updatedAt);
}

class ReaderPreferencesCompanion extends UpdateCompanion<ReaderPreference> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<String> backgroundColor;
  final Value<String> fontFamily;
  final Value<double> fontSize;
  final Value<double> lineHeight;
  final Value<double> horizontalPadding;
  final Value<double> paragraphSpacing;
  final Value<String> textAlign;
  final Value<String?> brightnessLock;
  final Value<int> updatedAt;
  const ReaderPreferencesCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.horizontalPadding = const Value.absent(),
    this.paragraphSpacing = const Value.absent(),
    this.textAlign = const Value.absent(),
    this.brightnessLock = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReaderPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.horizontalPadding = const Value.absent(),
    this.paragraphSpacing = const Value.absent(),
    this.textAlign = const Value.absent(),
    this.brightnessLock = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<ReaderPreference> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<String>? backgroundColor,
    Expression<String>? fontFamily,
    Expression<double>? fontSize,
    Expression<double>? lineHeight,
    Expression<double>? horizontalPadding,
    Expression<double>? paragraphSpacing,
    Expression<String>? textAlign,
    Expression<String>? brightnessLock,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (fontFamily != null) 'font_family': fontFamily,
      if (fontSize != null) 'font_size': fontSize,
      if (lineHeight != null) 'line_height': lineHeight,
      if (horizontalPadding != null) 'horizontal_padding': horizontalPadding,
      if (paragraphSpacing != null) 'paragraph_spacing': paragraphSpacing,
      if (textAlign != null) 'text_align': textAlign,
      if (brightnessLock != null) 'brightness_lock': brightnessLock,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReaderPreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<String>? backgroundColor,
    Value<String>? fontFamily,
    Value<double>? fontSize,
    Value<double>? lineHeight,
    Value<double>? horizontalPadding,
    Value<double>? paragraphSpacing,
    Value<String>? textAlign,
    Value<String?>? brightnessLock,
    Value<int>? updatedAt,
  }) {
    return ReaderPreferencesCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      textAlign: textAlign ?? this.textAlign,
      brightnessLock: brightnessLock ?? this.brightnessLock,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<String>(backgroundColor.value);
    }
    if (fontFamily.present) {
      map['font_family'] = Variable<String>(fontFamily.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (lineHeight.present) {
      map['line_height'] = Variable<double>(lineHeight.value);
    }
    if (horizontalPadding.present) {
      map['horizontal_padding'] = Variable<double>(horizontalPadding.value);
    }
    if (paragraphSpacing.present) {
      map['paragraph_spacing'] = Variable<double>(paragraphSpacing.value);
    }
    if (textAlign.present) {
      map['text_align'] = Variable<String>(textAlign.value);
    }
    if (brightnessLock.present) {
      map['brightness_lock'] = Variable<String>(brightnessLock.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReaderPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('fontSize: $fontSize, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('horizontalPadding: $horizontalPadding, ')
          ..write('paragraphSpacing: $paragraphSpacing, ')
          ..write('textAlign: $textAlign, ')
          ..write('brightnessLock: $brightnessLock, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BookReaderOverridesTable extends BookReaderOverrides
    with TableInfo<$BookReaderOverridesTable, BookReaderOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookReaderOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _fontFamilyMeta = const VerificationMeta(
    'fontFamily',
  );
  @override
  late final GeneratedColumn<String> fontFamily = GeneratedColumn<String>(
    'font_family',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
    'font_size',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lineHeightMeta = const VerificationMeta(
    'lineHeight',
  );
  @override
  late final GeneratedColumn<double> lineHeight = GeneratedColumn<double>(
    'line_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backgroundColorMeta = const VerificationMeta(
    'backgroundColor',
  );
  @override
  late final GeneratedColumn<String> backgroundColor = GeneratedColumn<String>(
    'background_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    fontFamily,
    fontSize,
    lineHeight,
    backgroundColor,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_reader_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookReaderOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('font_family')) {
      context.handle(
        _fontFamilyMeta,
        fontFamily.isAcceptableOrUnknown(data['font_family']!, _fontFamilyMeta),
      );
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    if (data.containsKey('line_height')) {
      context.handle(
        _lineHeightMeta,
        lineHeight.isAcceptableOrUnknown(data['line_height']!, _lineHeightMeta),
      );
    }
    if (data.containsKey('background_color')) {
      context.handle(
        _backgroundColorMeta,
        backgroundColor.isAcceptableOrUnknown(
          data['background_color']!,
          _backgroundColorMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookReaderOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookReaderOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      fontFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_family'],
      ),
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_size'],
      ),
      lineHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_height'],
      ),
      backgroundColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_color'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BookReaderOverridesTable createAlias(String alias) {
    return $BookReaderOverridesTable(attachedDatabase, alias);
  }
}

class BookReaderOverride extends DataClass
    implements Insertable<BookReaderOverride> {
  final String id;
  final String bookId;
  final String? fontFamily;
  final double? fontSize;
  final double? lineHeight;
  final String? backgroundColor;
  final int updatedAt;
  const BookReaderOverride({
    required this.id,
    required this.bookId,
    this.fontFamily,
    this.fontSize,
    this.lineHeight,
    this.backgroundColor,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    if (!nullToAbsent || fontFamily != null) {
      map['font_family'] = Variable<String>(fontFamily);
    }
    if (!nullToAbsent || fontSize != null) {
      map['font_size'] = Variable<double>(fontSize);
    }
    if (!nullToAbsent || lineHeight != null) {
      map['line_height'] = Variable<double>(lineHeight);
    }
    if (!nullToAbsent || backgroundColor != null) {
      map['background_color'] = Variable<String>(backgroundColor);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BookReaderOverridesCompanion toCompanion(bool nullToAbsent) {
    return BookReaderOverridesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      fontFamily: fontFamily == null && nullToAbsent
          ? const Value.absent()
          : Value(fontFamily),
      fontSize: fontSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fontSize),
      lineHeight: lineHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(lineHeight),
      backgroundColor: backgroundColor == null && nullToAbsent
          ? const Value.absent()
          : Value(backgroundColor),
      updatedAt: Value(updatedAt),
    );
  }

  factory BookReaderOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookReaderOverride(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      fontFamily: serializer.fromJson<String?>(json['fontFamily']),
      fontSize: serializer.fromJson<double?>(json['fontSize']),
      lineHeight: serializer.fromJson<double?>(json['lineHeight']),
      backgroundColor: serializer.fromJson<String?>(json['backgroundColor']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'fontFamily': serializer.toJson<String?>(fontFamily),
      'fontSize': serializer.toJson<double?>(fontSize),
      'lineHeight': serializer.toJson<double?>(lineHeight),
      'backgroundColor': serializer.toJson<String?>(backgroundColor),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BookReaderOverride copyWith({
    String? id,
    String? bookId,
    Value<String?> fontFamily = const Value.absent(),
    Value<double?> fontSize = const Value.absent(),
    Value<double?> lineHeight = const Value.absent(),
    Value<String?> backgroundColor = const Value.absent(),
    int? updatedAt,
  }) => BookReaderOverride(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    fontFamily: fontFamily.present ? fontFamily.value : this.fontFamily,
    fontSize: fontSize.present ? fontSize.value : this.fontSize,
    lineHeight: lineHeight.present ? lineHeight.value : this.lineHeight,
    backgroundColor: backgroundColor.present
        ? backgroundColor.value
        : this.backgroundColor,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BookReaderOverride copyWithCompanion(BookReaderOverridesCompanion data) {
    return BookReaderOverride(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      fontFamily: data.fontFamily.present
          ? data.fontFamily.value
          : this.fontFamily,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      lineHeight: data.lineHeight.present
          ? data.lineHeight.value
          : this.lineHeight,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookReaderOverride(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('fontSize: $fontSize, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    fontFamily,
    fontSize,
    lineHeight,
    backgroundColor,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookReaderOverride &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.fontFamily == this.fontFamily &&
          other.fontSize == this.fontSize &&
          other.lineHeight == this.lineHeight &&
          other.backgroundColor == this.backgroundColor &&
          other.updatedAt == this.updatedAt);
}

class BookReaderOverridesCompanion extends UpdateCompanion<BookReaderOverride> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String?> fontFamily;
  final Value<double?> fontSize;
  final Value<double?> lineHeight;
  final Value<String?> backgroundColor;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const BookReaderOverridesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookReaderOverridesCompanion.insert({
    required String id,
    required String bookId,
    this.fontFamily = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       updatedAt = Value(updatedAt);
  static Insertable<BookReaderOverride> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? fontFamily,
    Expression<double>? fontSize,
    Expression<double>? lineHeight,
    Expression<String>? backgroundColor,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (fontFamily != null) 'font_family': fontFamily,
      if (fontSize != null) 'font_size': fontSize,
      if (lineHeight != null) 'line_height': lineHeight,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookReaderOverridesCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String?>? fontFamily,
    Value<double?>? fontSize,
    Value<double?>? lineHeight,
    Value<String?>? backgroundColor,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return BookReaderOverridesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (fontFamily.present) {
      map['font_family'] = Variable<String>(fontFamily.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (lineHeight.present) {
      map['line_height'] = Variable<double>(lineHeight.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<String>(backgroundColor.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookReaderOverridesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('fontSize: $fontSize, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportRecordsTable extends ImportRecords
    with TableInfo<$ImportRecordsTable, ImportRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourcePathMeta = const VerificationMeta(
    'sourcePath',
  );
  @override
  late final GeneratedColumn<String> sourcePath = GeneratedColumn<String>(
    'source_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectedFormatMeta = const VerificationMeta(
    'detectedFormat',
  );
  @override
  late final GeneratedColumn<String> detectedFormat = GeneratedColumn<String>(
    'detected_format',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _charsetNameMeta = const VerificationMeta(
    'charsetName',
  );
  @override
  late final GeneratedColumn<String> charsetName = GeneratedColumn<String>(
    'charset_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _duplicateBookIdMeta = const VerificationMeta(
    'duplicateBookId',
  );
  @override
  late final GeneratedColumn<String> duplicateBookId = GeneratedColumn<String>(
    'duplicate_book_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdBookIdMeta = const VerificationMeta(
    'createdBookId',
  );
  @override
  late final GeneratedColumn<String> createdBookId = GeneratedColumn<String>(
    'created_book_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourcePath,
    fileName,
    fileHash,
    detectedFormat,
    charsetName,
    duplicateBookId,
    result,
    errorCode,
    errorMessage,
    createdBookId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_path')) {
      context.handle(
        _sourcePathMeta,
        sourcePath.isAcceptableOrUnknown(data['source_path']!, _sourcePathMeta),
      );
    } else if (isInserting) {
      context.missing(_sourcePathMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    if (data.containsKey('detected_format')) {
      context.handle(
        _detectedFormatMeta,
        detectedFormat.isAcceptableOrUnknown(
          data['detected_format']!,
          _detectedFormatMeta,
        ),
      );
    }
    if (data.containsKey('charset_name')) {
      context.handle(
        _charsetNameMeta,
        charsetName.isAcceptableOrUnknown(
          data['charset_name']!,
          _charsetNameMeta,
        ),
      );
    }
    if (data.containsKey('duplicate_book_id')) {
      context.handle(
        _duplicateBookIdMeta,
        duplicateBookId.isAcceptableOrUnknown(
          data['duplicate_book_id']!,
          _duplicateBookIdMeta,
        ),
      );
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_book_id')) {
      context.handle(
        _createdBookIdMeta,
        createdBookId.isAcceptableOrUnknown(
          data['created_book_id']!,
          _createdBookIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourcePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_path'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
      detectedFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detected_format'],
      ),
      charsetName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}charset_name'],
      ),
      duplicateBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duplicate_book_id'],
      ),
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_book_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ImportRecordsTable createAlias(String alias) {
    return $ImportRecordsTable(attachedDatabase, alias);
  }
}

class ImportRecord extends DataClass implements Insertable<ImportRecord> {
  final String id;
  final String sourcePath;
  final String fileName;
  final String? fileHash;
  final String? detectedFormat;
  final String? charsetName;
  final String? duplicateBookId;
  final String result;
  final String? errorCode;
  final String? errorMessage;
  final String? createdBookId;
  final int createdAt;
  const ImportRecord({
    required this.id,
    required this.sourcePath,
    required this.fileName,
    this.fileHash,
    this.detectedFormat,
    this.charsetName,
    this.duplicateBookId,
    required this.result,
    this.errorCode,
    this.errorMessage,
    this.createdBookId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_path'] = Variable<String>(sourcePath);
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    if (!nullToAbsent || detectedFormat != null) {
      map['detected_format'] = Variable<String>(detectedFormat);
    }
    if (!nullToAbsent || charsetName != null) {
      map['charset_name'] = Variable<String>(charsetName);
    }
    if (!nullToAbsent || duplicateBookId != null) {
      map['duplicate_book_id'] = Variable<String>(duplicateBookId);
    }
    map['result'] = Variable<String>(result);
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || createdBookId != null) {
      map['created_book_id'] = Variable<String>(createdBookId);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ImportRecordsCompanion toCompanion(bool nullToAbsent) {
    return ImportRecordsCompanion(
      id: Value(id),
      sourcePath: Value(sourcePath),
      fileName: Value(fileName),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
      detectedFormat: detectedFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(detectedFormat),
      charsetName: charsetName == null && nullToAbsent
          ? const Value.absent()
          : Value(charsetName),
      duplicateBookId: duplicateBookId == null && nullToAbsent
          ? const Value.absent()
          : Value(duplicateBookId),
      result: Value(result),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdBookId: createdBookId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBookId),
      createdAt: Value(createdAt),
    );
  }

  factory ImportRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportRecord(
      id: serializer.fromJson<String>(json['id']),
      sourcePath: serializer.fromJson<String>(json['sourcePath']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
      detectedFormat: serializer.fromJson<String?>(json['detectedFormat']),
      charsetName: serializer.fromJson<String?>(json['charsetName']),
      duplicateBookId: serializer.fromJson<String?>(json['duplicateBookId']),
      result: serializer.fromJson<String>(json['result']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdBookId: serializer.fromJson<String?>(json['createdBookId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourcePath': serializer.toJson<String>(sourcePath),
      'fileName': serializer.toJson<String>(fileName),
      'fileHash': serializer.toJson<String?>(fileHash),
      'detectedFormat': serializer.toJson<String?>(detectedFormat),
      'charsetName': serializer.toJson<String?>(charsetName),
      'duplicateBookId': serializer.toJson<String?>(duplicateBookId),
      'result': serializer.toJson<String>(result),
      'errorCode': serializer.toJson<String?>(errorCode),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdBookId': serializer.toJson<String?>(createdBookId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ImportRecord copyWith({
    String? id,
    String? sourcePath,
    String? fileName,
    Value<String?> fileHash = const Value.absent(),
    Value<String?> detectedFormat = const Value.absent(),
    Value<String?> charsetName = const Value.absent(),
    Value<String?> duplicateBookId = const Value.absent(),
    String? result,
    Value<String?> errorCode = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    Value<String?> createdBookId = const Value.absent(),
    int? createdAt,
  }) => ImportRecord(
    id: id ?? this.id,
    sourcePath: sourcePath ?? this.sourcePath,
    fileName: fileName ?? this.fileName,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
    detectedFormat: detectedFormat.present
        ? detectedFormat.value
        : this.detectedFormat,
    charsetName: charsetName.present ? charsetName.value : this.charsetName,
    duplicateBookId: duplicateBookId.present
        ? duplicateBookId.value
        : this.duplicateBookId,
    result: result ?? this.result,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdBookId: createdBookId.present
        ? createdBookId.value
        : this.createdBookId,
    createdAt: createdAt ?? this.createdAt,
  );
  ImportRecord copyWithCompanion(ImportRecordsCompanion data) {
    return ImportRecord(
      id: data.id.present ? data.id.value : this.id,
      sourcePath: data.sourcePath.present
          ? data.sourcePath.value
          : this.sourcePath,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      detectedFormat: data.detectedFormat.present
          ? data.detectedFormat.value
          : this.detectedFormat,
      charsetName: data.charsetName.present
          ? data.charsetName.value
          : this.charsetName,
      duplicateBookId: data.duplicateBookId.present
          ? data.duplicateBookId.value
          : this.duplicateBookId,
      result: data.result.present ? data.result.value : this.result,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdBookId: data.createdBookId.present
          ? data.createdBookId.value
          : this.createdBookId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportRecord(')
          ..write('id: $id, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('fileName: $fileName, ')
          ..write('fileHash: $fileHash, ')
          ..write('detectedFormat: $detectedFormat, ')
          ..write('charsetName: $charsetName, ')
          ..write('duplicateBookId: $duplicateBookId, ')
          ..write('result: $result, ')
          ..write('errorCode: $errorCode, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdBookId: $createdBookId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourcePath,
    fileName,
    fileHash,
    detectedFormat,
    charsetName,
    duplicateBookId,
    result,
    errorCode,
    errorMessage,
    createdBookId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportRecord &&
          other.id == this.id &&
          other.sourcePath == this.sourcePath &&
          other.fileName == this.fileName &&
          other.fileHash == this.fileHash &&
          other.detectedFormat == this.detectedFormat &&
          other.charsetName == this.charsetName &&
          other.duplicateBookId == this.duplicateBookId &&
          other.result == this.result &&
          other.errorCode == this.errorCode &&
          other.errorMessage == this.errorMessage &&
          other.createdBookId == this.createdBookId &&
          other.createdAt == this.createdAt);
}

class ImportRecordsCompanion extends UpdateCompanion<ImportRecord> {
  final Value<String> id;
  final Value<String> sourcePath;
  final Value<String> fileName;
  final Value<String?> fileHash;
  final Value<String?> detectedFormat;
  final Value<String?> charsetName;
  final Value<String?> duplicateBookId;
  final Value<String> result;
  final Value<String?> errorCode;
  final Value<String?> errorMessage;
  final Value<String?> createdBookId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ImportRecordsCompanion({
    this.id = const Value.absent(),
    this.sourcePath = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.detectedFormat = const Value.absent(),
    this.charsetName = const Value.absent(),
    this.duplicateBookId = const Value.absent(),
    this.result = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdBookId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportRecordsCompanion.insert({
    required String id,
    required String sourcePath,
    required String fileName,
    this.fileHash = const Value.absent(),
    this.detectedFormat = const Value.absent(),
    this.charsetName = const Value.absent(),
    this.duplicateBookId = const Value.absent(),
    required String result,
    this.errorCode = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdBookId = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourcePath = Value(sourcePath),
       fileName = Value(fileName),
       result = Value(result),
       createdAt = Value(createdAt);
  static Insertable<ImportRecord> custom({
    Expression<String>? id,
    Expression<String>? sourcePath,
    Expression<String>? fileName,
    Expression<String>? fileHash,
    Expression<String>? detectedFormat,
    Expression<String>? charsetName,
    Expression<String>? duplicateBookId,
    Expression<String>? result,
    Expression<String>? errorCode,
    Expression<String>? errorMessage,
    Expression<String>? createdBookId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourcePath != null) 'source_path': sourcePath,
      if (fileName != null) 'file_name': fileName,
      if (fileHash != null) 'file_hash': fileHash,
      if (detectedFormat != null) 'detected_format': detectedFormat,
      if (charsetName != null) 'charset_name': charsetName,
      if (duplicateBookId != null) 'duplicate_book_id': duplicateBookId,
      if (result != null) 'result': result,
      if (errorCode != null) 'error_code': errorCode,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdBookId != null) 'created_book_id': createdBookId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourcePath,
    Value<String>? fileName,
    Value<String?>? fileHash,
    Value<String?>? detectedFormat,
    Value<String?>? charsetName,
    Value<String?>? duplicateBookId,
    Value<String>? result,
    Value<String?>? errorCode,
    Value<String?>? errorMessage,
    Value<String?>? createdBookId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ImportRecordsCompanion(
      id: id ?? this.id,
      sourcePath: sourcePath ?? this.sourcePath,
      fileName: fileName ?? this.fileName,
      fileHash: fileHash ?? this.fileHash,
      detectedFormat: detectedFormat ?? this.detectedFormat,
      charsetName: charsetName ?? this.charsetName,
      duplicateBookId: duplicateBookId ?? this.duplicateBookId,
      result: result ?? this.result,
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      createdBookId: createdBookId ?? this.createdBookId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourcePath.present) {
      map['source_path'] = Variable<String>(sourcePath.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (detectedFormat.present) {
      map['detected_format'] = Variable<String>(detectedFormat.value);
    }
    if (charsetName.present) {
      map['charset_name'] = Variable<String>(charsetName.value);
    }
    if (duplicateBookId.present) {
      map['duplicate_book_id'] = Variable<String>(duplicateBookId.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdBookId.present) {
      map['created_book_id'] = Variable<String>(createdBookId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('fileName: $fileName, ')
          ..write('fileHash: $fileHash, ')
          ..write('detectedFormat: $detectedFormat, ')
          ..write('charsetName: $charsetName, ')
          ..write('duplicateBookId: $duplicateBookId, ')
          ..write('result: $result, ')
          ..write('errorCode: $errorCode, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdBookId: $createdBookId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $BookChaptersTable bookChapters = $BookChaptersTable(this);
  late final $ReadingProgressTable readingProgress = $ReadingProgressTable(
    this,
  );
  late final $ReaderPreferencesTable readerPreferences =
      $ReaderPreferencesTable(this);
  late final $BookReaderOverridesTable bookReaderOverrides =
      $BookReaderOverridesTable(this);
  late final $ImportRecordsTable importRecords = $ImportRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    books,
    bookChapters,
    readingProgress,
    readerPreferences,
    bookReaderOverrides,
    importRecords,
  ];
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      required String id,
      required String format,
      required String title,
      Value<String> author,
      Value<String?> description,
      required String sourceFilePath,
      required String localFilePath,
      required String fileName,
      required String fileExt,
      required int fileSize,
      required String fileHash,
      Value<String?> mimeType,
      Value<String?> coverImagePath,
      Value<String?> coverSourceType,
      Value<String?> charsetName,
      Value<String?> language,
      Value<int> totalChapters,
      Value<int?> totalWords,
      Value<bool> isFavorite,
      Value<int?> pinnedAt,
      Value<String> importStatus,
      Value<int> parseVersion,
      required int createdAt,
      required int updatedAt,
      Value<int?> lastReadAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<String> id,
      Value<String> format,
      Value<String> title,
      Value<String> author,
      Value<String?> description,
      Value<String> sourceFilePath,
      Value<String> localFilePath,
      Value<String> fileName,
      Value<String> fileExt,
      Value<int> fileSize,
      Value<String> fileHash,
      Value<String?> mimeType,
      Value<String?> coverImagePath,
      Value<String?> coverSourceType,
      Value<String?> charsetName,
      Value<String?> language,
      Value<int> totalChapters,
      Value<int?> totalWords,
      Value<bool> isFavorite,
      Value<int?> pinnedAt,
      Value<String> importStatus,
      Value<int> parseVersion,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> lastReadAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, Book> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BookChaptersTable, List<BookChapter>>
  _bookChaptersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookChapters,
    aliasName: $_aliasNameGenerator(db.books.id, db.bookChapters.bookId),
  );

  $$BookChaptersTableProcessedTableManager get bookChaptersRefs {
    final manager = $$BookChaptersTableTableManager(
      $_db,
      $_db.bookChapters,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookChaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingProgressTable, List<ReadingProgressData>>
  _readingProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingProgress,
    aliasName: $_aliasNameGenerator(db.books.id, db.readingProgress.bookId),
  );

  $$ReadingProgressTableProcessedTableManager get readingProgressRefs {
    final manager = $$ReadingProgressTableTableManager(
      $_db,
      $_db.readingProgress,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BookReaderOverridesTable,
    List<BookReaderOverride>
  >
  _bookReaderOverridesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bookReaderOverrides,
        aliasName: $_aliasNameGenerator(
          db.books.id,
          db.bookReaderOverrides.bookId,
        ),
      );

  $$BookReaderOverridesTableProcessedTableManager get bookReaderOverridesRefs {
    final manager = $$BookReaderOverridesTableTableManager(
      $_db,
      $_db.bookReaderOverrides,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bookReaderOverridesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ImportRecordsTable, List<ImportRecord>>
  _duplicateImportRecordRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.importRecords,
        aliasName: $_aliasNameGenerator(
          db.books.id,
          db.importRecords.duplicateBookId,
        ),
      );

  $$ImportRecordsTableProcessedTableManager get duplicateImportRecordRefs {
    final manager = $$ImportRecordsTableTableManager($_db, $_db.importRecords)
        .filter(
          (f) => f.duplicateBookId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _duplicateImportRecordRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ImportRecordsTable, List<ImportRecord>>
  _createdImportRecordRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.importRecords,
        aliasName: $_aliasNameGenerator(
          db.books.id,
          db.importRecords.createdBookId,
        ),
      );

  $$ImportRecordsTableProcessedTableManager get createdImportRecordRefs {
    final manager = $$ImportRecordsTableTableManager(
      $_db,
      $_db.importRecords,
    ).filter((f) => f.createdBookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _createdImportRecordRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileExt => $composableBuilder(
    column: $table.fileExt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverSourceType => $composableBuilder(
    column: $table.coverSourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get charsetName => $composableBuilder(
    column: $table.charsetName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalChapters => $composableBuilder(
    column: $table.totalChapters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalWords => $composableBuilder(
    column: $table.totalWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinnedAt => $composableBuilder(
    column: $table.pinnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importStatus => $composableBuilder(
    column: $table.importStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parseVersion => $composableBuilder(
    column: $table.parseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bookChaptersRefs(
    Expression<bool> Function($$BookChaptersTableFilterComposer f) f,
  ) {
    final $$BookChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookChapters,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookChaptersTableFilterComposer(
            $db: $db,
            $table: $db.bookChapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingProgressRefs(
    Expression<bool> Function($$ReadingProgressTableFilterComposer f) f,
  ) {
    final $$ReadingProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableFilterComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookReaderOverridesRefs(
    Expression<bool> Function($$BookReaderOverridesTableFilterComposer f) f,
  ) {
    final $$BookReaderOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookReaderOverrides,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookReaderOverridesTableFilterComposer(
            $db: $db,
            $table: $db.bookReaderOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> duplicateImportRecordRefs(
    Expression<bool> Function($$ImportRecordsTableFilterComposer f) f,
  ) {
    final $$ImportRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importRecords,
      getReferencedColumn: (t) => t.duplicateBookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportRecordsTableFilterComposer(
            $db: $db,
            $table: $db.importRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> createdImportRecordRefs(
    Expression<bool> Function($$ImportRecordsTableFilterComposer f) f,
  ) {
    final $$ImportRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importRecords,
      getReferencedColumn: (t) => t.createdBookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportRecordsTableFilterComposer(
            $db: $db,
            $table: $db.importRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileExt => $composableBuilder(
    column: $table.fileExt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverSourceType => $composableBuilder(
    column: $table.coverSourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get charsetName => $composableBuilder(
    column: $table.charsetName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalChapters => $composableBuilder(
    column: $table.totalChapters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalWords => $composableBuilder(
    column: $table.totalWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinnedAt => $composableBuilder(
    column: $table.pinnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importStatus => $composableBuilder(
    column: $table.importStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parseVersion => $composableBuilder(
    column: $table.parseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceFilePath => $composableBuilder(
    column: $table.sourceFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileExt =>
      $composableBuilder(column: $table.fileExt, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverSourceType => $composableBuilder(
    column: $table.coverSourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get charsetName => $composableBuilder(
    column: $table.charsetName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get totalChapters => $composableBuilder(
    column: $table.totalChapters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalWords => $composableBuilder(
    column: $table.totalWords,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pinnedAt =>
      $composableBuilder(column: $table.pinnedAt, builder: (column) => column);

  GeneratedColumn<String> get importStatus => $composableBuilder(
    column: $table.importStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parseVersion => $composableBuilder(
    column: $table.parseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> bookChaptersRefs<T extends Object>(
    Expression<T> Function($$BookChaptersTableAnnotationComposer a) f,
  ) {
    final $$BookChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookChapters,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.bookChapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingProgressRefs<T extends Object>(
    Expression<T> Function($$ReadingProgressTableAnnotationComposer a) f,
  ) {
    final $$ReadingProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookReaderOverridesRefs<T extends Object>(
    Expression<T> Function($$BookReaderOverridesTableAnnotationComposer a) f,
  ) {
    final $$BookReaderOverridesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bookReaderOverrides,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BookReaderOverridesTableAnnotationComposer(
                $db: $db,
                $table: $db.bookReaderOverrides,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> duplicateImportRecordRefs<T extends Object>(
    Expression<T> Function($$ImportRecordsTableAnnotationComposer a) f,
  ) {
    final $$ImportRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importRecords,
      getReferencedColumn: (t) => t.duplicateBookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.importRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> createdImportRecordRefs<T extends Object>(
    Expression<T> Function($$ImportRecordsTableAnnotationComposer a) f,
  ) {
    final $$ImportRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.importRecords,
      getReferencedColumn: (t) => t.createdBookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.importRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, $$BooksTableReferences),
          Book,
          PrefetchHooks Function({
            bool bookChaptersRefs,
            bool readingProgressRefs,
            bool bookReaderOverridesRefs,
            bool duplicateImportRecordRefs,
            bool createdImportRecordRefs,
          })
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> sourceFilePath = const Value.absent(),
                Value<String> localFilePath = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> fileExt = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<String?> coverImagePath = const Value.absent(),
                Value<String?> coverSourceType = const Value.absent(),
                Value<String?> charsetName = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<int> totalChapters = const Value.absent(),
                Value<int?> totalWords = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> pinnedAt = const Value.absent(),
                Value<String> importStatus = const Value.absent(),
                Value<int> parseVersion = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> lastReadAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                format: format,
                title: title,
                author: author,
                description: description,
                sourceFilePath: sourceFilePath,
                localFilePath: localFilePath,
                fileName: fileName,
                fileExt: fileExt,
                fileSize: fileSize,
                fileHash: fileHash,
                mimeType: mimeType,
                coverImagePath: coverImagePath,
                coverSourceType: coverSourceType,
                charsetName: charsetName,
                language: language,
                totalChapters: totalChapters,
                totalWords: totalWords,
                isFavorite: isFavorite,
                pinnedAt: pinnedAt,
                importStatus: importStatus,
                parseVersion: parseVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastReadAt: lastReadAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String format,
                required String title,
                Value<String> author = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required String sourceFilePath,
                required String localFilePath,
                required String fileName,
                required String fileExt,
                required int fileSize,
                required String fileHash,
                Value<String?> mimeType = const Value.absent(),
                Value<String?> coverImagePath = const Value.absent(),
                Value<String?> coverSourceType = const Value.absent(),
                Value<String?> charsetName = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<int> totalChapters = const Value.absent(),
                Value<int?> totalWords = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int?> pinnedAt = const Value.absent(),
                Value<String> importStatus = const Value.absent(),
                Value<int> parseVersion = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> lastReadAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                format: format,
                title: title,
                author: author,
                description: description,
                sourceFilePath: sourceFilePath,
                localFilePath: localFilePath,
                fileName: fileName,
                fileExt: fileExt,
                fileSize: fileSize,
                fileHash: fileHash,
                mimeType: mimeType,
                coverImagePath: coverImagePath,
                coverSourceType: coverSourceType,
                charsetName: charsetName,
                language: language,
                totalChapters: totalChapters,
                totalWords: totalWords,
                isFavorite: isFavorite,
                pinnedAt: pinnedAt,
                importStatus: importStatus,
                parseVersion: parseVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastReadAt: lastReadAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BooksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bookChaptersRefs = false,
                readingProgressRefs = false,
                bookReaderOverridesRefs = false,
                duplicateImportRecordRefs = false,
                createdImportRecordRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bookChaptersRefs) db.bookChapters,
                    if (readingProgressRefs) db.readingProgress,
                    if (bookReaderOverridesRefs) db.bookReaderOverrides,
                    if (duplicateImportRecordRefs) db.importRecords,
                    if (createdImportRecordRefs) db.importRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bookChaptersRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          BookChapter
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._bookChaptersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).bookChaptersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingProgressRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ReadingProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookReaderOverridesRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          BookReaderOverride
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._bookReaderOverridesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).bookReaderOverridesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (duplicateImportRecordRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ImportRecord
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._duplicateImportRecordRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).duplicateImportRecordRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.duplicateBookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (createdImportRecordRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ImportRecord
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._createdImportRecordRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).createdImportRecordRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.createdBookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, $$BooksTableReferences),
      Book,
      PrefetchHooks Function({
        bool bookChaptersRefs,
        bool readingProgressRefs,
        bool bookReaderOverridesRefs,
        bool duplicateImportRecordRefs,
        bool createdImportRecordRefs,
      })
    >;
typedef $$BookChaptersTableCreateCompanionBuilder =
    BookChaptersCompanion Function({
      required String id,
      required String bookId,
      required int chapterIndex,
      required String title,
      required String sourceType,
      Value<String?> href,
      Value<String?> anchor,
      Value<int?> startOffset,
      Value<int?> endOffset,
      Value<String?> plainText,
      Value<String?> htmlContent,
      Value<int?> wordCount,
      Value<int> level,
      Value<String?> parentId,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$BookChaptersTableUpdateCompanionBuilder =
    BookChaptersCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<int> chapterIndex,
      Value<String> title,
      Value<String> sourceType,
      Value<String?> href,
      Value<String?> anchor,
      Value<int?> startOffset,
      Value<int?> endOffset,
      Value<String?> plainText,
      Value<String?> htmlContent,
      Value<int?> wordCount,
      Value<int> level,
      Value<String?> parentId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$BookChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $BookChaptersTable, BookChapter> {
  $$BookChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.bookChapters.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $BookChaptersTable> {
  $$BookChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get href => $composableBuilder(
    column: $table.href,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchor => $composableBuilder(
    column: $table.anchor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plainText => $composableBuilder(
    column: $table.plainText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $BookChaptersTable> {
  $$BookChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get href => $composableBuilder(
    column: $table.href,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchor => $composableBuilder(
    column: $table.anchor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endOffset => $composableBuilder(
    column: $table.endOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plainText => $composableBuilder(
    column: $table.plainText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookChaptersTable> {
  $$BookChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get chapterIndex => $composableBuilder(
    column: $table.chapterIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get href =>
      $composableBuilder(column: $table.href, builder: (column) => column);

  GeneratedColumn<String> get anchor =>
      $composableBuilder(column: $table.anchor, builder: (column) => column);

  GeneratedColumn<int> get startOffset => $composableBuilder(
    column: $table.startOffset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endOffset =>
      $composableBuilder(column: $table.endOffset, builder: (column) => column);

  GeneratedColumn<String> get plainText =>
      $composableBuilder(column: $table.plainText, builder: (column) => column);

  GeneratedColumn<String> get htmlContent => $composableBuilder(
    column: $table.htmlContent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookChaptersTable,
          BookChapter,
          $$BookChaptersTableFilterComposer,
          $$BookChaptersTableOrderingComposer,
          $$BookChaptersTableAnnotationComposer,
          $$BookChaptersTableCreateCompanionBuilder,
          $$BookChaptersTableUpdateCompanionBuilder,
          (BookChapter, $$BookChaptersTableReferences),
          BookChapter,
          PrefetchHooks Function({bool bookId})
        > {
  $$BookChaptersTableTableManager(_$AppDatabase db, $BookChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<int> chapterIndex = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> href = const Value.absent(),
                Value<String?> anchor = const Value.absent(),
                Value<int?> startOffset = const Value.absent(),
                Value<int?> endOffset = const Value.absent(),
                Value<String?> plainText = const Value.absent(),
                Value<String?> htmlContent = const Value.absent(),
                Value<int?> wordCount = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookChaptersCompanion(
                id: id,
                bookId: bookId,
                chapterIndex: chapterIndex,
                title: title,
                sourceType: sourceType,
                href: href,
                anchor: anchor,
                startOffset: startOffset,
                endOffset: endOffset,
                plainText: plainText,
                htmlContent: htmlContent,
                wordCount: wordCount,
                level: level,
                parentId: parentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required int chapterIndex,
                required String title,
                required String sourceType,
                Value<String?> href = const Value.absent(),
                Value<String?> anchor = const Value.absent(),
                Value<int?> startOffset = const Value.absent(),
                Value<int?> endOffset = const Value.absent(),
                Value<String?> plainText = const Value.absent(),
                Value<String?> htmlContent = const Value.absent(),
                Value<int?> wordCount = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BookChaptersCompanion.insert(
                id: id,
                bookId: bookId,
                chapterIndex: chapterIndex,
                title: title,
                sourceType: sourceType,
                href: href,
                anchor: anchor,
                startOffset: startOffset,
                endOffset: endOffset,
                plainText: plainText,
                htmlContent: htmlContent,
                wordCount: wordCount,
                level: level,
                parentId: parentId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$BookChaptersTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$BookChaptersTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookChaptersTable,
      BookChapter,
      $$BookChaptersTableFilterComposer,
      $$BookChaptersTableOrderingComposer,
      $$BookChaptersTableAnnotationComposer,
      $$BookChaptersTableCreateCompanionBuilder,
      $$BookChaptersTableUpdateCompanionBuilder,
      (BookChapter, $$BookChaptersTableReferences),
      BookChapter,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$ReadingProgressTableCreateCompanionBuilder =
    ReadingProgressCompanion Function({
      required String id,
      required String bookId,
      Value<int> currentChapterIndex,
      Value<int?> chapterOffset,
      Value<double?> scrollOffset,
      Value<double> progressPercent,
      Value<String> locatorType,
      Value<String?> locatorValue,
      Value<int?> startedAt,
      required int lastReadAt,
      Value<int> totalReadingMinutes,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ReadingProgressTableUpdateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<int> currentChapterIndex,
      Value<int?> chapterOffset,
      Value<double?> scrollOffset,
      Value<double> progressPercent,
      Value<String> locatorType,
      Value<String?> locatorValue,
      Value<int?> startedAt,
      Value<int> lastReadAt,
      Value<int> totalReadingMinutes,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ReadingProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressData
        > {
  $$ReadingProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.readingProgress.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentChapterIndex => $composableBuilder(
    column: $table.currentChapterIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterOffset => $composableBuilder(
    column: $table.chapterOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locatorType => $composableBuilder(
    column: $table.locatorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locatorValue => $composableBuilder(
    column: $table.locatorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReadingMinutes => $composableBuilder(
    column: $table.totalReadingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentChapterIndex => $composableBuilder(
    column: $table.currentChapterIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterOffset => $composableBuilder(
    column: $table.chapterOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locatorType => $composableBuilder(
    column: $table.locatorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locatorValue => $composableBuilder(
    column: $table.locatorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReadingMinutes => $composableBuilder(
    column: $table.totalReadingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentChapterIndex => $composableBuilder(
    column: $table.currentChapterIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chapterOffset => $composableBuilder(
    column: $table.chapterOffset,
    builder: (column) => column,
  );

  GeneratedColumn<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => column,
  );

  GeneratedColumn<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locatorType => $composableBuilder(
    column: $table.locatorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locatorValue => $composableBuilder(
    column: $table.locatorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalReadingMinutes => $composableBuilder(
    column: $table.totalReadingMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressData,
          $$ReadingProgressTableFilterComposer,
          $$ReadingProgressTableOrderingComposer,
          $$ReadingProgressTableAnnotationComposer,
          $$ReadingProgressTableCreateCompanionBuilder,
          $$ReadingProgressTableUpdateCompanionBuilder,
          (ReadingProgressData, $$ReadingProgressTableReferences),
          ReadingProgressData,
          PrefetchHooks Function({bool bookId})
        > {
  $$ReadingProgressTableTableManager(
    _$AppDatabase db,
    $ReadingProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<int> currentChapterIndex = const Value.absent(),
                Value<int?> chapterOffset = const Value.absent(),
                Value<double?> scrollOffset = const Value.absent(),
                Value<double> progressPercent = const Value.absent(),
                Value<String> locatorType = const Value.absent(),
                Value<String?> locatorValue = const Value.absent(),
                Value<int?> startedAt = const Value.absent(),
                Value<int> lastReadAt = const Value.absent(),
                Value<int> totalReadingMinutes = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressCompanion(
                id: id,
                bookId: bookId,
                currentChapterIndex: currentChapterIndex,
                chapterOffset: chapterOffset,
                scrollOffset: scrollOffset,
                progressPercent: progressPercent,
                locatorType: locatorType,
                locatorValue: locatorValue,
                startedAt: startedAt,
                lastReadAt: lastReadAt,
                totalReadingMinutes: totalReadingMinutes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                Value<int> currentChapterIndex = const Value.absent(),
                Value<int?> chapterOffset = const Value.absent(),
                Value<double?> scrollOffset = const Value.absent(),
                Value<double> progressPercent = const Value.absent(),
                Value<String> locatorType = const Value.absent(),
                Value<String?> locatorValue = const Value.absent(),
                Value<int?> startedAt = const Value.absent(),
                required int lastReadAt,
                Value<int> totalReadingMinutes = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressCompanion.insert(
                id: id,
                bookId: bookId,
                currentChapterIndex: currentChapterIndex,
                chapterOffset: chapterOffset,
                scrollOffset: scrollOffset,
                progressPercent: progressPercent,
                locatorType: locatorType,
                locatorValue: locatorValue,
                startedAt: startedAt,
                lastReadAt: lastReadAt,
                totalReadingMinutes: totalReadingMinutes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$ReadingProgressTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$ReadingProgressTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingProgressTable,
      ReadingProgressData,
      $$ReadingProgressTableFilterComposer,
      $$ReadingProgressTableOrderingComposer,
      $$ReadingProgressTableAnnotationComposer,
      $$ReadingProgressTableCreateCompanionBuilder,
      $$ReadingProgressTableUpdateCompanionBuilder,
      (ReadingProgressData, $$ReadingProgressTableReferences),
      ReadingProgressData,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$ReaderPreferencesTableCreateCompanionBuilder =
    ReaderPreferencesCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> backgroundColor,
      Value<String> fontFamily,
      Value<double> fontSize,
      Value<double> lineHeight,
      Value<double> horizontalPadding,
      Value<double> paragraphSpacing,
      Value<String> textAlign,
      Value<String?> brightnessLock,
      required int updatedAt,
    });
typedef $$ReaderPreferencesTableUpdateCompanionBuilder =
    ReaderPreferencesCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> backgroundColor,
      Value<String> fontFamily,
      Value<double> fontSize,
      Value<double> lineHeight,
      Value<double> horizontalPadding,
      Value<double> paragraphSpacing,
      Value<String> textAlign,
      Value<String?> brightnessLock,
      Value<int> updatedAt,
    });

class $$ReaderPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get horizontalPadding => $composableBuilder(
    column: $table.horizontalPadding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paragraphSpacing => $composableBuilder(
    column: $table.paragraphSpacing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textAlign => $composableBuilder(
    column: $table.textAlign,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brightnessLock => $composableBuilder(
    column: $table.brightnessLock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReaderPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get horizontalPadding => $composableBuilder(
    column: $table.horizontalPadding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paragraphSpacing => $composableBuilder(
    column: $table.paragraphSpacing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textAlign => $composableBuilder(
    column: $table.textAlign,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brightnessLock => $composableBuilder(
    column: $table.brightnessLock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReaderPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  GeneratedColumn<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get horizontalPadding => $composableBuilder(
    column: $table.horizontalPadding,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paragraphSpacing => $composableBuilder(
    column: $table.paragraphSpacing,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textAlign =>
      $composableBuilder(column: $table.textAlign, builder: (column) => column);

  GeneratedColumn<String> get brightnessLock => $composableBuilder(
    column: $table.brightnessLock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReaderPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReaderPreferencesTable,
          ReaderPreference,
          $$ReaderPreferencesTableFilterComposer,
          $$ReaderPreferencesTableOrderingComposer,
          $$ReaderPreferencesTableAnnotationComposer,
          $$ReaderPreferencesTableCreateCompanionBuilder,
          $$ReaderPreferencesTableUpdateCompanionBuilder,
          (
            ReaderPreference,
            BaseReferences<
              _$AppDatabase,
              $ReaderPreferencesTable,
              ReaderPreference
            >,
          ),
          ReaderPreference,
          PrefetchHooks Function()
        > {
  $$ReaderPreferencesTableTableManager(
    _$AppDatabase db,
    $ReaderPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReaderPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReaderPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReaderPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> backgroundColor = const Value.absent(),
                Value<String> fontFamily = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<double> lineHeight = const Value.absent(),
                Value<double> horizontalPadding = const Value.absent(),
                Value<double> paragraphSpacing = const Value.absent(),
                Value<String> textAlign = const Value.absent(),
                Value<String?> brightnessLock = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => ReaderPreferencesCompanion(
                id: id,
                themeMode: themeMode,
                backgroundColor: backgroundColor,
                fontFamily: fontFamily,
                fontSize: fontSize,
                lineHeight: lineHeight,
                horizontalPadding: horizontalPadding,
                paragraphSpacing: paragraphSpacing,
                textAlign: textAlign,
                brightnessLock: brightnessLock,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> backgroundColor = const Value.absent(),
                Value<String> fontFamily = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<double> lineHeight = const Value.absent(),
                Value<double> horizontalPadding = const Value.absent(),
                Value<double> paragraphSpacing = const Value.absent(),
                Value<String> textAlign = const Value.absent(),
                Value<String?> brightnessLock = const Value.absent(),
                required int updatedAt,
              }) => ReaderPreferencesCompanion.insert(
                id: id,
                themeMode: themeMode,
                backgroundColor: backgroundColor,
                fontFamily: fontFamily,
                fontSize: fontSize,
                lineHeight: lineHeight,
                horizontalPadding: horizontalPadding,
                paragraphSpacing: paragraphSpacing,
                textAlign: textAlign,
                brightnessLock: brightnessLock,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReaderPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReaderPreferencesTable,
      ReaderPreference,
      $$ReaderPreferencesTableFilterComposer,
      $$ReaderPreferencesTableOrderingComposer,
      $$ReaderPreferencesTableAnnotationComposer,
      $$ReaderPreferencesTableCreateCompanionBuilder,
      $$ReaderPreferencesTableUpdateCompanionBuilder,
      (
        ReaderPreference,
        BaseReferences<
          _$AppDatabase,
          $ReaderPreferencesTable,
          ReaderPreference
        >,
      ),
      ReaderPreference,
      PrefetchHooks Function()
    >;
typedef $$BookReaderOverridesTableCreateCompanionBuilder =
    BookReaderOverridesCompanion Function({
      required String id,
      required String bookId,
      Value<String?> fontFamily,
      Value<double?> fontSize,
      Value<double?> lineHeight,
      Value<String?> backgroundColor,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$BookReaderOverridesTableUpdateCompanionBuilder =
    BookReaderOverridesCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String?> fontFamily,
      Value<double?> fontSize,
      Value<double?> lineHeight,
      Value<String?> backgroundColor,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$BookReaderOverridesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BookReaderOverridesTable,
          BookReaderOverride
        > {
  $$BookReaderOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) => db.books.createAlias(
    $_aliasNameGenerator(db.bookReaderOverrides.bookId, db.books.id),
  );

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookReaderOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $BookReaderOverridesTable> {
  $$BookReaderOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookReaderOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $BookReaderOverridesTable> {
  $$BookReaderOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookReaderOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookReaderOverridesTable> {
  $$BookReaderOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  GeneratedColumn<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookReaderOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookReaderOverridesTable,
          BookReaderOverride,
          $$BookReaderOverridesTableFilterComposer,
          $$BookReaderOverridesTableOrderingComposer,
          $$BookReaderOverridesTableAnnotationComposer,
          $$BookReaderOverridesTableCreateCompanionBuilder,
          $$BookReaderOverridesTableUpdateCompanionBuilder,
          (BookReaderOverride, $$BookReaderOverridesTableReferences),
          BookReaderOverride,
          PrefetchHooks Function({bool bookId})
        > {
  $$BookReaderOverridesTableTableManager(
    _$AppDatabase db,
    $BookReaderOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookReaderOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookReaderOverridesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BookReaderOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String?> fontFamily = const Value.absent(),
                Value<double?> fontSize = const Value.absent(),
                Value<double?> lineHeight = const Value.absent(),
                Value<String?> backgroundColor = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookReaderOverridesCompanion(
                id: id,
                bookId: bookId,
                fontFamily: fontFamily,
                fontSize: fontSize,
                lineHeight: lineHeight,
                backgroundColor: backgroundColor,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                Value<String?> fontFamily = const Value.absent(),
                Value<double?> fontSize = const Value.absent(),
                Value<double?> lineHeight = const Value.absent(),
                Value<String?> backgroundColor = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BookReaderOverridesCompanion.insert(
                id: id,
                bookId: bookId,
                fontFamily: fontFamily,
                fontSize: fontSize,
                lineHeight: lineHeight,
                backgroundColor: backgroundColor,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookReaderOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$BookReaderOverridesTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$BookReaderOverridesTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookReaderOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookReaderOverridesTable,
      BookReaderOverride,
      $$BookReaderOverridesTableFilterComposer,
      $$BookReaderOverridesTableOrderingComposer,
      $$BookReaderOverridesTableAnnotationComposer,
      $$BookReaderOverridesTableCreateCompanionBuilder,
      $$BookReaderOverridesTableUpdateCompanionBuilder,
      (BookReaderOverride, $$BookReaderOverridesTableReferences),
      BookReaderOverride,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$ImportRecordsTableCreateCompanionBuilder =
    ImportRecordsCompanion Function({
      required String id,
      required String sourcePath,
      required String fileName,
      Value<String?> fileHash,
      Value<String?> detectedFormat,
      Value<String?> charsetName,
      Value<String?> duplicateBookId,
      required String result,
      Value<String?> errorCode,
      Value<String?> errorMessage,
      Value<String?> createdBookId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$ImportRecordsTableUpdateCompanionBuilder =
    ImportRecordsCompanion Function({
      Value<String> id,
      Value<String> sourcePath,
      Value<String> fileName,
      Value<String?> fileHash,
      Value<String?> detectedFormat,
      Value<String?> charsetName,
      Value<String?> duplicateBookId,
      Value<String> result,
      Value<String?> errorCode,
      Value<String?> errorMessage,
      Value<String?> createdBookId,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$ImportRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $ImportRecordsTable, ImportRecord> {
  $$ImportRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _duplicateBookIdTable(_$AppDatabase db) =>
      db.books.createAlias(
        $_aliasNameGenerator(db.importRecords.duplicateBookId, db.books.id),
      );

  $$BooksTableProcessedTableManager? get duplicateBookId {
    final $_column = $_itemColumn<String>('duplicate_book_id');
    if ($_column == null) return null;
    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_duplicateBookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BooksTable _createdBookIdTable(_$AppDatabase db) =>
      db.books.createAlias(
        $_aliasNameGenerator(db.importRecords.createdBookId, db.books.id),
      );

  $$BooksTableProcessedTableManager? get createdBookId {
    final $_column = $_itemColumn<String>('created_book_id');
    if ($_column == null) return null;
    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_createdBookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImportRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportRecordsTable> {
  $$ImportRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detectedFormat => $composableBuilder(
    column: $table.detectedFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get charsetName => $composableBuilder(
    column: $table.charsetName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get duplicateBookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duplicateBookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BooksTableFilterComposer get createdBookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdBookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportRecordsTable> {
  $$ImportRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detectedFormat => $composableBuilder(
    column: $table.detectedFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get charsetName => $composableBuilder(
    column: $table.charsetName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get duplicateBookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duplicateBookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BooksTableOrderingComposer get createdBookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdBookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportRecordsTable> {
  $$ImportRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<String> get detectedFormat => $composableBuilder(
    column: $table.detectedFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get charsetName => $composableBuilder(
    column: $table.charsetName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get duplicateBookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.duplicateBookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BooksTableAnnotationComposer get createdBookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.createdBookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImportRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportRecordsTable,
          ImportRecord,
          $$ImportRecordsTableFilterComposer,
          $$ImportRecordsTableOrderingComposer,
          $$ImportRecordsTableAnnotationComposer,
          $$ImportRecordsTableCreateCompanionBuilder,
          $$ImportRecordsTableUpdateCompanionBuilder,
          (ImportRecord, $$ImportRecordsTableReferences),
          ImportRecord,
          PrefetchHooks Function({bool duplicateBookId, bool createdBookId})
        > {
  $$ImportRecordsTableTableManager(_$AppDatabase db, $ImportRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourcePath = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<String?> detectedFormat = const Value.absent(),
                Value<String?> charsetName = const Value.absent(),
                Value<String?> duplicateBookId = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> createdBookId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportRecordsCompanion(
                id: id,
                sourcePath: sourcePath,
                fileName: fileName,
                fileHash: fileHash,
                detectedFormat: detectedFormat,
                charsetName: charsetName,
                duplicateBookId: duplicateBookId,
                result: result,
                errorCode: errorCode,
                errorMessage: errorMessage,
                createdBookId: createdBookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourcePath,
                required String fileName,
                Value<String?> fileHash = const Value.absent(),
                Value<String?> detectedFormat = const Value.absent(),
                Value<String?> charsetName = const Value.absent(),
                Value<String?> duplicateBookId = const Value.absent(),
                required String result,
                Value<String?> errorCode = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String?> createdBookId = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ImportRecordsCompanion.insert(
                id: id,
                sourcePath: sourcePath,
                fileName: fileName,
                fileHash: fileHash,
                detectedFormat: detectedFormat,
                charsetName: charsetName,
                duplicateBookId: duplicateBookId,
                result: result,
                errorCode: errorCode,
                errorMessage: errorMessage,
                createdBookId: createdBookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ImportRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({duplicateBookId = false, createdBookId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (duplicateBookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.duplicateBookId,
                                    referencedTable:
                                        $$ImportRecordsTableReferences
                                            ._duplicateBookIdTable(db),
                                    referencedColumn:
                                        $$ImportRecordsTableReferences
                                            ._duplicateBookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (createdBookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.createdBookId,
                                    referencedTable:
                                        $$ImportRecordsTableReferences
                                            ._createdBookIdTable(db),
                                    referencedColumn:
                                        $$ImportRecordsTableReferences
                                            ._createdBookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ImportRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportRecordsTable,
      ImportRecord,
      $$ImportRecordsTableFilterComposer,
      $$ImportRecordsTableOrderingComposer,
      $$ImportRecordsTableAnnotationComposer,
      $$ImportRecordsTableCreateCompanionBuilder,
      $$ImportRecordsTableUpdateCompanionBuilder,
      (ImportRecord, $$ImportRecordsTableReferences),
      ImportRecord,
      PrefetchHooks Function({bool duplicateBookId, bool createdBookId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$BookChaptersTableTableManager get bookChapters =>
      $$BookChaptersTableTableManager(_db, _db.bookChapters);
  $$ReadingProgressTableTableManager get readingProgress =>
      $$ReadingProgressTableTableManager(_db, _db.readingProgress);
  $$ReaderPreferencesTableTableManager get readerPreferences =>
      $$ReaderPreferencesTableTableManager(_db, _db.readerPreferences);
  $$BookReaderOverridesTableTableManager get bookReaderOverrides =>
      $$BookReaderOverridesTableTableManager(_db, _db.bookReaderOverrides);
  $$ImportRecordsTableTableManager get importRecords =>
      $$ImportRecordsTableTableManager(_db, _db.importRecords);
}
