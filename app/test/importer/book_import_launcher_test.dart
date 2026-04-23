import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/features/importer/application/book_import_launcher.dart';
import 'package:pocketread/features/importer/domain/import_selection.dart';

void main() {
  test('returns cancelled when file picker returns no files', () async {
    final BookImportLauncher launcher = BookImportLauncher(
      permissionService: _FakePermissionService(granted: true),
      filePickerService: _FakeFilePickerService(selection: null),
    );

    final ImportLaunchResult result = await launcher.pickFiles();

    expect(result.status, ImportLaunchStatus.cancelled);
    expect(result.selection, isNull);
  });

  test('returns selected paths when file picker succeeds', () async {
    const ImportSelection selection = ImportSelection(
      kind: ImportPickKind.files,
      paths: <String>['/tmp/book.txt'],
      label: '已选择 1 本书',
    );
    final BookImportLauncher launcher = BookImportLauncher(
      permissionService: _FakePermissionService(granted: true),
      filePickerService: _FakeFilePickerService(selection: selection),
    );

    final ImportLaunchResult result = await launcher.pickFiles();

    expect(result.status, ImportLaunchStatus.success);
    expect(result.selection?.paths, <String>['/tmp/book.txt']);
  });

  test('returns blocked when permission is denied', () async {
    final BookImportLauncher launcher = BookImportLauncher(
      permissionService: _FakePermissionService(granted: false),
      filePickerService: _FakeFilePickerService(selection: null),
    );

    final ImportLaunchResult result = await launcher.pickFiles();

    expect(result.status, ImportLaunchStatus.blocked);
    expect(result.message, '无法打开文件选择器');
  });
}

class _FakePermissionService implements ImportPermissionPort {
  const _FakePermissionService({required this.granted});

  final bool granted;

  @override
  Future<ImportPermissionDecision> prepareForSystemPicker() async {
    return ImportPermissionDecision(
      granted: granted,
      message: granted ? '允许访问' : '无法打开文件选择器',
    );
  }
}

class _FakeFilePickerService implements BookFilePickerPort {
  const _FakeFilePickerService({required this.selection});

  final ImportSelection? selection;

  @override
  Future<ImportSelection?> pickBookFiles() async {
    return selection;
  }

  @override
  Future<ImportSelection?> pickBookDirectory() async {
    return selection;
  }
}
