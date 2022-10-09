import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/errors/exceptions.dart';
import 'package:neat_cli/src/commands/commands.dart';
import 'package:neat_cli/src/version.dart';
import 'package:pub_updater/pub_updater.dart';

const executableName = 'neat_cli';
const packageName = 'neat_cli';
const description = '🧼 Neat, Create FLutter Clean Archtecture Projects';

/// {@template neat_cli_command_runner}
/// A [CommandRunner] for the CLI.
/// {@endtemplate}
class NeatCliCommandRunner extends CommandRunner<int> {
  /// {@macro neat_cli_command_runner}
  NeatCliCommandRunner({
    Logger? logger,
    PubUpdater? pubUpdater,
  })  : _logger = logger ?? Logger(),
        _pubUpdater = pubUpdater ?? PubUpdater(),
        super(executableName, description) {
    // Add root options and flags
    argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the current version.',
    );

    // Add sub commands
    addCommand(UpdateCommand(logger: _logger));
    addCommand(CreateCommand(logger: _logger));
    addCommand(FeatureCommand(logger: _logger));
    addCommand(SettleCommand(logger: _logger));
  }
  final Logger _logger;
  final PubUpdater _pubUpdater;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final topLevelResults = parse(args);
      return await runCommand(topLevelResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      // On format errors, show the commands error message, root usage and
      // exit with an error code
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      // On usage errors, show the commands usage message and
      // exit with an error code
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);
      return ExitCode.usage.code;
    } on ErrorWhileInstallingYourDependencies catch (e) {
      _logger
        ..err(e.errorMsg)
        ..info('');
      return ExitCode.usage.code;
    } on ErrorWhileSetupDependencies catch (e) {
      _logger
        ..err(e.errorMsg)
        ..info('');
      return ExitCode.usage.code;
    } on ErrorWhileCreateProject catch (e) {
      _logger
        ..err(e.errorMsg)
        ..info('');
      return ExitCode.usage.code;
    } on ProjectExist catch (e) {
      _logger
        ..err(e.errorMsg)
        ..info('');
      return ExitCode.usage.code;
    } on NoProjectFound catch (e) {
      _logger
        ..err(e.errorMsg)
        ..info('');
      return ExitCode.usage.code;
    } on RepositoryNotFound catch (e) {
      _logger
        ..err(e.errorMsg)
        ..info('');
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    _logger
      ..detail('Argument information:')
      ..detail('  Top level options:');
    for (final option in topLevelResults.options) {
      if (topLevelResults.wasParsed(option)) {
        _logger.detail('  - $option: ${topLevelResults[option]}');
      }
    }
    if (topLevelResults.command != null) {
      final commandResult = topLevelResults.command!;
      _logger
        ..detail('  Command: ${commandResult.name}')
        ..detail('    Command options:');
      for (final option in commandResult.options) {
        if (commandResult.wasParsed(option)) {
          _logger.detail('    - $option: ${commandResult[option]}');
        }
      }
    }

    final int? exitCode;
    if (topLevelResults['version'] == true) {
      _logger.info('🧼 neat_cli version $packageVersion');
      exitCode = ExitCode.success.code;
    } else {
      exitCode = await super.runCommand(topLevelResults);
    }
    await _checkForUpdates();
    return exitCode;
  }

  /// Checks if the current version (set by the build runner on the
  /// version.dart file) is the most recent one. If not, show a prompt to the
  /// user.
  Future<void> _checkForUpdates() async {
    try {
      final latestVersion = await _pubUpdater.getLatestVersion(packageName);
      final isUpToDate = packageVersion == latestVersion;
      if (!isUpToDate) {
        _logger
          ..info('')
          ..info(
            '''
            ${lightYellow.wrap('Update available!')} ${lightCyan.wrap(packageVersion)} \u2192 ${lightCyan.wrap(latestVersion)}
            Run ${lightCyan.wrap('neat_cli update')} to update''',
          );
      }
    } catch (_) {}
  }
}
