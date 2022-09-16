import 'package:neat_cli/core/extension/string_methods.dart';

class SettleContentPrepare {
  String useCaseContnet({
    required String repoName,
    required String method,
    required String methodDescription,
  }) {
    return '''
class ${method.toTtile()}UseCase{
  final $repoName ${repoName.toCamelCase()};
  ${method.toTtile()}UseCase(this.${repoName.toCamelCase()});

  $methodDescription call() async {
    return await ${repoName.toCamelCase()}.$method();
  }
}
''';
  }
}
