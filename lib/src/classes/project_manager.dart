import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/logs_errors.dart';
import 'package:neat_cli/core/errors/exceptions.dart';
import 'package:neat_cli/src/classes/dependency_manager.dart';
import 'package:process_run/shell.dart';

/// [ProjectManager] class required for creating project

class ProjectManager {
  ProjectManager({
    required String name,
  }) : _projectName = name;

  // project name
  String _projectName;
  String get getProjectName => _projectName;
  // use_setters_to_change_properties
  // ignore: use_setters_to_change_properties
  void setProjectname(String name) => _projectName = name;
  // to excecute shell commands
  final Shell _shell = Shell(verbose: false);

  // dependency manager contains the main dep you need
  DependencyManager dependencies = DependencyManager();

  /// check if project already exist
  bool projectChecker(String name) {
    return Directory('${Directory.current.path}/$name').existsSync();
  }

  /// shell to execute command line
  /// [createProject] is the function required to create a new project
  Future<int> createProject() async {
    if (projectChecker(_projectName)) {
      throw ProjectExist(msg: projectExist);
    }
    try {
      // ignore: lines_longer_than_80_chars
      await _shell
          .run('flutter create $_projectName')
          .onError((error, stackTrace) {
        throw ErrorWhileCreateProject(msg: errorWhileCreatingAProject);
      });
      await dependencies.installDependencies(
        _shell.cd(_projectName),
      );
      return ExitCode.success.code;
    } catch (_) {
      throw ErrorWhileCreateProject(msg: errorWhileCreatingAProject);
    }
  }
}
