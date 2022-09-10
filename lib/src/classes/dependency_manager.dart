import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
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

  Future<int> addDep(Shell shell, String dep) async {
    try {
      final listDep = dep.split(',');
      for (final element in listDep) {
        if (deps.contains(element)) {
          return ExitCode.usage.code;
        }
      }

      Logger().info('📥📥 Adding your dependencies ');
      await shell.run('flutter pub add ${listDep.join(' ')}');
      return ExitCode.success.code;
    } catch (_) {
      return ExitCode.ioError.code;
    }
  }

  Future<int> installDependencies(Shell shell) async {
    try {
      Logger().info('📥📥 Installing dependencies ');
      await shell.run('flutter pub add $dependencie');
      return ExitCode.success.code;
    } catch (_) {
      return ExitCode.ioError.code;
    }
  }
}
