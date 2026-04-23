import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Books extends Table {
  TextColumn get id => text()();

  TextColumn get format => text()();

  TextColumn get title => text()();

  TextColumn get author => text().withDefault(const Constant(''))();

  TextColumn get description => text().nullable()();

  TextColumn get sourceFilePath => text()();

  TextColumn get localFilePath => text()();

  TextColumn get fileName => text()();

  TextColumn get fileExt => text()();

  IntColumn get fileSize => integer()();

  TextColumn get fileHash => text()();

  TextColumn get mimeType => text().nullable()();

  TextColumn get coverImagePath => text().nullable()();

  TextColumn get coverSourceType => text().nullable()();

  TextColumn get charsetName => text().nullable()();

  TextColumn get language => text().nullable()();

  IntColumn get totalChapters => integer().withDefault(const Constant(0))();

  IntColumn get totalWords => integer().nullable()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  IntColumn get pinnedAt => integer().nullable()();

  TextColumn get importStatus => text().withDefault(const Constant('pending'))();

  IntColumn get parseVersion => integer().withDefault(const Constant(1))();

  IntColumn get createdAt => integer()();

  IntColumn get updatedAt => integer()();

  IntColumn get lastReadAt => integer().nullable()();

  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class BookChapters extends Table {
  TextColumn get id => text()();

  TextColumn get bookId => text().references(Books, #id)();

  IntColumn get chapterIndex => integer()();

  TextColumn get title => text()();

  TextColumn get sourceType => text()();

  TextColumn get href => text().nullable()();

  TextColumn get anchor => text().nullable()();

  IntColumn get startOffset => integer().nullable()();

  IntColumn get endOffset => integer().nullable()();

  TextColumn get plainText => text().nullable()();

  TextColumn get htmlContent => text().nullable()();

  IntColumn get wordCount => integer().nullable()();

  IntColumn get level => integer().withDefault(const Constant(1))();

  TextColumn get parentId => text().nullable()();

  IntColumn get createdAt => integer()();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
        <Column<Object>>{bookId, chapterIndex},
      ];
}

class ReadingProgress extends Table {
  TextColumn get id => text()();

  TextColumn get bookId => text().references(Books, #id).unique()();

  IntColumn get currentChapterIndex => integer().withDefault(const Constant(0))();

  IntColumn get chapterOffset => integer().nullable()();

  RealColumn get scrollOffset => real().nullable()();

  RealColumn get progressPercent => real().withDefault(const Constant(0))();

  TextColumn get locatorType => text().withDefault(const Constant('txt_offset'))();

  TextColumn get locatorValue => text().nullable()();

  IntColumn get startedAt => integer().nullable()();

  IntColumn get lastReadAt => integer()();

  IntColumn get totalReadingMinutes => integer().withDefault(const Constant(0))();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class ReaderPreferences extends Table {
  IntColumn get id => integer()();

  TextColumn get themeMode => text().withDefault(const Constant('system'))();

  TextColumn get backgroundColor => text().withDefault(const Constant('#F6F1E9'))();

  TextColumn get fontFamily => text().withDefault(const Constant('system'))();

  RealColumn get fontSize => real().withDefault(const Constant(18))();

  RealColumn get lineHeight => real().withDefault(const Constant(1.6))();

  RealColumn get horizontalPadding => real().withDefault(const Constant(20))();

  RealColumn get paragraphSpacing => real().withDefault(const Constant(12))();

  TextColumn get textAlign => text().withDefault(const Constant('left'))();

  TextColumn get brightnessLock => text().nullable()();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class BookReaderOverrides extends Table {
  TextColumn get id => text()();

  TextColumn get bookId => text().references(Books, #id).unique()();

  TextColumn get fontFamily => text().nullable()();

  RealColumn get fontSize => real().nullable()();

  RealColumn get lineHeight => real().nullable()();

  TextColumn get backgroundColor => text().nullable()();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class ImportRecords extends Table {
  TextColumn get id => text()();

  TextColumn get sourcePath => text()();

  TextColumn get fileName => text()();

  TextColumn get fileHash => text().nullable()();

  TextColumn get detectedFormat => text().nullable()();

  TextColumn get charsetName => text().nullable()();

  @ReferenceName('duplicateImportRecordRefs')
  TextColumn get duplicateBookId => text().nullable().references(Books, #id)();

  TextColumn get result => text()();

  TextColumn get errorCode => text().nullable()();

  TextColumn get errorMessage => text().nullable()();

  @ReferenceName('createdImportRecordRefs')
  TextColumn get createdBookId => text().nullable().references(Books, #id)();

  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DriftDatabase(
  tables: <Type>[
    Books,
    BookChapters,
    ReadingProgress,
    ReaderPreferences,
    BookReaderOverrides,
    ImportRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults()
      : super(
          driftDatabase(
            name: 'pocketread_db',
            native: const DriftNativeOptions(
              shareAcrossIsolates: true,
            ),
          ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator migrator) async {
          await migrator.createAll();
          await into(readerPreferences).insert(
            ReaderPreferencesCompanion(
              id: const Value<int>(1),
              updatedAt: Value<int>(DateTime.now().millisecondsSinceEpoch),
            ),
          );
        },
      );
}
