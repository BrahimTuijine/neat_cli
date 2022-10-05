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
  ${method.toTtile()}UseCase({required this.${repoName.toCamelCase()}});

  $methodDescription call($params) async {
    return await ${repoName.toCamelCase()}.$method(${finalParams.join(',')});
  }
}
''';
  }

  String dataSourceAbstract({required String featureName}) {
    return 'import "package:dartz/dartz.dart";\nimport "package:http/http.dart" as http;\nimport "dart:convert";\nabstract class ${featureName.toTtile()}DataSource {\n';
  }

  String dataSourceAbstractFunctions({
    required String returntype,
    required String funcName,
    required String params,
  }) {
    return ' Future<$returntype> $funcName($params);\n';
  }

  String dataSourceImplemnetHeader({
    required String featureName,
  }) {
    return '''
class ${featureName.toTtile()}DataSourceImplement implements ${featureName.toTtile()}DataSource {
  final http.Client client;
  ${featureName.toTtile()}DataSourceImplement({required this.client});
''';
  }

  String dataSourceImplementSource({
    required String returnType,
    required String funcName,
    required String params,
    required String methodType,
  }) {
    var returnExpression = '';

    if (returnType.contains('List')) {
      final modelName = returnType.substring(
        returnType.indexOf('<') + 1,
        returnType.lastIndexOf('>'),
      );
      returnExpression = 'return ${modelName}FromJson(response.body)';
    } else if (returnType.toLowerCase().contains('unit')) {
      returnExpression = 'return Future.value(unit)';
    } else {
      // ignore: lines_longer_than_80_chars
      returnExpression =
          'return $returnType.fromJson(json.decode(response.body))';
    }
    return '''
@override
  Future<$returnType> $funcName($params) async {
    final headers = <String, String>{
      "Content-Type" : "application/json",
      "Accept" : "application/json"
    };
    final response = await client.$methodType(
      Uri.parse(''),
      headers: headers,
    );

    if ([200, 201].contains(response.statusCode)) {
      $returnExpression;
    } else {
      throw ServerException();
    }
  }
''';
  }
}
