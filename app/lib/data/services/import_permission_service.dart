import 'package:permission_handler/permission_handler.dart';
import 'package:pocketread/features/importer/application/book_import_launcher.dart';
import 'package:pocketread/features/importer/domain/import_selection.dart';

class ImportPermissionService implements ImportPermissionPort {
  const ImportPermissionService();

  @override
  Future<ImportPermissionDecision> prepareForSystemPicker() async {
    return const ImportPermissionDecision(
      granted: true,
      message: '系统文件选择器已准备就绪',
    );
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }
}
