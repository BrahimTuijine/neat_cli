import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/strings.dart';
import 'package:neat_cli/core/errors/exceptions.dart';
import 'package:neat_cli/src/classes/clean_argument.dart';
import 'package:neat_cli/src/classes/file_manager.dart';
import 'package:neat_cli/src/classes/folder_manager.dart';

class FeatureCommand extends Command<int> {
  FeatureCommand({required Logger logger}) : _logger = logger;
  @override
  String get description => 'Create new feature folder structure';

  @override
  String get name => 'feature';

  final ArgumentCleaner _argumentCleaner = ArgumentCleaner();

  @override
  String get usage => super.usage.replaceAll(
        super.usage.substring(
              super.usage.indexOf(':') + 1,
              super.usage.indexOf(']') + 1,
            ),
        ' neat_cli feature <feature_name> [arguments]',
      );

  final Logger _logger;
  final FileManager _fileManager = FileManager();
  final FolderManager _folderManager = FolderManager();
  @override
  Future<int> run() async {
    final arguments =
        _argumentCleaner.cleanArguments(argResults, argParser.options.values);
    if (arguments.isEmpty) {
      throw UsageException(noFeatureName, usage);
    } else if (arguments.length > 1) {
      throw UsageException(badArgs, usage);
    }
    final featureName = arguments[0];

    /// first we need to check if we are in the project folder
    if (!_fileManager.ifFileExist(mainDartPath)) {
      throw NoProjectFound(msg: noProject);
    }

    /// loop throw the feature folder structure and call directoryManager
    final current = Directory.current;
    newFeature.forEach((key1, value1) {
      _logger.info('🏗️ Creating $key1 layer');
      value1.forEach((key2, value2) {
        final path = '$featureBase$featureName/$value2';
        _folderManager.createFolder(path, current);
      });
    });

    return ExitCode.success.code;
  }
}
