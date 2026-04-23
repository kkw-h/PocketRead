enum ImportPickKind { files, directory }

enum ImportLaunchStatus { success, cancelled, blocked, failure }

class ImportSelection {
  const ImportSelection({
    required this.kind,
    required this.paths,
    required this.label,
  });

  final ImportPickKind kind;
  final List<String> paths;
  final String label;
}

class ImportLaunchResult {
  const ImportLaunchResult({
    required this.status,
    required this.message,
    this.selection,
  });

  final ImportLaunchStatus status;
  final String message;
  final ImportSelection? selection;
}

class ImportPermissionDecision {
  const ImportPermissionDecision({
    required this.granted,
    required this.message,
    this.canOpenSettings = false,
  });

  final bool granted;
  final String message;
  final bool canOpenSettings;
}
