class FileContentCleaner {
  List<String> methodDescription = <String>[];
  List<String> methodType = <String>[];
  List<String> get getMethods => methodType;
  List<String> get getMethodDescription => methodDescription;

  List<String> getSecondType(List<String> descriptions) {
    final result = <String>[];

    for (final str in descriptions) {
      final list = str
          .substring(str.indexOf(',') + 1, str.lastIndexOf('>') - 1)
          .trim()
          .trimLeft()
          .trimRight();

      result.add(list);
    }


    return result;
  }

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
    final result = <String>[];
    final list = content
        .substring(
          content.indexOf('{') + 1,
          content.lastIndexOf('}'),
        )
        .split(';')
        .join()
        .split('@');
    for (var element in list) {
      element = element
          .replaceAll('\n', '')
          .replaceAll('  ', ' ')
          .trim()
          .trimLeft()
          .trimRight();
      if (element.isNotEmpty) {
        result.add(element);
      }
    }

    return result;
  }

  List<String> getCleanListFunctions(List<String> dirtyList) {
    final result = <String>[];
    for (var i = 0; i < dirtyList.length; i++) {
      final element = dirtyList[i].trim().trimLeft().trimRight();
      methodType.add(
        element
            .substring(0, element.indexOf(' '))
            .trim()
            .trimLeft()
            .trimRight(),
      );
      methodDescription.add(
        element
            .substring(element.indexOf(' '), element.length)
            .trim()
            .trimLeft()
            .trimRight()
            .replaceAll('  ', ' '),
      );

      if (element.isNotEmpty) {
        result.add(element);
      }
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

  List<String> getParams(List<String> list) {
    final result = <String>[];
    for (var element in list) {
      element = element
          .substring(
            element.indexOf('(') + 1,
            element.lastIndexOf(')'),
          )
          .trim()
          .trimLeft()
          .trimRight();
      result.add(element);
    }
    return result;
  }
}
