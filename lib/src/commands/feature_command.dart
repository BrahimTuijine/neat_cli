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

    final existFeature =
        Directory('${Directory.current.path}/lib/features/$featureName')
            .existsSync();

    if (existFeature) {
      _logger.info(
          '''${styleBold.wrap('${lightYellow.wrap('Feature $featureName Exist [SKIPED]')}')}''');
      return ExitCode.success.code;
    }

    /// loop throw the feature folder structure and call directoryManager
    final current = Directory.current;
    newFeature.forEach((key1, value1) {
      _logger.info(
        '''${styleBold.wrap('${lightBlue.wrap('${key1.titlize()} Layer')}')}''',
      );
      value1.forEach((key2, value2) {
        final path = '$featureBase$featureName/$value2';
        _logger.info(
            '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap('${current.path}/$path')}')}''');
        _folderManager.createFolder(path, current);
      });
    });

    /// create an abstract class inside the lib/feature/domain/repositories
    _logger.info(
        '''${styleBold.wrap('${lightBlue.wrap('Preparing Files...')}')}''');
    var path =
        '$featureBase$featureName/${newFeature['domain']!['repositories'].toString()}/$featureName'
        '_repository.dart';
    _logger.info(
      '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
    );
    _fileManager.createFile(
      path,
      abstractRepoContent.replaceAll(
        '*',
        '${featureName.titlize()}' 'Repository',
      ),
    );



    // check if the user provide an entity or a model
    // if, then create a model and entity using the resource provided
    // else, create an empty entity and model
    if (argResults!['entity'] != null) {
      path =
          '$featureBase$featureName/${newFeature['domain']!['entities'].toString()}/$featureName'
          '_entity.dart';
      _logger.info(
        '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
      );
      await _modelEntityGen.generateEntity(
        argResults!['entity'].toString(),
        path,
        featureName,
      );
    } else {
      path =
          '$featureBase$featureName/${newFeature['domain']!['entities'].toString()}/$featureName'
          '_entity.dart';
      _logger.info(
        '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
      );
      await _modelEntityGen.generateEntity(
        null,
        path,
        featureName,
      );
    }
    if (argResults!['model'] != null) {
      path =
          '$featureBase$featureName/${newFeature['data']!['models'].toString()}/$featureName'
          '_model.dart';
      _logger.info(
        '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
      );
      await _modelEntityGen.generateEntity(
        argResults!['model'].toString(),
        path,
        featureName,
      );
    } else {
      path =
          '$featureBase$featureName/${newFeature['data']!['models'].toString()}/$featureName'
          '_model.dart';
      _logger.info(
        '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
      );
      await _modelEntityGen.generateModel(
        null,
        path,
        featureName,
      );
    }

    // todo : create new bloc
    if (argResults!['bloc'] == true) {}

    return ExitCode.success.code;
  }
}
