import 'package:neat_cli/core/constants/paths_contents.dart';
import 'package:neat_cli/core/extension/string_methods.dart';
import 'package:neat_cli/src/classes/file_manager.dart';
import 'package:process_run/shell.dart';

class ModelEntityGen {
  final _fileManager = FileManager();
  final _shell = Shell(verbose: false);

  // generate Model or entity
  // ignore: avoid_positional_boolean_parameters
  Future<void> generateModel(
    String? resource,
    String path,
    String featureName,
  ) async {
    if (resource == null) {
      _fileManager.createFile(
        path,
        emptyModel.replaceAll(
          '*',
          featureName.titlize(),
        ),
      );
    } else {
      final processResult = await _shell.run(
        'quicktype $resource --lang dart --required-props',
      );

      print(processResult);
    }
  }

  Future<void> generateEntity(
      String? resource, String path, String featureName) async {
    if (resource == null) {
      _fileManager.createFile(
        path,
        emptyEntity.replaceAll(
          '*',
          featureName.titlize(),
        ),
      );
    } else {
      final processResult = await _shell.run(
        'quicktype $resource --lang dart --required-props',
      );

      print(processResult);
    }
  }
}
