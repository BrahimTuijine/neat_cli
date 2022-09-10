import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/strings.dart';
import 'package:neat_cli/src/classes/clean_argument.dart';
import 'package:neat_cli/src/classes/dependency_manager.dart';
import 'package:neat_cli/src/classes/project_manager.dart';
import 'package:process_run/shell.dart';

class CreateCommand extends Command<int> {
  CreateCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser.addOption('package', abbr: 'p', help: 'packages to install');
  }

  @override
  String get description => 'Create new flutter project';

  @override
  String get name => 'create';

  @override
  String get usageFooter => 'try : neat_cli create <name> [arguments]';

  final Logger _logger;
  Logger get getLogger => _logger;

  // ignore: lines_longer_than_80_chars
  final ProjectManager _projectManager = ProjectManager(name: '');
  final ArgumentCleaner _argumentCleaner = ArgumentCleaner();
  final DependencyManager _dependencyManager = DependencyManager();
  @override
  Future<int> run() async {
    final arguments =
        _argumentCleaner.cleanArguments(argResults, argParser.options.values);
    if (arguments.length > 1 || arguments.isEmpty) {
      throw UsageException(noName, usage);
    }
    _projectManager.setProjectname(arguments[0]);
    _logger
        .info(lightCyan.wrap('Creating ${_projectManager.getProjectName}...'));
    final exitCode = await _projectManager.createProject();
    if (exitCode == 74) {
      throw UsageException(errorWhileCreatingAProject, usage);
    }

    if (argResults!['package'] != null) {
      String? deps = argResults!['package'].toString();
      final shell = Shell(verbose: false).cd(arguments[0]);
      final exitCode = await _dependencyManager.addDep(shell, deps);
      if (exitCode == 64) {
        throw UsageException(depAlredyInstalled, usage);
      }
    }

    _logger.success('✅ ${_projectManager.getProjectName} done!!!');
    return exitCode;
  }
}
