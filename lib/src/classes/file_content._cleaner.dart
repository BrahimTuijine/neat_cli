class FileContentCleaner {
  List<String> methodDescription = <String>[];
  List<String> methodType = <String>[];
  List<String> get getMethods => methodType;
  List<String> get getMethodDescription => methodDescription;

  List<String> getSecondType(List<String> descriptions) {
    final result = <String>[];

    for (final str in descriptions) {
      final list = str
          .substring(str.indexOf(',') + 1, str.lastIndexOf('>'))
          .trim()
          .trimLeft()
          .trimRight()
          .split('');
      var i = 0;
      var numberOfOpen = 0;
      var numberOfclose = 0;
      for (final element in list) {
        if (element == '<') numberOfOpen++;
      }
      var one = <String>[];
      while (i < list.length) {
        if (numberOfOpen > 0) {
          if (numberOfOpen == numberOfclose) break;
          if (list[i] == '>') numberOfclose++;
          one.add(list[i]);
        } else {
          if (list[i] == '>') break;
          one.add(list[i]);
        }
        i++;
      }
      if (one.join().contains('<')) {
        var element = one.sublist(
          one.indexOf('<')+1,
          one.lastIndexOf('>'),
        );
        one = one.join().replaceAll(element.join(), '*').split('');
      }else if(one.join().contains('Entity')){
        one = '*'.split('');
      }else{
        one = one;
      }
      result.add(one.join());
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
    var list = content
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
