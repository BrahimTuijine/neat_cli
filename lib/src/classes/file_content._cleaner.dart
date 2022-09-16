class FileContentCleaner {
  List<String> methodDescription = <String>[];
  List<String> methodType = <String>[];

  List<String> get getMethods => methodType;
  List<String> get getMethodDescription => methodDescription;

  String getfileContent(String content) {
    return content
        .substring(
          content.indexOf('abstract'),
          content.indexOf('}') + 1,
        )
        .trim()
        .trimLeft()
        .trimRight();
  }

  String getRepoName(String content) {
    return content
        .substring(
          0,
          content.indexOf('{'),
        )
        .trim()
        .trimLeft()
        .trimRight()
        .split(' ')
        .last;
  }

  List<String> listDirtyFunction(String content) {
    return content
        .substring(
          content.indexOf('{') + 1,
          content.lastIndexOf('}'),
        )
        .split(';')
        .join('')
        .split('@')
        .join(' ')
        .split('\n');
  }

  List<String> getCleanListFunctions(List<String> dirtyList) {
    final result = <String>[];
    for (var i = 0; i < dirtyList.length; i++) {
      final element = dirtyList[i].trim().trimLeft().trimRight();
      if (element.isNotEmpty) {
        result.add(element);
      }
    }

    for (var i = 0; i < result.length; i = i + 2) {
      methodType.add(result[i]);
      methodDescription.add(result[i + 1]);
    }

    return result;
  }

  List<String> listOfMethods(List<String> list) {
    final result = <String>[];
    for (var element in list) {
      element = element
          .substring(
            element.lastIndexOf('>') + 1,
            element.indexOf('('),
          )
          .trim()
          .trimLeft()
          .trimRight();
      result.add(element);
    }
    return result;
  }

  List<String> getOnlyMethodsDescription(List<String> list) {
    final result = <String>[];
    for (var element in list) {
      element = element
          .substring(0, element.lastIndexOf('>') + 1)
          .trim()
          .trimLeft()
          .trimRight();
      result.add(element);
    }
    return result;
  }
}
