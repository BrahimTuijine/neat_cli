import 'package:args/args.dart';

class ArgumentCleaner {

  /// [cleanArguments] taks the argument list and return command needs
  List<String> cleanArguments(
    ArgResults? argResults,
    Iterable<Option> options,
  ) {
    final result = List<String>.of(argResults!.arguments);
    for (final element in options) {
      if (argResults[element.name] != null) {
        if (result.contains(element.name)) {
          result.remove(result[result.indexOf(element.name) + 1]);
        }
        if (result.contains('-${element.abbr}')) {
          result.remove(result[result.indexOf('-${element.abbr}') + 1]);
        }
        result
          ..remove(element.name)
          ..remove('-${element.abbr}');
      }
    }
    return result;
  }
}
