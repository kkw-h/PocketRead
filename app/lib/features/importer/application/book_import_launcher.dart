import 'package:pocketread/features/importer/domain/import_selection.dart';

class BookImportLauncher {
  const BookImportLauncher({
    required ImportPermissionPort permissionService,
    required BookFilePickerPort filePickerService,
  }) : _permissionService = permissionService,
       _filePickerService = filePickerService;

  final ImportPermissionPort _permissionService;
  final BookFilePickerPort _filePickerService;

  Future<ImportLaunchResult> pickFiles() {
    return _pick(
      picker: _filePickerService.pickBookFiles,
      cancelledMessage: '已取消选择书籍',
      failureMessage: '打开文件选择器失败',
    );
  }

  Future<ImportLaunchResult> pickDirectory() {
    return _pick(
      picker: _filePickerService.pickBookDirectory,
      cancelledMessage: '已取消选择文件夹',
      failureMessage: '打开文件夹选择器失败',
    );
  }

  Future<ImportLaunchResult> _pick({
    required Future<ImportSelection?> Function() picker,
    required String cancelledMessage,
    required String failureMessage,
  }) async {
    try {
      final ImportPermissionDecision permission = await _permissionService
          .prepareForSystemPicker();
      if (!permission.granted) {
        return ImportLaunchResult(
          status: ImportLaunchStatus.blocked,
          message: permission.message,
        );
      }

      final ImportSelection? selection = await picker();
      if (selection == null) {
        return ImportLaunchResult(
          status: ImportLaunchStatus.cancelled,
          message: cancelledMessage,
        );
      }

      return ImportLaunchResult(
        status: ImportLaunchStatus.success,
        message: selection.label,
        selection: selection,
      );
    } on Exception catch (error) {
      return ImportLaunchResult(
        status: ImportLaunchStatus.failure,
        message: '$failureMessage：$error',
      );
    }
  }
}

abstract class ImportPermissionPort {
  Future<ImportPermissionDecision> prepareForSystemPicker();
}

abstract class BookFilePickerPort {
  Future<ImportSelection?> pickBookFiles();

  Future<ImportSelection?> pickBookDirectory();
}
