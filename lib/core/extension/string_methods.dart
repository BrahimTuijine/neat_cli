extension StrngMethods on String {
  String toCamelCase() {
    final toList = split('');
    if (toList[0] == toList[0].toUpperCase()) {
      toList[0] = toList[0].toLowerCase();
    }
    return toList.join();
  }

  String toTtile(){
    final list = split('');
    list[0] = list[0].toUpperCase();
    return list.join();
  }

  String titlize() {
    final list = toLowerCase().split('');
    list[0] = list[0].toUpperCase();
    return list.join();
  }

  String toFileName() {
    final str = toCamelCase();
    final list = str.split('');
    final result = <String>[];
    for (final element in list) {
      if (element == element.toUpperCase()) {
        result
          ..add('_')
          ..add(element.toLowerCase());
      } else {
        result.add(element);
      }
    }
    return result.join();
  }
}
