import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/logs_errors.dart';
import 'package:neat_cli/core/constants/paths_contents.dart';
import 'package:neat_cli/core/errors/exceptions.dart';
import 'package:neat_cli/core/extension/string_methods.dart';
import 'package:neat_cli/src/classes/clean_argument.dart';
import 'package:neat_cli/src/classes/file_manager.dart';
import 'package:neat_cli/src/classes/folder_manager.dart';
import 'package:neat_cli/src/classes/model_entity_generator.dart';
import 'package:process_run/shell.dart';

class FeatureCommand extends Command<int> {
  FeatureCommand({required Logger logger}) : _logger = logger {
    argParser
      ..addOption(
        'model',
        abbr: 'm',
        help: 'Generate model using endpoint or json file',
      )
      ..addOption(
        'entity',
        abbr: 'e',
        help: 'Generate entity using endpoint or json file',
      )
      ..addFlag('bloc', abbr: 'b', help: 'Create new bloc', negatable: false);
  }
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
  final Shell _shell = Shell(verbose: false);
  final ModelEntityGen _modelEntityGen = ModelEntityGen();
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
    if (!_fileManager.fileExist(mainDartPath)) {
      throw NoProjectFound(msg: noProject);
    }

    /// loop throw the feature folder structure and call directoryManager
    final current = Directory.current;
    newFeature.forEach((key1, value1) {
      _logger.info('🏗️  Creating $key1 layer');
      value1.forEach((key2, value2) {
        final path = '$featureBase$featureName/$value2';
        _folderManager.createFolder(path, current);
      });
    });

    // todo : create abstract repository
    var path =
        '$featureBase$featureName/${newFeature['domain']!['repositories'].toString()}';
    _fileManager.createFile(
      path,
      abstractRepoContent.replaceAll(
        '*',
        '${featureName.titlize()}' 'Repository',
      ),
    );

    // todo : create a model and entity for with the feature name
    // todo : default => create empty model and entitys
    // if (argResults!['entity'] != null) {
    //   path = '$featureBase$featureName/${newFeature['domain']!['entities']}';
    //   await _modelEntityGen.generateEntity(
    //     argResults!['entity'].toString(),
    //     path,
    //     featureName,
    //   );
    // } else {
    //   path = '$featureBase$featureName/${newFeature['domain']!['entities']}';
    //   await _modelEntityGen.generateEntity(
    //     null,
    //     path,
    //     featureName,
    //   );
    // }
    // if (argResults!['model'] != null) {
    //   path = '$featureBase$featureName/${newFeature['data']!['models']}';
    //   await _modelEntityGen.generateEntity(
    //     argResults!['model'].toString(),
    //     path,
    //     featureName,
    //   );
    // } else {
    //   path = '$featureBase$featureName/${newFeature['data']!['models']}';
    //   await _modelEntityGen.generateEntity(
    //     null,
    //     path,
    //     featureName,
    //   );
    // }

    // todo : create new bloc
    if (argResults!['bloc'] == true) {}

    return ExitCode.success.code;
  }
}
