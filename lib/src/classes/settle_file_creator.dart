import 'package:mason_logger/mason_logger.dart';
import 'package:neat_cli/core/constants/paths_contents.dart';
import 'package:neat_cli/core/extension/string_methods.dart';
import 'package:neat_cli/src/classes/file_manager.dart';
import 'package:neat_cli/src/classes/settle_content_prepare.dart';

class SettleFileCreator {
  final SettleContentPrepare _settleContent = SettleContentPrepare();
  final FileManager _fileManager = FileManager();

  // function to create one repo implement
  void createRepoImplement({
    required String repoName,
    required String featureName,
    required String content,
  }) {
    final path =
        '$featureBase$featureName/${newFeature['data']!['repositories']}/${repoName.toFileName()}_implement.dart';
    Logger().info(
      '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
    );
    _fileManager.createFile(path, content);
  }

  // function which create one usecase
  void createUseCase({
    required String featureName,
    required String repoName,
    required String params,
    required String method,
    required String methodDescription,
  }) {
    final content = _settleContent.useCaseContnet(
      repoName: repoName,
      params: params,
      method: method,
      methodDescription: methodDescription,
    );
    final path =
        '$featureBase$featureName/${newFeature['domain']!['usecases']}/${method.toFileName()}.dart';
    Logger().info(
      '''${styleBold.wrap('${lightGreen.wrap('\u2713')}')} ${styleDim.wrap('${lightGray.wrap(path)}')}''',
    );
    _fileManager.createFile(path, content);
  }
}
