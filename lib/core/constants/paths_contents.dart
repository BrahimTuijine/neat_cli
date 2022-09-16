const String mainDartPath = 'lib/main.dart';
const String featureBase = 'lib/features/';

/* Failures */
const String failuresPath = 'failures.dart';
const String failuresContent = '''
import 'package:equatable/equatable.dart';
abstract class Failure extends Equatable {}
''';

/* NEW FEATURE */
const Map<String, Map<String, String>> newFeature = {
  'data': {
    'dataresources': 'data/dataresources',
    'models': 'data/models',
    'repositories': 'data/repositories',
  },
  'domain': {
    'entities': 'domain/entities',
    'repositories': 'domain/repositories',
    'usecases': 'domain/usecases'
  },
  'presentation': {
    'bloc': 'presentation/bloc',
    'pages': 'presentation/pages',
    'widgets': 'presentation/widgets'
  },
};
/* REPO ABSTRACT CLASS CONTENT */

const String abstractRepoContent = 'abstract class * {}';

/* MATA DATA */
const String metaData = '''
/* 
  user must use this meta data to 
  identify the mothode inside the domain/repository files
  exp : 
    @get 
    Future<Failure, UserModel> listOfpost() 
  ![WARN] DO NOT DELETE THIS FILE
  use neat_cli to build app (it will delete the annotation and this file for you)
  check the docs at : https://github.com/MerseniBilel/neat_cli
*/
const get = 'get';
const post = 'post';
const put = 'put';
const patch = 'patch';
const delete = 'delete';
''';

/* FOLDER STRUCTURE */
const Map<String, Map<String, String>> folderStructure = {
  'feature': {'feature': 'lib/features'},
  'core': {
    'core': 'lib/core',
    'errors': 'lib/core/errors',
    'strings': 'lib/core/strings',
    'theme': 'lib/core/themes',
    'widgets': 'lib/core/widgets',
    'utils': 'lib/core/utils',
  }
};

/* EMPTY MODEL */
const String emptyModel = '''
class * {
  *();
}
''';
/* EMPTY ENTITY */
const String emptyEntity = '''
class * {
  *();
}
''';



// import 'package:clean_achitecture/core/errors/failures.dart';
// import 'package:clean_achitecture/features/post/domain/entites/post.dart';
// import 'package:dartz/dartz.dart';

// abstract class PostRepository {
//   Future<Either<Failure, List<Post>>> getAllPosts();
//   Future<Either<Failure, Unit>> deletePost(int postId);
//   Future<Either<Failure, Unit>> updatePost(Post post);
//   Future<Either<Failure, Unit>> addPost(Post post);
// }