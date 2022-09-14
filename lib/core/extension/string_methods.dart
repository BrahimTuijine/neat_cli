extension StrngMethods on String {
  String toCamelCase() {
    final toList = split('');
    if (toList[0] == toList[0].toUpperCase()) {
      toList[0] = toList[0].toLowerCase();
    }
    return toList.join();
  }

  String titlize() {
    final list = toLowerCase().split('');
    list[0] = list[0].toUpperCase();
    return list.join();
  }
}
