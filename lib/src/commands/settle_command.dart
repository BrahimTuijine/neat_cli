import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/logs_errors.dart';
import 'package:neat_cli/core/constants/paths_contents.dart';
import 'package:neat_cli/core/errors/exceptions.dart';
import 'package:neat_cli/core/extension/string_methods.dart';
import 'package:neat_cli/src/classes/file_manager.dart';

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
  final FileManager _fileManager = FileManager();

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

    /// check if the file exist;
    final path =
        '$featureBase$featureName/${newFeature['domain']!['repositories']}/$repoName';

    if (!_fileManager.fileExist(path)) {
      throw RepositoryNotFound(msg: '$repoNotFound ($repoName)');
    }

    /// open file and read the content
    var abstractfileContent = _fileManager.readFileContent(path);

    // ? time to clean the content get string from abstract to } over trim it 🤣
    abstractfileContent = abstractfileContent.substring(
      abstractfileContent.indexOf('abstract'),
      abstractfileContent.indexOf('}') + 1,
    ).trim().trimLeft().trimRight();

    print(abstractfileContent.split('@'));

    return ExitCode.success.code;
  }
}
