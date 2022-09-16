import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/logs_errors.dart';
import 'package:neat_cli/core/errors/exceptions.dart';
import 'package:process_run/shell.dart';

class DependencyManager {
  final List<String> deps = [
    'bloc',
    'flutter_bloc',
    'get_it',
    'http',
    'equatable',
    'dartz'
  ];

  String get dependencie => deps.join(' ');

  Future<int> addDep(Shell shell, List<String> dep) async {
    try {
      final finalDep = <String>[];
      for (final element in dep) {
        if (!deps.contains(element)) {
          finalDep.add(element);
        } else {
          Logger().info('''${styleBold.wrap('${lightYellow.wrap('$element is already installed SKIPED')}')}''');
        }
      }
      if (finalDep.isNotEmpty) {
        Logger().info('''${styleBold.wrap('${lightBlue.wrap('📥 Adding your dependencies ${finalDep.join('-')}')}')}''');
        await shell.run('flutter pub add ${finalDep.join(' ')}');
      }

      return ExitCode.success.code;
    } catch (_) {
      throw ErrorWhileInstallingYourDependencies(msg: errorInstallDeps);
    }
  }

  Future<int> installDependencies(Shell shell) async {
    try {
      Logger().info('''${styleBold.wrap('${lightBlue.wrap('📥 Installing dependencies $dependencie')}')}''');
      await shell.run('flutter pub add $dependencie');
      return ExitCode.success.code;
    } catch (_) {
      throw ErrorWhileSetupDependencies(msg: errorWhileSetupdep);
    }
  }
}
