import 'package:file_picker/file_picker.dart';
import 'package:pocketread/features/importer/application/book_import_launcher.dart';
import 'package:pocketread/features/importer/domain/import_selection.dart';

class BookFilePickerService implements BookFilePickerPort {
  const BookFilePickerService();

  @override
  Future<ImportSelection?> pickBookFiles() async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['txt', 'epub'],
      allowMultiple: true,
      withData: false,
      lockParentWindow: true,
    );

    if (result == null) {
      return null;
    }

    final List<String> paths = result.files
        .map((PlatformFile file) => file.path)
        .whereType<String>()
        .toList(growable: false);
    if (paths.isEmpty) {
      return null;
    }

    return ImportSelection(
      kind: ImportPickKind.files,
      paths: paths,
      label: _formatFilesLabel(paths.length),
    );
  }

  @override
  Future<ImportSelection?> pickBookDirectory() async {
    final String? path = await FilePicker.getDirectoryPath(
      lockParentWindow: true,
    );
    if (path == null || path.isEmpty) {
      return null;
    }

    return ImportSelection(
      kind: ImportPickKind.directory,
      paths: <String>[path],
      label: '已选择文件夹',
    );
  }

  String _formatFilesLabel(int count) {
    if (count == 1) {
      return '已选择 1 本书';
    }
    return '已选择 $count 本书';
  }
}
