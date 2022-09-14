class ErrorWhileInstallingYourDependencies implements Exception {
  ErrorWhileInstallingYourDependencies({required this.msg});
  final String msg;

  String get errorMsg => msg;
}

class ErrorWhileSetupDependencies implements Exception {
  ErrorWhileSetupDependencies({required this.msg});
  final String msg;

  String get errorMsg => msg;
}

class ErrorWhileCreateProject implements Exception {
  ErrorWhileCreateProject({required this.msg});
  final String msg;
  String get errorMsg => msg;
}

class ProjectExist implements Exception {
  ProjectExist({required this.msg});
  final String msg;

  String get errorMsg => msg;
}

class RepositoryNotFound implements Exception {
  RepositoryNotFound({required this.msg});
  final String msg;

  String get errorMsg => msg;
}

class NoProjectFound implements Exception {
  NoProjectFound({required this.msg});
  final String msg;

  String get errorMsg => msg;
}
