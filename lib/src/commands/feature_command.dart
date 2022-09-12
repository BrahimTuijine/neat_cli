import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/strings.dart';
import 'package:neat_cli/src/classes/clean_argument.dart';

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

  @override
  Future<int> run() async {
    final arguments =
        _argumentCleaner.cleanArguments(argResults, argParser.options.values);
    if (arguments.length > 1 || arguments.isEmpty) {
      throw UsageException(noFeatureName, usage);
    }
    return ExitCode.success.code;
  }
}
