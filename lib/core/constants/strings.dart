const String noName = 'I think you forget the name of the project';
const String noFeatureName = 'I Think you forget the feature name';
const String errorWhileCreatingAProject =
    'Error while creating the project (check project name)';
const String errorInstallDeps = 'Error while installing your dependencies';
const String errorWhileSetupdep = 'Error while setup dependencies';
const String projectExist = 'Project already exist';

const Map<String, Map<String, String>> newFeature = {
  'data': {
    'dataresources': 'data/dataresources',
    'models': 'data/models',
    'repositories': 'data/repositories',
  },
  'domain': {
    'entites': 'domain/entites',
    'repositories': 'domain/repositories',
    'usecases': 'domain/usecases'
  },
  'presentation': {
    'bloc': 'presentation/bloc',
    'pages': 'presentation/pages',
    'widgets': 'presentation/widgets'
  },
};

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
