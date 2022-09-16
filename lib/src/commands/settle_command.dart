import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/logs_errors.dart';
import 'package:neat_cli/core/constants/paths_contents.dart';
import 'package:neat_cli/core/errors/exceptions.dart';
import 'package:neat_cli/src/classes/file_content._cleaner.dart';
import 'package:neat_cli/src/classes/file_manager.dart';
import 'package:neat_cli/src/classes/settle_file_creator.dart';
import 'package:process_run/shell.dart';

class SettleCommand extends Command<int> {
  SettleCommand({required Logger logger}) : _logger = logger {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'Feature name',
      )
      ..addOption(
        'repo',
        abbr: 'r',
        help: 'Abstract repository name',
      );
  }

  @override
  String get description => 'Generate files based on the given repository file';

  @override
  String get name => 'settle';

  final Logger _logger;
  final Shell _shell = Shell(verbose: false);
  final FileManager _fileManager = FileManager();
  final FileContentCleaner _fileContentCleaner = FileContentCleaner();
  final SettleFileCreator _settleFileCreator = SettleFileCreator();

  @override
  Future<int> run() async {
    if (argResults!['feature'] == null || argResults!['repo'] == null) {
      printUsage();
      exit(0);
    }

    final featureName = argResults!['feature'].toString();
    var repoName = '';

    if (argResults!['repo'].toString().contains('.dart')) {
      repoName = argResults!['repo'].toString();
    } else {
      repoName = '${argResults!['repo']}.dart';
    }

    // * running dart format .
    _logger.info(
        '''${styleBold.wrap('${lightBlue.wrap('Running dart format ...')}')}''');
    await _shell.run('dart format .');

    /// check if the file exist;
    final path =
        '$featureBase$featureName/${newFeature['domain']!['repositories']}/$repoName';

    if (!_fileManager.fileExist(path)) {
      throw RepositoryNotFound(msg: '$repoNotFound ($repoName)');
    }

    /// open file and read the content
    var abstractfileContent = _fileManager.readFileContent(path);

    // ? time to clean the content get string from abstract to } over trim it 🤣
    abstractfileContent =
        _fileContentCleaner.getfileContent(abstractfileContent);

    // repository name
    final repositoryName = _fileContentCleaner.getRepoName(abstractfileContent);

    // list of function used (dirty)
    final dirtyListOfFunction = _fileContentCleaner.listDirtyFunction(
      abstractfileContent,
    );

    final cleanListFunction = _fileContentCleaner.getCleanListFunctions(
      dirtyListOfFunction,
    );

    /*
    |--------------------------------------------------------------------------
    | // * LET'S CLEAN THIS OUT 
    | // * CREATE 4 ARRAYS 
    | // * 1 - contains methods description and name : Future<Either<one, tow>> getPost();
    | // * 2 - contains only methid description : Future<Either<one, tow>>
    | // * 3 - contains method name : getPost
    | // * 4 - contains methodType : get, post, put, delete...
    |--------------------------------------------------------------------------
    |
    */

    final methodDescriptionWithName = _fileContentCleaner.getMethodDescription;
    final onlyMethodDescription = _fileContentCleaner
        .getOnlyMethodsDescription(methodDescriptionWithName);
    final methodsNames = _fileContentCleaner.listOfMethods(
      methodDescriptionWithName,
    );
    final methodType = _fileContentCleaner.getMethods;

    /*
    |--------------------------------------------------------------------------
    | CREATE THE USE CASES USING THE 4 ARRAYS
    |--------------------------------------------------------------------------
    |
    */

    for (var i = 0; i < methodsNames.length; i++) {
      _settleFileCreator.createUseCase(
        featureName: featureName,
        repoName: repositoryName,
        method: methodsNames[i],
        methodDescription: onlyMethodDescription[i],
      );
    }

    return ExitCode.success.code;
  }
}
