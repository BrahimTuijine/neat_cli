List<String> getFinalParams({required String params}) {
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
  return finalParams;
}
