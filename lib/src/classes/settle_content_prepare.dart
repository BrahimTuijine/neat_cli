import 'package:neat_cli/core/extension/string_methods.dart';

class SettleContentPrepare {

  String repoImplementHeader({required String repoName}) {
    return '''
class ${repoName}Implement implements $repoName {
  ${repoName}Implement();

''';
  }

  String repoImplementContent({
    required String methodDescription,
    required String methodName,
    required String params,
  }) {
    return '''
 @override
  $methodDescription $methodName($params) async {
    // todo : Implement $methodName
    throw UnimplementedError();
  }
''';
}

  // prepare usecase
  String useCaseContnet({
    required String repoName,
    required String method,
    required String params,
    required String methodDescription,
  }) {
    // [, TodoEntity todo, int id, String name, String email,]
    List<String> paramsSplit;
    final finalParams = <String>[];
    if (params.contains(',')) {
      paramsSplit = params.split(',');
      for (var element in paramsSplit) {
        if (element.isNotEmpty) {
          element = element.trim().trimLeft().trimRight();
          finalParams.add(element.split(' ').last);
        }
      }
    } else {
      paramsSplit = params.split(' ');
      finalParams.add(paramsSplit.last);
    }

    // int i, int a
    return '''
class ${method.toTtile()}UseCase{
  final $repoName ${repoName.toCamelCase()};
  ${method.toTtile()}UseCase(this.${repoName.toCamelCase()});

  $methodDescription call($params) async {
    return await ${repoName.toCamelCase()}.$method(${finalParams.join(',')});
  }
}
''';
  }


  String dateSourceAbstract({required String featureName}){
    return '''
abstract class ${featureName.toTtile()}DataSource {
  Future<List<TodoModel>> getAllTodo();
  Future<Unit> addTodo(TodoEntity todo);
}
''';
}
}
