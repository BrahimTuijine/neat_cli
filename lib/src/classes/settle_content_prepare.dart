import 'package:neat_cli/core/extension/string_methods.dart';

import '../../core/Utils/get_final_params.dart';

class SettleContentPrepare {
  String repoImplementHeader({
    required String repoName,
    required String featureName,
  }) {
    return '''
  import '../../domain/repositories/${featureName}_repository.dart';
  import '../dataresources/${featureName}_repository_data_source.dart';
  import '../../../../core/errors/failures.dart';
  import 'package:dartz/dartz.dart';
  import '../../../../core/errors/exceptions.dart';
  import '../models/${featureName}_model.dart';
    import '../../domain/entities/${featureName}_entity.dart';

class ${repoName}Implement implements $repoName {
  final ${featureName.toTtile()}DataSource ${featureName}DataSource;
  ${repoName}Implement({required this.${featureName}DataSource});

''';
  }

  String repoImplementContent({
    required String methodDescription,
    required String methodName,
    required String params,
    required String featureName,
    required String returnType,
  }) {
    var returnFormt = '';

    // "String name , int id "

    if (returnType == 'Unit') {
      returnFormt = '''
      await ${featureName}DataSource.$methodName(${getFinalParams(params: params).join(',')});
      return const Right(unit);
      ''';
    } else {
      returnFormt = '''
      final response = await ${featureName}DataSource.$methodName($params);
     return Right(response);
  ''';
    }

    return '''
 @override
  $methodDescription $methodName($params) async {
    try {
        $returnFormt
      } on ServerException {
        return Left(ServerFailure());
      }
  }
''';
  }

  

  // prepare usecase
  String useCaseContnet({
    required String featureName,
    required String repoName,
    required String method,
    required String params,
    required String methodDescription,
  }) {
    // [, TodoEntity todo, int id, String name, String email,]

    // int i, int a
    return '''
import 'package:dartz/dartz.dart';
import '../repositories/${featureName}_repository.dart';
import '../../../../core/errors/failures.dart';
import '../entities/${featureName}_entity.dart';

class ${method.toTtile()}UseCase{
  final $repoName ${repoName.toCamelCase()};
  ${method.toTtile()}UseCase({required this.${repoName.toCamelCase()}});

  $methodDescription call($params) async {
    return await ${repoName.toCamelCase()}.$method(${getFinalParams(params: params).join(',')});
  }
}
''';
  }

  String dataSourceAbstract({required String featureName}) {
    return '''
    import "package:dartz/dartz.dart";
    import "package:http/http.dart" as http;
    import "dart:convert";
    import '../../../../core/errors/exceptions.dart';
    import '../models/${featureName}_model.dart';
    import '../../domain/entities/${featureName}_entity.dart';
    
    abstract class ${featureName.toTtile()}DataSource {\n''';
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
