import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/logs_errors.dart';
import 'package:neat_cli/core/constants/paths_contents.dart';
import 'package:neat_cli/src/classes/clean_argument.dart';
import 'package:neat_cli/src/classes/dependency_manager.dart';
import 'package:neat_cli/src/classes/file_manager.dart';
import 'package:neat_cli/src/classes/folder_manager.dart';
import 'package:neat_cli/src/classes/project_manager.dart';
import 'package:process_run/shell.dart';

class CreateCommand extends Command<int> {
  CreateCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser.addMultiOption('package', abbr: 'p', help: 'Packages to install');
  }

  @override
  String get description => 'Create new flutter project';

  @override
  String get name => 'create';

  @override
  String get usageFooter => 'try : neat_cli create <name> [arguments]';

  @override
  String get usage => super.usage.replaceAll(
        super.usage.substring(
              super.usage.indexOf(':') + 1,
              super.usage.indexOf(']') + 1,
            ),
        ' neat_cli create <project_name> [arguments]',
      );

  final Logger _logger;
  Logger get getLogger => _logger;

  // ignore: lines_longer_than_80_chars
  final ProjectManager _projectManager = ProjectManager(name: '');
  final ArgumentCleaner _argumentCleaner = ArgumentCleaner();
  final DependencyManager _dependencyManager = DependencyManager();
  final FolderManager _folderManager = FolderManager();
  final FileManager _fileManager = FileManager();
  @override
  Future<int> run() async {
    final arguments =
        _argumentCleaner.cleanArguments(argResults, argParser.options.values);
    if (arguments.length > 1 || arguments.isEmpty) {
      throw UsageException(noName, usage);
    }
    _projectManager.setProjectname(arguments[0]);
    _logger.info(
      '''${styleBold.wrap('${lightBlue.wrap('Creating ${_projectManager.getProjectName}...')} ')}''',
    );
    final exitCode = await _projectManager.createProject();
    if (argResults!['package'] != null) {
      final deps = argResults!['package'] as List<String>;
      final shell = Shell(verbose: false).cd(arguments[0]);
      if (deps.isNotEmpty) {
        await _dependencyManager.addDep(shell, deps);
      }
    }

    /// now we need to create the folder structure
    /// first set the current direcory to the project folder
    final dir = Directory('${Directory.current.path}/${arguments[0]}');
    _logger.info(
      '''${styleBold.wrap('${lightBlue.wrap('Preparing folder structure')}')}''',
    );
    folderStructure.forEach((key1, value1) {
      value1.forEach((key2, value2) {
        _logger.info(
          '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap('${dir.path}/$value2')}')}''',
        );
        _folderManager.createFolder(value2, dir);
      });
    });

    /// create a meta_data.dart file in lib/core/strings/
    _fileManager.createFile(
      '${folderStructure['core']!['strings']}/meta_data.dart',
      metaData,
    );

    // create a failures file inside the lib/core/errors
    var path = '${folderStructure['core']!['errors'].toString()}/$failuresPath';
    _logger.info(
      '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
    );
    _fileManager.createFile(path, failuresContent);

    return exitCode;
  }
}
