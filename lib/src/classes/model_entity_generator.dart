import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/paths_contents.dart';
import 'package:neat_cli/core/extension/string_methods.dart';
import 'package:neat_cli/src/classes/file_manager.dart';
import 'package:process_run/shell.dart';

class ModelEntityGen {
  final _fileManager = FileManager();
  final _shell = Shell(verbose: false);

  // generate Model or entity
  // ignore: avoid_positional_boolean_parameters
  Future<void> generateModel(
    String? resource,
    String path,
    String featureName,
  ) async {
    if (resource == null) {
      _fileManager.createFile(
        path,
        emptyModel.replaceAll(
          '*',
          '${featureName.titlize()}Model',
        ),
      );
    } else {
      if (!_fileManager.fileExist(path)) {
        await _shell.run(
          'quicktype $resource --lang dart --required-props --final-props -o $path',
        );
        ClearGenerated.clearModelAndEntity(path, null);
      } else {
        Logger().warn('File Exist [SKIPED]');
      }
    }
  }

  Future<void> generateEntity(
    String? resource,
    String path,
    String featureName,
  ) async {
    if (resource == null) {
      _fileManager.createFile(
        path,
        emptyEntity.replaceAll(
          '*',
          '${featureName.titlize()}Entity',
        ),
      );
    } else {
      if (!_fileManager.fileExist(path)) {
        await _shell.run(
          'quicktype $resource --lang dart --required-props --final-props -o $path',
        );
        ClearGenerated.clearModelAndEntity(null, path);
      } else {
        Logger().warn('File Exist [SKIPED]');
      }
    }
  }
}

class ClearGenerated {
  static void clearModelAndEntity(String? modelPath, String? entityPath) {
    if (entityPath != null) {
      final fileContent = File(entityPath)
          .readAsStringSync()
          .replaceAll('@', '')
          .replaceAll("import 'package:meta/meta.dart';", '');
      File(entityPath).writeAsStringSync(fileContent);
    }
    if (modelPath != null) {
      final fileContent = File(modelPath)
          .readAsStringSync()
          .replaceAll('@', '')
          .replaceAll("import 'package:meta/meta.dart';", '');
      File(modelPath).writeAsStringSync(fileContent);
    }
  }
}
